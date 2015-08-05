module tests::soft::typing::php::Utils::Test_Analysis_Nested_Includes

import lang::php::analysis::cfg::Label;
import soft::typing::php::elements::Identifier;
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::Utils::Analysis;
import tests::soft::typing::php::helper::Test_SetComparator;

import soft::typing::php::declarations::PublicDataTypes;

private loc localP=rootP+"Test_Analysis_Nested_Includes";

test bool test_NestedIncludes1( )
{

	str fileP	="include_fileB.php";
		
	exitEnvm=runAnalysis(localP,fileP);
	
	
	map[Lab, TypeEnvironment] expectEnvm= (
	  lab(5):(
	    var("varA"):typeSet({Int()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(7):(
	    var("varA"):typeSet({Int()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(2):(
	    var("varA"):typeSet({Int()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(8):(
	    var("varA"):nullTypeRoot(),
	    var("varB"):nullTypeRoot()
	  ),
	  lab(9):(
	    var("varA"):typeSet({Int()}),
	    var("varB"):typeSet({Float()})
	  )
	)	;
	
	return assertEquals(exitEnvm,expectEnvm,"Lab","Identifier","Analysis");

}


test bool test_NestedIncludes2( )
{
	str fileP	="include_fileB_fileA.php";
	
	exitEnvm=runAnalysis(localP,fileP);
	
	expectEnvm=(

	  lab(20):(
	    var("varA"):typeSet({Float()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(16):(
	    var("varA"):typeSet({Int()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(28):(
	    var("varA"):typeSet({Int()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(29):(
	    var("varA"):typeSet({Num()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(24):(
	    var("varA"):typeSet({Num()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(25):(
	    var("varA"):typeSet({Num()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(26):(var("varA"):nullTypeRoot()),
	  lab(27):(
	    var("varA"):typeSet({Num()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(5):(var("varA"):typeSet({String()})),
	  lab(7):(
	    var("varA"):typeSet({Int()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(2):(var("varA"):typeSet({String()})),
	  lab(13):(
	    var("varA"):typeSet({Int()}),
	    var("varB"):typeSet({Float()})
	  ),
	  lab(10):(
	    var("varA"):typeSet({Int()}),
	    var("varB"):typeSet({Float()})
	  )
	);	
	return assertEquals(exitEnvm,expectEnvm,"Lab","Identifier","analysis");
	

}