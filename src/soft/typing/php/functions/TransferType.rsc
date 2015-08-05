module soft::typing::php::functions::TransferType
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::functions::DependencyHelpers;
import soft::typing::php::elements::Identifier;
import soft::typing::php::functions::DeltaOperator;
import soft::typing::php::Utils::GenericHelpers;
import soft::typing::php::warnings::TypeCoercionCheckers;
import lang::php::analysis::cfg::Label;

import Set;
import List;
import IO;
import Exception;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;


private alias PropertySetNode=tuple[set[Handle] handles, Identifier fieldVar];


public tuple[TypeEnvironment typeEnvm, HdToObjIdfs map1,LabToObjIdfs map2,list[Warning] warnings]
	transferTypes(loc rootP,Lab nodeLabel,LabelToIdentifierMap labelToIdentifierMap,TypeEnvironment entry
		,set[Constraint] constraints,HdToObjIdfs hdToObjIdfs,LabToObjIdfs labToObjIdfs,str mode)
			
{
	//first make a copy
	toReturn=entry;
	
	list[Warning] warnings=[];
	//initialize a self-consistency check mechanism. This is to test and see if any of the
	//identifier undergoes change of typeRoot more than once (if at all) in the current node. Useful because
	//I was getting into the precarious situation such that if $a=array($a), and if $a was originally
	// INT(), I should be getting $a=Array(Int()) at the end of the analysis of this node. However, while
	//I am iterating through the depedencyResolvedConstraint list, the typeRoot associated with the previous
	//type of $a would replace the type for $a in the Right Hand Side. Hence, I check to see if the type of
	//the identifier (i.e. $a ) has now changed from the entry type, then only make the new assignment. 
	
	//While doing above, I realize that I do not if there is a situation when an identifier can change type
	//more than once in the same analysis node. I.e. is there a scenario or a statement so that an identifier
	// (i.e. $a) can chane its type more than once in a statement...? I don't know. If such an act is seen, I
	//want the code to let me know by throwing an exception and aborting further processing.
	map[Identifier,int] varChangedTypeRootCount=(idf:0 | idf<-entry);
	
	//now resolve dependencies (all yieldFlow constraints will be surveyed and replaced
	//with a yieldType constraint by navigating the elements of constraints)
	<dependencyResolvedConstraints,warnings,dirtyHandles>=resolveDependencies(rootP,constraints,entry,mode);
	
	printIndLn("Resolved dependencies: <dependencyResolvedConstraints>");
	
	for(Constraint cc <- [cct|cct<-dependencyResolvedConstraints,cct is yieldType])
	{
		//get the destination label
		dest=cc.l1;
		
		//declare a TypeRoot
		TypeRoot resolvedType=cc.t;

		//assert that resolved type is typeSet. It should be such, because only this form canbe stored
		//as type information for a var in the type environment.
		assert resolvedType is typeSet: 
			"Expect typeSet. Got: <resolvedType>. Error@loc 1098372710987.";
			
		if(dest in labelToIdentifierMap) //check if dest is associated with an identifier
		{
			//get the identifier pointed to by the label			
			idf=labelToIdentifierMap[dest];
			
			//if the statement involves setting an object field, then update the
			//instance field
			if(propertySet(Lab lab,Identifier fieldName):=idf)
			{
				<toReturn,hdToObjIdfs,labToObjIdfs,warnings> = 
					processPropertySetNode(nodeLabel,lab,fieldName,entry,
						labelToIdentifierMap,resolvedType,hdToObjIdfs,labToObjIdfs,dest);
			}
			//if the statement involves setting a static property, then update
			//static instance of the class
			else if(statFieldSet(str cName,Identifier fieldVar):=idf)
			{
				warnings=processStaticPropertySetNode(cName,fieldVar,resolvedType,warnings,dest);
			}		
			
			//if the statement involves setting a normal var, or an array var 
			//to a particular value, then execute this branch. 
			else if(var(name):=idf || arraySet(var(name)):=idf )
			{
				
				//if any of the types in the set refer to an object-type, then register
				//this identifier in the HandleToIdentifierMap
				for(Type aT <- resolvedType.types)
					if(Object(h,_):=aT) //if type is an object type					
						//register this identifier to this handle, and to this node								
						<hdToObjIdfs,labToObjIdfs>= 
							registerIdentifierToObjectHandleAndNode(h,idf,nodeLabel,hdToObjIdfs,labToObjIdfs);					
				
				//if the statement involves setting an array value								
				if(idf is arraySet)
				{
					//redeclare idf as the ordinary var that is contained within idf		
					idf=idf.arrVar;			
					<resolvedType,warn>=processArraySetExpression(resolvedType,idf,entry,dest);
					warnings +=[warn];
				}
				
					
				//if two or more labels point to the same identifier, then check and see if
				//there's an updated value, and use that value !!	
				//I don't remember anymore in what kind of php statements this occurs...	
				
				if(resolvedType != entry[idf])
				{
					//no need to update value when encountering a propertySet(_,_), because I go through an
					//internal iteration that resolves all property-sets and all the object references
					//by calling the method: notifyObjectVarsOfObjectInstanceUpdate(..)
				
					//if any of the type is 'any', then be sure to generate a warning for that.					
					if(hasVoidType(resolvedType.types))
						warnings+=[assignVoidTypeToVar("Assigning a Void type to var(<idf.name>) @ <dest>.")];
					
					//check and see if the type changed for this variable	
					if(typeChanged(resolvedType,entry[idf]))
						warnings+=[typeOfVarChanged(" Var(<idf.name>) changed type @ <dest> "+ 
							"from <entry[idf].types> to <resolvedType.types>.")];

					//update type info for var in the type environment
					toReturn[idf]=resolvedType;

					//note that the value of this var has changed in the analysis of this node.	
					varChangedTypeRootCount[idf]=varChangedTypeRootCount[idf]+1;
					if( varChangedTypeRootCount[idf] >1)
						throw "Identifier: <idf> changed TypeRoot more than once for analysis node: <nodeLabel>";

				}//end if (resolvedType != entry[idf])
				
				
			}
			else
			{			
				throw "Unknown concrete type for TypeRoot. Error loc 7160143. TypeRoot: <cc.t>";
			}
			
		}//end if (dest in identifierMap)
	
	}//end for(Constraint cc <- dependencyResolvedConstraints)	
	
	//once you've made any necessary type information update, 
	//update all vars that has a reference to a dirty handle!
	<temp,warnings>=updateVarReferencesWithDirtyHandles(dirtyHandles,nodeLabel,warnings,hdToObjIdfs,labToObjIdfs);
	toReturn+=temp;
	
	//invoke method to check for any kind of illegal type-coercions
	warnings+=
		checkForWarningsInNode(nodeLabel,dependencyResolvedConstraints,entry);
	
	//return the new type-environment, plus other information generated 
	//for this node..! Analysis is complete for one node in the cfg.
	return <toReturn,hdToObjIdfs,labToObjIdfs,warnings>;
}//end method transferTypes

public list[Warning] processStaticPropertySetNode(str cName,Identifier fieldVar,TypeRoot resolvedType,list[Warning] warns,Lab l )
{
	printIndLn("static field set node encountered. Proceeding to update static instance of class: <cName>");
	
	str actualClassName="";
	set[Handle] h={};
		
	if(cName=="self")
	{
		//get set of handles stored in calling context					
		h=top(GlobalObjectContextStack);
		
		//assert that there is only one handle, because there should be only one static-instance
		//of each php class
		assert size(h)==1;
		actualClassName=HandleToClassInstanceMap[getOneFrom(h)].srcClass;
		
	}
	else
	{
		actualClassName=cName;
	}
	
	//first, get the class scheme from the global class map
	ClassScheme classScheme=GlobalClassDeclsMap[actualClassName];
	
	//Now get the static instance 
	ClassInstance thisStatInstance=classScheme.statInstance;
	
	//assert that the given field exists
	if (fieldVar in thisStatInstance.fieldToTypeMap)
	{
	
		//Now update the field information
		thisStatInstance.fieldToTypeMap[fieldVar]=resolvedType;
								
		//Now update the static instance parameter of current class;
		classScheme.statInstance=thisStatInstance;
		
		//finally update GlobalClassDeclsMap
		GlobalClassDeclsMap[actualClassName]=classScheme;
		
		//search for the handle that points to static instance of this class
		set[Handle] searchedH={hh|hh<-HandleToClassInstanceMap,
			HandleToClassInstanceMap[hh].srcClass==actualClassName,
			HandleToClassInstanceMap[hh] is statInst};
		//make an assertion
		assert size(searchedH)==1:
			"Expected single handle for static instance. Failed. Retreived handle-set: <searchedH>";
		//Now finally proceed to update the global map
		HandleToClassInstanceMap[getOneFrom(searchedH)]=thisStatInstance;

	}	
	else
	{	
		//return warnings!
		warns+=accessUndefinedClassProperty("Failed to initialize static class property: var(<fieldVar.name>) @ <l>.");
		
	}
	
	return warns; 			
}

public tuple[TypeRoot tR,Warning warn] 
	processArraySetExpression(TypeRoot resolvedType,Identifier idf,TypeEnvironment entry, Lab l)
{
	if(entry[idf] is nullTypeRoot)
	{
		//this means that the var has not been initialized before.
		//just return resolvedType,
		assert resolvedType is typeSet :
			//This assertion is not a php script error to flag, 
			//but logical error in this program.
			"Expected typeSet. Got: <resolvedType>";
		
		for(Type t<-resolvedType.types)
			assert t is Array:
				//if this assertion fails, it is not a php script error to flag, 
				//but error in my logic in this program. any array-set identifier
				//must result in a Array(<some_types>) type for the variable.
				"Expected Array. Got: <t>"; 
				
		return <resolvedType,noWarning("Processed constraint to add new Array: var(<idf.name>) @ <l>.")>;
	}// end if (entry[idf] is nullTypeRoot;
	
	Warning warn=noWarning("foobar");	
	//This means entry[idf] is not nullTypeRoot, i.e. it has been initialized before.
	if(! onlyContainsArrayTypes(entry[idf]) )
		//if entry[idf] had a non-array type, then issue warning below
		warn=typeCoercionWarning("Trying to add key -\> value pair to non-Array: var(<idf.name>) @ <l>.");	
	else
		//okay! idf was already an array type
		warn=noWarning("Processed constraint to add type to Array: var(<idf.name>) @ <l>.");
	
	set[Type] tR={};
	//for all types in entry[idf] that were not array type, 
	//get the array types of them, and widen.
	for(Type t<-entry[idf].types)
	{
		if(Array(_):=t)		
			tR+={t};
		else
			tR+={Array(t)};
		
	}
	TypeRoot toArrayOld=typeSet(tR);	
	return <widen(resolvedType,toArrayOld),warn>;
	
}

public bool onlyContainsArrayTypes(TypeRoot tR)
{
	assert tR is typeSet:
		"Need to be typeSet";
	
	bool onlyArray=true;
	
	for (Type t<-tR.types)
		if(! (t is Array) )
			onlyArray=false;
	return onlyArray;
}

public bool typeChanged(TypeRoot tNew,TypeRoot tOld)
{
	//this signifies that the var had not been processed before.
	//Hence, ignore this.
	if(tOld is nullTypeRoot)
		return false;
	assert tOld is typeSet:
		"Old TypeRoot expected to be a typeSet. Got: <tOld>. Error@loc 1767-847018-283.";
	//tNew has already been checked to be typeSet.
	
	//Again, if the typeset has void, then it means that var was assinged a value
	//from an errorneous expression (e.g. uninitialized variable, undeclared func, or
	//a func. with void return type. In this case, a typeChange is a good thing!
	if(hasVoidType(tOld.types))
		return false;
	
	//if an int or float type is being replaced by a 'num' type, don't issue warning
	if( (tOld.types=={Int()} || tOld.types=={Float})
		&& tNew.types=={Num()})
		return false;
		
	if(! (tNew==tOld) )
		return true;
}

public tuple[TypeEnvironment typeEnvm,HdToObjIdfs map1,LabToObjIdfs map2,list[Warning] warnings] 
	processPropertySetNode(Lab nodeLabel,Lab lab,
		Identifier fieldName,TypeEnvironment entry,LabelToIdentifierMap labelToIdentifierMap,
				TypeRoot resolvedType,HdToObjIdfs hdToObjIdfs, LabToObjIdfs labToObjIdfs,Lab l)

{	
	/*
	Think of a statement that appears as: 
	$car->engine->piston->material=new Material();
	
	the CFGNode for this statement would look as follows:
	exprNode(
	  assign(
	    propertyFetch(
	      propertyFetch(
	        propertyFetch(
	          var(name(name("myCar")))[
	            @lab=lab(24)
	          ],
	          name(name("engine")))[
	          @lab=lab(25)
	        ],
	        name(name("piston")))[
	        @lab=lab(26)
	      ],
	      name(name("material")))[
	      @lab=lab(27)
	    ],
	    new(
	      name(name("Material")[
	        ]),
	      [])[
	      @lab=lab(28)
	    ])[
	    @lab=lab(29)
	  ],
	  lab(29))[
	  @lab=lab(29)
	]
	//--------------------------------------------
	The labelToIdentifierMap for this node would look as follows (it only processes the left hand side of the node):
	(
		lab(27):propertySet(lab(26),material)
		lab(26):propertySet(lab(25),piston)
		lab(25):propertySet(lab(24),engine)
		lab(24):var("myCar")
		
	//--------------------------------------------
	Then getHandles would produce a propertySetStack as follows:
	propertySetStack=
		[< {objHd(3)},material >,
		 < {objHd(2)},piston   >,
		 < {objHd(1)},engine   >
		]
		
	where: 
		objHd(3) = an object of type Piston,
		objHd(2) = an object of type Engine, and
		objHd(1) = an object of type Car. 
		
	These object instances were created in the statements preceeding the above.
	So essentially, I am recursing through the propertySet node and getting back the object handle
	pointed to by each node, along with the required fieldName. Once I obtain that, I just									
	*/ 
	
	
	//This method builds a stack of the propertySetNode
	printIndLn("propertySet node encountered. proceeding to update object instance in label: <lab> -\> <fieldName>");
	
	<propertySetStack,warnings>=getHandles(lab,fieldName,entry,labelToIdentifierMap,l);
	
	//Test to see if propertySetSTack is empty. This would be so, if any of the called identifier is a non-object!
	if(isEmpty(propertySetStack))
		return <entry,resolvedType,hdToObjIdfs,labToObjIdfs,warnings>;
		
	while(!isEmpty(propertySetStack))
	{					
		<myTuple,propertySetStack>=pop(propertySetStack);
		set[Type] setType={};
		<myHandles,fieldName>=myTuple;
		//once you've got the handles, look into the fields of each one
		//of them and set their typeRoots from what was obtained
		
		for(Handle h<-myHandles)
		{
			//get class instances pointed by the handle
			ClassInstance ci=HandleToClassInstanceMap[h];
			
			//assert that ci has given field:
			if (fieldName notin ci.fieldToTypeMap)
			{
				warnings+=[dynamicFieldInsertion("Adding field: var(<fieldName.name>) to object @ <l>.")];
			}	
			
			assert resolvedType is typeSet : 
				"Expect typeSet (concrete typeRoot). But Got: <resolvedType>";
			
			//update field type information
			ci.fieldToTypeMap[fieldName]=resolvedType;
			
			//The following is purely to register any newly created/inferred
			//object types to the global handle->object map!
			for(Type t<-resolvedType.types)
				if(t is Object)
				{
					//register the identifier of type objField(handle h, Identifier field)
					//to the object handle, and also to the node
					<hdToObjIdfs,labToObjIdfs>=
						registerIdentifierToObjectHandleAndNode(
							t.h,objField(h,fieldName),nodeLabel,hdToObjIdfs,labToObjIdfs);
				}
			
			//update the global map to reflect this change:
			HandleToClassInstanceMap[h]=ci;
			
			//form an object type.
			setType +={Object(h,ci)};
			
		}//end for iterate through myHandles
		
		//set the resolved type to be typeSet(Set of object types)
		resolvedType=typeSet(setType);
		
		//update all identifiers that references that object
		<temp,warnings> += notifyObjectVarsOfObjectInstanceUpdate(
			nodeLabel,resolvedType,hdToObjIdfs,labToObjIdfs,warnings,"noCauseString");
		entry+=temp;
		
	}//end while

	return <entry,hdToObjIdfs,labToObjIdfs,warnings>;
}

public tuple[TypeEnvironment envm,list[Warning] warnings] 
	updateVarReferencesWithDirtyHandles(map[Handle,ClassInstance] dirtyHandles,
		Lab nodeLabel, list[Warning] warnings,HdToObjIdfs hdToObjIdfs,LabToObjIdfs labToObjIdfs)
{
	TypeEnvironment toRet=();
	//iterate through the dirty handles map
	for(Handle h<-dirtyHandles)
	{
		//form a temporary typeroot, so that I can reuse a method that
		//was written to handle a similar task..
		TypeRoot broadCastTypeRoot=typeSet({Object(h,dirtyHandles[h])});
		
		//use the method below to broadcast this change to all object
		//vars that are registered to listen to this handle's state change!	
		<toRet,warnings>=notifyObjectVarsOfObjectInstanceUpdate(
				nodeLabel,broadCastTypeRoot,hdToObjIdfs,labToObjIdfs,warnings,"funcCallChangedObjectState");
				
		
	}
	
	return <toRet,warnings>;
}
public tuple[TypeEnvironment envm,list[Warning] warnings]notifyObjectVarsOfObjectInstanceUpdate(
	Lab nodeLabel,TypeRoot resolvedType,HdToObjIdfs hdToObjIdfs,LabToObjIdfs labToObjIdfs,list[Warning] warnings,str foo )
{
	//nodeLabel: the current cfg node under analysis
	//resolvedType: the object that changed, and now needs to broadcast its change to all registered identifiers
	//hdToObjIdfs : map[Handle,set[identifiers]] of current analysis envm
	//labToObjIdfs: map[Lab,set[Identifier] ] of current analysis envm.
	
	TypeEnvironment microEnvm=( );

	if(!(resolvedType is typeSet))
		throw "Expect typeSet. Error loc: 614104104.";
		
	for(Type t<-resolvedType.types)
	{
		//For now, I expect object type in this situation!
		if(!(t is Object))
			throw "Expect Object Type. Got: <t>";
		
		//Get handle held by t	
		Handle hHeld=t.h;
		
		//It isn't always the case that a handle has
		//identifiers registered to received state changes.
		//In that case, do nothing
		if(hHeld notin hdToObjIdfs)
			continue;
		
		//If identifiers are registered to receive object updates	
		for(Identifier idf <- hdToObjIdfs[hHeld])
		{
			//First check if this var is initialized...
			//The problem was occuring with revisiting nodes on branches and loops.
			//e.g. 
			/*
			if(i==o)
				//do something
			else
				//do something else
			
			$a=new Object()
			...
			..
			.
			
			The analysis may pick up one of the branches from  if/else fork, and run analyses
			until the end, along the process picking up $a as a registered identifier to object
			created in that statement. However, going back to the other branch in the if/else
			the analysis may try to do stuffs with $a also. The code below prevents this from
			happening.
			*/
		
			if(idf in labToObjIdfs[nodeLabel]){
				//if this identifier has been initialized for this node, procceed
				//to update its object instance
				microEnvm[idf]=resolvedType;
				if(foo=="funcCallChangedObjectState" && (idf has name))				
					warnings+=[objChangedState(
						"Object instance: var(<idf.name>) changed state in a func. or method body @ <nodeLabel>.")];
			}
		}
	}
		
	return <microEnvm,warnings>;

}//end function




public tuple[list[PropertySetNode] propStack,list[Warning] warns]
 getHandles(Lab lab,Identifier fieldVar,TypeEnvironment entry, LabelToIdentifierMap mapp,Lab l)
{
	Identifier next=mapp[lab];

	if(var(name):=next)
	{
		
		list[PropertySetNode] myPropertySetStack=[ ];
		list[Warning] warnings=[];
		//this is the base condition for this recursive function. It is when the
		//propertySet stack essentially points to a variable that holds an object reference.
		//For e.g. in the expression: $obj->aVar->bVar->... , when the function has
		//recursed to this base condition, that var(name) is "$obj". 
		
		if (!(var(name) in entry) )
		{
			//the base object reference is not present in the entry environment.
			//Issue a warning, and return
			warnings+=[readFromNonDeclaredVar("Failed to find: var(<name>) in entry environment @ <l>.")];
			return <myPropertySetStack,warnings>;
		}
			
		
		set[Handle] hh={};
		for (Type t<-entry[var(name)].types)
		{
			if(!(t is Object))
				//insert a warning.. non compatible type
				warnings+=[setPropertyOnNonObjectVar("Failed to set property because var(<name>) is non-object @ <l>.")];
							
			else
				//get the handles pointed to by this var: var(name), where mapp[lab]=var(name).
				hh+={t.h};
		}//end for

		//add element on the propertySetStack only is any set of handles was found
		if(!isEmpty(hh))
			myPropertySetStack=push(<hh,fieldVar>,myPropertySetStack);
			
		
		//return the tuple placed on the propertySetStack
		//This will be the first element that goes on this stack
		return <myPropertySetStack,warnings>;
	}
	//----------------------------------------------------------
	//remains to check below for dynamically added field vars
	if (propertySet(Lab nextLab,Identifier nextField):=next)
	//condition signifies that the field points to another object
	//e.g. $obj->aVar->bVar->cVar...
	{
		//dig deeper (i.e. recurse until you satisfy the base condition)
		<propertySetStack,warnings>=getHandles(nextLab,nextField,entry,mapp,l);
	
		if(isEmpty(propertySetStack))
			return<propertySetStack,warnings>;
				
		//get the top element without removing it from the stack
		myTuple=top(propertySetStack);
		
		<myHandles,fieldName>=myTuple;
		
		// "For my own understanding and piece of mind.";
		assert fieldName==nextField : 
			"fieldName not equal to nextField. Check.";
		//---------------------------------------------	
		//get handles
		set[Handle] hh={};
		
		for(Handle h<-myHandles)
		{
			<tempHandles,tempWarns> =
				getHandlesFromFieldOfClassInstance(HandleToClassInstanceMap[h],nextField,l);
			
			hh+=tempHandles;
			warnings+=tempWarns;
		}
		
		if( !isEmpty(hh) )
			//add element to the stack. It could be empty if the base condition of this function failed	
			propertySetStack=push(<hh,fieldVar>,propertySetStack);			
			
		//return the stack of tuples: <Set[Handle], Identifier>
		return <propertySetStack,warnings>;		
	}	
	else
	{
		throw "Could not find terminating resource for propertySet. Error loc 1041048928.";
	}//end if		
}

public tuple[set[Handle] hds,list[Warning] warns] 
	getHandlesFromFieldOfClassInstance(ClassInstance ci,Identifier fieldVar,Lab l)
{
	set[Handle] hh={};
	list[Warning] warns=[];

	//check to see if fieldVar is defined as a field for given class-instance
	if(fieldVar notin ci.fieldToTypeMap)
	{
		warngs+=[];
		return;
		
	}
	TypeRoot tField=ci.fieldToTypeMap[fieldVar];
	for(Type u<-tField.types)
	{
		if(!(u is Object))
			warns+=[setPropertyOnNonObjectVar("Failed to set property because var(<fieldVar.name>) is non-object @ <l>.")];
		else
			hh+={u.h};
	}//end for	

	return <hh,warns>;
}


public list[Warning] checkForWarningsInNode(Lab nodeLabel,set[Constraint] resolvedConstraints,TypeEnvironment entry)
{

	list[Warning] genWarnings=[];
	//get the set of constraints of type: expectType
	expectConstraints={cc|cc<-resolvedConstraints,cc is expectType || cc is expectFlow};
	
	//Loop through the labels in these constraints, while checking for any
	//illegal type coercions
	
	for(Constraint cc <- expectConstraints)
	{
		
		try
		{	
			//Get the first label (This points to the particular node in consideration)
			Lab l1=cc.l1;
						
			//get the type-set that was evaluated for this label
			TypeRoot typeRootYield=getElementFromSingletonList([
				tt.t| tt<-resolvedConstraints,tt is yieldType, tt.l1==l1 ]);
				
			//assert that it is a typeSet
			assert typeRootYield is typeSet :
				"Expect to yield a concrete typeRoot. Error loc 1098174-01.";
			
			//finally get type calculated for given expression..
			set[Type] typesYield = typeRootYield.types;
			
			//Now proceed to evaluate types to expect!
			set[Type] typesExpect={};	//empty declaration
			if(cc is expectType)
			{
				//also type-root expected for given expression..
				TypeRoot typeRootExpect = cc.t;
				
				//assert that is a typeSet
				assert typeRootExpect is typeSet:
					"Expected typeSet. Got: <typeRootExpect>. Error loc 180874710984.";
					
				//finally, get types expected
				typesExpect=typeRootExpect.types;
				
				//get the generated warnings, if any!
				genWarnings+=
					checkForIllegalTypeCoercions(typesYield,typesExpect,l1);
				
			}
			else if(cc is expectFlow)
			{
				//then we are asserting that two expressions have the same type;
				//get label of the second label (or the label against which l1 is
				// begin compared against)
				Lab l2=cc.l2;
				
				//get the typeroot of l2 from evaluated constraints. There has 
				//gotta be one or it's an error
				TypeRoot typeRootExpect=getElementFromSingletonList([
					tt.t|tt<-resolvedConstraints,tt is yieldType,tt.l1==l2]);
				
				//finally get types expected
				typesExpect=typeRootExpect.types;
				
				//get the generated warnings, if any!
				genWarnings+=
					checkForIllegalTypeCoercions(typesYield,typesExpect,l1,l2);
				
			}
			else
			{
				throw "Expected either expectType or expectFlow constraint. Got: <cc>.";
			}//end if (cc is expectType/expectFlow)
			
		}
		catch AssertionFailed(str msg):
		{
			printIndLn(msg);
			
			//print the constraint causing the trouble:
			printIndLn("Constraint causing trouble:")
			iprintln(cc);
			printIndLn("Resolved Constraints, [Only yieldType]: ");
			iprintln([tt|tt<-resolvedConstraints,tt is yieldType]);
			
			throw msg;
		
		}	
			
	}//end for (iterate through resolvedConstraints)
	return genWarnings;
}



