module soft::typing::php::declarations::PublicDataTypes
import lang::php::ast::AbstractSyntax;
import lang::php::analysis::cfg::CFG;
import lang::php::analysis::cfg::FlowEdge;
import lang::php::analysis::cfg::Label;
import Exception;
import IO;
//------------------------------------------------------------------------------------


//Defining the root type location:
public loc rootP=|file:///Users/apil/Dropbox/Scripts|;

// Defining constraints
public data Type=
		 Bool()|
		 Int()|
		 Float()|
		 String()|
		 Num()|
		 Any()|
		 Object(Handle h,ClassInstance ci)|	
		 Array(Type t)|
		 Void();		 


public data TypeRoot =typeSet(set[Type] types)
					|toArray(Lab aLabel)
					|toArraySet(set[Lab] labels)
					|fromArray(Lab l)
					|toArray(Type t)
					|funcCall(str name,list[Lab] params)
					|fromLabels(set[Lab] labels)
					|fromLabel(Lab label)
					|fromVar(Identifier aVar)
					//Added for object support
					|newObjectInstance(str cName,list[Lab] params)
					|fromObjectProperty(TypeRoot fromExprAtLabel,Identifier fieldVar)
					|fromStaticProperty(str cName, Identifier fieldVar)
					|fromMethodCall(TypeRoot fromExprAtLabel,str fName,list[Lab] params)
					|fromStaticCall(str cName, str fName, list[Lab] params)
					|nullTypeRoot();
					
				/*
					The reason I have the following for dealing with object instances:
					- |fromObjectProperty(TypeRoot fromExprAtLabel,Identifier fieldVar)
					- |fromMethoCall(TypeRoot fromExprAtLabel,str fName,list[Lab] params)
					
					( say as opposed to using Identifier objName instead of TypeRoot fromExprAtLabel )
					is since Object instances are uniquely identified by a handle that points to them;
					and not variables. In fact, some times i could have:
					
					new ClassA( ) -> invokeMethodA( );
					
					in which case, I don't even have an identifier to associate with for the objects.
					Hence, I will simply have a constructor (above two) that says that ultimately, I will 
					delegate this job to a later point when the expression has to be resolved, before invoking
					the method call.
					
				*/
					
public data Constraint=
	nullConstraint( )		   |				
	yieldFlow(Lab l1,Lab l2)   |
	expectFlow(Lab l1,Lab l2)  | 
	yieldType(Lab l1,TypeRoot t)| 
	expectType(Lab l1, TypeRoot t);

public data Severity=severe(num v)|moderate(num v)|noerr(num v);

public data Warning=
	//incompatibility with got and expected types for any label
	typeCoercionWarning(str inform)|
	
	equalTypesExpectedFail(str inform)|
	
	//trying to read from expressions using array index, i.e. $some_expr[<some_index>]
	readFromNonArrayVal(str inform)|
	
	//read from non-declared/non-initialized var
	readFromNonDeclaredVar(str inform)|
	
	//read from a var that has the "Any" type. Doesn't add much to the type information.
	readFromVarWithVoidType(str inform)|
	
	//Warning to inform that an "Any" type is being assigned to a var
	assignVoidTypeToVar(str inform)|
	
	//Warning to inform that a function call could not be completed
	//because the function definition could not be found.
	failedToFindFunction(str inform)|
	
	//used to denote that a "Any" type was computed from an express.
	usingVoidTypeForExpr(str inform)|
	
	//used to denoted that the type of a var changed 
	typeOfVarChanged(str inform)|
	
	//used to point that a var acquired multiple types
	varHasMultipleTypes(str inform)|
	
	//instantiate object from non defined class
	classDefNotFound(str inform)|
	
	//access undefined object property
	accessUndefinedClassProperty(str inform)|
	
	//read from uninitialized object field
	readUninitializedClassProperty(str inform)|
	
	//read non-object as object
	readPropertyFromNonObjectVar(str inform)|
	
	//call method on a var that is not an object type
	callMethodFromNonObjectVar(str inform)|
	
	//set property expression on non-object var
	setPropertyOnNonObjectVar(str inform)|
	
	//call function with less than specified number of arguments
	insufficientArgsOnFuncCall(str inform)|

	//referenced 'this' while calling a static function
	referenceObjInStaticContext(str inform)|	
	
	//dynamic field insertion for an object
	dynamicFieldInsertion(str inform)|
	
	//inform that an object changed state inside a func. body
	objChangedState(str inform)|
	
	//informs that analyzing a recursively called function call sequence
	//could not derive any concrete type.
	recursiveCallAnalysisFailed(str inform)|
	
	//used to inform the user that a file to be included could not be
	//included for some reason. Maybe a syntax/missing
	includeFileNotFound(str inform)|
	
	noWarning(str inform);
	
	
		
	
//------------------------------------------------------------------------------------
//Taken from soft.typing.php.Identifier
public data Identifier
					 //ordinary variables
					 =var(str name) 
					  //for processing propertyFetch nodes in the ast
					  |propertySet(Lab exprLabel,Identifier fieldName)
					  //for static fields
					  |statFieldSet(str cName,Identifier fieldName)
					  
					  //for instance fields
					  /*
					   * I have objHd instead of a var(name) to refer to the object
					   * containing the field; because an object instance is uniquely
					   * identified using a handle, and not a variable in this analysis.
					   * 
					   * Now the below is not mentioned in the thesis. It serves as an
					   * auxilary data that I maintain through the code, which lets me
					   * view the types of object fields as I propagate analysis through
					   * a script. Not included in thesis for brevity
					   */ 
					  |objField(Handle objHd,Identifier fieldName)
					  
					  //array set expressions; e.g. $a[1]= <some_value>;
					  /* Not mentioned in thesis for sake of brevity too
					  */    	
					  |arraySet(Identifier arrVar);
					  
	

public alias TypeEnvironment=map[Identifier,TypeRoot];

public alias LabelToIdentifierMap =map[Lab,Identifier];


public alias LabToObjIdfs=map[Lab,set[Identifier]];

public alias HdToObjIdfs=map[Handle,set[Identifier]];

//------------------------------------------------------------------------------------
//Taken from soft.typing.php.Utils.Analysis
//this is an in-memory storage of all functions defined in global scope for the php script in analysis
public map[str,Function] GlobalFuncDeclsMap=(); 


//declaration of func data type
public data Function=func(map[list[Type],TypeRoot] templates);
/* The structure is as follows:
 * for each function declared as: func("fName",templates),
 * the templates is a map which maps a list of types to a typeroot. The list
 * of types is essentially a list of the types carried by the function parameters
 * in the order that they appear in a call site.
 * For e.g. if a function is called as follows:
 * 
 * sum($a,$b), and  
 * 	typeRoot($a) = typeSingleton(Int()), 
 * 	typeRoot($b) = typeSingleton(Float()),
 * then, we would have a func datatype that looked as follows:
 * Function aFunc=func("sum",templates), where
 * templates=
 * (
 *   [ Int(),Float() ]: Float()
 * )
 *
 * If we had additional call sites for sum, where the typeroots of $a and $ b were
 * typeSet( {String(),Bool() } ), and typeSet( {String(),Float()} ) respectively,
 * then, the templates for the func: sum would be
 *
 * templates=
   (
     [ Int( ),Float()   ]: Float(),
     [ String(),String()]: someReturnType,
     [ String(),Float() ]:  "			 ,
     [ Bool(),String()	]:  "			 ,
     [ Bool(),Float()	]:	"			 ,
  )
 * 
 * So, in essence, the map 'templates' is a representation of the cartesian product
 * relation of the set of type parameters obtained for the calls.
*/

//define the structure for the PHP Application in analysis
public map[str,AnalysisEnvm] ApplicationMap=();

//The following is used to grab the exit Environment from each
//analysis envm, when propagation finishes propagating through it.
//This is only used to set up the unit test 
public map[str,map[Lab,TypeEnvironment]] AppExitEnvms=();

//The following is used to grab warnings from the entire application,
//and used only to set up the unit test as well!
public map[str,list[Warning]] AppWarnings=();

//an analysis envm is defined for each script file loaded
public data AnalysisEnvm=analysisEnvm(
	//get information on scriptName
	str scriptName,
	//to store information about the nodes in this envm (file)
	set[AnalysisNode] analysisNodes,
	//label to identifier map required to keep track of identifiers defined
	map[Lab,LabelToIdentifierMap] labelToIdentifierTable,
	//entry environment table
	map[Lab,TypeEnvironment] entryEnvironmentTable,
	//exit environment table
	map[Lab,TypeEnvironment] exitEnvironmentTable,
	//used during propagation, ensures that each node is visited at least once!
	map[Lab,bool] isVisited,
	//the following is copied directly from the CFG; used only to print final dot figure
	set[FlowEdge] edges,
	
	//This is to keep track of all the identifiers that possess a particular 
	//handle. This will be used to notify the identifiers when the object instance
	//changes, so that each can update its object instance to the changed object.
	
	//For e.g if two statements appear as: $abc=new A( ), and $efg=$abc,
	//then now, $efg and $abc will both be associated with the same handle. Now, 
	//any state change of the object pointed to by the handle can now be
	// broadcasted to both these listeners.
	
	//map[Handle,set[Identifier]] objHdToSetOfAliasedObjectIdfs,
	HdToObjIdfs hdToObjIdfs,
	//-------------------------------------------------------------
	//The following  data structures is used to keep track of
	//which object instances have been initialized until now. This is because
	//until now, I just scan the whole script for identifiers and start them
	//from the beginning. That was causing me some problems, where I had
	//aliases for objects. Hopefully this will resolve the issue. Additionally,
	//
	// TODO: REFACTOR this away, because I don't like the look of this. The only
	//reason I'm going along for now is because I dont want to spend too much time
	//resolving this prettily. There will likely be other issues to resolve as I
	//add support for more complex analysis. I want to attack them all at once later.
	
	//map[Lab,set[Identifier]] labToObjIdfs
	LabToObjIdfs labToObjIdfs
	 
);
	
//define what an AnalysisNode maybe
public data AnalysisNode= 
	analysisNode(
		Lab l,
		str content,
		set[Constraint] constraints,
		set[FlowEdge] edgesTo
	)|
  	scriptEntryNode(
  		Lab l,
  		str content,
  		set[FlowEdge] edgesTo
  	)|	 
  	scriptExitNode (
  		Lab l,
  		str content
  	)|
  	paramDefinition(
  		str paramName,
  		Lab l,
  		str content,
  		set[Constraint] constraints,
  		set[FlowEdge] edgesTo
  	)|
  	returnNode(
  		Lab l,
  		str content,
  		set[Constraint] constraints,
  		set[FlowEdge] edgesTo
  	)|
  	includeNode(
  		//any include definitions
  		Lab l,
  		str content,
  		set[Constraint] constraints,
  		set[FlowEdge] edgesTo,
  		str scriptName
  	)|
  	inlineHTMLNode(
  		Lab l,
  		str content,
  		set[Constraint] constraints,
  		set[FlowEdge] edgesTo
  	
	);


//------------------------------------------------------------------------------------
//Defining data types for class typing support
//an in-memory store of all class defined in 
//global scope for php script under analysi
public map[str,ClassScheme] GlobalClassDeclsMap=();

public int ClassTemplateId=0;
public int ClassInstanceId=-1;
public data ClassElement
	/*
	An important distinction in how I've defined ClassElement from ClassItem 
	(in PHPAnalysis) is that I will define a unique instance of field for every
	property that is declared.. for e.g. if there's a declaration as
	
	Class A{
	
		public static $var1,$var2;
		..
	}
	
	Then I construct two instances of field, each for $var1 and $var2, while the 
	original Script maintains a single property reference to both these fields.	
	*/ 
	=field  (set[Modifier] modifiers,Identifier prop)
	|method (set[Modifier] modifiers,str name,list[Param] params);

public data ClassScheme=classScheme
	(
		str name, 
		str parent, 
	
		set[ClassElement] fields,
		set[ClassElement] methods, 
		
		ClassInstance initInstance,
		
		ClassInstance statInstance,
		
		//this is to maintain reference to all
		//object instances spawned from this 
		//class. Don't have much use for this yet!
		set[Handle] objInstanceHandles
	);

public data ClassTemplate=classTemplate
	(
		int classTemplateId,
		list[Type] OneCombination
	);
	
public data ClassInstance=
	//this instance is constructed when a class definition is encountered for
	//the first time. This instance will also be used to spawn new object instances
	//of the class.
	initInst
	(
		//int classInstanceId,
		map[Identifier,TypeRoot] fieldToTypeMap //all fields, static and non-static
		//str srcClass,
		//set[ClassTemplate] myClassTemplates
	)|
	statInst
	//only one static instance available at any point in time. Used to keep track of all
	//static members
	(
		int classInstanceId,
		map[Identifier,TypeRoot] fieldToTypeMap, //only information on static fields kept track of
		str srcClass
		//set[ClassTemplate] myClassTemplates
	
	)|
	objInst
	//An object instance is created when a class constructor is encountered
	(
		int classInstanceId,
		map[Identifier,TypeRoot] fieldToTypeMap, //only information on non-static fields 
		str srcClass,
		set[ClassTemplate] myClassTemplates
	);
	 
public data Handle=
	//maybe define references (or aliases) as a kind of this data as well..?
	objHd(int classInstanceId);  

//use this to maintain a map from a handle to a class-instance
public map[Handle,ClassInstance] HandleToClassInstanceMap=( );



//stores the information on the object instance that is making a method call.
public list[set[Handle]] GlobalObjectContextStack=[];

//stores the function call stack. If this stack contains any
//function already, then the tool will not call this function.
//Added: also keep track of the particular template in the call-stack
public list[tuple[str fName,list[Type] paramsType]] GlobalFuncCallStack=[];

//-------------------------------------------------------------
//The following set stores all variables that acquired more than
//one kind of types in the given analysis envm. It is used so that
//the same var may not generate warnings about having multiple types
//through the entire nodes in a given analysis environment.
								
public map[str,set[Identifier]] MultipleTypedVarMap=();	

//-------------------------------------------------------------

public alias AppInfo=tuple[map[str,map[Lab,TypeEnvironment]],map[str,list[Warning]]];

