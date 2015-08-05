module tests::soft::typing::php::Thesis::Test_ThesisSampleResults

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::Utils::Analysis;
import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::helper::Test_SetComparator;
import tests::soft::typing::php::helper::Test_GenerateWarnings;
import IO;

private loc localP=rootP+"Test_ThesisSampleResults";


test void test_SimpleDataCoercions()
{
	
	//Sample 1	
	fileTest="SimpleDataCoercions.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}

test void test_SimpleArrayCoercions()
{
	
	//Sample 2	
	fileTest="SimpleArrayCoercions.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}

test void test_OtherScriptWarnings()
{
	
	//Sample 3		
	fileTest="OtherScriptWarnings.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}

test void test_ObjectStateChange()
{
	
	//Sample 4		
	fileTest="ObjectStateChange.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}

test void test_RecursiveFail2()
{

	//test a simple case when a recursive 
	//call analysis triggers an error
	//Sample 5	
	fileTest="RecursiveFail2.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return;
	
}	

test void test_FuncCallWithTooFewArguments()
{

	//test a simple case where a func. is 
	//called with too few arguments
	fileTest="FuncTooFewArguments.php";
	exitEnvm=runAnalysis(localP,fileTest);
	
	generateWarnings(AppWarnings);
	return;
}

test void test_SimpleScriptForAppendix()
{
	//a simple example included in the
	//appendix
	fileTest="SimpleScriptForAppendix.php";
	exitEnvm=runAnalysis(localP,fileTest);
	
	generateWarnings(AppWarnings);
	return;
}