module tests::soft::typing::php::Utils::Test_RepeatFunctionCalls

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::Utils::Analysis;
import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::helper::Test_SetComparator;

private loc localP=rootP+"Test_RepeatFunctionCalls";

test bool test_RepeatFunctionCalls1()
{
	//test a simple case when a function
	//call is made using the same type
	//signature multiple times!
	fileTest="RepeatFunctionCalls1.php";
	
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo=
	 <(
	  "getSum":(
	    lab(30):(
	      var("x"):nullTypeRoot(),
	      var("y"):nullTypeRoot(),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(31):(
	      var("x"):typeSet({Int()}),
	      var("y"):typeSet({Int()}),
	      var("temp"):typeSet({Num()})
	    ),
	    lab(5):(
	      var("x"):typeSet({Int()}),
	      var("y"):typeSet({Int()}),
	      var("temp"):typeSet({Num()})
	    ),
	    lab(32):(
	      var("x"):typeSet({Int()}),
	      var("y"):nullTypeRoot(),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(33):(
	      var("x"):typeSet({Int()}),
	      var("y"):typeSet({Int()}),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(14):(
	      var("x"):typeSet({Int()}),
	      var("y"):typeSet({Int()}),
	      var("temp"):typeSet({Num()})
	    ),
	    lab(11):(
	      var("x"):typeSet({Int()}),
	      var("y"):typeSet({Int()}),
	      var("temp"):typeSet({Num()})
	    )
	  ),
	  "RepeatFunctionCalls1.php":(
	    lab(20):(
	      var("sol1"):typeSet({Num()}),
	      var("sol2"):nullTypeRoot()
	    ),
	    lab(28):(
	      var("sol1"):nullTypeRoot(),
	      var("sol2"):nullTypeRoot()
	    ),
	    lab(29):(
	      var("sol1"):typeSet({Num()}),
	      var("sol2"):typeSet({Num()})
	    ),
	    lab(26):(
	      var("sol1"):typeSet({Num()}),
	      var("sol2"):typeSet({Num()})
	    ),
	    lab(15):(
	      var("sol1"):nullTypeRoot(),
	      var("sol2"):nullTypeRoot()
	    )
	  )
	),(
	  "getSum":[],
	  "RepeatFunctionCalls1.php":[]
	)>;
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
	
}

test bool test_RepeatFunctionCalls2()
{
	//test a simple case when two or more
	//function calls are made withzero no
	//arguments.
	fileTest="RepeatFunctionCalls2.php";
	
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo= <(
	  "getTheInt":(
	    lab(21):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({Int()}),
	      var("c"):typeSet({Num()})
	    ),
	    lab(18):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({Int()}),
	      var("c"):typeSet({Num()})
	    ),
	    lab(4):(
	      var("a"):typeSet({Int()}),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot()
	    ),
	    lab(33):(
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot()
	    ),
	    lab(34):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({Int()}),
	      var("c"):typeSet({Num()})
	    ),
	    lab(8):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({Int()}),
	      var("c"):nullTypeRoot()
	    )
	  ),
	  "RepeatFunctionCalls2.php":(
	    lab(22):(
	      var("int1"):nullTypeRoot(),
	      var("int2"):nullTypeRoot()
	    ),
	    lab(29):(
	      var("int1"):typeSet({Num()}),
	      var("int2"):typeSet({Num()})
	    ),
	    lab(31):(
	      var("int1"):nullTypeRoot(),
	      var("int2"):nullTypeRoot()
	    ),
	    lab(25):(
	      var("int1"):typeSet({Num()}),
	      var("int2"):nullTypeRoot()
	    ),
	    lab(32):(
	      var("int1"):typeSet({Num()}),
	      var("int2"):typeSet({Num()})
	    ),
	    lab(1):(
	      var("int1"):nullTypeRoot(),
	      var("int2"):nullTypeRoot()
	    )
	  )
	),(
	  "getTheInt":[],
	  "RepeatFunctionCalls2.php":[]
	)>;

return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");		
}

test bool test_RepeatFunctionCalls3()
{
	//test a simple case when a function
	//call is made using the same type
	//signature multiple times!
	fileTest="RepeatFunctionCalls3.php";
	
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo=
	<(
	  "weirdFunction":(
	    lab(37):(
	      var("val1"):typeSet({Float()}),
	      var("val2"):typeSet({Bool()})
	    ),
	    lab(34):(
	      var("val1"):nullTypeRoot(),
	      var("val2"):nullTypeRoot()
	    ),
	    lab(35):(
	      var("val1"):typeSet({Float()}),
	      var("val2"):typeSet({Bool()})
	    ),
	    lab(36):(
	      var("val1"):typeSet({Float()}),
	      var("val2"):nullTypeRoot()
	    ),
	    lab(4):(
	      var("val1"):typeSet({Float()}),
	      var("val2"):typeSet({Bool()})
	    )
	  ),
	  "RepeatFunctionCalls3.php":(
	    lab(21):(
	      var("val2"):typeSet({Bool()}),
	      var("sol"):nullTypeRoot(),
	      var("val1"):typeSet({Float()})
	    ),
	    lab(17):(
	      var("val2"):nullTypeRoot(),
	      var("sol"):nullTypeRoot(),
	      var("val1"):typeSet({Float()})
	    ),
	    lab(28):(
	      var("val2"):typeSet({Bool()}),
	      var("sol"):typeSet({
	          Array(Bool()),
	          Array(String()),
	          Array(Float())
	        }),
	      var("val1"):typeSet({
	          Float(),
	          String()
	        })
	    ),
	    lab(30):(
	      var("val2"):nullTypeRoot(),
	      var("sol"):nullTypeRoot(),
	      var("val1"):nullTypeRoot()
	    ),
	    lab(31):(
	      var("val2"):typeSet({Bool()}),
	      var("sol"):typeSet({
	          Array(Bool()),
	          Array(String()),
	          Array(Float())
	        }),
	      var("val1"):typeSet({
	          Float(),
	          String()
	        })
	    ),
	    lab(5):(
	      var("val2"):nullTypeRoot(),
	      var("sol"):nullTypeRoot(),
	      var("val1"):nullTypeRoot()
	    ),
	    lab(6):(
	      var("val2"):nullTypeRoot(),
	      var("sol"):nullTypeRoot(),
	      var("val1"):nullTypeRoot()
	    ),
	    lab(32):(
	      var("val2"):nullTypeRoot(),
	      var("sol"):nullTypeRoot(),
	      var("val1"):nullTypeRoot()
	    ),
	    lab(33):(
	      var("val2"):typeSet({Bool()}),
	      var("sol"):nullTypeRoot(),
	      var("val1"):typeSet({
	          Float(),
	          String()
	        })
	    ),
	    lab(13):(
	      var("val2"):typeSet({Bool()}),
	      var("sol"):nullTypeRoot(),
	      var("val1"):typeSet({String()})
	    ),
	    lab(9):(
	      var("val2"):nullTypeRoot(),
	      var("sol"):nullTypeRoot(),
	      var("val1"):typeSet({String()})
	    )
	  )
	),(
	  "weirdFunction":[],
	  "RepeatFunctionCalls3.php":[
	    varHasMultipleTypes("Var sol acquired more than one types at lab(28)."),
	    varHasMultipleTypes("Var val1 acquired more than one types at lab(21).")
	  ]
	)>;
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
}