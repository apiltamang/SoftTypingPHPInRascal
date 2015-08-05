module soft::typing::php::constraints::GetConstraints

import lang::php::ast::AbstractSyntax;
import lang::php::analysis::cfg::Label;
import soft::typing::php::constraints::OperationHelper;
import soft::typing::php::constraints::ConstraintHelper;
import lang::php::analysis::cfg::BuildCFG;

import Node;
import Set;
import IO;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;



/*private loc rootP=|file:///home/apil/Scripts|;*/
public set[Constraint] extractConstraints(Script labeledScript)
{
	set[Constraint] constraints={};

	if(script(list[Stmt] stmts):= labeledScript)
	{
		for(Stmt st <- stmts)
		{
			printIndLn("Stmt: ====\> <st>");
			ccs =extractConstraints(st);
			printIndLn("CCs :=====\> <ccs>");
			constraints +=ccs;
		}
		
	}
	return constraints;
}

public set[Constraint] searchForVarsInExpr(Expr expr)
{
	set[Constraint] constraints={};
	top-down visit(expr)
	{
		case Expr ee:var(name(name(str aName))):
		{
			constraints += yieldType(ee@lab,fromVar(var(aName)));
		}
		case Expr ee:propertyFetch(Expr target,name(name(str fieldName))):
		{
			constraints += yieldType(ee@lab,fromObjectProperty(fromLabel(target@lab),var(fieldName)));
		}
		
		case Expr ee:staticPropertyFetch(name(name(str cName)),name(name(str fieldName))):
		{
			constraints += yieldType(ee@lab,fromStaticProperty(cName,var(fieldName)));
		}
	}
	
	return constraints;
}//----------------------------------

public set[Constraint] searchForVarsInParamsList(list[ActualParameter] params)
{
	//params is the list of actual parameters being passed during a method call, or a class constructor
	set[Constraint] constraints={};
	
	//within each parameter
	for(ActualParameter aP<-params)
	{	
		//search for expression, and
		if(actualParameter(Expr v,_):=aP)
			//search for identifiers within the expression!
			constraints+=searchForVarsInExpr(v);
	}
	
	return constraints;
}//----------------------------------

public set[Constraint] extractConstraints(Stmt aStmt)
{
	set[Constraint] constraints={};
	
	//do a top-down visit of the nodes
	top-down visit(aStmt)
	{
		
		case Expr expr:
		{
			constraints+=extractConstraints(expr);
		}
		
		//---> Start of constraints from fig 7.7 (Constraints for basic statements)
		//handle case when Stmt is echo
		case Stmt st:echo(list[Expr] exprs):
		{
			//enforce that all expressions are expected to be a string
			constraints+={expectType(ee@lab,typeSet({String()})) 
								| Expr ee <- exprs}; //use of 'Comprehension'
			
			for(Expr ee<-exprs)
				constraints+=searchForVarsInExpr(ee);
			
		}
		
		//handle case when stmt is an if-statement
		case Stmt ss:\if(Expr cond,_,list[ElseIf]elseIfs,_):
		{
			constraints+=expectType(cond@lab,typeSet({Bool()}));
			
			constraints+=searchForVarsInExpr(cond);
			
			for(ElseIf eif <-elseIfs)
			{	
				if(elseIf(Expr ee,_) := eif)
				{
					constraints+=expectType(ee@lab,typeSet({Bool()}));
					constraints+=searchForVarsInExpr(ee);	
				}
			}	
		
		}//end case Stmt ss:\if
		
		//handle case for switch case statements
		case Stmt ss:\switch(Expr eeTop,list[Case]cases):
		{
			constraints +=searchForVarsInExpr(eeTop);
			
			for(Case cc <- cases)
			{
				
				if(\case(someExpr(Expr eeDown),_) := cc )
				{
					constraints +=yieldFlow(eeTop@lab,eeDown@lab);
					constraints +=searchForVarsInExpr(eeDown);	
				}
		
			}
		}//end case Stmt ss:\switch
		
		//handle case for while statements
		case Stmt ss:\while(Expr cond,_):
		{
			constraints +=expectType(cond@lab,typeSet({Bool()}));
			constraints +=searchForVarsInExpr(cond);
		}
		
		//handle case for do-while statement
		case Stmt ss:do(Expr cond,_):
		{
			constraints +=expectType(cond@lab,typeSet({Bool()}));
			constraints +=searchForVarsInExpr(cond);
		} 	
		
		//handle case for for loops
		case Stmt ss:\for(_,list[Expr] conds,_,_):
		{
			for(Expr ee<-conds)
			{
				constraints +=expectType(ee@lab,typeSet({Bool()}));
				constraints +=searchForVarsInExpr(ee);
			}
		}
		
		//handle case for return statements from within functions
		case Stmt ss:\return(OptionExpr opExpr):
		{
			if(someExpr(Expr expr):=opExpr)
			{
				constraints+=yieldFlow(ss@lab,expr@lab);
				/*constraints+=extractConstraints(expr);*/
				constraints+=searchForVarsInExpr(expr);
			}
			else //no expr!
			{
				constraints+=yieldType(ss@lab,typeSet({Void()}));
			}
		}
		
	}
	
	return constraints;
}	

public set[Constraint] extractConstraints(Expr anExpr)
{
	set[Constraint] constraints={};
	
	bool isAnAssignedExpr=false;
	
	top-down visit(anExpr)
	{
		//fig. 7.4 from the thesis
		case Expr sc:scalar(Scalar aType) :
		{
			constraints = constraints+ {yieldType(sc@lab,typeSet({getScalarType(aType)}))};
		}
		case Expr fc:fetchConst(name(str aName)):
		{	
			if (aName=="true" || aName=="false")
				constraints += {yieldType(fc@lab,typeSet({Bool()}))};
			else
				constraints += {yieldType(fc@lab,typeSet({String()}))};
		}

		//-------> start of constraints from fig. 7.5
		case Expr expr:assign(Expr left, Expr right) :
		{  	
			//handle case for when an array variable is on left,
			//then we have to enforce the constraint that the
			//variable is an array 
			if(fetchArrayDim(v1:var(_),_) := left)
			{
				constraints += {yieldType(v1@lab,toArray(right@lab))};
			}
			
			
			//the implicit assumption is that the expression on the left (of assignment)
			// is a variable
			else
			{
				constraints += searchForVarsInExpr(right);
				isAnAssignedExpr=true;	
				constraints += {yieldFlow(left@lab,right@lab)};
				constraints += {yieldFlow(expr@lab,right@lab)};
			}
			
			 
		}

		//for unary operations specifically involving Integer-operations
		case Expr uOp:unaryOperation(Expr v, Op opern):
		{
			//a unary operation could act on a float as follows: - (expr)
			//or + (expr)
			if(isUnaryNumOp(opern))
			{
				constraints += expectType(v@lab,typeSet({Num()}));
				constraints += yieldType(uOp@lab,typeSet({Int()}));
			
			}
			else if(isIntOp(opern))
			{
				constraints += expectType(v@lab,typeSet({Int()}));
				constraints += yieldType(uOp@lab,typeSet({Int()}));
			}
			else if(isBoolOp(opern))
			{
				constraints += expectType(v@lab,typeSet({Bool()}));
				constraints += yieldType (uOp@lab,typeSet({Bool()}));
			}
			
			//bitwise operator
			else if(isBitwiseOp(opern))
			{
				//TODO: bitwise operation supported for both integers and strings
				//		Not sure how to handle this.
				//For now, only expecting the operand to be an integer
				
				//expect the operand to be an integer
				constraints+=expectType(v@lab,typeSet({Int()}));
				//expect the expression to yield an integer
				constraints+=yieldType (uOp@lab,typeSet({Int()}));
			}
			
			constraints+=searchForVarsInExpr(v);
								
		}
		case Expr cc:cast(tt:CastType,v:Expr):
		{
			constraints+=yieldType(cc@lab,typeSet({tt.getName}));
		}
		// <-----end of constraints from fig. 7.5
		
		//------->start of constraints from fig. 7.6
		case Expr cc:binaryOperation(Expr e1,Expr e2, Op opern):
		{
			
			if(isNumOp(opern))
			{	
				//expect the operands to be a number
				constraints +=expectType(e1@lab,typeSet({Num()}));
				constraints +=expectType(e2@lab,typeSet({Num()}));
			
				//expect opern to yield a number
				constraints +=yieldType(cc@lab,typeSet({Num()}));
			}
			else if(opern is concat)
			{
				
				constraints +=expectType(e1@lab,typeSet({String()}));
				constraints +=expectType(e2@lab,typeSet({String()}));
			
				constraints +=yieldType(cc@lab,typeSet({String()}));
			}
			else if(isBoolOp(opern))
			{
				
				constraints +=expectType(e1@lab,typeSet({Bool()}));
				constraints +=expectType(e2@lab,typeSet({Bool()}));
			
				constraints +=yieldType(cc@lab,typeSet({Bool()}));
			} 	
			//if opern is PHP's 'equal' or 'notEqual' operator			
			else if(opern is equal||opern is notEqual)
			{
				//enforce a flow of expect-Constraint from L2 -> L1
				constraints +=expectFlow(e1@lab,e2@lab);
				
				//enforce that the expression yields a boolean value.
				constraints +=yieldType(cc@lab,typeSet({Bool()}));
				
			}
			//if opern is a numerical comparator operator
			else if(isNumComparator(opern))
			{
				//enforce that both the operands are expected to be numbers
				constraints +=expectType(e1@lab,typeSet({Num()}));
				constraints +=expectType(e2@lab,typeSet({Num()}));
				
				//enforce that this expression yields a boolean
				constraints +=yieldType(cc@lab,typeSet({Bool()}));
				
			}
			else if(isBitwiseOp(opern))
			{
				//TODO:
				//enforce that the the constraints have to be either numbers or strings
				
				//for now, enforce that the operands are integers!!
				constraints +=expectType(e1@lab,typeSet({Int()}));
				constraints +=expectType(e2@lab,typeSet({Int()}));
				
				//enforce that result yields an integer
				constraints +=expectType(cc@lab,typeSet({Int()}));
			}
			
			constraints +=searchForVarsInExpr(cc);
			
		}//end case for binary opreation involving numbers
		
		//handle the case for the ternary operator
		case Expr ee:ternary(Expr cond, someExpr(Expr ifBranch), Expr elseBranch):
		{

			//TODO: figure out the constraint for the ternary operator
			//This is quite tricky. Need to establish the constraint that:
			//constraints+=[yieldType (ee@lab,typeSet(["<typeOf(ifBranch)>","<typeOf(elseBranch)>"))];
			//but not quite sure yet how to do this...

			//enforce that conditional part expects boolean
			constraints+=expectType(cond@lab,typeSet({Bool()}));
			
			//enforce that resulting expression yields typeSet from the ifBranch and the elseBranch
			constraints+=yieldType(ee@lab,
				fromLabels({ifBranch@lab,elseBranch@lab}));			
		}
		case Expr ee:ternary(Expr cond,noExpr(),Expr elseBranch):
		{
			//This is the case when there isn't an if branch
			//TODO: What kind of constraints can I impose on the cond
			//		branch now? It doesn't necessarily have to be a
			//		boolean expression!
			
			constraints+=yieldType(ee@lab,
				fromLabels({cond@lab,elseBranch@lab}));
												  

		}
		//<--- End of constraints from fig 7.6
		

		//handle case when Stmt is self-assignment
		case Expr ee:assignWOp(v1:var(_),Expr e2,Op opern):
		{
			if(isNumOp(opern))
			{
				//enforce the variable to yield a number
				constraints+=yieldType(v1@lab,typeSet({Num()}));
				//enforce the right expression to expect a number
				constraints+=expectType(e2@lab,typeSet({Num()}));
				
				
			}
			else if(opern is concat)
			{
				//enforce var to yield a string
				constraints+=yieldType(v1@lab,typeSet({String()}));
				//enforce the right expression to yield a string
				constraints+=expectType(e2@lab,typeSet({String()}));
				
			}
			else if(isBitwiseOp(opern))
			{
				//enforce the constraints that all operands including results are integers
				constraints +=yieldType(v1@lab,typeSet({Int()}));
				constraints +=expectType(e2@lab,typeSet({Int()}));
				
			}
		}//end case Expr ee:assignWOp
		
		//handle case for array references i.e. $a[5] OR $a['name']
		case Expr ee:fetchArrayDim(v1:var(_),someExpr(Expr v2)):
		{
			//assert that the var has to be an array of type any
			constraints +=expectType(v1@lab,typeSet({Array(Any())}));
			
			
			//assert that the value within the array reference has to be int OR string
			constraints +=expectType(v2@lab,typeSet({Int(),String()}));
			
			//assert that the resulting expression yields the base type of the array
			constraints +=yieldType(ee@lab,fromArray(v1@lab));
			
		}
		
		//case when expression is an array declaration, i.e. array("1",2,true)
		case Expr ee:array(list[ArrayElement] items):
		{
			//Declare an empty list of types
			set[Lab]llabels={};
				
			//from each ArrayElement, grab the constraint that you get an array of the type of
			//the arrayElement	
			llabels +={v@lab |   
						ArrayElement elem<-items, 
							arrayElement(_,Expr v,_):= elem};
							 
			//assert that the resulting expression is an array of type of each of the 
			//arrayElement present within it.
			if(isEmpty(llabels))
				constraints +=expectType(ee@lab,typeSet({Array(Any())}));
			else	
				constraints +=yieldType(ee@lab,toArraySet(llabels));
		}
		//case when the expression is count($someVar))
		case Expr ee:call(name(name("count")),list[ActualParameter] params):
		{
			
			//assert that expr: count($a) returns an integer
			constraints +=yieldType(ee@lab,typeSet({Int()}));
			
			//assert that the parameter is an array
			constraints +={expectType(v@lab,typeSet({Array(Any())})) |
									  ActualParameter aPs <-params,
									  		actualParameter(Expr v,_):= aPs };
		}
		
		//a function call site
		case Expr ee:call(name(name(str fname)),list[ActualParameter] fparams):
		{
			list[Lab] temp=[];
			temp=[v@lab| ActualParameter aP <- fparams,actualParameter(Expr v,_):=aP];
			constraints +=yieldType(ee@lab,funcCall(fname,temp));
			constraints +=searchForVarsInParamsList(fparams);
			
		}
		//a method call site
		case Expr ee:methodCall(Expr ef,name(name(str fName)),list[ActualParameter] fparams):
		{
			list[Lab] temp=[];
			constraints  +=searchForVarsInExpr(ef);
			
			temp=[v@lab| ActualParameter aP <- fparams,actualParameter(Expr v,_):=aP];
			constraints +=yieldType(ee@lab,fromMethodCall(fromLabel(ef@lab),fName,temp));
			
			constraints += searchForVarsInParamsList(fparams);
			
		}
		//a static method call site
		case Expr ee:staticCall(name(name(str cName)),name(name(str fName)),list[ActualParameter] fparams):
		{
			list[Lab] temp=[];
			temp=[v@lab| ActualParameter aP <- fparams,actualParameter(Expr v,_):=aP];
			constraints +=yieldType(ee@lab,fromStaticCall(cName,fName,temp));
			constraints +=searchForVarsInParamsList(fparams);
			
		}
		//instantiation of a new class object
		case Expr ee:new(name(name(cName)),list[ActualParameter] params):
		{
			
			//get the label of the parameters
			paramsLab=[v@lab|ActualParameter p<-params, actualParameter(Expr v,_):=p];
			
			//establish constraint: 
			//yieldType(ee@lab,typeSingleton(ObjectHandle(createdHandle)));
			
			constraints+=
				yieldType(ee@lab,newObjectInstance(cName,paramsLab));
				
			constraints += searchForVarsInParamsList(params);
		}
		
		
		case Expr ee:propertyFetch(_,_):
		{
			if(!isAnAssignedExpr)
			{
				//this ensures that while analyzing an assign expression 
				//containing propertyFetch sub-expressions, the constraints
				//from the statement in this block doesn't affect what has
				//already been generated
				constraints +=searchForVarsInExpr(ee);
			}
			
		}
		
	}//end top-down visit(Expr)
	
	return constraints;
}
