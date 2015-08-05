module soft::typing::php::warnings::TypeCoercionCheckers

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;

import lang::php::analysis::cfg::Label;

private num getWarningValue(Type type1,Type type2)
{
	//if yield type is Void, return 1 no 
	//matter what the expected type maybe.
	if(type1 is Void)
		return 1;   
	if(type1==type2)
		return 0;
	if(type1 is Any)
		return 0;
	if(type2 is Any)
		return 0;
	
	if (type1 is Int||type1 is Float)
		if(type2 is Num)
			return 0;
		else
			return 1;
	if(type1 is Num)
		if(type2 is Int||type2 is Float)
			return 0;
		else
			return 1;
			
	return 1;		
	
}

public num generateTypeCoercionValue(Type tY,Type tE)
{
	
	if(Array(Type tt1):=tY && Array(Type tt2):=tE)
		//go into recursion...
		return generateTypeCoercionValue(tt1,tt2);
	
	return getWarningValue(tY,tE);
}


//this method would have been called in response to an expectType constraint.
public list[Warning] checkForIllegalTypeCoercions(set[Type] typesYield, set[Type] typesExpect,Lab l1)
{
	list[Warning] warnings=[];
	num warnVal=0.0;
	
	for(Type tY <- typesYield)
	{
		//potentially, all is severe warning case	
		bool raiseSevereWarn=true;
		for(Type tE <- typesExpect)
		{
			//get the warning value			
			warnVal=generateTypeCoercionValue(tY,tE);
			
			//if any of the type in expect accepts the
			//yield case, suppress warning
			if(warnVal==0)
			{
				raiseSevereWarn = false;
			}
			
		}//end for (iterate typesExpect)
	
		if(raiseSevereWarn)
			warnings+=[typeCoercionWarning("Possible Illegal Type Coercion @ <l1>. Got: <tY>. Expected from: <typesExpect>.")];
	}
	return warnings;
}

//this method would have been called in response to an expectFlow constraint..
public list[Warning] checkForIllegalTypeCoercions(set[Type] typesYield, set[Type] typesExpect,Lab l1, Lab l2)
{
	list[Warning] eL=[];
	if(!(typesYield==typesExpect))
		//return [typeCoercionWarning("Type set yield for <l1> does not match that for <l2>.")];
		return [equalTypesExpectedFail("Type-set yield for <l1>: <typesYield>. Type-set yield for <l2>: <typesExpect>.")]; 
	else
		return eL;
	
}
