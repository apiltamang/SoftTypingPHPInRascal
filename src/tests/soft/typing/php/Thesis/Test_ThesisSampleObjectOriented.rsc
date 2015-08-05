module tests::soft::typing::php::Thesis::Test_ThesisSampleObjectOriented

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::Utils::Analysis;
import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::helper::Test_SetComparator;
import tests::soft::typing::php::helper::Test_GenerateWarnings;
import IO;

private loc localP=rootP+"Test_ThesisSampleObjectOriented";


test void test_ClassRelatedErrors()
{
	
	//Sample 1	
	fileTest="ClassRelatedErrors.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}

test void test_ClassRelatedErrorsIntroduced1()
{
	
	//Sample 1	
	fileTest="ClassRelatedErrorsIntroduced1.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}

test void test_ClassRelatedErrorsIntroduced2()
{
	
	//Sample 1	
	fileTest="ClassRelatedErrorsIntroduced2.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}

test void test_ClassRelatedErrorsIntroduced3()
{
	
	//Sample 1	
	fileTest="ClassRelatedErrorsIntroduced3.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}

test void test_ClassRelatedErrorsIntroduced4()
{
	
	//Sample 1	
	fileTest="ClassRelatedErrorsIntroduced4.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}

test void test_ClassRelatedErrorsIntroduced5()
{
	
	//Sample 1	
	fileTest="ClassRelatedErrorsIntroduced5.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	generateWarnings(AppWarnings);
	
	return ;
	//<AppExitEnvms,AppWarnings>;
}
