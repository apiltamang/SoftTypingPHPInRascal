module soft::typing::php::elements::Function
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::functions::DeltaOperator;
import soft::typing::php::Utils::Analysis;
import soft::typing::php::Utils::AnalysisHelpers;
import soft::typing::php::Utils::GenericHelpers;
import soft::typing::php::elements::Identifier;
import lang::php::analysis::cfg::Label;
import soft::typing::php::functions::DependencyHelpers;
import soft::typing::php::cfg2::Visualize;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;


import IO;
import Set;
import List;



public set[list[Type]] getCartesianProduct(set[list[Type]] set1, set[Type] set2)
{
	set[list[Type]] toRet={};

	//if set1 is empty, which it will be for the first time that this method is invoked
	if (isEmpty(set1)) 
	{
		//just include the elements from set2
		for (Type aT<- set2)
		{
			toRet +=[aT];
		}
		
		return toRet;
	}
	
	//if set1 is not empty, then for each element of set1		
	for(list[Type] aTerm <- set1)
	{
		//pair it with an element from set2
		for(Type aT <- set2)
			toRet += aTerm+aT;
	}

	return toRet;
}

public set[list[Type]] getCartesianProductOfParams(list[TypeRoot] params )
{

	set[list[Type]] comb={};	

	//take the cartesian product progressively...
	for(TypeRoot t<-params)
	{
		//get the set of types
		temp=getSetOfTypesFrom(t);
		
		//take the cartesian product
		comb=getCartesianProduct(comb,temp);
	}

	return comb;

}

public set[Type] getSetOfTypesFrom(TypeRoot t)
{

		set[Type] temp={};
		
		if (t is typeSet)
			temp +=t.types;
		else
			throw "Expected typeSet or typeSingleton for function return type analysis. Error loc 0913847";
		
		return temp;
}
//written for compatibility
public TypeRoot runAnalysisThroughFunc(loc rootP,str fName,list[Type]aKey, str callType)
{
	Lab l=lab(-999);
	str mode="normal";
	return runAnalysisThroughFunc(rootP,fName,aKey,callType,l,mode).typeRoot;
	
}

public tuple[TypeRoot typeRoot,list[Warning] warns] runAnalysisThroughFunc(loc rootP,str fName,list[Type]aKey, str callType, Lab l,str mode)
{
	
	//this method will perform a complete flow through the
	//method in consideration deriving a net output for the
	//typeRoot returned by the function. A nulltypeRoot() is
	//returned if the function/method returns nothing.
	
	//get the funcAnalysisEnvm
	funcAnalysis=ApplicationMap[fName];

	<moveForward,mode>=continueAnalysisThroughFunc( fName, aKey,mode );
	if(!moveForward)
	{
		list[Warning] emptyList=[];
		return <typeSet({Void()}),emptyList>;
	}
	
	incrementIndentationString(); //This is to format output so that all output is indented by a certain amount
	printIndLn("");
	printIndLn("\>\>\>\>\>\>\>\>\>\>\>\> RUNNING analysis thorough function/method: <fName> in mode: <mode> \<\<\<\<\<\<\<\<\<\<\<\<");	
	printIndLn("");
	
	//get the entry node:
	entryNode=getElementFromSingletonList([nn|nn<-funcAnalysis.analysisNodes, nn is scriptEntryNode]);
	
	//get the edge that comes from the entry node
	anEdge=getElementFromSingletonList(toList(entryNode.edgesTo));
	
	//get the node
	nextNode=getNodeToOfEdge(anEdge,funcAnalysis.analysisNodes);
	if(callType=="instanceCall")
	{
		//Initialize any $this references withthe context of the calling object
		//Note: It maybe that there is no reference to $this in the method body, but I
		//will still keep it to know who the caller is.
		funcAnalysis.entryEnvironmentTable[nextNode.l][var("this")]=
			typeSet({Object(hh,HandleToClassInstanceMap[hh])|hh<-top(GlobalObjectContextStack)});
	
		//register var("this") to listen to any object updates,
		//Also need to mark that this identifier is initialized for this node
		for(Handle hh<-top(GlobalObjectContextStack))
			<funcAnalysis.hdToObjIdfs,funcAnalysis.labToObjIdfs>=
				registerIdentifierToObjectHandleAndNode(hh,var("this"),nextNode.l,
					funcAnalysis.hdToObjIdfs,funcAnalysis.labToObjIdfs); 
	}
	
	//initialize a counter for the index 
	ii=0;
	
	printIndLn("Initializing function analysis: <fName> in script: <funcAnalysis.scriptName> ");
	//while the next node is a paramDefinition node,
	bool insufficientArguments=false;
	Type tempTR=Void();
	
	while(paramDefinition(str paramName,_,_,_,_):=nextNode)
	{
		try
		{
			//somehow, if aKey is a purely empty list, then IndexOutOfBounds(msg) doesn't
			//catch this erroneous condition. Hence, including check if(isEmpty(aKey)){...}
			if(isEmpty(aKey))
			{
				insufficientArguments=true;
				tempTR=Void();				
			}
			else
			{
				tempTR=aKey[ii];
				ii=ii+1;
			}
				
		}
		catch IndexOutOfBounds(msg): 		
		{
			
			insufficientArguments=true;
			tempTR=Void();						
		}//end try/catch

		printIndLn("Setting parmater var(<paramName>): <tempTR>");
		
		//update the entry environment for this node using the type
		// information available from aKey
		funcAnalysis.entryEnvironmentTable[nextNode.l][var(paramName)]=
			typeSet({tempTR});
		
		//if parameter is taking an object type, then register it to the handle			
		if(tempTR is Object)
			<funcAnalysis.hdToObjIdfs,funcAnalysis.labToObjIdfs>=
				registerIdentifierToObjectHandleAndNode(tempTR.h,var(paramName),
					nextNode.l,funcAnalysis.hdToObjIdfs,funcAnalysis.labToObjIdfs);
							
		//get next edge
		anEdge=getElementFromSingletonList(toList(nextNode.edgesTo));
		
		//get node from this edge
		nextNode=getNodeToOfEdge(anEdge,funcAnalysis.analysisNodes);		
		
	}

	//propagate type information through the function body. Collect the entry and exit environments.	
	<entryEnvm,exitEnvm,warnings>=propagate(rootP,funcAnalysis,mode);	
	
	//update global reference
	AppExitEnvms[fName]=exitEnvm;
	
	//Now proceeding to evaluate a return type for this func. call!
	toReturnTypeRoot=extractTypeRootFromFunctionReturnNodes(
			rootP,funcAnalysis.analysisNodes,entryEnvm,fName,aKey,mode);	

	list[Warning] warns=[];

	if(mode=="normal")
	{	
		//commit some information + draw .dot file. This information is written in fName.dot files
		commitInformation(rootP,fName,warnings,funcAnalysis,exitEnvm,callType);
		//these warnings are passed back to the caller
		if(insufficientArguments)
			warns+=[insufficientArgsOnFuncCall("Function call made with less than min. required args @ <l>.")];
	}
	else if(mode=="recursion" && toReturnTypeRoot.types=={Any()})
	{
		//warnings passed back to the caller
		warns+=[ recursiveCallAnalysisFailed("Recursive call type analysis on: <fName> failed to deduce concrete types at <l>.")];
	}
	printIndLn("");
	printIndLn("\<\<\<\<\<\<\<\<\<\<\<\< EXITING analysis from function/method: <fName> in mode: <mode>  \>\>\>\>\>\>\>\>\>\>\>\>");	
	printIndLn("");
	decrementIndentationString();
	
	//return the computed value
	return <toReturnTypeRoot,warns>;
}//end method


public tuple[bool forward,str mode]  
	continueAnalysisThroughFunc(str fName,list[Type] aKey, str mode )
{
	//------------ Very important block--------------------------//
	//
	if( mode=="recursion" && <fName,aKey> in GlobalFuncCallStack )
	{
		//function analysis running in recursive mode. Trying to
		//invoke the recursing method again. Pushing through will
		// create cycling loops. Hence, need to exit
		
		//The third thing that happens when analyzing a recursing
		//function call sequence i.e. (1) -> (2) -> (3)
		return <false,mode>;
	}
	
	else if( <fName,aKey> in GlobalFuncCallStack )	
	{
		//A function call with given signature is being invoked
		//again. This time, perform a 'recursive' mode analysis
		
		//The second thing that happens when analysing a recursing
		//function call sequence, i.e. (1) -> (2)
		mode="recursion";
		return <true,mode>;
	}
	else
	{
		//Now insert this function with the given list of parameter types 
		//in the global function call stack, so that if it is called again,
		//it is possible to propagate analysis in the "recursive" mode.	
		
		// The first thing that happens always (1).
		mode="normal";
		GlobalFuncCallStack=push( <fName, aKey>, GlobalFuncCallStack );		
		return <true,mode>;
	}
	//------------ End of very important block -------------------//


} //end method

public void commitInformation(loc rootP,str fName, 
	list[Warning] warnings, AnalysisEnvm funcAnalysis,map[Lab,TypeEnvironment] exitEnvm,str callType)
{
	//keep track of the warnings..
	//These warnings will be written to the global AppWarnings map instead of returning it.
	if(fName in AppWarnings)
		AppWarnings[fName]=AppWarnings[fName]+warnings;
	else
		AppWarnings[fName]=warnings;
	
	//draw to a dot file...
	loc writeTo;
	if(callType=="staticCall"||callType=="instanceCall")
		writeTo=rootP+"<funcAnalysis.scriptName>.<fName>.method.post.dot";
	else
		writeTo=rootP+"<funcAnalysis.scriptName>.<fName>.function.post.dot";
		
	renderAnalysisEnvmAsDot(funcAnalysis.analysisNodes,
					funcAnalysis.edges,exitEnvm,writeTo,"<writeTo>");					
	//pop the func call signature from the global stack once you're through with the function!
	<throwAway,GlobalFuncCallStack>=pop(GlobalFuncCallStack);						

}//end method


public TypeRoot extractTypeRootFromFunctionReturnNodes(
	loc rootP,set[AnalysisNode] analysisNodes,	map[Lab,TypeEnvironment] entryEnvm,str fName,list[Type] aKey,str mode )
{
	//Initialize a var of type TypeRoot and set it to null. This will be the
	//final typeroot evaluated for the function
	TypeRoot toReturnTypeRoot=nullTypeRoot();	

	//grab all the returnNodes from funcAnalysis.analysisNodes, then evaluate the typeRoot
	//obtained from each of the returnNodes. Use the widening operator to combine them as 
	//they are evaluated.
	printIndLn("````````````````````` Deducing return type for function call ``````````````````````");
	for(AnalysisNode aReturnNode<-{nn| nn<-analysisNodes,nn is returnNode})
	{
		printIndLn("Polling return node: [<aReturnNode.content>] of function: <fName> in mode: <mode>.");
		//grab the constraints
		<ccs,warns>=resolveDependencies(
			rootP,aReturnNode.constraints,entryEnvm[aReturnNode.l],"polling");
			//the "polling" mode is to establish that I'm running over expressions
			//on the return node to extract type information from each expression. 
			//this mode will be used to prevent infinite recursion should a certain
			//case be satisfied! 
			 
		typeRootObtained=
			getElementFromSingletonList([tt|cc<-ccs,
				yieldType(Lab l,TypeRoot tt):=cc,l==aReturnNode.l]);
				
		printIndLn("TypeRoot of return expression: <typeRootObtained>");
		
		if(mode=="recursion" && typeRootObtained.types=={Void()})		
			typeRootObtained=nullTypeRoot();
		
		//widen typeRoot if there is more than one return node
		toReturnTypeRoot=widen(toReturnTypeRoot,typeRootObtained);
		
	}

	printIndLn("Deduced typeRoot: <toReturnTypeRoot> from function call: <fName> with parameter keys: <aKey>, running in mode: <mode>");
	printIndLn("```````````````````````` Finished evaluating return type  ````````````````````````");
	
	//if no concrete types are scheduled to be returned, then
	//return the 'Void' type.
	
	
	if(toReturnTypeRoot is nullTypeRoot)
		if(mode=="normal")		
			toReturnTypeRoot=typeSet({Void()});
		else if (mode=="recursion")		
			toReturnTypeRoot=typeSet({Any()});
		else
			throw "Expected mode to be either recursion/normal. Got: <mode>."; 

	return toReturnTypeRoot;
}//end method
			
public list[Warning]  updateFunctionInfoBase(loc rootP,str fName,set[list[Type]] keys, str callType,Lab l, str mode)
{
	
	list[Warning] warns=[];
	f=GlobalFuncDeclsMap[fName];
	
	bool pushThrough=false;
	
	//if this is a method call, then push analysisthrough 
	//the body of the method in concern.
	if(callType=="instanceCall" || callType=="staticCall")
		if(!(mode=="polling"))
			pushThrough=true;
		
	//Adding support for functions that doesn't take any parameters
	if (isEmpty(keys))
	{
		list[Type]emptyList=[];
		if(!(emptyList in f.templates) || pushThrough )
		{
			<typeRoot,temp>=runAnalysisThroughFunc(rootP,fName,emptyList,callType,l,mode);
				
			warns+=temp;
			
			//update reference of f. This is important, because new
			//information could've been written to GlobalFuncDeclsMap
			//when a recursive analysis is underway
			f=GlobalFuncDeclsMap[fName];
			
			f.templates+=(emptyList:typeRoot);
			
			GlobalFuncDeclsMap[fName]=f;
			
			return warns;
		}
		else
		{
			printIndLn("Function: <fName> with keys: <emptyList> found and reused.");
		}
	}
	
	//for all key in keys, where key is not already in f, 
	for(list[Type] aKey <- keys)
	{	
		if(! (aKey in f.templates) || pushThrough )
		{
			//run the analysis through it to see what I get for the given list of Types (given for the parameters in order)
			<typeRoot,temp>=runAnalysisThroughFunc(rootP,fName,aKey,callType,l,mode);
			warns+=temp;

			//update reference of f. This is important, because new
			//information could've been written to GlobalFuncDeclsMap
			//when a recursive analysis is underway
			f=GlobalFuncDeclsMap[fName];
			
			//add given list[Type] as a new key to its map element,
			f.templates+=(aKey:typeRoot);
			
			//finally, update the GlobalFuncDeclsMap with the updated function...
			GlobalFuncDeclsMap[fName]=f;

		}//end if( ! (aKey in f.templates) )
		else
		{
			printIndLn("Function: <fName> with keys: <aKey> found in template and reused. Reused typeroot: <f.templates[aKey]>.");
		}
		
	}//end for (aKey <- keys)
	
	return warns;

}//end function updateFuncInfoBase

public TypeRoot getReturnTypeRootForFuncCall(str fName,set[list[Type]] keys,Lab l)
{

	
	//get the function from the map
	f=GlobalFuncDeclsMap[fName];
	
	TypeRoot t2=nullTypeRoot();
	//if the function takes no parameters, then get return type from emptyList
	if(isEmpty(keys))
	{
		list[Type]emptyList=[];
		t2=f.templates[emptyList];
		
	}
	else
	{	
		//for each key in keys
		for(list[Type] aKey <- keys)
		{
			if(! (aKey in f.templates) )
				throw "Key not found in f.templates. Error loc 4908011.";
			
			//get type by looking up f.templates[key]
			t=f.templates[aKey]; 
			
			//now use the widening operator to combine the incoming typeroots
			t2=widen(t2,t);
		}	
	}
	
	return t2;
}

//This method written only for compatibility to old interface. The parameter l was added, so
//any error/warning generated while making this function call can be annotated with the call site.
public tuple[TypeRoot tRoots,list[Warning] warns] getFuncReturnValue(loc rootP,str fName,list[TypeRoot] params, str callType)
{
	Lab foobar=lab(-999);
	return getFuncReturnValue(rootP,fName,params,callType,foobar);
}

//This is used for normal func. calls, including static calls
public tuple[TypeRoot tRoots,list[Warning] warns,map[Handle,ClassInstance] dirtyHandles] 
	getFuncReturnValue(loc rootP,str fName,list[TypeRoot] params, str callType,Lab l,str mode)
{
	TypeRoot caller=nullTypeRoot();
	return getFuncReturnValue( rootP, fName, params, callType, l, mode, caller );
}

//this is used for instance calls
public tuple[TypeRoot tRoots,list[Warning] warns,map[Handle,ClassInstance] dirtyHandles] 
	getFuncReturnValue(loc rootP,str fName,list[TypeRoot] params, str callType,Lab l,str mode,TypeRoot caller)
{
	/*
	 *params: [ t1, t2, ...,tN ] where
	 * t1, t2 ,...., tN are typeroots of
	 * the function parameters in the order
	 * that they appear in the function call.
	 */
	list[Warning] warns=[];
	map[Handle,ClassInstance] dirtyHandles=();
	
	assert (callType == "funcCall" || callType== "instanceCall" 
		|| callType == "staticCall" || callType=="non-exist-method") :
			"invalid value for callType parameter.";
	
	//Now get the cartesian product of the parameters coming through
	set[list[Type]] comb=getCartesianProductOfParams(params);
	
	//this means that fName is not defined yet. Fall back with a warning
	if(!(fName in GlobalFuncDeclsMap))
	{
		warns+=[failedToFindFunction("Failed to find function definition: <fName>, call site @ <l>.")];
		return <typeSet({Void()}),warns,dirtyHandles>;
	
	}
	
	//update the function definition using incoming parameters
	warns=updateFunctionInfoBase(rootP,fName,comb,callType,l,mode);
		
	//get the typeRoot to be returned by mining through the templates
	t2=getReturnTypeRootForFuncCall(fName,comb,l);
		
	//Once the function call is complete, check to see if any passed parameter was an object,
	//and if its state changed. Pass it back as a set of dirtyHandles.
	if(callType=="instanceCall")
		params+=[caller]; //if instance call, also check to see if calling object changed state!
	<dirtyHandles,warns>=checkIfAnyObjectStateChanged(params,warns,fName,l);
	return <t2,warns,dirtyHandles>;
	
}


public tuple[map[Handle,ClassInstance] dirtyHandles,list[Warning] warns]
	checkIfAnyObjectStateChanged(list[TypeRoot] params,list[Warning] warns,str fName,Lab l)
{
	map[Handle,ClassInstance] dirtyHandles=();
	
	//iterate through the different params
	outer:
	for(TypeRoot tRoot <- params)
	{
		if(tRoot is nullTypeRoot)
			continue outer;
			
		assert tRoot is typeSet: 
			"Expect typeSet. Got something else! Error loc @ 9817091.";
		
		//Iterate through the type of each param
		inner:	
		for(Type t <- tRoot.types)
		{
			if( ! (t is Object))
				continue inner;
			
			//Get the Handle stored in the Object type
			Handle objHd=t.h;
			//Get the object instance carried by the parameter,
			//This is the object state before the func. call was made
			ClassInstance ciPrev=t.ci;
			
			//Get the object instance carried by the global storage for objects
			//this is the object state after the func. call was made
			ClassInstance ciAfter=HandleToClassInstanceMap[objHd];
			
			//check to see if the object state changed due to func. call
			if(ciPrev != ciAfter){
				//if object state has changed, then add this objHandle,ClassInstance pair
				//to the map that is to be returned and processed later.
				dirtyHandles[objHd]=ciAfter;
				
			}
				
		}//end for inner
	
	}//end outer
	
	return <dirtyHandles,warns>;

}//end method
