module tests::soft::typing::php::constraints::Test_GetConstraints_Helper

import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::constraints::GetConstraints;
import tests::soft::typing::php::helper::Test_SetComparator;
import lang::php::analysis::cfg::Label;
import Set;
import IO;

import soft::typing::php::declarations::PublicDataTypes;

public bool assertEquals(set[Constraint]soln,str phpStmt)
{
	//get the result using the function calls
	set[Constraint]result=extractConstraints(getLabeledStmt(phpStmt));
	
	return assertEquals(result,soln,"Constraint","extractConstraints");	
}

