module soft::typing::php::Utils::AnalysisHelpers

import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::constraints::GetConstraints;
import soft::typing::php::elements::Identifier;
import soft::typing::php::Utils::GenericHelpers;
import soft::typing::php::functions::TransferType;
import soft::typing::php::functions::UnionOperator;
import soft::typing::php::cfg2::CollapseCFG;

import lang::php::analysis::NamePaths;
import lang::php::analysis::cfg::FlowEdge;
import lang::php::analysis::cfg::Label;
import lang::php::ast::AbstractSyntax;
import lang::php::analysis::cfg::CFG;
import lang::php::analysis::cfg::BuildCFG;
import lang::php::pp::PrettyPrinter;
import lang::php::analysis::cfg::BasicBlocks;

import IO;
import List;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;


//create a new type environment where all identifiers are mapped to empty typeroot
public TypeEnvironment newTypeEnvironment(idfs)
{

	TypeEnvironment envm=();
	for(Identifier idf <- idfs)
	{
		envm[idf]=nullTypeRoot();
	}
	
	return envm;
}
/*
//checks for equality of two environments.  Complication brought on about by the introduction
//of object handles that are assigned to object instances in the script.
public bool isEqual(TypeEnvironment envm1,TypeEnvironment envm2)
{
	if(!(assertEquals({k1|k1<-envm1},{k2|k2<-envm2},
		"Identifiers","isEqual(TypeEnvironment,TypeEnvironment)") ) )
		return false;
	//well, at least the set of keys are the same in the two maps.
	for(Identifier idf<-envm1)
	{
		;	
	}
}
*/
public CFGNode getNodeToOfEdge(FlowEdge edge, set[CFGNode] nodes)
{
	toLabel=edge.to;
	toNodeList=[nn|nn<-nodes,nn@lab==toLabel];
	if(size(toNodeList)>1)
		throw "Expected one node at end of edge. Got more than one end node.";
	else
		return toNodeList[0];


}

//get the AnalysisNode that an edge points to
public AnalysisNode getNodeToOfEdge(FlowEdge edge,set[AnalysisNode] nodes)
{
	toLabel=edge.to;
	toNodeList=[nn|nn<-nodes,nn.l==toLabel];
	if(size(toNodeList)>1)
		throw "Expected one node at end of edge. Got more than one end node.";
	else
		return toNodeList[0];
}

//remove expected constraints and return
public set[Constraint] getConstraintsWithoutExpectedTypes(set[Constraint] allConstraints)
{
	set[Constraint] ccs={ };
	for(Constraint cc <- allConstraints)
	{
		if(cc is yieldFlow || cc is yieldType || cc is setField)
			ccs += cc;
	}
	
	return ccs;
}

//generated constraints for the expressions/statements that appear in a cfg node
public set[Constraint] getConstraintsFromCFGNode(CFGNode aNode)
{
	set[Constraint] ccs={};
	
	//header and footer nodes are artificial nodes constructed to 
	//signal the beginning and end of block statements such as if/else/end if
	//or while/end-while
	if(aNode is headerNode || aNode is footerNode)
		return ccs;
	visit(aNode)
	{
		case Stmt stmt:
			ccs=extractConstraints(stmt);
		case Expr expr:
			ccs=extractConstraints(expr);
	}
	
	return ccs;
}

//prepare module for a new Analysis given a cfg
public AnalysisEnvm newAnalysisEnvm(str scriptName,CFG scriptCFG)
{
	//declare the members of newAnalysisEnvm
	map[Lab,bool]isVisited=( );
	map[Lab,TypeEnvironment]entryEnvironmentTable=( );
	map[Lab,TypeEnvironment]exitEnvironmentTable=( );
	map[Lab,LabelToIdentifierMap] labelToIdentifierTable=( );
	set[AnalysisNode] analysisNodes={ };	
	
	printIndLn("Preparing analysis environment...");
	set[Identifier] idfs=getIdentifiersInCFG(scriptCFG);
	
	//navigate the cfg and initialize the above variables
	aNode=getElementFromSingletonList([nn|nn<-scriptCFG.nodes,
		nn is scriptEntry 	|| 
		nn is functionEntry ||
		nn is methodEntry	]);
	
	list[FlowEdge] workStack=[];
	
	for(FlowEdge ed<-{ee|ee<-scriptCFG.edges,ee.from==aNode@lab })
		workStack=push(ed,workStack);
	
	bool stackEmpty=false;
	int maxIter=100;
	int iterCount=0;
	
	map[Lab,bool] isInitialized=( );
	for(CFGNode aNode<-scriptCFG.nodes)
		isInitialized[aNode@lab]=false;
	
	//just plain empty initialization. See module: "PublicDataType" to see what
	//each of these variables are for.
	//1. 
	map[Lab,set[Identifier] ] labToObjIdfs=();
	//2.
	HdToObjIdfs hdToObjIdfs=( );
	
	while(!stackEmpty && iterCount<maxIter)
	{

		
		//now iterate through the individual nodes in this analysis environment
		try
		{
			printIndLn("````````` Reading CFGNode : <aNode@lab>");
			iprintln(aNode);
			if(!isInitialized[aNode@lab])
			{
				//declare myLab
				Lab myLab=lab(-99);
				
				//need to create empty set of constraints for each node
				set[Constraint] ccs={};
				
				
				
				content=printCFGNode(aNode);
				if(aNode is scriptEntry || aNode is functionEntry || aNode is methodEntry)
				{
					myLab=aNode@lab;
					
					myEdges={ee|ee<-scriptCFG.edges,ee.from==myLab};
					analysisNodes+= scriptEntryNode(myLab,content,myEdges);
				} 
				elseif(aNode is scriptExit || aNode is functionExit ||aNode is methodExit)
				{
					myLab=aNode@lab;
					
					analysisNodes +=scriptExitNode(myLab,content);
				}
				//also appears only for functions. Additionally, only for
				//functions that return a specific value (if any..)
				elseif( stmtNode(\return(OptionExpr returnExpr),_):=aNode)
				{
					myLab=aNode@lab;
					analysisNodes +=returnNode
					(
						myLab,
						content,
						getConstraintsFromCFGNode(aNode),
						{ee|ee<-scriptCFG.edges,ee.from==myLab}
					);
				}
				//following node appears only for functions with
				//parameters
				elseif( actualProvided(str paramName,_):=aNode)
				
				{
					//get the label of the node
					myLab=aNode@lab;
					
					//get the edges of the node
					myEdges={ee|ee<-scriptCFG.edges,ee.from==myLab};
					
					//initialize an empty set for this node...
					//This is because I want this node to be treated
					//like any other node during the 'propagate' process.
					//However, there isn't any befitting constraint to
					//have for this node
					set[Constraint] emptySet={};
					
					//finally initialize the node
					analysisNodes +=paramDefinition(paramName,
										myLab,content,emptySet,myEdges);
				}
				elseif( stmtNode(classDef(class(_,_,_,_,_)),_):=aNode) 
				{
					printIndLn("Class found");
					printIndLn("Class Definition: <aClass>");
				}
				elseif( exprNode(include(scalar(string(str fileName)),_),_):=aNode)
				{
					myLab=aNode@lab;
					analysisNodes +=includeNode
					(
						myLab,content,
						getConstraintsFromCFGNode(aNode),
						{ee|ee<-scriptCFG.edges,ee.from==myLab},
						fileName
					);
				}
				elseif( inlineHTML(_):=aNode)
				{
					myLab=aNode@lab;
					analysisNodes +=inlineHTMLNode(
						myLab,
						"HTMLCode",
						getConstraintsFromCFGNode(aNode),
						{ee|ee<-scriptCFG.edges,ee.from==myLab}
					);
				}
				else
				{
					//get the label for that node
					myLab=aNode@lab;
					
					//get the constraints generated by that node
					ccs=getConstraintsFromCFGNode(aNode);
					
					//now get the edges emanating from this node
					myEdges={ee|ee<-scriptCFG.edges,ee.from==myLab};
					
					//initialize analysis node from the given information,
					//and add it to the set of analysis nodes
					analysisNodes += analysisNode(myLab,content,ccs,myEdges);
					
				}//end if(aNode)/elseifs/else
				
				
				//get map[Lab,Identifier] only for this node...
				//searches explicitly for identifiers in the left hand side of an expression.
				//This is because that particular identifier is the only one (hopefully) which
				//will undergo the side-effect caused by the expression in the right.
				labelToIdentifierTable[myLab] =initializeLabelToIdentifierMap(aNode);
				
				//initialize the type environments for the nodes
				entryEnvironmentTable[myLab]=newTypeEnvironment(idfs);
				exitEnvironmentTable[myLab] =newTypeEnvironment(idfs);
				
				//initialize the map to record visits to the analysis node. 
				//This will be used in the seed function
				isVisited[myLab]=false;
				
				//This data structure is used to keep track of all the object vars defined
				//for this node..
				set[Identifier] idfs={};
				labToObjIdfs[myLab]=idfs;
				
				//counter to ensure that I don't iterate indefinitely due to an error
				iterCount=iterCount+1;
				
				//set initialized to true, so that I don't re-initialize the same node.
				isInitialized[aNode@lab]=true;
				for(FlowEdge ed<-{ee|ee<-scriptCFG.edges,ee.from==aNode@lab })
					workStack=push(ed,workStack);
				
				printIndLn("````````` Initialization Done.");
				printIndLn("````````` Constraints: <ccs>. ");
				
			}//end if(!isInitialized[aNode])
			else
			{
				printIndLn("````````` Already Initialized.");
			}
			
			//pop edge from stack and update the stack
			<currEdge,workStack>=pop(workStack);
			
			//get the next node
			aNode=getNodeToOfEdge(currEdge,scriptCFG.nodes);
				
			
		}//end try
		catch EmptyList():
		{
			stackEmpty=true;
			printIndLn("Done creating new analysis environment.");
		}
	}//end while  (! stackEmpty || iterCount < maxIter)
	
	return analysisEnvm(scriptName,analysisNodes,labelToIdentifierTable,
		entryEnvironmentTable,exitEnvironmentTable,isVisited,scriptCFG.edges,
			hdToObjIdfs,labToObjIdfs);
}
