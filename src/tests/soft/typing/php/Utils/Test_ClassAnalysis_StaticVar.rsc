module tests::soft::typing::php::Utils::Test_ClassAnalysis_StaticVar

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::Utils::Analysis;
import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::helper::Test_SetComparator;

private loc localP=rootP+"Test_ClassAnalysis_StaticVars";

test bool testStaticVar_TestA()
{

	fileTest="StaticVar_TestA.php";
	
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectEnvm=
	(
	  lab(16):(
	    var("a"):typeSet({Object(
	          objHd(2),
	          objInst(
	            2,
	            (),
	            "A",
	            {}))}),
	    var("test"):typeSet({String()})
	  ),
	  lab(4):(
	    var("a"):nullTypeRoot(),
	    var("test"):nullTypeRoot()
	  ),
	  lab(1):(
	    var("a"):nullTypeRoot(),
	    var("test"):nullTypeRoot()
	  ),
	  lab(12):(
	    var("a"):typeSet({Object(
	          objHd(2),
	          objInst(
	            2,
	            (),
	            "A",
	            {}))}),
	    var("test"):typeSet({String()})
	  ),
	  lab(14):(
	    var("a"):typeSet({Object(
	          objHd(2),
	          objInst(
	            2,
	            (),
	            "A",
	            {}))}),
	    var("test"):typeSet({String()})
	  ),
	  lab(15):(
	    var("a"):nullTypeRoot(),
	    var("test"):nullTypeRoot()
	  ),
	  lab(8):(
	    var("a"):typeSet({Object(
	          objHd(2),
	          objInst(
	            2,
	            (),
	            "A",
	            {}))}),
	    var("test"):nullTypeRoot()
	  )
	);
	
	return assertEquals(exitEnvm,expectEnvm,"map[Lab,TypeEnvironment]","propagate");	
	
}

test bool testStaticVar_TestB()
{

	fileTest="StaticVar_TestB.php";
	
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectEnvm=(
	  lab(6):(var("test"):nullTypeRoot()),
	  lab(2):(var("test"):nullTypeRoot()),
	  lab(3):(var("test"):nullTypeRoot()),
	  lab(12):(var("test"):typeSet({Object(
	          objHd(3),
	          objInst(
	            3,
	            (),
	            "B",
	            {}))})),
	  lab(13):(var("test"):nullTypeRoot()),
	  lab(14):(var("test"):typeSet({Object(
	          objHd(3),
	          objInst(
	            3,
	            (),
	            "B",
	            {}))})),
	  lab(10):(var("test"):typeSet({Object(
	          objHd(3),
	          objInst(
	            3,
	            (),
	            "B",
	            {}))}))
	);
	
	return assertEquals(exitEnvm,expectEnvm,"map[Lab,TypeEnvironment]","propagate");
	
}