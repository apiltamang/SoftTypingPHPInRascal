module soft::typing::php::cfg2::Visualize

import lang::php::ast::AbstractSyntax;
import lang::php::analysis::cfg::FlowEdge;
import lang::php::pp::PrettyPrinter;
import lang::php::analysis::cfg::Label;
import soft::typing::php::elements::Identifier;
import soft::typing::php::constraints::ConstraintHelper;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;

import IO;
import List;
import String;
import vis::Figure;
import vis::Render; 

import soft::typing::php::Utils::AnalysisHelpers;

public str escapeForDot(str s) {
	return escape(s, ("\n" : "\\n", "\"" : "\\\""));
}

public str printEnvmForDot(TypeEnvironment envm)
{
	str retStr="";
	for (Identifier idf<- envm)
	{
		retStr += "<idf>: <envm[idf]> \n";
	}
	return retStr;
}
public void renderAnalysisEnvmAsDot(set[AnalysisNode] nodes, set[FlowEdge] edges, 
	map[Lab,TypeEnvironment] exitEnvmTable,loc writeTo, str title)
{
	str getID(AnalysisNode n) = "<n.l>";
	
	str getEN(AnalysisNode n) = "<n.l>+EnvmNode";
	
	print_nodes =[ "\"<getID(n)>\" [ label = \"<getID(n)>:<escapeForDot(n.content)>\", 
		labeljust=\"l\" , tooltip=\" I am a tooltip! \" ];" | n <- nodes ];
	print_edges = [ "\"<e.from>\" -\> \"<e.to>\" [ label = \"<printFlowEdgeLabel(e)>\"];" | e <- edges ];
	
	envm_nodes = [ "\"<getEN(n)>\" [ label = 
		\"< escapeForDot(printEnvmForDot(exitEnvmTable[n.l])) >\", shape=\"ellipse\"];" | n<- nodes];
	envm_edges = [ "\"<getID(n)>\" -\> \"<getEN(n)>\" [ label = \" \" ]; " | n<- nodes];
	
	str dotGraph = "digraph \"CFG\" {
				   '	graph [ label = \"Control Flow Graph<size(title)>0?" for <title>":"">\" ];
				   '	node [ shape = box ];
				   '	<intercalate("\n", print_nodes)>
				   '	<intercalate("\n", envm_nodes )>
				   '	<intercalate("\n", print_edges)>
				   '	<intercalate("\n", envm_edges )>
				   '}";
	writeFile(writeTo,dotGraph);
	

}