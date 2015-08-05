module tests::soft::typing::php::Utils::Test_Analysis_2

//Testing analysis for scripts with functions 
import lang::php::ast::AbstractSyntax;
import soft::typing::php::functions::DeltaOperator;
import soft::typing::php::functions::UnionOperator;
import soft::typing::php::elements::Identifier;
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::Utils::Analysis;
import soft::typing::php::Utils::AnalysisHelpers;
import soft::typing::php::elements::Function;
import lang::php::analysis::cfg::Label;
import lang::php::analysis::cfg::Visualize;
import lang::php::analysis::cfg::BuildCFG;
import tests::soft::typing::php::helper::Test_SetComparator;

import soft::typing::php::declarations::PublicDataTypes;

import IO;

private loc localP=rootP+"Test_Analysis_2";

test bool testVariableReassignment()
{
	str fileP="ReassignVariable.php";
	
	exitEnvm=runAnalysis(localP,fileP);
	
	expectEnvm=(
		  lab(22):(
	    var("a"):typeSet({String()}),
	    var("b"):typeSet({Bool()})
	  ),
	  lab(18):(
	    var("a"):typeSet({String()}),
	    var("b"):typeSet({String()})
	  ),
	  lab(28):(
	    var("a"):typeSet({String()}),
	    var("b"):typeSet({
	        String(),
	        Bool()
	      })
	  ),
	  lab(29):(
	    var("a"):typeSet({String()}),
	    var("b"):typeSet({Int()})
	  ),
	  lab(30):(
	    var("a"):typeSet({String()}),
	    var("b"):typeSet({
	        String(),
	        Bool()
	      })
	  ),
	  lab(26):(
	    var("a"):typeSet({String()}),
	    var("b"):typeSet({
	        String(),
	        Bool()
	      })
	  ),
	  lab(27):(
	    var("a"):nullTypeRoot(),
	    var("b"):nullTypeRoot()
	  ),
	  lab(7):(
	    var("a"):typeSet({Float()}),
	    var("b"):typeSet({Int()})
	  ),
	  lab(3):(
	    var("a"):typeSet({Float()}),
	    var("b"):nullTypeRoot()
	  ),
	  lab(15):(
	    var("a"):typeSet({String()}),
	    var("b"):typeSet({Int()})
	  ),
	  lab(11):(
	    var("a"):typeSet({String()}),
	    var("b"):typeSet({Int()})
	  )
	);
	
	return assertEquals(exitEnvm,expectEnvm,"Lab","Identifier","propagate");


}
test bool testSimpleFunctionCall()
{

	
	
	map[str,TypeRoot] toRet=();

	str fileP="SimpleFunction.php";
	newAnalysis();
	ApplicationMap=initializeAnalysis(localP,fileP);
	
	
	
	toRet["getSum"]=runAnalysisThroughFunc(localP,"getSum",[Int(),Float()],"funcCall");
	
	toRet["getDiff"]=runAnalysisThroughFunc(localP,"getDiff",[Int(),Float()],"funcCall");
	
	//make sure that the entry environments have changed
	//to reflect the type information passed as arguments
	
	toRet["loopReturn"]=runAnalysisThroughFunc(localP,"loopReturn",[Int(),Int(),Int()],"funcCall");
	
	toRet["getArrayOfFloat"]=runAnalysisThroughFunc(localP,"getArray",[Float()],"funcCall");
	
	toRet["getArrayOfBool"]=runAnalysisThroughFunc(localP,"getArray",[Bool()],"funcCall");
	
	toRet["getArrayOfIntArray"]=runAnalysisThroughFunc(localP,"getArray",[Array(Int())],"funcCall");
	
	toRet["getArrayOfStrArrayArray"]=runAnalysisThroughFunc(localP,"getArray",[Array(Array(String()))],"funcCall");
	
	map[str,TypeRoot] expect=(
	  "getArrayOfFloat":typeSet({Array(Float())}),
	  "loopReturn":typeSet({Num()}),
	  "getSum":typeSet({Num()}),
	  "getArrayOfStrArrayArray":typeSet({Array(Array(Array(String())))}),
	  "getDiff":typeSet({
	      Bool(),
	      Num()
	    }),
	  "getArrayOfIntArray":typeSet({Array(Array(Int()))}),
	  "getArrayOfBool":typeSet({Array(Bool())})
	
	);
	
	return assertEquals(toRet,expect,"string","TypeRoot","runAnalysisThroughFunc");
	
}

test bool testSimpleFunctionCalls()
{
	str fileP="SimpleFunction.php";
	
	
	exitEnvm=runAnalysis(localP,fileP);
		
	expectEnvm=(

	  lab(52):(
	    var("sum"):nullTypeRoot(),
	    var("loop"):nullTypeRoot(),
	    var("diff"):nullTypeRoot(),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):nullTypeRoot()
	  ),
	  lab(85):(
	    var("sum"):typeSet({Num()}),
	    var("loop"):typeSet({Num()}),
	    var("diff"):typeSet({
	        Bool(),
	        Num()
	      }),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):typeSet({Array(Int())})
	  ),
	  lab(48):(
	    var("sum"):nullTypeRoot(),
	    var("loop"):nullTypeRoot(),
	    var("diff"):nullTypeRoot(),
	    var("b"):nullTypeRoot(),
	    var("a"):typeSet({Int()}),
	    var("arr"):nullTypeRoot()
	  ),
	  lab(81):(
	    var("sum"):typeSet({Num()}),
	    var("loop"):typeSet({Num()}),
	    var("diff"):typeSet({
	        Bool(),
	        Num()
	      }),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):typeSet({Array(Int())})
	  ),
	  lab(93):(
	    var("sum"):typeSet({Num()}),
	    var("loop"):typeSet({Num()}),
	    var("diff"):typeSet({
	        Bool(),
	        Num()
	      }),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):typeSet({Array(Int())})
	  ),
	  lab(95):(
	    var("sum"):typeSet({Num()}),
	    var("loop"):typeSet({Num()}),
	    var("diff"):typeSet({
	        Bool(),
	        Num()
	      }),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):typeSet({Array(Int())})
	  ),
	  lab(89):(
	    var("sum"):typeSet({Num()}),
	    var("loop"):typeSet({Num()}),
	    var("diff"):typeSet({
	        Bool(),
	        Num()
	      }),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):typeSet({Array(Int())})
	  ),
	  lab(58):(
	    var("sum"):typeSet({Num()}),
	    var("loop"):nullTypeRoot(),
	    var("diff"):nullTypeRoot(),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):nullTypeRoot()
	  ),
	  lab(71):(
	    var("sum"):typeSet({Num()}),
	    var("loop"):typeSet({Num()}),
	    var("diff"):typeSet({
	        Bool(),
	        Num()
	      }),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):nullTypeRoot()
	  ),
	  lab(64):(
	    var("sum"):typeSet({Num()}),
	    var("loop"):nullTypeRoot(),
	    var("diff"):typeSet({
	        Bool(),
	        Num()
	      }),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):nullTypeRoot()
	  ),
	  lab(76):(
	    var("sum"):typeSet({Num()}),
	    var("loop"):typeSet({Num()}),
	    var("diff"):typeSet({
	        Bool(),
	        Num()
	      }),
	    var("b"):typeSet({Int()}),
	    var("a"):typeSet({Int()}),
	    var("arr"):typeSet({Array(Int())})
	  ),
	  lab(45):(
	    var("sum"):nullTypeRoot(),
	    var("loop"):nullTypeRoot(),
	    var("diff"):nullTypeRoot(),
	    var("b"):nullTypeRoot(),
	    var("a"):nullTypeRoot(),
	    var("arr"):nullTypeRoot()
	  ),
	  lab(94):(
	    var("sum"):nullTypeRoot(),
	    var("loop"):nullTypeRoot(),
	    var("diff"):nullTypeRoot(),
	    var("b"):nullTypeRoot(),
	    var("a"):nullTypeRoot(),
	    var("arr"):nullTypeRoot()
	  ),
	  lab(30):(
	    var("sum"):nullTypeRoot(),
	    var("loop"):nullTypeRoot(),
	    var("diff"):nullTypeRoot(),
	    var("b"):nullTypeRoot(),
	    var("a"):nullTypeRoot(),
	    var("arr"):nullTypeRoot()
	  ),
	  lab(41):(
	    var("sum"):nullTypeRoot(),
	    var("loop"):nullTypeRoot(),
	    var("diff"):nullTypeRoot(),
	    var("b"):nullTypeRoot(),
	    var("a"):nullTypeRoot(),
	    var("arr"):nullTypeRoot()
	  ),
	  lab(9):(
	    var("sum"):nullTypeRoot(),
	    var("loop"):nullTypeRoot(),
	    var("diff"):nullTypeRoot(),
	    var("b"):nullTypeRoot(),
	    var("a"):nullTypeRoot(),
	    var("arr"):nullTypeRoot()
	  )
	
	);

	return assertEquals(exitEnvm,expectEnvm,"Lab","Identifier","propagate");		
}

test bool testSimpleInclude()
{
	str fileP="IncludeTest.php";
	
	exitEnvm=runAnalysis(localP,fileP);
	
	expectEnvm=(
	  lab(22):(
	    var("vars_var_3"):typeSet({String()}),
	    var("vars_FuncCallInVars"):typeSet({
	        Array(String()),
	        String()
	      }),
	    var("vars_var_2"):typeSet({Int()}),
	    var("vars_var"):typeSet({String()}),
	    var("include_var"):typeSet({Bool()}),
	    var("include_FuncCallInInclude"):typeSet({String()}),
	    var("include_FuncCallInVars"):typeSet({String()})
	  ),
	  lab(17):(
	    var("vars_var_3"):typeSet({String()}),
	    var("vars_FuncCallInVars"):typeSet({
	        Array(String()),
	        String()
	      }),
	    var("vars_var_2"):typeSet({Int()}),
	    var("vars_var"):typeSet({String()}),
	    var("include_var"):typeSet({Bool()}),
	    var("include_FuncCallInInclude"):nullTypeRoot(),
	    var("include_FuncCallInVars"):typeSet({String()})
	  ),
	  lab(28):(
	    var("vars_var_3"):typeSet({String()}),
	    var("vars_FuncCallInVars"):typeSet({
	        Array(String()),
	        String()
	      }),
	    var("vars_var_2"):typeSet({Int()}),
	    var("vars_var"):typeSet({String()}),
	    var("include_var"):typeSet({Bool()}),
	    var("include_FuncCallInInclude"):typeSet({String()}),
	    var("include_FuncCallInVars"):typeSet({String()})
	  ),
	  lab(31):(
	    var("vars_var_3"):typeSet({String()}),
	    var("vars_FuncCallInVars"):typeSet({
	        Array(String()),
	        String()
	      }),
	    var("vars_var_2"):typeSet({Int()}),
	    var("vars_var"):typeSet({Float()}),
	    var("include_var"):typeSet({Bool()}),
	    var("include_FuncCallInInclude"):typeSet({String()}),
	    var("include_FuncCallInVars"):typeSet({String()})
	  ),
	  lab(26):(
	    var("vars_var_3"):typeSet({String()}),
	    var("vars_FuncCallInVars"):typeSet({
	        Array(String()),
	        String()
	      }),
	    var("vars_var_2"):typeSet({Int()}),
	    var("vars_var"):typeSet({String()}),
	    var("include_var"):typeSet({Bool()}),
	    var("include_FuncCallInInclude"):typeSet({String()}),
	    var("include_FuncCallInVars"):typeSet({String()})
	  ),
	  lab(36):(
	    var("vars_var_3"):typeSet({String()}),
	    var("vars_FuncCallInVars"):typeSet({
	        Array(String()),
	        String()
	      }),
	    var("vars_var_2"):typeSet({Int()}),
	    var("vars_var"):typeSet({Float()}),
	    var("include_var"):typeSet({Bool()}),
	    var("include_FuncCallInInclude"):typeSet({String()}),
	    var("include_FuncCallInVars"):typeSet({String()})
	  ),
	  lab(6):(
	    var("vars_var"):nullTypeRoot(),
	    var("include_var"):typeSet({String()}),
	    var("include_FuncCallInInclude"):nullTypeRoot(),
	    var("include_FuncCallInVars"):nullTypeRoot()
	  ),
	  lab(34):(
	    var("vars_var_3"):typeSet({String()}),
	    var("vars_FuncCallInVars"):typeSet({
	        Array(String()),
	        String()
	      }),
	    var("vars_var_2"):typeSet({Int()}),
	    var("vars_var"):typeSet({Float()}),
	    var("include_var"):typeSet({Bool()}),
	    var("include_FuncCallInInclude"):typeSet({String()}),
	    var("include_FuncCallInVars"):typeSet({String()})
	  ),
	  lab(15):(
	    var("vars_var"):nullTypeRoot(),
	    var("include_var"):typeSet({String()}),
	    var("include_FuncCallInInclude"):nullTypeRoot(),
	    var("include_FuncCallInVars"):nullTypeRoot()
	  ),
	  lab(35):(
	    var("vars_var"):nullTypeRoot(),
	    var("include_var"):nullTypeRoot(),
	    var("include_FuncCallInInclude"):nullTypeRoot(),
	    var("include_FuncCallInVars"):nullTypeRoot()
	  ),
	  lab(3):(
	    var("vars_var"):nullTypeRoot(),
	    var("include_var"):typeSet({String()}),
	    var("include_FuncCallInInclude"):nullTypeRoot(),
	    var("include_FuncCallInVars"):nullTypeRoot()
	  )
	);
	
	return assertEquals(exitEnvm,expectEnvm,"Lab","Identifier","propagate");	
}

test bool testIncludeNotFound()
{
	str fileP="IncludeNotFound.php";
	
	exitEnvm=runAnalysis(localP,fileP);

	expectInfo=
	<("IncludeNotFound.php":(
	    lab(6):(
	      var("include_var"):typeSet({String()}),
	      var("vars_var"):nullTypeRoot(),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(3):(
	      var("include_var"):typeSet({String()}),
	      var("vars_var"):nullTypeRoot(),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(12):(
	      var("include_var"):nullTypeRoot(),
	      var("vars_var"):nullTypeRoot(),
	      var("temp"):nullTypeRoot()
	    ),
	    lab(13):(
	      var("include_var"):typeSet({String()}),
	      var("vars_var"):nullTypeRoot(),
	      var("temp"):typeSet({Void()})
	    ),
	    lab(10):(
	      var("include_var"):typeSet({String()}),
	      var("vars_var"):nullTypeRoot(),
	      var("temp"):typeSet({Void()})
	    )
	  )),("IncludeNotFound.php":[
	    includeFileNotFound("Include stmt at lab(6) for file: varss.php returned error. Maybe file missing or has syntax-errors."),
	    readFromNonDeclaredVar("Attempt to read from undeclared var(vars_var) @ lab(10)."),
	    usingVoidTypeForExpr("Computed typeSet for lab(10) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(temp) @ lab(8).")
	  ])>;
			
	//return <AppExitEnvms,AppWarnings>;
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
	
}