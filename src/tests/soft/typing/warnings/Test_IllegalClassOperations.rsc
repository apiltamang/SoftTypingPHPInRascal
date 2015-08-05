module tests::soft::typing::warnings::Test_IllegalClassOperations

import lang::php::analysis::cfg::Label;
import soft::typing::php::elements::Identifier;
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::Utils::Analysis;
import tests::soft::typing::php::helper::Test_SetComparator;

import soft::typing::php::declarations::PublicDataTypes;

private loc localP=rootP+"Test_IllegalClassOperations";

test bool test_UndefinedClass()
{
	fileTest="UndefinedClass.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectInfo= <("UndefinedClass.php":(
    lab(5):(
      var("yes"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("make"):typeSet({String()}),
                var("year"):nullTypeRoot()
              ),
              "ClassA",
              {}))}),
      var("no"):nullTypeRoot()
    ),
    lab(2):(
      var("yes"):nullTypeRoot(),
      var("no"):nullTypeRoot()
    ),
    lab(12):(
      var("yes"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("make"):typeSet({String()}),
                var("year"):nullTypeRoot()
              ),
              "ClassA",
              {}))}),
      var("no"):typeSet({Void()})
    ),
    lab(9):(
      var("yes"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("make"):typeSet({String()}),
                var("year"):nullTypeRoot()
              ),
              "ClassA",
              {}))}),
      var("no"):typeSet({Void()})
    ),
    lab(11):(
      var("yes"):nullTypeRoot(),
      var("no"):nullTypeRoot()
    )
  	)),("UndefinedClass.php":[
    	classDefNotFound("Trying to instantiate from unknown class: ClassB @ lab(9)"),
    	usingVoidTypeForExpr("Computed typeSet for lab(9) has Void type."),
    	assignVoidTypeToVar("Assigning a Void type to var(no) @ lab(7).")
  	])>;
  	
  	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");	

}

test bool test_AccessUndefinedClassProperty()
{
	fileTest="AccessUndefinedClassProperty.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo= <("AccessUndefinedClassProperty.php":(
    lab(20):(
      var("testA"):typeSet({String()}),
      var("yes"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("make"):typeSet({String()}),
                var("year"):nullTypeRoot()
              ),
              "ClassA",
              {}))}),
      var("testB"):typeSet({Void()}),
      var("testC"):typeSet({Void()})
    ),
    lab(22):(
      var("testA"):nullTypeRoot(),
      var("yes"):nullTypeRoot(),
      var("testB"):nullTypeRoot(),
      var("testC"):nullTypeRoot()
    ),
    lab(23):(
      var("testA"):typeSet({String()}),
      var("yes"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("make"):typeSet({String()}),
                var("year"):nullTypeRoot()
              ),
              "ClassA",
              {}))}),
      var("testB"):typeSet({Void()}),
      var("testC"):typeSet({Void()})
    ),
    lab(5):(
      var("testA"):nullTypeRoot(),
      var("yes"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("make"):typeSet({String()}),
                var("year"):nullTypeRoot()
              ),
              "ClassA",
              {}))}),
      var("testB"):nullTypeRoot(),
      var("testC"):nullTypeRoot()
    ),
    lab(2):(
      var("testA"):nullTypeRoot(),
      var("yes"):nullTypeRoot(),
      var("testB"):nullTypeRoot(),
      var("testC"):nullTypeRoot()
    ),
    lab(15):(
      var("testA"):typeSet({String()}),
      var("yes"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("make"):typeSet({String()}),
                var("year"):nullTypeRoot()
              ),
              "ClassA",
              {}))}),
      var("testB"):typeSet({Void()}),
      var("testC"):nullTypeRoot()
    ),
    lab(10):(
      var("testA"):typeSet({String()}),
      var("yes"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("make"):typeSet({String()}),
                var("year"):nullTypeRoot()
              ),
              "ClassA",
              {}))}),
      var("testB"):nullTypeRoot(),
      var("testC"):nullTypeRoot()
    )
  	)),("AccessUndefinedClassProperty.php":[
    	accessUndefinedClassProperty("Attempt to access un-defined object property: var(model) @ lab(12)."),
    	usingVoidTypeForExpr("Computed typeSet for lab(12) has Void type."),
    	assignVoidTypeToVar("Assigning a Void type to var(testB) @ lab(12)."),
    	readUninitializedClassProperty("Attempt to read un-initialized object property: var(year) @ lab(17)."),
    	usingVoidTypeForExpr("Computed typeSet for lab(17) has Void type."),
    	assignVoidTypeToVar("Assigning a Void type to var(testC) @ lab(17).")
  	])>;
  
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");  	
}

test bool test_AccessUndefinedStaticProperty()
{
	fileTest="AccessUnDefinedStaticProperty.php";
	exitEnvm=runAnalysis(localP,fileTest);
	expectInfo= <("AccessUnDefinedStaticProperty.php":(
	    lab(16):(
	      var("testA"):typeSet({String()}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):typeSet({Void()})
	    ),
	    lab(5):(
	      var("testA"):typeSet({String()}),
	      var("testB"):nullTypeRoot(),
	      var("testC"):nullTypeRoot()
	    ),
	    lab(2):(
	      var("testA"):nullTypeRoot(),
	      var("testB"):nullTypeRoot(),
	      var("testC"):nullTypeRoot()
	    ),
	    lab(13):(
	      var("testA"):typeSet({String()}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):typeSet({Void()})
	    ),
	    lab(15):(
	      var("testA"):nullTypeRoot(),
	      var("testB"):nullTypeRoot(),
	      var("testC"):nullTypeRoot()
	    ),
	    lab(9):(
	      var("testA"):typeSet({String()}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):nullTypeRoot()
	    )
	  )),("AccessUnDefinedStaticProperty.php":[
	    accessUndefinedClassProperty("Attempt to read from undefined class property: var(model) of class: ClassA @ lab(7)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(7) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(testB) @ lab(7)."),
	    readUninitializedClassProperty("Attempt to read from uninitialized class property: var(year) of class: ClassA @ lab(12)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(12) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(testC) @ lab(11).")
	  ])>;
		
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate Warnings");	
}

test bool test_ErroneousMethodCalls()
{
	fileTest="ErroneousMethodCalls.php";
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectInfo=
	<(
	  "ClassA.testMethodA":(
	    lab(3):(
	      var("a"):typeSet({Int()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})
	    ),
	    lab(73):(var("a"):nullTypeRoot()),
	    lab(74):(
	      var("a"):typeSet({Int()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})
	    ),
	    lab(75):(
	      var("a"):typeSet({Int()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})
	    )
	  ),
	  "ClassA.testMethodB":(
	    lab(7):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({Void()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})
	    ),
	    lab(76):(
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot()
	    ),
	    lab(77):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({Void()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})
	    ),
	    lab(78):(
	      var("a"):typeSet({Int()}),
	      var("b"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})
	    ),
	    lab(79):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({Void()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})
	    )
	  ),
	  "ClassA.testMethodC":(
	    lab(80):(var("x"):nullTypeRoot()),
	    lab(81):(
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("x"):typeSet({Void()})
	    ),
	    lab(82):(
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("x"):typeSet({Void()})
	    ),
	    lab(11):(
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("x"):typeSet({Void()})
	    )
	  ),
	  "ClassA.testMethodD":(
	    lab(84):(var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})),
	    lab(16):(var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})),
	    lab(83):(),
	    lab(13):(var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))})),
	    lab(15):(var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}))
	  ),
	  "ErroneousMethodCalls.php":(
	    lab(20):(
	      var("testA"):nullTypeRoot(),
	      var("testA3"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):nullTypeRoot(),
	      var("testA2"):nullTypeRoot(),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):nullTypeRoot(),
	      var("testC"):nullTypeRoot(),
	      var("testD"):nullTypeRoot()
	    ),
	    lab(54):(
	      var("testA"):typeSet({Int()}),
	      var("testA3"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):typeSet({Num()}),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):typeSet({Void()}),
	      var("testD"):typeSet({Void()})
	    ),
	    lab(61):(
	      var("testA"):typeSet({Int()}),
	      var("testA3"):typeSet({Void()}),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):typeSet({Num()}),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):typeSet({Void()}),
	      var("testD"):typeSet({Void()})
	    ),
	    lab(31):(
	      var("testA"):nullTypeRoot(),
	      var("testA3"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):typeSet({Num()}),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):nullTypeRoot(),
	      var("testC"):nullTypeRoot(),
	      var("testD"):nullTypeRoot()
	    ),
	    lab(25):(
	      var("testA"):nullTypeRoot(),
	      var("testA3"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):nullTypeRoot(),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):nullTypeRoot(),
	      var("testC"):nullTypeRoot(),
	      var("testD"):nullTypeRoot()
	    ),
	    lab(71):(
	      var("testA"):nullTypeRoot(),
	      var("testA3"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):nullTypeRoot(),
	      var("testA2"):nullTypeRoot(),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):nullTypeRoot(),
	      var("testB"):nullTypeRoot(),
	      var("testC"):nullTypeRoot(),
	      var("testD"):nullTypeRoot()
	    ),
	    lab(65):(
	      var("testA"):typeSet({Int()}),
	      var("testA3"):typeSet({Void()}),
	      var("foo"):typeSet({Int()}),
	      var("testB2"):typeSet({Num()}),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):typeSet({Void()}),
	      var("testD"):typeSet({Void()})
	    ),
	    lab(72):(
	      var("testA"):typeSet({Int()}),
	      var("testA3"):typeSet({Void()}),
	      var("foo"):typeSet({Int()}),
	      var("testB2"):typeSet({Num()}),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):typeSet({Void()}),
	      var("testD"):typeSet({Void()})
	    ),
	    lab(43):(
	      var("testA"):typeSet({Int()}),
	      var("testA3"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):typeSet({Num()}),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):nullTypeRoot(),
	      var("testD"):nullTypeRoot()
	    ),
	    lab(49):(
	      var("testA"):typeSet({Int()}),
	      var("testA3"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):typeSet({Num()}),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):typeSet({Void()}),
	      var("testD"):nullTypeRoot()
	    ),
	    lab(17):(
	      var("testA"):nullTypeRoot(),
	      var("testA3"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):nullTypeRoot(),
	      var("testA2"):nullTypeRoot(),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):nullTypeRoot(),
	      var("testB"):nullTypeRoot(),
	      var("testC"):nullTypeRoot(),
	      var("testD"):nullTypeRoot()
	    ),
	    lab(69):(
	      var("testA"):typeSet({Int()}),
	      var("testA3"):typeSet({Void()}),
	      var("foo"):typeSet({Int()}),
	      var("testB2"):typeSet({Num()}),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):typeSet({Void()}),
	      var("testC"):typeSet({Void()}),
	      var("testD"):typeSet({Void()})
	    ),
	    lab(37):(
	      var("testA"):typeSet({Int()}),
	      var("testA3"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("testB2"):typeSet({Num()}),
	      var("testA2"):typeSet({Void()}),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "ClassA",
	              {}))}),
	      var("testB"):nullTypeRoot(),
	      var("testC"):nullTypeRoot(),
	      var("testD"):nullTypeRoot()
	    )
	  )
	),(
	  "ClassA.testMethodA":[
	    readFromVarWithVoidType("Reading from var containing Void type  @ lab(2)"),
	    usingVoidTypeForExpr("Computed typeSet for lab(2) has Void type.")
	  ],
	  "ClassA.testMethodB":[
	    readFromVarWithVoidType("Reading from var containing Void type  @ lab(5)"),
	    usingVoidTypeForExpr("Computed typeSet for lab(5) has Void type."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(5). Got: Void(). Expected from: {Num()}.")
	  ],
	  "ClassA.testMethodC":[
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(9). Got: Int(). Expected from: {String()}."),
	    readFromVarWithVoidType("Reading from var containing Void type  @ lab(9)"),
	    usingVoidTypeForExpr("Computed typeSet for lab(9) has Void type."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(9). Got: Void(). Expected from: {String()}.")
	  ],
	  "ClassA.testMethodD":[usingVoidTypeForExpr("Computed typeSet for lab(16) has Void type.")],
	  "ErroneousMethodCalls.php":[
	    insufficientArgsOnFuncCall("Function call made with less than min. required args @ lab(22)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(22) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(testA2) @ lab(22)."),
	    insufficientArgsOnFuncCall("Function call made with less than min. required args @ lab(31)."),
	    failedToFindFunction("Failed to find function definition: ClassA.testMethodE, call site @ lab(39)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(39) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(testB) @ lab(39)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(45) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(testC) @ lab(45)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(51) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(testD) @ lab(51)."),
	    readFromNonDeclaredVar("Attempt to read from undeclared var(x) @ lab(58)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(58) has Void type."),
	    readFromNonDeclaredVar("Attempt to read from undeclared var(y) @ lab(59)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(59) has Void type."),
	    usingVoidTypeForExpr("Computed typeSet for lab(61) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(testA3) @ lab(56)."),
	    callMethodFromNonObjectVar("Attempt to call method: testMethodC from non-object @ lab(69)."),
	    callMethodFromNonObjectVar("Attempt to call method: testMethodC from non-object @ lab(69)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(69) has Void type.")
	  ]
	)>;
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate Warnings");
	//return <AppExitEnvms,AppWarnings>;
}