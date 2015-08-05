module soft::typing::php::functions::UnionOperator
import soft::typing::php::elements::Identifier;
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::functions::DeltaOperator;
import lang::php::analysis::cfg::Label;
import Set;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;


//combine typenvironments that have exactly same set of keys! Initially developed...
//used to combine typeenvironments for nodes within a script where the set of keys
//are same for both environments
public TypeEnvironment combine_old(TypeEnvironment envm1, TypeEnvironment envm2)
{
	TypeEnvironment toReturn=( );

	//iterate through all the identifiers
	for(Identifier idf <- [k | k<-envm1])
	{
		//note that the set of keys for all TypeEnvironments are the same. They
		//are simply all the variables that appear in the script
		
		//retrieve the typeroots
		t1=envm1[idf];
		t2=envm2[idf];
		
		//use the widening operator to combine them
		tt=widen(t1,t2);
		
		//now add this to the environment to return
		toReturn[idf]=tt;
	}
	
	return toReturn;
}

//this method is called by any relevant unit tests 
public TypeEnvironment combine(TypeEnvironment envm1,TypeEnvironment envm2)
{
	Lab foo=lab(999);
	list[Warning] el=[];
	str foobar="foobar";
	return combine(envm1,envm2,foo,el,foobar).envm;
}

//combine typeEnvironments with varying keys. Written to support combination of
//environments across two different scripts. Required for 'include(filename)'.
//Supplants the usage of combine_old. All tests have passed without a hitch.
public tuple[TypeEnvironment envm,list[Warning] warns] combine
	(TypeEnvironment envm1,TypeEnvironment envm2, Lab nodeLabel,list[Warning] warns,str scriptName)
{
	TypeEnvironment toReturn=( );
	
	//for all identifiers in envm1	
	for(Identifier idf<-envm1)
		//if idf is also in envm2
		if(idf in envm2)
		{
			//the result is a combination of the two following norms of widening
			TypeRoot widened=widen(envm1[idf],envm2[idf]);
			
			//issue warning if the typeSet contains more than one types
			//The last condition is to check and see that the var acquired numerous types
			//as a result of being merged. If envm1[idf] or envm2[idf] already had the
			//same numerous type-set for var, then it isn't necessary to flag this. This
			//would be flagged in the node where this happened.
			if(widened has types && size(widened.types)>1)
			{
				//make a table where you store all dirty vars, i.e. var that has had multiple types, void
				//types, etc. for this script, and if you find this var in this dirty list, do not generate
				//additional errors.	
				if(idf notin MultipleTypedVarMap[scriptName])				
				{
					MultipleTypedVarMap[scriptName]=MultipleTypedVarMap[scriptName]+{idf};		
					warns+=[varHasMultipleTypes("Var <idf.name> acquired more than one types at <nodeLabel>.")];
				}
			
			}
				
			//An alternate is that widened is nullTypeRoot, which simply says
			//that idf has not been processed yet, and it is likely just passing
			//through the node.	
			toReturn[idf]=widened;
		}
		else
		{
			//just the first one
			toReturn[idf]=envm1[idf];
		}

	//add identifiers in idf2 which do not appear in idf1
	for(Identifier idf<-[ii|ii <- envm2, ii notin envm1])
		toReturn[idf]=envm2[idf];

	return <toReturn,warns>;
}