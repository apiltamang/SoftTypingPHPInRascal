module soft::typing::php::elements::IncludedScript

import soft::typing::php::elements::Identifier;
import soft::typing::php::Utils::AnalysisHelpers;
import soft::typing::php::Utils::Analysis;
import soft::typing::php::Utils::GenericHelpers;
import soft::typing::php::functions::UnionOperator;
import soft::typing::php::cfg2::Visualize;
import List;
import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;

import lang::php::analysis::cfg::Label;
//NOTE: I don't have a very good support for cross-referencing errors/warning
//		when execution flows through an included script. For instance, I don't 
//		carry over the data from hdToObjIdfs, labToObjIdfs which are essential 
//		for updating the aliases to objects in PHP.

//method runs analysis through an included script, and returns a typeenvironment,
//The method will also populate the global function declaration map, so that any
//function(s) defined in top level scope in this script is available for further use.
public tuple[TypeEnvironment envm,list[Warning] warns] runAnalysisThroughIncludedScript(loc rootP,str fileName,
		TypeEnvironment entryEnvm,list[Warning] warns, Lab l)
{
	
	//Step 0: spawn analysis for new script and add it to
	//		  current application map
	
	includeAppMap = initializeAnalysis(rootP,fileName);
	
	if(isEmpty([k|k<-includeAppMap])){
		
		warns+=includeFileNotFound("Include stmt at <l> for file: <fileName> returned error. Maybe file missing or has syntax-errors.");
		return <entryEnvm,warns>;
	}
	ApplicationMap+=includeAppMap;	
	
	includedScriptEnvm=ApplicationMap[fileName];
	
	
	//TODO: Somewhere in here, I have to pass in information about hdToObjIdfs and labToObjIdfs 
	//	    between this environment, and the environment from which this script was called.
	
	//Step 1: initialize entryEvnm of scriptEntryNode in target analysisEnvm
	
		//For that, first, get the script entry node
		entryNode=getElementFromSingletonList([nn|
			nn<-includedScriptEnvm.analysisNodes,nn is scriptEntryNode]);
		
		//second, get the next node connected by the entry node. It
		//will be assumed that the entry node is connected to only one
		//another node
			
			//For this, get edges coming from entry node
			edgeFromEntryNode=getElementFromSingletonList([ed|
				ed<-entryNode.edgesTo]);
			
			//then, get node attached to the end of this
			nextToEntryNode=getNodeToOfEdge(edgeFromEntryNode,
				includedScriptEnvm.analysisNodes);
			
			//and finally, get the label of the nextToEntryNode
			entryLabel=nextToEntryNode.l;
				
				
		// secondly, initialize the entryEnvironmentTable map of the nextToEntryNode by 
		// combining the following environments:
		// a. environment coming in from the including script: entryEnvm,
		// b. environment created during the initialization phase: entryEnvironmentTable[entryLabel]
		
		// NOTE: throw away the warnings while combining these environments. The warnings
		// woud alert about any identifiers that may have more than one type of values. If such
		// a case exists, it would be caught in 'propagate' method down below as well.
		list[Warning] throwAway=[];
		includedScriptEnvm.entryEnvironmentTable[entryLabel]=
			combine(entryEnvm,includedScriptEnvm.entryEnvironmentTable[entryLabel],
				entryLabel,throwAway,fileName).envm;	
				
	//Step 2: invoke propagation through the target analysisEnvm
	str mode="normal";
	<entryExtTable,exitExtTable,warnings>=propagate(rootP,includedScriptEnvm,mode);
		
	//Step 3: Grab exitTable from target analysisEnvm and combine 
	// 		  with the entryEnvm for this node. New variable could/should
	//		  appear in the resulting typeEnvironment now.
	
	//first need to get the the label corresponding to the exit node
	exitLabel=getElementFromSingletonList([nn.l|
		nn<-includedScriptEnvm.analysisNodes,
		nn is scriptExitNode]);
	
	//then set the exit environment from the last node in the
	//included script to the exit environment of the node that
	//called this script.	
	exitPrime=exitExtTable[exitLabel];
	
	//print to a dot figure file..
	writeTo=rootP+"<fileName>.included.post.dot";
	renderAnalysisEnvmAsDot(includedScriptEnvm.analysisNodes,
					includedScriptEnvm.edges,exitExtTable,writeTo,"<writeTo>");
	
	//update global ApplicationMap
	AppExitEnvms[fileName]=exitExtTable;
	
	//also add the warnings generated in this envm
	AppWarnings[fileName]=warnings;
	return <exitPrime,warns>;

}

