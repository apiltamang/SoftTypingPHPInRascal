module soft::typing::php::Utils::Analysis

import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::constraints::GetConstraints;
import soft::typing::php::elements::Identifier;
import soft::typing::php::Utils::GenericHelpers;
import soft::typing::php::functions::TransferType;
import soft::typing::php::functions::UnionOperator;
import soft::typing::php::cfg2::CollapseCFG;
import soft::typing::php::elements::IncludedScript;
import soft::typing::php::Utils::AnalysisHelpers;
import soft::typing::php::cfg2::Visualize;

import lang::php::ast::AbstractSyntax;
import lang::php::analysis::cfg::CFG;
import lang::php::analysis::cfg::BuildCFG;
import lang::php::analysis::NamePaths;
import lang::php::analysis::cfg::Label;
import lang::php::analysis::cfg::FlowEdge;

import IO;
import List;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;



//main module function 
public map[Lab,TypeEnvironment]  runAnalysis(loc rootP,str fileTest)
{
	//clear global variables, prep for analysis
	newAnalysis();
	
	//get the ApplicationMap
	ApplicationMap=initializeAnalysis(rootP,fileTest);
	
	//get main analysis envm (i.e. the one for the file for which analysis is called for)
	mainEnvm=ApplicationMap[fileTest];
	
	//propagate type information
	str mode="normal";
	<entryEnvm,exitEnvm,warnings>=propagate(rootP,mainEnvm,mode);
	
	//write to dot file
	writeTo=rootP+"<fileTest>.main.post.dot";
	renderAnalysisEnvmAsDot(mainEnvm.analysisNodes,
			mainEnvm.edges,exitEnvm,writeTo,"<writeTo>");
	
	/*
	//update the main environment
	mainEnvm.exitEnvironmentTable=exitEnvm;
	
	//Now update the ApplicationMap 
	ApplicationMap[fileTest]=mainEnvm;
	*/
	AppExitEnvms[fileTest]=exitEnvm;	
	AppWarnings[fileTest]=warnings;
	return exitEnvm;	
}

public void newAnalysis()
{
	resetIterationIndex();
	//store information about classes in the php system
	GlobalClassDeclsMap=();
	//Store information about function param and return types
	GlobalFuncDeclsMap=();
	//store information about main script, plus all method and function envms
	ApplicationMap=();
	//store information from each analysis envm when it's been propagated for the last time
	AppExitEnvms=();
	//store the warnings generated for current application
	AppWarnings=();
	
	//just a unique id to give to all class templates
	ClassTemplateId=0;
	//just a unique id to give to all class instances
	ClassInstanceId=0;
	
	//maps handle to class instances. This is also the global object store
	//where the original class-instances are stored for any future use.
	HandleToClassInstanceMap=();	
	//used to store information on the context of a method call.
	GlobalObjectContextStack=[];
	//clear this map as well
	MultipleTypedVarMap=();
	//clear the global function call stack;
	GlobalFuncCallStack=[];
	
}
public map[str,AnalysisEnvm] initializeAnalysis(loc rootP,str fileTest)
{	
	//get collapsed CFG + draw dot figure for the cfg
	myMap=getNewCollapsedCFG(rootP,fileTest);
	
	map[str, AnalysisEnvm] toReturn=();
	if(isEmpty([k|k<-myMap]))
		return toReturn;
	
	
	//for each cfg, get the set of analysis nodes
	for(str k<- myMap)
	{
		if( fileTest:=k)
		{
			printIndLn("Preparing analysis environment for main script: <fileTest>...");
			toReturn[fileTest]=newAnalysisEnvm(fileTest,myMap[k]);
			printIndLn("Done preparing environment for main script");
		}
		else
		{
			printIndLn("Preparing analysis environment for function:<k> in script: <fileTest>...");
			toReturn[k]=newAnalysisEnvm(fileTest,myMap[k]);
			
			//initialize the global function declaration map.
			//This is where information about the functions is
			//stored...
			
			map[list[Type],TypeRoot] templates=();
			GlobalFuncDeclsMap[k]=func(templates);
			
			//acknowledge that this initialization is done
			printIndLn("Done preparing environment for function.");
		}

		set[Identifier] temp={};
		MultipleTypedVarMap[fileTest]=temp;
	}
	
	return toReturn;
}


//seed the identifiers with a typeroot using the worklist algorithm...
public tuple[map[Lab,TypeEnvironment] entryEnvmTable,map[Lab,TypeEnvironment] exitEnvmTable,
	list[Warning] warnings ]propagate(loc rootP,AnalysisEnvm currAnalysis,str mode)
{
	list[FlowEdge] workStack=[ ];
	list[Warning] warnings=[];
	set[FlowEdge] edgesForPrintingToDotFig={ };
	
	
	//Step -1: set the isVisited value for each label to be false, so 
	//that proper iteration can take place
	for(Lab l<-currAnalysis.isVisited)
		currAnalysis.isVisited[l]=false;
	
	
	//Step 0: Grab the scriptEntryNode
	entryNode=getElementFromSingletonList([nn|nn<-currAnalysis.analysisNodes,
		nn is scriptEntryNode]);
	
	//Step 1: Add the edges that come from the entry node
	printIndLn(" ");
	printIndLn("Beginning type propagation on script: <currAnalysis.scriptName>");
	for(FlowEdge ed<- entryNode.edgesTo)
	{
		workStack=push(ed,workStack);
		printIndLn("Pushing edge from script entry node: <ed>");
		
	}	
	
	bool stackEmpty=false;
	int maxIter=100;
	int iterCount=0;
	
	//Step 3: Work until no more edge is present in the work-stack
	while(!stackEmpty && iterCount<maxIter)
	{
		if (isEmpty(workStack)) 
		{
			printIndLn("workStack is empty. Exiting analysis.");
			stackEmpty = true;
			break;
		}
		
		//Step 2: Pop an edge for the workStack
		printIndLn("Current Stack: <workStack> ");
				
		<currEdge,workStack>=pop(workStack);
	
		printIndLn("Popping edge from stack: <currEdge> ");
		
		//get the node pointed to by the edge
		currNode=getNodeToOfEdge(currEdge,currAnalysis.analysisNodes);

		//print for debugging
		printIndLn("---------------------------------------------------------");
		printIndLn(" ");
		printIndLn("Node  under analysis : <currNode.l> [<currNode.content>]");
		
		//get the entry and exit environments				
		entryEnvm=currAnalysis.entryEnvironmentTable[currNode.l];
		exitEnvm=currAnalysis.exitEnvironmentTable[currNode.l];
		
		printIndLn("Effective Entry  envm: <entryEnvm>");
		printIndLn("Initial   Exit   envm: <exitEnvm>");
		
		printIndLn(" ");
		//if currNode is scriptExitNode, then move on to next edge on
		//the work stack
		if(currNode is scriptExitNode)
		{
			printIndLn("Encountered a script exit node.");
			
			printIndLn("Proceeding to analyze next edge on worklist...");
			currAnalysis.exitEnvironmentTable[currNode.l]=
				currAnalysis.entryEnvironmentTable[currNode.l];
			continue;
		}	

		
		//get the set of constraints minus the expected constraints
		/* I will disable this, because I use the expectType constraints
		   system to check for illegal type coercions in the node.
		 
		constraints=
			getConstraintsWithoutExpectedTypes(currNode.constraints);	
		*/
		constraints=
			currNode.constraints;
			
		//print for debugging
		printIndLn(" ");
		printIndLn("constraints effective: <constraints>");
		printIndLn("constraints effective: <prettyPrint(constraints)>");
		printIndLn("labelToIdentifierMap : <currAnalysis.labelToIdentifierTable[currNode.l]>");
		//VERY IMPORTANT METHOD=============================================================
		//transfer types through the node
		<newSet,currAnalysis.hdToObjIdfs,currAnalysis.labToObjIdfs,nodeWarnings>
			=transferTypes(rootP,currNode.l,currAnalysis.labelToIdentifierTable[currNode.l],entryEnvm,constraints,
				currAnalysis.hdToObjIdfs,currAnalysis.labToObjIdfs,mode);
		
		printIndLn(" ++++++++++++++ Generated warnings: ++++++++++++++");
		iprintIndLn(nodeWarnings);
		printIndLn(" ++++++++++++++  END OF WARNINGS.   ++++++++++++++");

		//Add warnings from previous node:
		warnings+=nodeWarnings;
		printIndLn(" ");
		printIndLn("Transferred types    : <newSet> ");

		//evaluate exitPrime 
		<exitPrime,warnings>=
			combine(exitEnvm,newSet,currNode.l,warnings,currAnalysis.scriptName);
		
		//Here maybe a good point to calculate all coercion type-errors.
		
		//if node is an include node, then process that script before
		//resuming operation in the current script
		if(currNode is includeNode)
		{
			printIndLn("Encountered an include node: <currNode.scriptName>");
			printIndLn("Switching analysis to referenced script.");
			<exitPrime,warnings>=runAnalysisThroughIncludedScript(
				rootP,currNode.scriptName,entryEnvm,warnings,currNode.l);
			printIndLn("Analysis on included script completed.");
			printIndLn("Resuming analysis on including script.");
			
		}
		
			
		//print 
		printIndLn(" ");
		printIndLn("Resulting exit envm  : <exitPrime> ");
		
		
		/*
		 * if the currend node has not been visited yet, OR 
		 * exitPrime is not equal to exit, then carry forward
		 * with the analysis.
		 *
		 * exit=TypeEnvironment on node before the analysis
		 * exitPrime=TypeEnvironment on node after the analysis
		*/
		
		if(! currAnalysis.isVisited[currNode.l] || !(exitPrime==exitEnvm) )
		{
			//set currNode's exit to be exitPrime
			currAnalysis.exitEnvironmentTable[currNode.l]=exitPrime;
			
			//set the visited flag to true;
			currAnalysis.isVisited[currNode.l]=true;
			
			//reach for all edges originating from this node
			for(FlowEdge ed<- currNode.edgesTo)
			{
				//push the edge to the workstack
				workStack=push(ed,workStack);
				printIndLn(" ");
				printIndLn("Pushing edge on stack: <ed>");
				
				//get the node at the end of this edge
				nextNode=getNodeToOfEdge(ed,currAnalysis.analysisNodes);
				
				//get nextNode's entry environment. Call it entryPrime
				entryPrime=	
					currAnalysis.entryEnvironmentTable[nextNode.l];
				
				//update its entry environment by combining with
				//the environment flowing in
				//Ignore warnings produced while merging the entry envm with exit envm from previous node
				<currAnalysis.entryEnvironmentTable[nextNode.l],warnings>=
					combine(entryPrime,exitPrime,currNode.l,warnings,currAnalysis.scriptName);
					
				//also add all the object vars collected in this node
				//to the next node's InitializedObjectVarSet.
				//InitializedObjectVarSet started as empty set for all
				//the node labels. It will collect new object vars if
				//it sees a new object initialization.
				currAnalysis.labToObjIdfs[nextNode.l]=
					currAnalysis.labToObjIdfs[nextNode.l]+
					currAnalysis.labToObjIdfs[currNode.l];
					 
					
			}//end for(FlowEdge ed<- currNode.edgesTo)
		
		}//end if (! isVisited[currNode] || !(exitPrime==exit) )	
		
	}//end while(!stackEmpty !! iterCount < maxIter)
	
	//return th entry and exit environment tables
	return <currAnalysis.entryEnvironmentTable,currAnalysis.exitEnvironmentTable,warnings>;
	
}//end method

