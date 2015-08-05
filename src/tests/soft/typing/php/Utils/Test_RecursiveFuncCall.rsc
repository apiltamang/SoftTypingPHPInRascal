module tests::soft::typing::php::Utils::Test_RecursiveFuncCall


import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::Utils::Analysis;
import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::helper::Test_SetComparator;

import IO;

private loc localP=rootP+"Test_RecursiveFuncCall";

test bool test_SimpleRecursiveCall()
{
	//test a simple recursion case when a 
	//function calls itself
	//The recursion happens as follows:
	/*
	factorial($x){
	  if($x==0) 
	    return 1;
	  else
	    $temp=$x*factorial($x-1);
	    return $temp;
	}
	*/
	fileTest="SimpleRecursiveCall.php";
	
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo= <(
	  "factorial":(
	    lab(17):(
	      var("x"):typeSet({Int()}),
	      var("temp"):typeSet({Num()})
	    ),
	    lab(4):(
	      var("x"):typeSet({Int()}),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(6):(
	      var("x"):typeSet({Int()}),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(40):(
	      var("x"):nullTypeRoot(),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(41):(
	      var("x"):typeSet({Int()}),
	      var("temp"):typeSet({Num()})
	    ),
	    lab(42):(
	      var("x"):typeSet({Int()}),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(44):(
	      var("x"):typeSet({Int()}),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(12):(
	      var("x"):typeSet({Int()}),
	      var("temp"):typeSet({Num()})
	    )
	  ),
	  "SimpleRecursiveCall.php":(
	    lab(22):(
	      var("n"):typeSet({Int()}),
	      var("res"):nullTypeRoot()
	    ),
	    lab(19):(
	      var("n"):nullTypeRoot(),
	      var("res"):nullTypeRoot()
	    ),
	    lab(27):(
	      var("n"):typeSet({Int()}),
	      var("res"):typeSet({Num()})
	    ),
	    lab(36):(
	      var("n"):typeSet({Int()}),
	      var("res"):typeSet({Num()})
	    ),
	    lab(38):(
	      var("n"):nullTypeRoot(),
	      var("res"):nullTypeRoot()
	    ),
	    lab(39):(
	      var("n"):typeSet({Int()}),
	      var("res"):typeSet({Num()})
	    ),
	    lab(1):(
	      var("n"):nullTypeRoot(),
	      var("res"):nullTypeRoot()
	    )
	  )
	),(
	  "factorial":[equalTypesExpectedFail("Type-set yield for lab(2): {Num()}. Type-set yield for lab(3): {Int()}.")],
	  "SimpleRecursiveCall.php":[
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(34). Got: Num(). Expected from: {String()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(30). Got: Int(). Expected from: {String()}.")
	  ]
	)>;	

	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");	
}

test bool test_SimpleFactorialFunction()
{
	//test a simple recursion case when a 
	//function calls itself.
	
	//This is a little different from the above
	//test in the way the return statement appears.
	//Here I have "return $x * factorial($x-1);" 
	
	fileTest="SimpleFactorialFunction.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo= <(
	  "factorial":(
	    lab(37):(var("x"):typeSet({Int()})),
	    lab(13):(var("x"):typeSet({Int()})),
	    lab(40):(var("x"):typeSet({Int()})),
	    lab(36):(var("x"):nullTypeRoot()),
	    lab(4):(var("x"):typeSet({Int()})),
	    lab(38):(var("x"):typeSet({Int()})),
	    lab(6):(var("x"):typeSet({Int()}))
	  ),
	  "SimpleFactorialFunction.php":(
	    lab(23):(
	      var("n"):typeSet({Int()}),
	      var("res"):typeSet({Num()})
	    ),
	    lab(18):(
	      var("n"):typeSet({Int()}),
	      var("res"):nullTypeRoot()
	    ),
	    lab(32):(
	      var("n"):typeSet({Int()}),
	      var("res"):typeSet({Num()})
	    ),
	    lab(1):(
	      var("n"):nullTypeRoot(),
	      var("res"):nullTypeRoot()
	    ),
	    lab(34):(
	      var("n"):nullTypeRoot(),
	      var("res"):nullTypeRoot()
	    ),
	    lab(35):(
	      var("n"):typeSet({Int()}),
	      var("res"):typeSet({Num()})
	    ),
	    lab(15):(
	      var("n"):nullTypeRoot(),
	      var("res"):nullTypeRoot()
	    )
	  )
	),(
	  "factorial":[equalTypesExpectedFail("Type-set yield for lab(2): {Num()}. Type-set yield for lab(3): {Int()}.")],
	  "SimpleFactorialFunction.php":[
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(26). Got: Int(). Expected from: {String()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(30). Got: Num(). Expected from: {String()}.")
	  ]
	)>;	
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
	
}

test bool test_TwoFunctionRecursion()
{
	//test a simple recursion case when two functions 
	//recursively call each other.
	
	
	fileTest="TwoFunctionRecursion.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo=
	<(
	  "TwoFunctionRecursion.php":(
	    lab(22):(var("result"):nullTypeRoot()),
	    lab(28):(var("result"):nullTypeRoot()),
	    lab(29):(var("result"):typeSet({String()})),
	    lab(26):(var("result"):typeSet({String()})),
	    lab(10):(var("result"):nullTypeRoot())
	  ),
	  "funcA":(
	    lab(30):(var("str"):nullTypeRoot()),
	    lab(31):(var("str"):typeSet({String()})),
	    lab(5):(var("str"):typeSet({String()})),
	    lab(32):(var("str"):typeSet({String()})),
	    lab(34):(var("str"):typeSet({String()})),
	    lab(3):(var("str"):typeSet({String()})),
	    lab(8):(var("str"):typeSet({String()}))
	  ),
	  "funcB":(
	    lab(20):(var("str"):typeSet({String()})),
	    lab(17):(var("str"):typeSet({String()})),
	    lab(36):(var("str"):typeSet({String()})),
	    lab(37):(var("str"):typeSet({String()})),
	    lab(39):(var("str"):typeSet({String()})),
	    lab(35):(var("str"):nullTypeRoot()),
	    lab(13):(var("str"):typeSet({String()}))
	  )
	),(
	  "TwoFunctionRecursion.php":[],
	  "funcA":[],
	  "funcB":[]
	)>;
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
}


test bool test_SimpleObjectRecursion()
{
	//test a simple recursion case when two functions 
	//recursively call each other.
	
	
	fileTest="SimpleObjectRecursion.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectInfo=
	<(
	  "FactorialClass.factorial":(
	    lab(4):(
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))}),
	      var("x"):typeSet({Int()})
	    ),
	    lab(6):(
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))}),
	      var("x"):typeSet({Int()})
	    ),
	    lab(44):(
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))}),
	      var("x"):typeSet({Int()})
	    ),
	    lab(42):(
	      var("this"):nullTypeRoot(),
	      var("x"):nullTypeRoot()
	    ),
	    lab(43):(
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))}),
	      var("x"):typeSet({Int()})
	    ),
	    lab(46):(
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))}),
	      var("x"):typeSet({Int()})
	    ),
	    lab(14):(
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))}),
	      var("x"):typeSet({Int()})
	    )
	  ),
	  "SimpleObjectRecursion.php":(
	    lab(23):(
	      var("n"):typeSet({Int()}),
	      var("res"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))})
	    ),
	    lab(16):(
	      var("n"):nullTypeRoot(),
	      var("res"):nullTypeRoot(),
	      var("obj"):nullTypeRoot()
	    ),
	    lab(19):(
	      var("n"):typeSet({Int()}),
	      var("res"):nullTypeRoot(),
	      var("obj"):nullTypeRoot()
	    ),
	    lab(29):(
	      var("n"):typeSet({Int()}),
	      var("res"):typeSet({Num()}),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))})
	    ),
	    lab(38):(
	      var("n"):typeSet({Int()}),
	      var("res"):typeSet({Num()}),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))})
	    ),
	    lab(1):(
	      var("n"):nullTypeRoot(),
	      var("res"):nullTypeRoot(),
	      var("obj"):nullTypeRoot()
	    ),
	    lab(40):(
	      var("n"):nullTypeRoot(),
	      var("res"):nullTypeRoot(),
	      var("obj"):nullTypeRoot()
	    ),
	    lab(41):(
	      var("n"):typeSet({Int()}),
	      var("res"):typeSet({Num()}),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (),
	              "FactorialClass",
	              {}))})
	    )
	  )
	),(
	  "FactorialClass.factorial":[equalTypesExpectedFail("Type-set yield for lab(2): {Num()}. Type-set yield for lab(3): {Int()}.")],
	  "SimpleObjectRecursion.php":[
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(32). Got: Int(). Expected from: {String()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(36). Got: Num(). Expected from: {String()}.")
	  ]
	)>;	
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
}
