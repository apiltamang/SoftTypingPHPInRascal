module soft::typing::php::functions::DependencyHelpers

import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::functions::DeltaOperator;
import soft::typing::php::elements::Identifier;
import soft::typing::php::elements::Function;
import lang::php::analysis::cfg::Label;
import Set;
import IO;
import List;
import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;

import soft::typing::php::elements::Class;
import soft::typing::php::Utils::GenericHelpers;
private int recursionLevel=0;

//this is the function that is of main utility, and one which is called
//by other functions. It basically does the following:
/*
* a) removes any yieldFlow(dest,src)/expectFlow(dest,src) constraints and replaces 
*	 them with yieldType(dest,TypeRoot)/expectType(dest,TypeRoot)

*	 where the typeroot of the target = the inferred typeroot of the src. In order for this to happen
*	 it must also evaluate the typeroot for the src.

* 	b) removes and resolves any typeroots containing to/from Array/ArraySet identifiers, and replaces them
*	   with the correct types
*
*   c) if the typeroot is associated with an identifier or a function call, then this method examines the
*      entry type-environment and/or global function declaration map to determine if the typeroot for that
*      particular label can be deduced from either one of them.
*/
public tuple[set[Constraint] ccs,list[Warning] warns,map[Handle,ClassInstance] dirtyHandles] resolveDependencies(loc rootP,set[Constraint] constraints,
			TypeEnvironment entry,str mode )
{
	//this stores the information on type values of each labels
	set[Constraint] toReturn={};
	
	//this stores all the warnings that were generated while evaluating expresssion
	list[Warning] warns=[];
	
	//this stores all the object handles that have now become dirty, and needs to be updated
	//this is caused by a func. call expression that takes objects as arguments, and modifies
	//the state of the object inside the function body.
	//---> The ClassInstance reflects the new object state! 
	map[Handle,ClassInstance] dirtyHandles=();
	
	//This map is used to stored the typeroots that need evaulations.
	//It is initialized to null for each node during the analysis.
	map[TypeRoot,TypeRoot] evaluatedTRoots=();
	
	map[Lab,TypeRoot] evaluatedLabs=();

	TypeRoot typeRoot=nullTypeRoot();
	set[Constraint]ccsNew={};
	
	//Look for dependencies involvig yield/expectFlow identifiers, and replace with a concrete
	//constraint, i.e. one involving yieldType OR expectType
	for(Constraint cc <- constraints)
	{
		//resolve if constraint is yieldFlow/expectFlow
		if(yieldFlow(Lab dest,Lab src) := cc)
		   
		{
			//get the typeRoot by resolving the flow
			ccsNew+=yieldType(dest,resolveFlow(src,constraints,entry));
				
		}
		else if(expectFlow(Lab l1,Lab l2):= cc  )
		{
			//ccsNew+=expectType(dest,resolveFlow(src,constraints,entry));
			ccsNew+=cc;			
		}
		else if(yieldType(Lab dest,TypeRoot t):=cc ||				
				expectType(Lab dest,TypeRoot t ):=cc)
		{
			ccsNew+=cc;
		}
		else
		{
			//we have a nullConstraint(), which is illegal. So throw exception.
			throw "Expected non-null constraint, but got null constraint.Error loc: 109847.";
			
		}
	}
	
	//Now look for any dependencies involving toArray/fromArray/funcCall etc identifiers, and replace them
	//with the appropriate resulting types.
	for(Constraint cc<-ccsNew)
	{
		
		if(yieldType(Lab dest,TypeRoot t):=cc) 
		{

			<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>
				=getTypeOf(rootP,dest,ccsNew,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
			toReturn += yieldType(dest,got);

		}
		else if(expectType(Lab dest,TypeRoot t):=cc)
		{
			/*
			 This is not necessary. ExpectType is clearly a concrete type,
			 not an expression. No need to drill down to resolve this.   
			<got,evaluatedTRoots,evaluatedLabs>
				=getTypeOf(rootP,dest,ccsNew,entry,evaluatedTRoots,evaluatedLabs);
			*/
			assert t is typeSet :
				"Expect concrete type for expectType. Got: <t>. Error loc 1089371-471-09.";
			toReturn += expectType(dest,t);
		
		}
		else if(expectFlow(Lab dest,Lab src):=cc)
		{
			toReturn +=cc;	//I need this unmodified!
		}
		else
		{
			throw "Expected yield/expect-type constraint, but got something else. Error loc: 203091";
		}

	}
	
	return <toReturn,warns,dirtyHandles>;
}	

public tuple[TypeRoot got,map[TypeRoot,TypeRoot] evaluatedTRoots,
	map[Lab,TypeRoot] evaluatedLabs,list[Warning] warns,map[Handle,ClassInstance] dirtyHandles]
		getTypeOf(loc rootP,Lab l, set[Constraint] ccs,TypeEnvironment entry,
			map[TypeRoot,TypeRoot] evaluatedTRoots,map[Lab,TypeRoot]evaluatedLabs,
				list[Warning] warns,map[Handle,ClassInstance] dirtyHandles,str mode)
{
	//This method looks at the typeRoot associated with 'l', then if it finds situations 
	//where 'l' is another sub-expression that needs to be evaluated to determine its type,
	//then the method will go into recursion. The base case is when 'l' is a literal or a constant!
	
		
	TypeRoot ab=
		getElementFromSingletonList([cc.t| cc<-ccs, cc is yieldType,cc.l1==l]);
	
	TypeRoot toReturn=nullTypeRoot();

	//There maybe instances when I have constraint: yieldType(fromLabel(l), typeSet(..)).
	//In that case, do not evaluate again. Just look from the given map.
	//Turns out to be a partial implementtion of the "memoization" technique.
	if(l in evaluatedLabs)
		return <evaluatedLabs[l],evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>;

	//if the base typeRoot, i.e. one with type: typeSet (..), has already
	//been calculated, then don't do it again!. Previously, I would keep
	//drilling down everytime I had this need. Else, drill down until you get to 
	//the base type, i.e. one that ends with typeSet(..);	
	//A kind of a "memoization" technique
	if(ab in evaluatedTRoots)
		return <evaluatedTRoots[ab],evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>;		

	//if l points to an element with the toArray/fromArray identifier,
	//then drill further into the type of l, 
	else if(toArraySet(set[Lab] labels):=ab)
	{
		set[Type] temp={};
		for(Lab l<-labels)
		{
			<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>
				=getTypeOf(rootP,l,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
			if(got is typeSet)
				temp+={Array(t)|t<-got.types};
			/*	
			else if(got is typeSingleton)
				temp+={Array(got.aType)};
			*/
			else
				throw "Error...Expected typeSet or typeSingleton. Got: <got>";	
		}
		toReturn = typeSet(temp);	
	}


	else if(toArray(Lab ll):=ab || addToArray(Lab ll):=ab)
	{
		//return Array(type(l)); flow goes into recursion
		<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>
			= getTypeOf(rootP,ll,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
		if (got is typeSet)
		{
			
			toReturn= typeSet({Array(t)|t<-got.types});			
		}
		else
			throw "Evaluation of label must return typeSet. Got: <got>";
	}
	else if(fromArray(Lab label):=ab)
	{
		<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>
			=getTypeOf(rootP,label,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
		if (typeSet(set[Type]types):=got)
		{
			set[Type]typp={};
			for(Type arrT <- types)
			{
				if(Array(Type aT):=arrT)
					typp += aT;
				else
				{
					warns+=[readFromNonArrayVal("Expected array @ <label>. Got Non-array: <got>.")];
					
					typp += Void();
				}
			}
			toReturn= typeSet(typp);
		}
		else
			throw "shouldnot be here...Error loc 288793";
	}
	else if(toArray(Any()):=ab)
	{
		
		toReturn= typeSet({Array(Any())});
	}
	else if(funcCall(str fName,list[Lab] fParams):=ab)
	{
		list[TypeRoot] t=[];
		for(Lab l<-fParams){
			<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>
				=getTypeOf(rootP,l,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
			t+=[got];
		}	
		<toReturn,temp,dirtyHandles>= getFuncReturnValue(rootP,fName,t,"funcCall",l,mode);
		
		warns+=temp;

	}
	else if(fromLabels(set[Lab] labels):=ab)
	{
		TypeRoot t=nullTypeRoot();
		for(Lab l<-labels)
		{
			<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>=
				getTypeOf(rootP,l,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
			t=widen(t,got);
		}
		
		toReturn= t;
	}
	else if(fromLabel(Lab label):=ab)
	{
		//it should be that there is a yieldType(Lab label,TypeRoot someTypeRoot);
		//search for that instead of getting type all over again..
		<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>
			=getTypeOf(rootP,label,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
		toReturn=got;
		
	}
	else if(fromVar(var(varName)):=ab)
	{
		
		toReturn= entry[var(varName)];
		
		if (toReturn is nullTypeRoot)
		{
			//it maybe a $this var reference inside a method body. If this reference appeared
			//in the context of a static call, then $this would have 'nullTypeRoot', and it'd
			//be necessary to issue a warning, assign a void type, and continue with analysis.
			//
			//In the event that $this was referenced in a instance method call, then it would
			//have been assigned a set of types in rascal function: runAnalysisThroughFunc(..).
			if(varName=="this")
			{
				warns+=[referenceObjInStaticContext("Attempt to use <varName> in static context @ <l>.")];				
			}
			else
			{
				warns+=[readFromNonDeclaredVar("Attempt to read from undeclared var(<varName>) @ <l>.") ];
			}
			
			//assign a void type when retrieving a typeroot for a var failed
			toReturn=typeSet({Void()});
		}
		
		else
		{
			//just second-proofing my own implementation. If everything went okay, toReturn 
			//here would be: typeSet({ type1,type2,.. });
			assert toReturn is typeSet: 
				"Expect typeset. Got: <toReturn>. Error@loc: 19737709848.";
		
			if(hasVoidType(toReturn.types))
				warns+=[readFromVarWithVoidType("Reading from var containing Void type  @ <l>")];
			
		}
		
		
		
	}
	else if(newObjectInstance(cName,paramsLab):=ab)
	{
		//call to create a new object of class: cName, with
		//constructor parameters: paramsLab
		printIndLn("New Object being constructed at Lab: <l>");
		
		printIndLn("TypeRoot triggering this action	: <ab>");
		
		if(!(cName in GlobalClassDeclsMap))
		{
			warns+=[classDefNotFound("Trying to instantiate from unknown class: <cName> @ <l>")];
			toReturn=typeSet({Void()});
		}		
		else
		{	
			//get concrete types for each params
			list[Lab] paramsLab=[];
			for(Lab l2 <- paramsLab)
			{
				<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>=
					getTypeOf(rootP,l2,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
				paramsLab+=[got];
			}
			
			//increment the global ids for class-instance and obj-handle			
			ClassInstanceId+=1; 
			
			//using concrete parameter types defined in the constructor, instantiate the fields.
			//This will potentially result in new warnings
			fieldToTypeMap=mapConstructorParamsToClassFields(cName,paramsLab);
	
			//get the member templates that this object belongs to
			memberTemplates=getMemberClassTemplates(fieldToTypeMap);
			
			//create a new object instance;
			ClassInstance newObject=objInst(
				ClassInstanceId, //unique id
				fieldToTypeMap, //empty map
				cName,
				memberTemplates //empty set
			);
			
			//create a new handle;
			Handle newObjHandle=objHd(
				ClassInstanceId
			);			
			
			//add the created instance to the spawnedInstance field of
			//the class, so that the class is always aware of this
			GlobalClassDeclsMap[cName]
				.objInstanceHandles+={newObjHandle};
				
			//store this in the global mapp/store for class-instances
			HandleToClassInstanceMap+=(newObjHandle:newObject);
			
			toReturn= typeSet
					({Object(newObjHandle,newObject)});
		}
		
	}
	else if(fromObjectProperty(TypeRoot fromExprAtLabel,Identifier fieldVar):=ab)
	{
		//message fromExprAtLabel a bit...
		
		//first drill down to get type of fromExprAtLabel
		assert fromExprAtLabel is fromLabel :
			"Expected TypeRoot: fromLabel(Lab aLabel). Assert Error loc: 0910-4180. Got: <fromExprAtLabel>";
		
		//get the typeroot
		<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>
			=getTypeOf(rootP,fromExprAtLabel.label,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
		
		TypeRoot ab=got;
		if(ab is typeSet)
		
		{
			
			for(Type t<-ab.types)
				if(Object(h,_):=t)
				{
					objHeld=HandleToClassInstanceMap[h];
					<got,warns>=getTypeRootOfFieldFromObject(objHeld,fieldVar,warns,l);
					toReturn =widen(toReturn,got);	
				}
				else
				{
					//throw "Expected Object Type. Instead got: <t>";
					warns+=[ readPropertyFromNonObjectVar("Attempt to read property: <fieldVar.name> from non-object @ <l>.") ];
					toReturn=widen(toReturn,typeSet({Void()}));
				} 
		}
		else
		{
			throw "Expected typeSet. Got: <ab>. Error loc: 87109371.";
		}
			
	}
	else if (fromStaticProperty(str cName,Identifier fieldVar):=ab)
	{
		str actualClassName="";
		//resolve the context of self, i.e. figure out the static instance of the class
		if(cName=="self")
		{
			//retrieve the top element on global object stack
			set[Handle] hs=top(GlobalObjectContextStack); 
			
			set[str] srcClasses={};
			
			//get the src classes of each of the instances connected by given set of handles.
			//It doesn't matter if the handle points to a statInstance or objInstance node.
			//They both have the 'srcClass' field. The former would be on top of the stack if
			//the call had been made by a static method call statement. The latter would be
			//on the top of the stack if the call was made via a specific object.
			for(Handle h<-hs)
				srcClasses +={HandleToClassInstanceMap[h].srcClass};
			
			if(size(srcClasses)>1)
				throw "Cannot have more than one type of src classes. Error loc: 19741907209.";
			
			actualClassName=getOneFrom(srcClasses);
		
		}
		else
		{
			//This was called by using the name of the class explicitly!
			actualClassName=cName;
		}
		
		if(actualClassName in GlobalClassDeclsMap)
		{
			//get the class-scheme, and the corresponding statInstance
			ClassInstance thisStatInstance=
				GlobalClassDeclsMap[actualClassName].statInstance;
			
			
			if( fieldVar in thisStatInstance.fieldToTypeMap )
			{			
				//get the typeroot from the stored field to type map
				toReturn=thisStatInstance.fieldToTypeMap[fieldVar];
				
				//if fieldVar has not been initialized, then issue a 'void' type
				if (toReturn is nullTypeRoot)
				{
					toReturn=typeSet({Void()});
					warns+=[readUninitializedClassProperty
						("Attempt to read from uninitialized class property: var(<fieldVar.name>) of class: <actualClassName> @ <l>.")];
				}
			}
			else
			{
				toReturn=typeSet({Void()});
				warns+=[accessUndefinedClassProperty
					( "Attempt to read from undefined class property: var(<fieldVar.name>) of class: <actualClassName> @ <l>.") ];
			}
				
		}
		else
		{ 
			//class def not found.
			toReturn=typeSet({Void()});
			warns+=[classDefNotFound
				("Trying to access class property from unknown class: <actualClassName> @ <l>.")]; 
		}
	}
	else if(fromMethodCall(TypeRoot fromExprAtLabel,str fName,list[Lab] params):=ab)
	{
		assert fromExprAtLabel is fromLabel:
			"Expected fromLabel(aLabel) typeRoot. Got: <fromExprAtLabel>. Error loc: 918-89817";
		
		//get the typeroot
		<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>
			=getTypeOf(rootP,fromExprAtLabel.label,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
		
		TypeRoot ab=got;
		assert ab is typeSet:
			"Expected typeSet. Got <ab>. Error loc: 029391798";
		
		set[Handle] handles={};
		set[str] parentClasses={};
		
		//get the set of handles from this typeSet		
		for(Type t <- ab.types)
		{
			if(Object(h,ci):=t)
			{
				handles+={h};			
				//store the name of the src parent class of each object.
				parentClasses+={HandleToClassInstanceMap[h].srcClass};
			}
			else
			{
				//non-object type.. report warning!
				warns+=[ callMethodFromNonObjectVar("Attempt to call method: <fName> from non-object @ <l>.") ];
			}
		}
			
		if(size(parentClasses)>1)
		{
			//Entering this block means that there is something wrong with my code
			throw "Cannot have more than one type of src classes. Error loc: 1093871987.";
		}
		else if(size(parentClasses)==0)
		{
			//This would hold if none of the types in ab.types was Object
			warns+=[ callMethodFromNonObjectVar("Attempt to call method: <fName> from non-object @ <l>.") ];
			toReturn=widen(toReturn,typeSet({Void()})); 
		}
		else
		{	
			//size(parentClasses)==1, and everything is okay so far so good!
						
			//Now push this set of handles on the global object context stack
			GlobalObjectContextStack=push(handles,GlobalObjectContextStack);
			
			//Now collect the type list of parameters in the method call
			list[TypeRoot] t=[];
			methodName=getOneFrom(parentClasses)+"."+fName;
			
			for(Lab l<- params){
				//collect the typeroots of the parameters being passed.
				<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>=
					getTypeOf(rootP,l,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
				t+=[got];
			}
			//get the typeroots from the method call. This method call will be reliant
			//on the objects stored on the global object context stack to resolve any
			//$this/$self property accesses
			
			/*
			 * V. Imp. check to see if fName is a static func. or a method func.
			 * because in PHP, you can do both: 
			 * 	- $obj->callAStaticMethod(..),
			 * 	- $obj->callAnInstanceMethod(..)
			 *  i.e. call both 'static' and 'instance' methods using an object-context!
			 */
			 str methodCallType=getMethodCallType(getOneFrom(parentClasses),fName);
			 
			<toReturn,tempWarns,dirtyHandles> = getFuncReturnValue(rootP,methodName,t,methodCallType,l,mode,ab);
			warns+=tempWarns;
			
			//Once you've got the return type, pop out the object context!
			<throwAway,GlobalObjectContextStack>=pop(GlobalObjectContextStack);
		}
		
	}
	else if(fromStaticCall(str cName,str fName,list[Lab] params):=ab)
	{
		if(cName in GlobalClassDeclsMap)
		{
			//get static instance of the class		
			ClassInstance thisStatInstance=
				GlobalClassDeclsMap[cName].statInstance;
			
			//form the method name as is stored in global map
			staticMethodName=cName+"."+fName;
			
			
			//now collect the typeroots of the function parameters
			list[TypeRoot] paramsTypeRoots=[];
			for(Lab ll<-params){
				//collect the typeroots of the parameters being passed.
				<got,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>=
					getTypeOf(rootP,ll,ccs,entry,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles,mode);
			
				paramsTypeRoots +=[got];
			}	
			
			//get handle associated to the static instance of this class	
			set[Handle] h={};
			h+={objHd(thisStatInstance.classInstanceId)};
			
			//Push this into the global context, so that the function processor
			//knows what context this method call is being made under
			GlobalObjectContextStack=push(h,GlobalObjectContextStack);
			
			//process the method call. This will also return the typeRoot of any
			//expression returned by the static method call.
			<toReturn,tempWarns,dirtyHandles> = getFuncReturnValue(rootP,staticMethodName,paramsTypeRoots,"staticCall",l,mode);
			warns+=tempWarns;
			
			//once done with this call, throw it away
			<throwAway,GlobalObjectContextStack>=pop(GlobalObjectContextStack);
		}
		else
		{
			//class not found warning
			warns+=[ classDefNotFound("Failed to find class definition: <cName> referred to @ <l>.")];
		}
		
	}
	else 
	{
		
		//Lone 'return' statement in function body still screws this up!
		//Hopefully this is gone by now. A function returning a void type
		//now returns a type: void, and the error will be caught later.
		
		assert ab is typeSet:
			"The base case can only be a typeSet. Got: <ab>";

		
		toReturn= ab;	
	}
	
	//add this to the EvaluatedTypeRootMap so that it doesn't have to evaluated again
	//if more than one label point to this. Note that this Map is initialized to an
	//empty map during the analysis of each node (or a statement) the php script. Hence,
	//I shouldn't have to worry about any conflicts between nodes because of this.
	evaluatedTRoots +=(ab:toReturn);
	
	//add the information that the base typeroot for this label has already been calculated,
	//and there's no need to calculate it again!
	evaluatedLabs +=(l:toReturn);
	
	if(toReturn is typeSet && hasVoidType(toReturn.types))
		warns+=[usingVoidTypeForExpr("Computed typeSet for <l> has Void type.")];
	
	
	return <toReturn,evaluatedTRoots,evaluatedLabs,warns,dirtyHandles>;
}

public TypeRoot resolveFlow(Lab src,set[Constraint] constraints,TypeEnvironment entry)
{

	//resolve flow basically drills through the dependencies until it finds a case where
	//Constraint cc = yieldType(Lab src,TypeRoot t), then returns t.
	
	// for e.g. if l1 <= l2, and l2<= l3, and l3 := yieldSet/yieldSingleton(aType/types), then
	// this method returns: aType/types
	
	Constraint cons=getDataFlowDependency(src,constraints);

	if(yieldFlow(_,Lab label):= cons)
	{
		//if the constraint derived is another flow statement, then dig
		//deeper by going into a recursion...
		
		return resolveFlow(label,constraints,entry);
	}
	
	else if(yieldType(Lab label,TypeRoot t):=cons )
	{
		//else if the constraint derived yields a specific type,
		//return the typeroot
		return t;
	}
	else if(cons is nullConstraint)
	{
		throw "Resolving dependency for Label: <src> threw a null-constraint. Error loc: 34872783";
	}
	else
	{
		throw "A concrete terminating typeroot could not be calculated for Label: <src>. Error loc: 2908132";
	}
}

public bool hasVoidType(set[Type] types)
{
	bool hasVoid=false;
	
	for(Type tt<-types)
		if(/Void():=tt)
			hasVoid=true;
	return hasVoid;
	
}

public Constraint getDataFlowDependency(Lab label,set[Constraint]constraints)
{
	//works in aid of resolveFlow method to drill through the dependency chain
	for(Constraint cc <- constraints)
	{
		//print("  Checking constraint: ");printIndLn(cc);
		if( yieldFlow(Lab dest,Lab src):=cc ||
			yieldType(Lab dest,TypeRoot t):=cc )
		{
			
			if(dest==label)
			{
				
				return  cc;
			}
		}		
	}
	return nullConstraint();
	
}

