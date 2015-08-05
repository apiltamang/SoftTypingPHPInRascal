module soft::typing::php::cfg2::CollapseCFG

//The functions in this module will be responsible for collapsing
//the cfg into blocks of statements as per the methods provided 
//by Dr. Hills

import lang::php::analysis::cfg::BuildCFG;
import lang::php::analysis::cfg::CFG;
import lang::php::analysis::NamePaths;
import lang::php::analysis::cfg::Visualize;
import lang::php::ast::AbstractSyntax;
import lang::php::util::Utils;

import soft::typing::php::elements::Class;
import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;
import IO;
import Node;



public map[str,CFG] getNewCollapsedCFG(loc rootP,str fileTest)
{
	fileP=rootP+fileTest;
	printIndLn("File Under Test: <fileP>");
	<labeledScript,myM>=buildCFGsAndScript(loadPHPFile(fileP)
										,buildBasicBlocks=false);

	
	/*
	//TODO: Someday, I will have the annotations deleted!!
	for(NamePath k <- myM)
		myM[k]=removeAnnotations(myM[k]);
	*/
	
	/*
	printIndLn("Built CFG: ");
	iprintln(myM);
	*/
	
	map[str,CFG] mapp=( );
	
	//error could be thrown for a number of reasons 
	//(syntax error/missing file)
	if(errscript(_):=labeledScript)
		return mapp;
		
	//get the class definitions
	GlobalClassDeclsMap=extractClassDefs(labeledScript);
	printIndLn("Class definitions: ");
	iprintln(GlobalClassDeclsMap);
	
	
	
	i=0;
	for(NamePath k <- myM)
	{
		myCFG=removeChildExpressions(myM[k]);
		
		if( [global()]:=k)
		{
			printIndLn("global k: <k>");
			mapp[fileTest]=myCFG;
			
			
			writeToFile=rootP+"<fileTest>.main.init.dot";
			printIndLn("Write To File: <writeToFile>");
			
			renderCFGAsDot(myCFG,writeToFile,"<writeToFile>");
			

		}
		else if( [global(),function(str fname)] :=k )
		{
			printIndLn("function k: <k>");
			mapp[fname]=myCFG;
			
			writeToFile=rootP+"<fileTest>.<fname>.function.init.dot";
			printIndLn("Write To File: <writeToFile>");
			renderCFGAsDot(myCFG,writeToFile,"<writeToFile>");
			

		}
		else if( [class(str cName),method(str mName)] :=k)
		{
			printIndLn("method k: <k>");
			
			methodId=cName+"."+mName;
			mapp[methodId]=myCFG;
			
			writeToFile=rootP+"<fileTest>.<methodId>.method.init.dot";
			printIndLn("Write To File: <writeToFile>");
			renderCFGAsDot(myCFG,writeToFile,"<writeToFile>");
			
			
		}
		else
		{
			throw Exception("Unknown namespace encountered: <k>");
		}
	}
	
	return mapp;
}

public CFG removeAnnotations(CFG scr)
{
	return  
			removeLocAnnotations
			(
				removeScopeAnnotations
				(
					removeDocAnnotations(scr)
				)
			);
				
}

public CFG removeDocAnnotations(CFG scr)
{
	str docAnno="phpdoc";
	return visit(scr)
	{
		case Expr e => delAnnotationsRec(e,docAnno) when (e@phpdoc)?
		case Stmt s => delAnnotationsRec(s,docAnno) when (s@phpdoc)?
	}
}

public CFG removeScopeAnnotations(CFG scr)
{
	str scopeAnno="scope";
	return visit(scr)
	{
		case Expr e => delAnnotationsRec(e,scopeAnno) when (e@scope)?
		case Stmt s => delAnnotationsRec(s,scopeAnno) when (s@scope)?
	}
}

public CFG removeLocAnnotations(CFG scr)
{
	str locAnno="at";
	return visit(scr)
	{
		case Expr e => delAnnotationsRec(e,locAnno) when (e@at)?
		case Stmt s => delAnnotationsRec(s,locAnno) when (s@at)?
	}
}