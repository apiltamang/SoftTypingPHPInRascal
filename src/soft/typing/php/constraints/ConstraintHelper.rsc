module soft::typing::php::constraints::ConstraintHelper


import lang::php::ast::AbstractSyntax;
import lang::php::analysis::cfg::LabelState;
import lang::php::analysis::cfg::Label;
import lang::php::util::Utils;
import Set;
import Node;
import IO;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;

public Type getScalarType(Scalar sc)
{

	if (getName(sc)=="integer")
		return Int();
	if (getName(sc)=="float")
		return Float();
	if (getName(sc)=="string")
		return String();
	else
		throw "Expected Scalar value. Got: <sc> \n"+
		"Error loc 5820158320.";
			
} 	
public Script loadAST(loc filePath)
{	
	fileAST=loadPHPFile(filePath,true,false);
	return fileAST;
	
}

public Stmt getLabeledStmt(str s)
{
	Stmt myStmt=parsePHPStatement(s);
	LabelState label=ls(0);
	tuple[Stmt,LabelState]labeledStmt=labelStmt(myStmt,label);
	return labeledStmt[0];
}

public tuple[Stmt,LabelState] labelStmt(Stmt stmt, LabelState lstate) {
	Lab incLabel() { 
		lstate.counter += 1; 
		return lab(lstate.counter); 
	}
	
	labeledStmt = bottom-up visit(stmt) {
		case Stmt s => s[@lab = incLabel()]
		case Expr e => e[@lab = incLabel()]
	};
	
	return < labeledStmt, lstate >;
}


public Script getLabeledScript(loc filePath)
{
	//For now work with only one statement scripts
	
	//get the AST
	Script aScript=loadAST(filePath);
	LabelState label=ls(0); //define a starting label value for the labels
	
	tuple[Script,LabelState] labeledScriptTuple=labelScript(aScript,label);
	
	Script labeledScript=labeledScriptTuple[0]; //called 'subscription' of a tuple


	return labeledScript;
	
	
}
