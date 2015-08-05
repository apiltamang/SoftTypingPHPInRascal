module tests::soft::typing::php::Utils::Test_Analysis

import lang::php::ast::AbstractSyntax;
import soft::typing::php::functions::DeltaOperator;
import soft::typing::php::functions::UnionOperator;
import soft::typing::php::elements::Identifier;
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::Utils::Analysis;
import soft::typing::php::Utils::AnalysisHelpers;
import lang::php::analysis::cfg::Label;
import lang::php::analysis::cfg::Visualize;
import lang::php::analysis::cfg::BuildCFG;
import tests::soft::typing::php::helper::Test_SetComparator;

import soft::typing::php::declarations::PublicDataTypes;

import IO;

private loc localP=rootP+"Test_Analysis";

test bool testFullSimpleScript()
{

	//firt grab the script and initialize analysis nodes
	str fileTest="FullSimpleScript.php";
	
	
	/* Content of file: 
	
	<?php 
	$a=0;   
	$b=0;
	while ($a < 10)
	{
		$a++;
		if ( ($b % 3) == 0 )
	
			$b +=($a * 2);
	
		else
			$b--;
	}
	
	if($b<10)
		$c="test";
	else
		$c=true;
	
	echo $c;
		
	?>
	
	End of file*/
	
	/*
	 * Old interface to analysis
		
	 * newAnalysis();
	 * myT=initializeAnalysis(fileTest);
	 * <entryEnvmTable,exitEnvmTable>=seed(myT.nodes );
	*/
	
	/* 
	 * New interface to analysis
	*/
	
	exitEnvmTable=runAnalysis(localP,fileTest);
		
	expectExitEnvmTable=(

	lab(52):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):typeSet({String(),Bool()})),
	lab(48):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot()),
	lab(49):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot()),
	lab(50):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot()),
	lab(24):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot()),
	lab(27):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot()),
	lab(36):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):typeSet({String()})),
	lab(7):(var("a"):typeSet({Int()}),var("b"):typeSet({Int()}),var("c"):nullTypeRoot()),
	lab(33):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot()),
	lab(3):(var("a"):typeSet({Int()}),var("b"):nullTypeRoot(),var("c"):nullTypeRoot()),
	lab(44):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):typeSet({String(),Bool()})),
	lab(46):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):typeSet({String(),Bool()})),
	lab(47):(var("a"):typeSet({Int()}),var("b"):typeSet({Int()}),var("c"):nullTypeRoot()),
	lab(40):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):typeSet({Bool()})),
	lab(11):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot()),
	lab(51):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot()),
	lab(19):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot()),
	lab(45):(var("a"):nullTypeRoot(),var("b"):nullTypeRoot(),var("c"):nullTypeRoot()),
	lab(13):(var("a"):typeSet({Int()}),var("b"):typeSet({Num()}),var("c"):nullTypeRoot())

	);
	
	assertEquals(exitEnvmTable,expectExitEnvmTable,"Lab","TypeEnvironment","propagate");	
	
	return true;
}

test bool testArray4Script()
{

	//firt grab the script and initialize analysis nodes
	str fileTest="Array4.php";
	
	
	exitEnvmTable=runAnalysis(localP,fileTest);
		
	  expectExitEnvmTable= (
		lab(21): (var("d"):nullTypeRoot(),var("e"):nullTypeRoot(),var("f"):nullTypeRoot(),var("a"):typeSet({Array(String()),Array(Int())}),var("b"):typeSet({String(),Int()}),var("c"):typeSet({Array(Int())})),
		lab(31): (var("d"):typeSet({Int()}),var("e"):typeSet({Array(String()),Array(Int())}),var("f"):nullTypeRoot(),var("a"):typeSet({Array(String()),Array(Int())}),var("b"):typeSet({String(),Int()}),var("c"):typeSet({Array(Int())})),
		lab(27): (var("d"):typeSet({Int()}),var("e"):nullTypeRoot(),var("f"):nullTypeRoot(),var("a"):typeSet({Array(String()),Array(Int())}),var("b"):typeSet({String(),Int()}),var("c"):typeSet({Array(Int())})),
		lab(37): (var("d"):nullTypeRoot(),var("e"):nullTypeRoot(),var("f"):nullTypeRoot(),var("a"):nullTypeRoot(),var("b"):nullTypeRoot(),var("c"):nullTypeRoot()),
		lab(35): (var("d"):typeSet({Int()}),var("e"):typeSet({Array(String()),Array(Int())}),var("f"):typeSet({Array(Int())}),var("a"):typeSet({Array(String()),Array(Int())}),var("b"):typeSet({String(),Int()}),var("c"):typeSet({Array(Int())})),
		lab(12): (var("d"):nullTypeRoot(),var("e"):nullTypeRoot(),var("f"):nullTypeRoot(),var("a"):typeSet({Array(String()),Array(Int())}),var("b"):typeSet({String(),Int()}),var("c"):nullTypeRoot()),
		lab(38): (var("d"):typeSet({Int()}),var("e"):typeSet({Array(String()),Array(Int())}),var("f"):typeSet({Array(Int())}),var("a"):typeSet({Array(String()),Array(Int())}),var("b"):typeSet({String(),Int()}),var("c"):typeSet({Array(Int())})),
		lab(6): (var("d"):nullTypeRoot(),var("e"):nullTypeRoot(),var("f"):nullTypeRoot(),var("a"):typeSet({Array(String()),Array(Int())}),var("b"):nullTypeRoot(),var("c"):nullTypeRoot())
	);
	
	return assertEquals(exitEnvmTable,expectExitEnvmTable,"Lab","TypeEnvironment","propagate");	
}

test bool testTwoLineScript()
{
	
	str fileP="TwoLinesScript.php";
	
	exitEnvmTable=runAnalysis(localP,fileP);
	exitEnvmResult=(	
	  lab(7):(
	    var("a"):typeSet({Int()}),
	    var("c"):typeSet({Int()})
	  ),
	  lab(3):(
	    var("a"):typeSet({Int()}),
	    var("c"):nullTypeRoot()
	  ),
	  lab(9):(
	    var("a"):nullTypeRoot(),
	    var("c"):nullTypeRoot()
	  ),
	  lab(10):(
	    var("a"):typeSet({Int()}),
	    var("c"):typeSet({Int()})
	  )
	);
	
	return assertEquals(exitEnvmTable,exitEnvmResult,"Lab","TypeEnvironment","propagate");
	
	
}

test bool testArrayInLoop()
{

	str fileP="ArrayInLoop.php";

	exitEnvmTable=runAnalysis(localP,fileP);
	
		
	exitEnvmExpect=
	(
		lab(20) : (var("a"):typeSet({Array(Any())})),
		lab(16) : (var("a"):typeSet({Array(Any())})),
		lab(17) : (var("a"):nullTypeRoot()),
		lab(18) : (var("a"):typeSet({Array(Any())})),
		lab(19) : (var("a"):typeSet({Array(Int())})),
		lab(6) : (var("a"):typeSet({Array(Int())})),
		lab(12) : (var("a"):typeSet({Array(Array(Any()))})),
		lab(8) : (var("a"):typeSet({Array(Any())}))
	);				
	
	return assertEquals(exitEnvmTable,exitEnvmExpect,"Lab","TypeEnvironment","propagate");
	
}
test bool testArrayDeclWithKeys()
{
	str fileP="ArrayDeclWithKeys.php";
	
		
	exitEnvmTable=runAnalysis(localP,fileP);
	
	exitEnvmExpect=(
	  lab(12):(var("ab"):typeSet({
	        Array(Bool()),
	        Array(String()),
	        Array(Int())
	      })),
	  lab(13):(var("ab"):nullTypeRoot()),
	  lab(14):(var("ab"):typeSet({
	        Array(Bool()),
	        Array(String()),
	        Array(Int())
	      })),
	  lab(9):(var("ab"):typeSet({
	        Array(Bool()),
	        Array(String()),
	        Array(Int())
	      }))
	);
	
	return assertEquals(exitEnvmTable,exitEnvmExpect,"Lab","TypeEnvironment","propagate");
}
/*
test bool testArrayEmptyDecl()
{
	str fileP="ArrayEmptyDecl.php";
	loc localP   =|file:///Users/apil/Dropbox/Scripts|;
	exitEnvmTable=runAnalysis(localP,fileP);
	for(Lab l<-exitEnvmTable)
		printIndLn("<l> : <exitEnvmTable[l]>");
}
*/

/*test AppInfo testIfStmtIsNoted(){
	
	str fileP="IfStmtIsNoted.php";
	
	exitEnvm=runAnalysis(localP,fileP);
	
	return <AppExitEnvms,AppWarnings>;
}*/
