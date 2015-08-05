module tests::soft::typing::php::master::Test_Master

import soft::typing::php::declarations::PublicDataTypes;

import tests::soft::typing::php::constraints::Test_GetConstraints_Suite1;
import tests::soft::typing::php::constraints::Test_GetConstraints_Suite2;

import tests::soft::typing::php::functions::Test_DeltaOperator;
import tests::soft::typing::php::functions::Test_DependencyHelper;

import tests::soft::typing::php::Utils::Test_Analysis_2;
import tests::soft::typing::php::Utils::Test_Analysis_Nested_Includes;
import tests::soft::typing::php::Utils::Test_Analysis;
import tests::soft::typing::php::Utils::Test_ClassAnalysis_Methods;
import tests::soft::typing::php::Utils::Test_ClassAnalysis_StaticVar;
import tests::soft::typing::php::Utils::Test_ClassAnalysis;
import tests::soft::typing::php::Utils::Test_Function;
import tests::soft::typing::php::Utils::Test_RecursiveFuncCall;
import tests::soft::typing::php::Utils::Test_RepeatFunctionCalls;

import tests::soft::typing::warnings::Test_DynamicPropertySet;
import tests::soft::typing::warnings::Test_IllegalClassOperations;
import tests::soft::typing::warnings::Test_IllegalClassOperations2;
import tests::soft::typing::warnings::Test_IllegalClassOperations3;
import tests::soft::typing::warnings::Test_IllegalTypeCoercions;
import tests::soft::typing::warnings::Test_ObjectStateChangesInFunction;
import tests::soft::typing::warnings::Test_RecursiveCallAnalysisFailed;
import tests::soft::typing::warnings::Test_UseUnDeclaredVar;







import Exception;
import IO;

/*
private data XX=xx(int val);

private map[int,XX] experimentMap=( );

public void foobar(list[int] intList)
{
	try
	{
		int i=0;
		while(i<=5)
		{
			printIndLn(intList[i]);
			i++;
		}
	}
	catch IndexOutOfBounds(msg):
	{
		//do something
	}
}

public void testExperimentMap( )
{
	experimentMap[1]=xx(10); //set new key:value pair in map
	
	testVal=experimentMap[1].val; //should get 10
	
	assert testVal==10 : "test failed";
	
	//now try to change element directly,
	experimentMap[1].val=20;
	
	//does this change the original value?
	iprintln(experimentMap);
	
	assert testVal==10; //This holds!
	
}

public void testEditorFailAssertFailException()
{
	for(int a<-[1,2,3])
	{
		try
		{
			a=getElementFromSingletonList([1,2,3]);
			if(a==1)
				print("a=1");
			else
				print("a!=1");
		}
		catch AssertionFailed(str msg):
		{
			printIndLn(msg);
			
			printIndLn("Hello Error");
			
			throw msg;
		}
	}
}
*/

public void printTuple()
{
	//testing to see if I can assign tuple values to vars: foo and bar,
	//although the func gives them names: a, and b.
	list[int] eg=[1,2,3,4];
	
	//set[int] intSet={};
	//list[str] strList=[];
	//
	//for(int i <- eg)
	//	intSet=getTuple(i);
	intSet=getTuple(1);
	
	printIndLn("intSet: <intSet>");
	//printIndLn("strList: <strList>");
}

public set[int] getTuple(int i)
{
	/*
	if(i==1)
		return <{1},["string"]>;
	else if(i==2)
		return <{2},["dumb"]>;
	else if(i==3)
		return <{3},["foo"]>;
	else
		return <{4},["bar"]>;
	*/
	set[int] ab={1,2};
	//return ab;
	return {1,2};
}