module tests::soft::typing::php::cfg::Test_CFGBuilder

import soft::typing::php::cfg::BuildCFG;
import lang::php::analysis::NamePaths;
import soft::typing::php::cfg::CFG;
import soft::typing::php::cfg::Label;
import soft::typing::php::cfg::FlowEdge;
import soft::typing::php::cfg::Visualize;
import soft::typing::php::cfg::CollapseCFG;
import lang::php::ast::AbstractSyntax;
import IO;
import soft::typing::php::constraints::ConstraintHelper;

private loc rootP=|file:///Users/apil/Dropbox/Scripts|;
private alias MyTuple=[Script scr,CFG cfgs,LabelRefsForCFGNodes refs];

public MyTuple visualize(loc fileName,loc writeName)
{
	soln=buildCFGs(fileName,buildBasicBlocks=false);
	
	renderCFGAsDot( soln.cfgs,writeName,"<fileName>");
	return soln;
}


public MyTuple createCFG_Cond001()
{
	loc fileName=rootP+"/Cond001.php";
	loc writeTo= rootP+"/Cond001.dot";
	return visualize(fileName,writeTo);
	
}

public MyTuple createCFG_Cond002()
{
	loc fileName=rootP+"/Cond002.php";
	loc writeTo =rootP+"/Cond002.dot";
	
	return visualize(fileName,writeTo);
}

public MyTuple createCFG_Cond003()
{
	loc fileName=rootP+"/Cond003.php";
	loc writeTo =rootP+"/Cond003.dot";
	
	return visualize(fileName,writeTo);
}

public MyTuple createCFG_Simple1()
{
	loc filename=rootP+"/simple1.php";
	loc writeTo=rootP+"/simple1.dot";
	return visualize(filename,writeTo);
}

public MyTuple createCFG_Simple7()
{
	loc filename=rootP+"/simple7.php";
	loc writeTo=rootP+"/simple7.dot";
	return visualize(filename,writeTo);
}

public MyTuple createCFG_AssignWOp1()
{
	loc filename=rootP+"/AssignWOp1.php";
	loc writeTo= rootP+"/AssignWOp1.dot";
	return visualize(filename,writeTo);
}

public MyTuple createCFG_UnaryOp1()
{
	loc filename=rootP+"/UnaryOp1.php";
	loc writeTo =rootP+"/UnaryOp1.dot";
	return visualize(filename,writeTo);
}

public MyTuple createCFG_While1()
{

	loc filename=rootP+"/While1.php";
	loc writeTo =rootP+"/While1.dot";
	
	return visualize(filename,writeTo);
}	

public MyTuple createCFG_WhileAndIf1()
{
	loc filename=rootP+"/WhileAndIf1.php";
	loc writeTo=rootP+ "/WhileAndIf1.dot";
	return visualize(filename,writeTo);
}	

public MyTuple createCFG_Ternary1()
{
	loc filename=rootP+"/Ternary1.php";
	loc writeTo=rootP+ "/Ternary1_Collapsed.dot";
	return visualize(filename,writeTo);

}

public MyTuple createCFG_FullSimpleScript()
{
	loc filename=rootP+"/FullSimpleScript.php";
	loc writeTo=rootP+ "/FullSimpleScript.dot";
	return visualize(filename,writeTo);
}

//build cfg and run analysis for file with array declaration
public MyTuple testArray1()
{
	loc rootP   =|file:///Users/apil/Dropbox/Scripts|;
	loc fileTest=rootP+"/Array1.php";
	loc writeTo =rootP+"/Array1.dot";

	myT=visualize(fileTest,writeTo);
	
	return myT;
}public MyTuple testArray2()
{
	
	loc fileTest=rootP+"/Array2.php";
	loc writeTo =rootP+"/Arra2.dot";

	myT=visualize(fileTest,writeTo);
	
	return myT;
}
public MyTuple testArray4()
{
	loc fileTest=rootP+"/Array4.php";
	loc writeTo =rootP+"/Array4.dot";
	
	myT=visualize(fileTest,writeTo);
	
	return myT;
}

public MyTuple testSimpleFunction()
{
	loc fileTest=rootP+"SimpleFunction.php";
	loc writeTo=rootP+"SimpleFunction.dot";
	
	myT=visualize(fileTest,writeTo);
	
	return myT;
}

