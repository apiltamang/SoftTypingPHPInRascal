module tests::soft::typing::warnings::Test_UseUnDeclaredVar

import IO;
import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::Utils::Analysis;
import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::helper::Test_SetComparator;

private loc localP=rootP+"Test_Other_Script_Errors";

test AppInfo test_example()
{

	fileTest="example.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	return <AppExitEnvms,AppWarnings>;
	
}

test bool test_UseUninitializedVar()
{

	fileTest="Reference_UninitializedVar.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	ExpectInfo=
	<("Reference_UninitializedVar.php":(
	    lab(7):(
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):typeSet({Int()}),
	      var("t"):typeSet({Void()})
	    ),
	    lab(3):(
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("t"):typeSet({Void()})
	    ),
	    lab(13):(
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(14):(
	      var("a"):nullTypeRoot(),
	      var("b"):typeSet({Void()}),
	      var("c"):typeSet({Int()}),
	      var("t"):typeSet({Void()})
	    ),
	    lab(11):(
	      var("a"):nullTypeRoot(),
	      var("b"):typeSet({Void()}),
	      var("c"):typeSet({Int()}),
	      var("t"):typeSet({Void()})
	    )
	  )),("Reference_UninitializedVar.php":[
	    readFromNonDeclaredVar("Attempt to read from undeclared var(a) @ lab(1)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(1) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(t) @ lab(1)."),
	    readFromVarWithVoidType("Reading from var containing Void type  @ lab(9)"),
	    usingVoidTypeForExpr("Computed typeSet for lab(9) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(b) @ lab(9).")
	  ])>;
	  //return <AppExitEnvms,AppWarnings>;	
	  return assertEquals(<AppExitEnvms,AppWarnings>,ExpectInfo,"AppInfo","generateWarnings");	
}

test bool test_UseUndeclaredFunc()
{

	fileTest="UseUndeclaredFunc.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	ExpectInfo= AppInfo= <(
	  "UseUndeclaredFunc.php":(
	    lab(22):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Void()})
	    ),
	    lab(23):(
	      var("b"):nullTypeRoot(),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot()
	    ),
	    lab(24):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Void()})
	    ),
	    lab(3):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):nullTypeRoot()
	    ),
	    lab(8):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Void()})
	    )
	  ),
	  "callDeclaredFunc":(
	    lab(21):(
	      var("d"):typeSet({Void()}),
	      var("f"):nullTypeRoot(),
	      var("c"):typeSet({Int()})
	    ),
	    lab(16):(
	      var("d"):typeSet({Void()}),
	      var("f"):nullTypeRoot(),
	      var("c"):typeSet({Int()})
	    ),
	    lab(25):(
	      var("d"):nullTypeRoot(),
	      var("f"):nullTypeRoot(),
	      var("c"):nullTypeRoot()
	    ),
	    lab(26):(
	      var("d"):typeSet({Void()}),
	      var("f"):nullTypeRoot(),
	      var("c"):typeSet({Int()})
	    ),
	    lab(12):(
	      var("d"):nullTypeRoot(),
	      var("f"):nullTypeRoot(),
	      var("c"):typeSet({Int()})
	    )
	  )
	),(
	  "UseUndeclaredFunc.php":[
	    readFromNonDeclaredVar("Attempt to read from undeclared var(b) @ lab(6)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(6) has Void type."),
	    failedToFindFunction("Failed to find function definition: callUndeclaredFunc, call site @ lab(7)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(7) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(y) @ lab(5).")
	  ],
	  "callDeclaredFunc":[
	    readFromNonDeclaredVar("Attempt to read from undeclared var(f) @ lab(16)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(16) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(d) @ lab(14).")
	  ]
	)>;
	
	//return <AppExitEnvms,AppWarnings>;
	return assertEquals(<AppExitEnvms,AppWarnings>,ExpectInfo,"ExitEnvm And Warnings","generateWarnings");
}

test bool test_AssignFromVoidFunc()
{

	fileTest="AssignFromVoidFunc.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo= <(
	  "AssignFromVoidFunc.php":(
	    lab(23):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Void()}),
	      var("z"):typeSet({Void()})
	    ),
	    lab(48):(
	      var("b"):nullTypeRoot(),
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("z"):nullTypeRoot()
	    ),
	    lab(49):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Void()}),
	      var("z"):typeSet({Void()})
	    ),
	    lab(34):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Void()}),
	      var("z"):typeSet({Void()})
	    ),
	    lab(3):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):nullTypeRoot(),
	      var("z"):nullTypeRoot()
	    ),
	    lab(13):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Void()}),
	      var("z"):typeSet({Void()})
	    ),
	    lab(47):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Void()}),
	      var("z"):typeSet({Void()})
	    ),
	    lab(8):(
	      var("b"):nullTypeRoot(),
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Void()}),
	      var("z"):nullTypeRoot()
	    )
	  ),
	  "callVoidFunc1":(
	    lab(52):(
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot()
	    ),
	    lab(53):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({Num()})
	    ),
	    lab(26):(
	      var("a"):typeSet({Int()}),
	      var("b"):nullTypeRoot()
	    ),
	    lab(32):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({Num()})
	    )
	  ),
	  "callDeclaredFunc":(
	    lab(22):(var("c"):typeSet({Int()})),
	    lab(17):(var("c"):typeSet({Int()})),
	    lab(50):(var("c"):nullTypeRoot()),
	    lab(51):(var("c"):typeSet({Int()}))
	  ),
	  "callVoidFunc2":(
	    lab(54):(var("a"):nullTypeRoot()),
	    lab(55):(var("a"):typeSet({Int()})),
	    lab(56):(var("a"):typeSet({Int()})),
	    lab(57):(var("a"):typeSet({Int()})),
	    lab(37):(var("a"):typeSet({Int()})),
	    lab(44):(var("a"):typeSet({Int()})),
	    lab(41):(var("a"):typeSet({Int()})),
	    lab(42):(var("a"):typeSet({Int()}))
	  )
	),(
	  "AssignFromVoidFunc.php":[
	    readFromNonDeclaredVar("Attempt to read from undeclared var(b) @ lab(6)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(6) has Void type."),
	    usingVoidTypeForExpr("Computed typeSet for lab(8) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(y) @ lab(5)."),
	    readFromNonDeclaredVar("Attempt to read from undeclared var(b) @ lab(11)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(11) has Void type."),
	    usingVoidTypeForExpr("Computed typeSet for lab(10) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(z) @ lab(10).")
	  ],
	  "callVoidFunc1":[],
	  "callDeclaredFunc":[],
	  "callVoidFunc2":[usingVoidTypeForExpr("Computed typeSet for lab(42) has Void type.")]
	)>;	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"exitEnvms and warnings","generate warnings");
}

test bool test_VarMultipleTypes()
{
	fileTest="VarMultipleTypes.php";
	exitEnvm=runAnalysis(localP,fileTest);
	

	expectInfo= <("VarMultipleTypes.php":(
	    lab(21):(
	      var("a"):typeSet({
	          String(),
	          Int()
	        }),
	      var("x"):typeSet({
	          String(),
	          Int()
	        }),
	      var("t"):typeSet({
	          String(),
	          Int()
	        })
	    ),
	    lab(23):(
	      var("a"):nullTypeRoot(),
	      var("x"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(17):(
	      var("a"):typeSet({Bool()}),
	      var("x"):typeSet({
	          String(),
	          Int()
	        }),
	      var("t"):typeSet({
	          String(),
	          Int()
	        })
	    ),
	    lab(24):(
	      var("a"):typeSet({
	          String(),
	          Int()
	        }),
	      var("x"):typeSet({
	          String(),
	          Int()
	        }),
	      var("t"):typeSet({
	          String(),
	          Int()
	        })
	    ),
	    lab(25):(
	      var("a"):typeSet({Bool()}),
	      var("x"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(26):(
	      var("a"):typeSet({Bool()}),
	      var("x"):typeSet({
	          String(),
	          Int()
	        }),
	      var("t"):nullTypeRoot()
	    ),
	    lab(5):(
	      var("a"):typeSet({Bool()}),
	      var("x"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(3):(
	      var("a"):typeSet({Bool()}),
	      var("x"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(12):(
	      var("a"):typeSet({Bool()}),
	      var("x"):typeSet({Int()}),
	      var("t"):nullTypeRoot()
	    ),
	    lab(8):(
	      var("a"):typeSet({Bool()}),
	      var("x"):typeSet({String()}),
	      var("t"):nullTypeRoot()
	    )
	  )),("VarMultipleTypes.php":[
	    typeOfVarChanged(" Var(a) changed type @ lab(19) from {Bool()} to {String()}."),
	    varHasMultipleTypes("Var x acquired more than one types at lab(12)."),
	    varHasMultipleTypes("Var t acquired more than one types at lab(17)."),
	    typeOfVarChanged(" Var(a) changed type @ lab(19) from {Bool()} to {String(),Int()}."),
	    varHasMultipleTypes("Var a acquired more than one types at lab(21).")
	  ])>;
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"Exit Envms and Warnings","Generate Warnings");	
	//return <AppExitEnvms,AppWarnings>;
}

test bool test_VarChangesType()
{

	fileTest="VarChangesType.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo=<(
	  "VarChangesType.php":(
	    lab(53):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):typeSet({
	          Array(Num()),
	          Void(),
	          Num()
	        }),
	      var("t"):typeSet({
	          Array(Num()),
	          Void(),
	          Num()
	        })
	    ),
	    lab(55):(
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(48):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("t"):typeSet({Num()})
	    ),
	    lab(19):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Num()}),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(60):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):typeSet({
	          Array(Num()),
	          Void(),
	          Num()
	        }),
	      var("t"):typeSet({Num()})
	    ),
	    lab(29):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Num()}),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(30):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(56):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):typeSet({
	          Array(Num()),
	          Void(),
	          Num()
	        }),
	      var("t"):typeSet({
	          Array(Num()),
	          Void(),
	          Num()
	        })
	    ),
	    lab(57):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Num()}),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(58):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(59):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):nullTypeRoot(),
	      var("t"):typeSet({Num()})
	    ),
	    lab(34):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Array(Num())}),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(3):(
	      var("x"):typeSet({String()}),
	      var("y"):nullTypeRoot(),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(44):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):typeSet({Void()}),
	      var("t"):typeSet({Num()})
	    ),
	    lab(41):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):nullTypeRoot(),
	      var("t"):typeSet({Num()})
	    ),
	    lab(11):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({Int()}),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(39):(
	      var("x"):typeSet({Num()}),
	      var("y"):typeSet({
	          Array(Num()),
	          Num()
	        }),
	      var("z"):nullTypeRoot(),
	      var("t"):typeSet({Num()})
	    ),
	    lab(7):(
	      var("x"):typeSet({Num()}),
	      var("y"):nullTypeRoot(),
	      var("z"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    )
	  ),
	  "callDeclaredFunc":(
	    lab(23):(var("c"):typeSet({Int()})),
	    lab(28):(var("c"):typeSet({Int()})),
	    lab(61):(var("c"):nullTypeRoot()),
	    lab(62):(var("c"):typeSet({Int()}))
	  )
	),(
	  "VarChangesType.php":[
	    typeOfVarChanged(" Var(x) changed type @ lab(5) from {String()} to {Num()}."),
	    failedToFindFunction("Failed to find function definition: callVoidFunc, call site @ lab(42)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(42) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(z) @ lab(42)."),
	    varHasMultipleTypes("Var z acquired more than one types at lab(44)."),
	    readFromVarWithVoidType("Reading from var containing Void type  @ lab(51)"),
	    usingVoidTypeForExpr("Computed typeSet for lab(51) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(t) @ lab(51)."),
	    typeOfVarChanged(" Var(t) changed type @ lab(51) from {Num()} to {Void(),Num()}."),
	    varHasMultipleTypes("Var t acquired more than one types at lab(53)."),
	    typeOfVarChanged(" Var(y) changed type @ lab(31) from {Num()} to {Array(Num())}."),
	    varHasMultipleTypes("Var y acquired more than one types at lab(34)."),
	    readFromVarWithVoidType("Reading from var containing Void type  @ lab(51)"),
	    usingVoidTypeForExpr("Computed typeSet for lab(51) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(t) @ lab(51)."),
	    typeOfVarChanged(" Var(t) changed type @ lab(51) from {Num()} to {Array(Num()),Void(),Num()}."),
	    failedToFindFunction("Failed to find function definition: callVoidFunc, call site @ lab(42)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(42) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(z) @ lab(42)."),
	    typeOfVarChanged(" Var(y) changed type @ lab(31) from {Array(Num()),Num()} to {Array(Num())}.")		  
	  ],
	  "callDeclaredFunc":[]
	)>;
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"Exit Envms and Warnings","Generate Warnings");
	//return <AppExitEnvms,AppWarnings>;
}