module soft::typing::php::constraints::OperationHelper

import lang::php::ast::AbstractSyntax;


public bool isNumOp(Op op)
{
	if (op==div()||op==minus()||
		op==\mod()||op==mul()||op==plus())
	{
		return true;
	}else
	{
		return false;
	}
}
		
public bool isBoolOp(Op op)
{
	if(op is booleanNot||
	   op is booleanOr ||
	   op is booleanAnd||
	   op is logicalAnd||
	   op is logicalOr ||
	   op is logicalXor||
	   op is logical)
	{
		return true;
	}
	else
	{
		return false;
	}
}

public bool isUnaryNumOp(Op op)
{
	if(op is unaryPlus || op is unaryMinus)
		return true;
	else
		return false;
}

public bool isIntOp(Op op)
{
	if(op==	postDec()||op==postInc()||op==preInc())
	{
		return true;
	}
	else
	{
		return false;
	}
	
}	

public bool isNumComparator(Op op)
{
	if( op is gt||op is geq ||
		op is lt||op is leq  )
	{
		return true;
	}
	else
	{
		return false;
	}
		
}

public bool isBitwiseOp(Op op)
{
	if( op is bitwiseAnd||op is bitwiseOr
	  ||op is bitwiseNot||op is rightShift
	  ||op is leftShit)
	 {
	 	return true;
	 }
	 else
	 {
	 	return false;
	 }
}


