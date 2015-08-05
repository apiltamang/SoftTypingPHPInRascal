module tests::soft::typing::warnings::Test_IllegalClassOperations2

import lang::php::analysis::cfg::Label;
import soft::typing::php::elements::Identifier;
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::Utils::Analysis;
import tests::soft::typing::php::helper::Test_SetComparator;

import soft::typing::php::declarations::PublicDataTypes;

private loc localP=rootP+"Test_IllegalClassOperations2";

test bool test_ErroneousVarAccessInMethods()
{
	fileTest="ErroneousVarAccessInMethods.php";
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo= <(
	  "ClassA.getYear":(
	    lab(17):(
	      var("temp1"):typeSet({Void()}),
	      var("temp3"):typeSet({Int()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Int()})
	              ),
	              "ClassA",
	              {}))}),
	      var("temp2"):typeSet({Void()})
	    ),
	    lab(35):(
	      var("temp1"):nullTypeRoot(),
	      var("temp3"):nullTypeRoot(),
	      var("this"):nullTypeRoot(),
	      var("temp2"):nullTypeRoot()
	    ),
	    lab(14):(
	      var("temp1"):typeSet({Void()}),
	      var("temp3"):typeSet({Int()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Int()})
	              ),
	              "ClassA",
	              {}))}),
	      var("temp2"):typeSet({Void()})
	    ),
	    lab(9):(
	      var("temp1"):typeSet({Void()}),
	      var("temp3"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Int()})
	              ),
	              "ClassA",
	              {}))}),
	      var("temp2"):typeSet({Void()})
	    ),
	    lab(36):(
	      var("temp1"):typeSet({Void()}),
	      var("temp3"):typeSet({Int()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Int()})
	              ),
	              "ClassA",
	              {}))}),
	      var("temp2"):typeSet({Void()})
	    ),
	    lab(4):(
	      var("temp1"):typeSet({Void()}),
	      var("temp3"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Int()})
	              ),
	              "ClassA",
	              {}))}),
	      var("temp2"):nullTypeRoot()
	    )
	  ),
	  "ErroneousVarAccessInMethods.php":(
	    lab(21):(
	      var("testA"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):nullTypeRoot()
	              ),
	              "ClassA",
	              {}))})
	    ),
	    lab(18):(
	      var("testA"):nullTypeRoot(),
	      var("obj"):nullTypeRoot()
	    ),
	    lab(31):(
	      var("testA"):typeSet({Int()}),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Int()})
	              ),
	              "ClassA",
	              {}))})
	    ),
	    lab(26):(
	      var("testA"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Int()})
	              ),
	              "ClassA",
	              {}))})
	    ),
	    lab(33):(
	      var("testA"):nullTypeRoot(),
	      var("obj"):nullTypeRoot()
	    ),
	    lab(34):(
	      var("testA"):typeSet({Int()}),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Int()})
	              ),
	              "ClassA",
	              {}))})
	    )
	  )
	),(
	  "ClassA.getYear":[
	    accessUndefinedClassProperty("Attempt to access un-defined object property: var(model) @ lab(4)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(4) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(temp1) @ lab(1)."),
	    readUninitializedClassProperty("Attempt to read un-initialized object property: var(make) @ lab(6)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(6) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(temp2) @ lab(6).")
	  ],
	  "ErroneousVarAccessInMethods.php":[]
	)>;

	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
	
}

test bool test_AdditionalMethodCalls()
{
	fileTest="AdditionalMethodCalls.php";
	exitEnvm=runAnalysis(localP,fileTest);


	expectInfo=
	<(
	  "Year.setValue":(
	    lab(6):(
	      var("this"):typeSet({Object(
	            objHd(5),
	            objInst(
	              5,
	              (var("value"):typeSet({Int()})),
	              "Year",
	              {}))}),
	      var("x"):typeSet({Int()})
	    ),
	    lab(40):(
	      var("this"):nullTypeRoot(),
	      var("x"):nullTypeRoot()
	    ),
	    lab(42):(
	      var("this"):typeSet({Object(
	            objHd(5),
	            objInst(
	              5,
	              (var("value"):nullTypeRoot()),
	              "Year",
	              {}))}),
	      var("x"):typeSet({Int()})
	    ),
	    lab(41):(
	      var("this"):typeSet({Object(
	            objHd(5),
	            objInst(
	              5,
	              (var("value"):typeSet({Int()})),
	              "Year",
	              {}))}),
	      var("x"):typeSet({Int()})
	    ),
	    lab(9):(
	      var("this"):typeSet({Object(
	            objHd(5),
	            objInst(
	              5,
	              (var("value"):typeSet({Int()})),
	              "Year",
	              {}))}),
	      var("x"):typeSet({Int()})
	    )
	  ),
	  "Year.newYear":(
	    lab(38):(),
	    lab(39):(),
	    lab(2):()
	  ),
	  "AdditionalMethodCalls.php":(
	    lab(21):(var("obj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):nullTypeRoot()
	              ),
	              "ClassA",
	              {}))})),
	    lab(18):(var("obj"):nullTypeRoot()),
	    lab(28):(
	      objField(
	        objHd(3),
	        var("year")):typeSet({Object(
	            objHd(5),
	            objInst(
	              5,
	              (var("value"):typeSet({Int()})),
	              "Year",
	              {}))}),
	      var("obj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Object(
	                      objHd(5),
	                      objInst(
	                        5,
	                        (var("value"):typeSet({Int()})),
	                        "Year",
	                        {}))})
	              ),
	              "ClassA",
	              {}))})
	    ),
	    lab(36):(var("obj"):nullTypeRoot()),
	    lab(37):(
	      objField(
	        objHd(3),
	        var("year")):typeSet({Object(
	            objHd(5),
	            objInst(
	              5,
	              (var("value"):typeSet({Int()})),
	              "Year",
	              {}))}),
	      var("obj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Object(
	                      objHd(5),
	                      objInst(
	                        5,
	                        (var("value"):typeSet({Int()})),
	                        "Year",
	                        {}))})
	              ),
	              "ClassA",
	              {}))})
	    ),
	    lab(35):(
	      objField(
	        objHd(3),
	        var("year")):typeSet({Object(
	            objHd(5),
	            objInst(
	              5,
	              (var("value"):typeSet({Int()})),
	              "Year",
	              {}))}),
	      var("obj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (
	                var("make"):nullTypeRoot(),
	                var("year"):typeSet({Object(
	                      objHd(5),
	                      objInst(
	                        5,
	                        (var("value"):typeSet({Int()})),
	                        "Year",
	                        {}))})
	              ),
	              "ClassA",
	              {}))})
	    ),
	    lab(10):(var("obj"):nullTypeRoot())
	  )
	),(
	  "Year.setValue":[],
	  "Year.newYear":[],
	  "AdditionalMethodCalls.php":[typeCoercionWarning("Possible Illegal Type Coercion @ lab(33). Got: Int(). Expected from: {String()}.")]
	)>;	 
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
}

test bool test_IllegalStatMethodCalls()
{
	fileTest="IllegalStaticMethodCalls.php";
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectInfo= <(
  	"ClassA.statMethodA":(
    lab(84):(
      var("tempA"):nullTypeRoot(),
      var("tempB"):nullTypeRoot(),
      var("tempC"):nullTypeRoot(),
      var("this"):nullTypeRoot()
    ),
    lab(50):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("tempC"):typeSet({String()}),
      var("this"):nullTypeRoot()
    ),
    lab(46):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("tempC"):nullTypeRoot(),
      var("this"):nullTypeRoot()
    ),
    lab(42):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):nullTypeRoot(),
      var("tempC"):nullTypeRoot(),
      var("this"):nullTypeRoot()
    ),
    lab(85):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("tempC"):typeSet({String()}),
      var("this"):nullTypeRoot()
    ),
    lab(53):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("tempC"):typeSet({String()}),
      var("this"):nullTypeRoot()
    )
  ),
  "ClassA.instMethodA":(
    lab(21):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("tempC"):typeSet({String()}),
      var("this"):nullTypeRoot(),
      var("tempD"):typeSet({Void()})
    ),
    lab(23):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("tempC"):typeSet({String()}),
      var("this"):nullTypeRoot(),
      var("tempD"):typeSet({Void()})
    ),
    lab(80):(
      var("tempA"):nullTypeRoot(),
      var("tempB"):nullTypeRoot(),
      var("tempC"):nullTypeRoot(),
      var("this"):nullTypeRoot(),
      var("tempD"):nullTypeRoot()
    ),
    lab(13):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("tempC"):nullTypeRoot(),
      var("this"):nullTypeRoot(),
      var("tempD"):nullTypeRoot()
    ),
    lab(8):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):nullTypeRoot(),
      var("tempC"):nullTypeRoot(),
      var("this"):nullTypeRoot(),
      var("tempD"):nullTypeRoot()
    ),
    lab(81):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("tempC"):typeSet({String()}),
      var("this"):nullTypeRoot(),
      var("tempD"):typeSet({Void()})
    ),
    lab(17):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("tempC"):typeSet({String()}),
      var("this"):nullTypeRoot(),
      var("tempD"):nullTypeRoot()
    )
  ),
  "ClassA.instMethodB":(
    lab(82):(
      var("tempA"):nullTypeRoot(),
      var("tempB"):nullTypeRoot(),
      var("tempC"):nullTypeRoot(),
      var("this"):nullTypeRoot()
    ),
    lab(83):(
      var("tempA"):typeSet({String()}),
      var("tempB"):typeSet({String()}),
      var("tempC"):typeSet({Void()}),
      var("this"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(31):(
      var("tempA"):typeSet({String()}),
      var("tempB"):typeSet({String()}),
      var("tempC"):nullTypeRoot(),
      var("this"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(27):(
      var("tempA"):typeSet({String()}),
      var("tempB"):nullTypeRoot(),
      var("tempC"):nullTypeRoot(),
      var("this"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(38):(
      var("tempA"):typeSet({String()}),
      var("tempB"):typeSet({String()}),
      var("tempC"):typeSet({Void()}),
      var("this"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(35):(
      var("tempA"):typeSet({String()}),
      var("tempB"):typeSet({String()}),
      var("tempC"):typeSet({Void()}),
      var("this"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    )
  ),
  "IllegalStaticMethodCalls.php":(
    lab(54):(
      var("tempA"):nullTypeRoot(),
      var("tempB"):nullTypeRoot(),
      var("obj"):nullTypeRoot()
    ),
    lab(61):(
      var("tempA"):nullTypeRoot(),
      var("tempB"):nullTypeRoot(),
      var("obj"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(57):(
      var("tempA"):nullTypeRoot(),
      var("tempB"):nullTypeRoot(),
      var("obj"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(71):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):nullTypeRoot(),
      var("obj"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(64):(
      var("tempA"):nullTypeRoot(),
      var("tempB"):nullTypeRoot(),
      var("obj"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(67):(
      var("tempA"):nullTypeRoot(),
      var("tempB"):nullTypeRoot(),
      var("obj"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(76):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("obj"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    ),
    lab(78):(
      var("tempA"):nullTypeRoot(),
      var("tempB"):nullTypeRoot(),
      var("obj"):nullTypeRoot()
    ),
    lab(79):(
      var("tempA"):typeSet({Void()}),
      var("tempB"):typeSet({Void()}),
      var("obj"):typeSet({Object(
            objHd(2),
            objInst(
              2,
              (
                var("instVarA"):typeSet({String()}),
                var("instVarB"):typeSet({String()})
              ),
              "ClassA",
              {}))})
    	)
  	)
	)	
	,(
  "ClassA.statMethodA":[
    referenceObjInStaticContext("Attempt to use this in static context @ lab(40)."),
    usingVoidTypeForExpr("Computed typeSet for lab(40) has Void type."),
    readPropertyFromNonObjectVar("Attempt to read property: instVarA from non-object @ lab(42)."),
    usingVoidTypeForExpr("Computed typeSet for lab(42) has Void type."),
    assignVoidTypeToVar("Assigning a Void type to var(tempA) @ lab(39)."),
    accessUndefinedClassProperty("Attempt to read from undefined class property: var(instVarA) of class: ClassA @ lab(44)."),
    usingVoidTypeForExpr("Computed typeSet for lab(44) has Void type."),
    assignVoidTypeToVar("Assigning a Void type to var(tempB) @ lab(44).")
  ],
  "ClassA.instMethodA":[
    referenceObjInStaticContext("Attempt to use this in static context @ lab(6)."),
    usingVoidTypeForExpr("Computed typeSet for lab(6) has Void type."),
    readPropertyFromNonObjectVar("Attempt to read property: instVarA from non-object @ lab(8)."),
    usingVoidTypeForExpr("Computed typeSet for lab(8) has Void type."),
    assignVoidTypeToVar("Assigning a Void type to var(tempA) @ lab(5)."),
    referenceObjInStaticContext("Attempt to use this in static context @ lab(11)."),
    usingVoidTypeForExpr("Computed typeSet for lab(11) has Void type."),
    readPropertyFromNonObjectVar("Attempt to read property: statVarB from non-object @ lab(10)."),
    usingVoidTypeForExpr("Computed typeSet for lab(10) has Void type."),
    assignVoidTypeToVar("Assigning a Void type to var(tempB) @ lab(10)."),
    accessUndefinedClassProperty("Attempt to read from undefined class property: var(instVarB) of class: ClassA @ lab(19)."),
    usingVoidTypeForExpr("Computed typeSet for lab(19) has Void type."),
    assignVoidTypeToVar("Assigning a Void type to var(tempD) @ lab(19)."),
    usingVoidTypeForExpr("Computed typeSet for lab(23) has Void type.")
  ],
  "ClassA.instMethodB":[
    accessUndefinedClassProperty("Attempt to read from undefined class property: var(instVarA) of class: ClassA @ lab(33)."),
    usingVoidTypeForExpr("Computed typeSet for lab(33) has Void type."),
    assignVoidTypeToVar("Assigning a Void type to var(tempC) @ lab(33).")
  ],
  "IllegalStaticMethodCalls.php":[
    usingVoidTypeForExpr("Computed typeSet for lab(67) has Void type."),
    accessUndefinedClassProperty("Attempt to read from undefined class property: var(instVarA) of class: ClassA @ lab(69)."),
    usingVoidTypeForExpr("Computed typeSet for lab(69) has Void type."),
    assignVoidTypeToVar("Assigning a Void type to var(tempA) @ lab(69)."),
    accessUndefinedClassProperty("Attempt to access un-defined object property: var(statVarA) @ lab(75)."),
    usingVoidTypeForExpr("Computed typeSet for lab(75) has Void type."),
    assignVoidTypeToVar("Assigning a Void type to var(tempB) @ lab(73).")
  ]
	)>;	
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
}
