module soft::typing::php::elements::Identifier

import soft::typing::php::constraints::ConstraintHelper;
import lang::php::analysis::cfg::Label;
import IO;
import List;
import Set;
import lang::php::analysis::cfg::BuildCFG;
import lang::php::analysis::cfg::CFG;
import lang::php::ast::AbstractSyntax;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;
import soft::typing::php::Utils::GenericHelpers;


public LabelToIdentifierMap initializeLabelToIdentifierMap(Script scr)
{

	labelToIdentifierMap=(v@lab:var(x)| /v:var(name(name(str x))):=scr);
	
	return labelToIdentifierMap;
	

}


public LabelToIdentifierMap initializeLabelToIdentifierMap(CFGNode cfgNode)

{
	//This method searches for variables only in the left hand side of the 
	//assign expression. See associated tests...
	LabelToIdentifierMap mapp=( );

	if(cfgNode is headerNode ||
	   cfgNode is footerNode)
	   return mapp;
	
	//look at Expr e appearing ONLY in the left hand side of an
	//assignment or assignmentWOp expression   
	result={e | /assign(e,_):=cfgNode}
		+{e | /assignWOp(e,_,_):=cfgNode};
	
	if(isEmpty(result))
		return mapp;

	//This assertion is here, because I'm only looking for identifiers on the left
	//hand of an assignment statement. E.g. $a = <someExpr> 
	//OR $a [+|-|*|/]= <someExpr> OR $a->var=<someExpr>.

	if(! (size(result)==1) )
	{	
		iprintln(cfgNode);
		iprintln(result);
		throw"Error loc: 081841-35. Expected singleton list. Got: <result>";	
	}	
	
	Expr temp=getOneFrom(result);
	
	//for statements with left hand side (lhs): $someVar[<some_index>] = <some_value>
	if(/Expr e:fetchArrayDim(v:var(name(name(str x))),_):=temp)
		mapp +=(v@lab:arraySet(var(x)));
	
	//for statements with lhs: $someVar = <some_value>
	else if(/Expr e:var(name(name(str x))):=temp)
		mapp +=(e@lab:var(x));

	//for statements with lhs: $someObj->some_field=<some_value>;
	for(/Expr e:propertyFetch(Expr f, name(name(str y))):= temp)
		mapp +=(e@lab:propertySet(f@lab,var(y)));

	//for statements with lhs: someClass::$some_field= <some_value>;
	for(/Expr e:staticPropertyFetch(name(name(str className)), name(name(str y))):=temp)
		mapp +=(e@lab:statFieldSet(className,var(y)));
	
	printIndLn("************ Printing Identifier To Label Map *****************");
	iprintln(mapp);
	printIndLn("************   END Identifier To Label Map *****************");
	
	return mapp;
}

	
public set[Identifier] getIdentifiersInCFG(CFG scriptCFG)
{
	set[Identifier] idfs={ };
	idfs+={ var(x)| /v:var(name(name(str x))) := scriptCFG };
	idfs+={ var(x)| /v:actualProvided(str x,_):= scriptCFG };
	return idfs;
}

public tuple[HdToObjIdfs hdToObjIdfs,LabToObjIdfs labToObjIdfs]
	registerIdentifierToObjectHandleAndNode
		(Handle h, Identifier idf,Lab nodeLabel,HdToObjIdfs hdToObjIdfs,LabToObjIdfs labToObjIdfs)
		
{

	//Register this object var to the handle passed as an argument. This
	//links the identifier to the object instance, so that later in the future, it can
	//receive updates about changed object events.
	try
	{
		set[Identifier]idfs=hdToObjIdfs[h];
		hdToObjIdfs[h]= idfs+{idf};
	}
	catch NoSuchKey(_):
	{
		hdToObjIdfs[h]= {idf};
	}
	catch str x:
	{
		throw "Exception occurred and thrown. Error loc: 31-8642-274. Error Message: <x>";
	}
	
	//Now register the identifier to the node as well
	labToObjIdfs=
		registerObjectIdentifierToThisNode(nodeLabel,idf,labToObjIdfs);
	
	//return the tuple	
	return <hdToObjIdfs,labToObjIdfs>;
	
}


public LabToObjIdfs registerObjectIdentifierToThisNode(
	Lab nodeLabel,Identifier idf,LabToObjIdfs labToObjIdfs)
{
	//query the set of object var for this node..
	set[Identifier] idfs=labToObjIdfs[nodeLabel];
	
	//update the node infor
	labToObjIdfs[nodeLabel]=idfs+{idf};
	
	//return the updated identifier
	return labToObjIdfs;
}
