module tests::soft::typing::warnings::Test_RecursiveCallAnalysisFailed

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::Utils::Analysis;
import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::helper::Test_SetComparator;

import IO;

private loc localP=rootP+"Test_RecursiveCallAnalysisFailed";

test bool test_RecursiveCallAnalysisFailed1()
{

	//test a simple case when a recursive call analysis
	//triggers an error
		
	fileTest="RecursiveCallAnalysisFailed1.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	

	expectInfo= <(
	  "RecursiveCallAnalysisFailed1.php":(
	    lab(18):(
	      var("result_1"):typeSet({Any()}),
	      var("arr"):nullTypeRoot(),
	      var("result_2"):nullTypeRoot()
	    ),
	    lab(30):(
	      var("result_1"):typeSet({Any()}),
	      var("arr"):typeSet({Array(Int())}),
	      var("result_2"):typeSet({Int()})
	    ),
	    lab(25):(
	      var("result_1"):typeSet({Any()}),
	      var("arr"):typeSet({Array(Int())}),
	      var("result_2"):nullTypeRoot()
	    ),
	    lab(32):(
	      var("result_1"):nullTypeRoot(),
	      var("arr"):nullTypeRoot(),
	      var("result_2"):nullTypeRoot()
	    ),
	    lab(33):(
	      var("result_1"):typeSet({Any()}),
	      var("arr"):typeSet({Array(Int())}),
	      var("result_2"):typeSet({Int()})
	    ),
	    lab(14):(
	      var("result_1"):nullTypeRoot(),
	      var("arr"):nullTypeRoot(),
	      var("result_2"):nullTypeRoot()
	    )
	  ),
	  "funcA":(
	    lab(36):(
	      var("val"):typeSet({Array(Int())}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(5):(
	      var("val"):typeSet({Array(Int())}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(38):(
	      var("val"):typeSet({Array(Int())}),
	      var("test"):nullTypeRoot()
	    ),
	    lab(34):(
	      var("val"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    ),
	    lab(12):(
	      var("val"):typeSet({Array(Int())}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(9):(
	      var("val"):typeSet({Array(Int())}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(35):(
	      var("val"):typeSet({Array(Int())}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(3):(
	      var("val"):typeSet({Array(Int())}),
	      var("test"):typeSet({Bool()})
	    )
	  )
	),(
	  "RecursiveCallAnalysisFailed1.php":[],
	  "funcA":[
	    readFromNonArrayVal("Expected array @ lab(6). Got Non-array: typeSet({String()})."),
	    usingVoidTypeForExpr("Computed typeSet for lab(8) has Void type."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(6). Got: String(). Expected from: {Array(Any())}."),
	    recursiveCallAnalysisFailed("Recursive call type analysis on: funcA failed to deduce concrete types at lab(11).")
	  ]
	)>;
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
}


