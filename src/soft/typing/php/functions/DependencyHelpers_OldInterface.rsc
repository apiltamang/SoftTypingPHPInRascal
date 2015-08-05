module soft::typing::php::functions::DependencyHelpers_OldInterface

import soft::typing::php::elements::Identifier;
import soft::typing::php::constraints::ConstraintHelper;
import lang::php::analysis::cfg::Label;
import soft::typing::php::functions::DependencyHelpers;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;


/*
 * Module written primarily to define functions that are used in a range
 * of unit tests
*/
//just for compatibility with the interface as specified for unit tests
//public set[Constraint] resolveDependencies(loc rootP,set[Constraint] constraints,
//			TypeEnvironment entry )
//{
//	return resolveDependencies(rootP,constraints,entry).ccs;
//}

public set[Constraint] resolveDependencies(set[Constraint] constraints)
{
	//function primarily defined to make previously written tests to pass...
	TypeEnvironment envm=();
	map[Lab,Identifier] aMap=();
	str mode="normal";
	loc rootP=|file:///|;
	return resolveDependencies(rootP,constraints,envm,mode).ccs;
}

public TypeRoot resolveFlow(Lab src, set[Constraint] constraints)
{
	TypeEnvironment envm=();
	
	return resolveFlow(src,constraints,envm);
}

public TypeRoot getTypeOf(Lab l,set[Constraint] ccs,TypeEnvironment entry)
{
	map[Lab,Identifier] aMap=();
	
	return getTypeOf(l,ccs,entry);
}

public TypeRoot getTypeOf(loc rootP, Lab l, set[Constraint] ccs, TypeEnvironment entry)
{
	map[TypeRoot,TypeRoot] foobar1=();
	map[Lab,TypeRoot] foobar2=();
	str mode="normal";
	<got,evaluatedTRoots,evaluatedLabs>=
		getTypeOf(rootP,l,ccs,entry,foobar1,foobar2,mode);
		
	return got;
}