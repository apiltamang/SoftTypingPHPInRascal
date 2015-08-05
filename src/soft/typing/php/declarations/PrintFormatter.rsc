module soft::typing::php::declarations::PrintFormatter
import soft::typing::php::declarations::PublicDataTypes;
import IO;
//======================================
private int iterationIndex=0;
private str indentationStr="";
//======================================
public void resetIterationIndex()
{
	iterationIndex=0;
}

public void incrementIndentationString()
{
	iterationIndex=iterationIndex+1;
	indentationStr=indentStr();
}

public void decrementIndentationString()
{
	iterationIndex=iterationIndex-1;
	indentationStr=indentStr();
}

public str indentStr()
{
	if(iterationIndex>20)
		throw "Too many iterations..";
		
	str temp="";
	
	if(iterationIndex>0)
		temp+="<iterationIndex>";
	
	int i=0;
	while(i<iterationIndex){
		temp+="        ";
		i=i+1;
	}
	
	return temp;
}

public void printIndLn(str content)
{
	print(indentationStr);	
	println(content);
	
}

public void iprintIndLn(list[&T] content)
{
	
	for(&T abc <- content)
	{
		print(indentationStr);
		iprintln(abc);		
	}
}

public str prettyPrint(set[Constraint] ccs)
{
	str temp="";
	//for(Constraint cc<-ccs)
	//{
	//	if(yieldFlow(l1,l2):=cc)
	//		temp+="\\m{l_{<l1.id>} \\leftArrow l_{<l2.id>}},";
	//	if(expectFlow(l1,l2):=cc)
	//		temp+="\\m{l_{<l1.id>} \\leftArrow_{\\equiv} l_{<l2.id>}},";
	//	if(yieldType(l1,tt):=cc)
	//		temp+=
	//}
	return temp;
}