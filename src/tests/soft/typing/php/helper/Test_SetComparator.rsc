module tests::soft::typing::php::helper::Test_SetComparator
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;

import Set;
import IO;
import List;
//method written just for backward compatibility
public bool assertEquals(map[&T,&V]result,map[&T,&V]expect,str dataTypeT,str dataTypeV,str funcTested)
{
	
	str dataType="map[<dataTypeT>,<dataTypeV>]";
	return assertEquals(result,expect,dataType,funcTested);
}

public bool assertEquals(tuple[&T,&V] result,tuple[&T,&V] expect, str dataType,str funcTested)
{
	if(assertEquals(result[0],expect[0],dataType,funcTested) &&
	   assertEquals(result[1],expect[1],dataType,funcTested)  )
		return true;
	else
		return false;
}

//primary entry method for most of the unit tests written
public bool assertEquals(map[&T,&V]result,map[&T,&V]expect,str dataType, str funcTested)
{
	bool equal=true;
	for(&T aKey<-result)
	{
		if(aKey in expect)
		{
			temp1=result[aKey];
			temp2=expect[aKey];
			if(!assertEquals(result[aKey],expect[aKey],dataType,funcTested))
			{
				equal=false;
				printIndLn("\>\>\>********FAILED**********\< \<\<");
				printIndLn("result[<aKey>]: <result[aKey]>");
				printIndLn("expect[<aKey>]: <expect[aKey]>");
			}
			else
			{
				printIndLn("passing test for <result[aKey]> == <expect[aKey]>");
			}
			
		}
		else
		{
			equal=false;
			printIndLn("\>\>\>********FAILED**********\< \<\<");
			printIndLn("Could not find key: <aKey> in expected map.");
			printIndLn("result[<aKey>]: <result[aKey]>");
		}
	}//end for (aKey <- result)
	
	for(&T aKey<-expect)
	{
		if(!(aKey in result))
		{
			equal=false;
			printIndLn("\>\>\>********FAILED**********\< \<\<");
			printIndLn("Could not find key: <aKey> in result map.");
			printIndLn("expect[<aKey>]: <result[aKey]>");
		}
	}//end for (aKey <- expect)
	
	if(!equal)
	{
		printIndLn("\>\>\>********FAILED**********\< \<\<");
		printIndLn(" Testing map[&T,&V] result == map[&T,&V] expected, where  [&T,&V] is <dataType>, function under Test: <funcTested>");
		printIndLn("----------\>");
		printIndLn("resulted: <result>");
		printIndLn(" ");
		printIndLn("Expected: <expect>");
		printIndLn("----------\>");
		return false;
	
	}
	else
	{
		printIndLn("Passed: Testing map[&T,&V] result == map[&T,&V] expect, where [&T,&V] is <dataType>, and function under Test: <funcTested>");		
		return true;
	}
}

public bool assertEquals(set[&T]result,set[&T]expected,str dataType,str funcTested)
{
	bool equal=true;
	for(&T cc <- result)
		if(!(cc in expected))
			{
				equal=false;
				printIndLn("Could not find <cc> in expected.");
			}	
	for(&T cc<- expected)
		if(! (cc in result))
			{
				equal=false;
				printIndLn("Could not find <cc> in result.");
			}
	
	if(!equal)
	{
		printIndLn("\>\>\>********FAILED**********\< \<\<");
		printIndLn(" Testing set[&T] result == set[&T] expected, where  &T is <dataType>, function under Test: <funcTested>");
		printIndLn("----------\>");
		printIndLn("resulted: <result>");
		printIndLn(" ");
		printIndLn("Expected: <expected>");
		printIndLn("----------\>");
		return false;
	}
	
	printIndLn("Passed: Testing set[&T] result == set[&T] expected, where &T is <dataType>, function under Test: <funcTested>");
	return equal;

}

public bool assertEquals(list[&T]result,list[&T]expect,str dataType,str funcTested)
{
	bool equal=true;
	
	list[int] indexR=index(result);
	list[int] indexE=index(expect);


	for(int ii<-indexR)
	{
		if(!(ii in indexE))
		{
			equal=false;
			printIndLn("Could not find <result[ii]> in expected");
		}
		else if(!(assertEquals(result[ii],expect[ii],dataType,funcTested)))
		{
			equal=false;
			printIndLn("Could not match <result[ii]> to <expect[ii]>");
		}
	}	

	for(int ii<- indexE)
	{
		if(!(ii in indexR))
		{
			equal=false;
			printIndLn("Could not find <expect[ii]> in resulted");
		}
		else if(!(assertEquals(expect[ii],result[ii],dataType,funcTested)))
		{
			equal=false;
			printIndLn("Could not match <expect[ii]> to <result[ii]>");
		}
	}	
	
	if(!equal)
	{
		printIndLn("\>\>\>********FAILED**********\< \<\<");
		printIndLn(" Testing list[&T] result == listt[&T] expected, where  &T is <dataType>, function under Test: <funcTested>");
		printIndLn("----------\>");
		printIndLn("resulted: <result>");
		printIndLn(" ");
		printIndLn("Expected: <expect>");
		printIndLn("----------\>");
		return false;
	}
	
	printIndLn("Passed: Testing set[&T] result == set[&T] expected, where &T is <dataType>, function under Test: <funcTested>");
	return equal;

}

public bool assertEquals(&T result,&T expected,str dataType, str funcTested)
{
	
	if(result==expected)
	{
		printIndLn("Passed: Testing &T result == &T expected, where &T is <dataType>, function under Test: <funcTested>");
		return true;
	}
	else
	{
		printIndLn("\>\>\>********FAILED**********\< \<\<");
		printIndLn(" Testing &T result == &T expected, where  &T is <dataType>, , function under Test: <funcTested>");
		printIndLn("----------\>");
		printIndLn("resulted: <result>");
		printIndLn(" ");
		printIndLn("Expected: <expected>");
		printIndLn("---------\>");
		return false;
	}	
}


test bool test0_0()
{
	TypeRoot t1=typeSet({Float()});
	TypeRoot t2=typeSet({String(),Bool()});
	
	return (!assertEquals(t1,t2,"TypeRoot","SetComparator"));
}
