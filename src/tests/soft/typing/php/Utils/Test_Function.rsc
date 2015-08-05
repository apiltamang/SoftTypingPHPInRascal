module tests::soft::typing::php::Utils::Test_Function

import soft::typing::php::elements::Function;
import soft::typing::php::constraints::ConstraintHelper;
import tests::soft::typing::php::helper::Test_SetComparator;
import IO;

import soft::typing::php::declarations::PublicDataTypes;

test bool test1()
{
	TypeRoot t1=typeSet({Int()});
	TypeRoot t2=typeSet({Float()});
	
	list[TypeRoot] params=[t1,t2];
	
	result=getCartesianProductOfParams(params);
	
	expect={[Int(),Float()]};
	
	return assertEquals(result,expect,"set[list[Type]]","getCartesianProductOfParams");

}

test bool test2()
{
	TypeRoot t1=typeSet({Int(),String()});
	TypeRoot t2=typeSet({Bool()});
	
	result=getCartesianProductOfParams([t1,t2]);
	
	expect={ [Int(),Bool()],[String(),Bool()] };
	
	return assertEquals(result,expect,"set[list[Type]]","getCartesianProductOfParams");
}

test bool test3()
{
	TypeRoot t1=typeSet({Int(),String()});
	TypeRoot t2=typeSet({Bool(),Float()});
	
	result=getCartesianProductOfParams([t1,t2]);
	
	expect={ [Int(),Bool()], [Int(),Float()], [String(),Bool()], [String(),Float()] };
	
	return assertEquals(result,expect,"set[list[Type]]","getCartesianProductOfParams");
	
}

test bool test4()
{
	TypeRoot t1=typeSet({Int()});
	TypeRoot t2=typeSet({Float(),Bool()});
	
	result=getCartesianProductOfParams([t1,t2]);
	
	expect={ [Int(),Float()], [Int(),Bool()] };
	
	return assertEquals(result,expect,"set[list[Type]]","getCartesianProductOfParams");
	
}

test bool test5()
{
	t1=typeSet({Int()});
	t2=typeSet({Float()});
	t3=typeSet({Float()});
	
	result=getCartesianProductOfParams([t1,t2,t3]);
	
	expect={ [Int(),Float(),Float()] };
	
	return assertEquals(result,expect,"set[list[Type]]","getCartesianProductOfParams");
}

test bool test6()
{

	t1=typeSet({Int()});
	t2=typeSet({Bool(),Int()});
	t3=typeSet({Float(),Int(),String()});
	
	result=getCartesianProductOfParams([t1,t2,t3]);
	
	expect={ [Int(),Bool(),Float()], [Int(),Bool(),Int()], [Int(),Bool(),String()], 
			 [Int(),Int(),Float()],  [Int(),Int(),Int()] , [Int(),Int(),String()] };
	return assertEquals(result,expect,"set[list[Type]]","getCartesianProductOfParams");
}

test bool test7()
{
	t1=typeSet({Int(),Float()});
	t2=typeSet({String(),Bool(),Num()});
	t3=typeSet({Array(Int()), Array(Bool())});
	t4=typeSet({Array(Array(Float())),Array(String())});
	
	result=getCartesianProductOfParams([t1,t2,t3,t4]);
	expect= {[Float(),Bool(),Array(Bool()),Array(String())],[Float(),Bool(),Array(Bool()),Array(Array(Float()))],
			 [Float(),String(),Array(Int()),Array(Array(Float()))],[Float(),String(),Array(Int()),Array(String())],
			 [Float(),Num(),Array(Int()),Array(String())],[Float(),Num(),Array(Int()),Array(Array(Float()))],
			 [Float(),Num(),Array(Bool()),Array(String())],[Float(),Num(),Array(Bool()),Array(Array(Float()))],
			 [Float(),Bool(),Array(Int()),Array(String())],[Float(),Bool(),Array(Int()),Array(Array(Float()))],
			 [Float(),String(),Array(Bool()),Array(Array(Float()))],[Float(),String(),Array(Bool()),Array(String())],
			 
			 [Int(),Bool(),Array(Int()),Array(Array(Float()))],[Int(),Bool(),Array(Int()),Array(String())],
			 [Int(),String(),Array(Bool()),Array(String())],[Int(),String(),Array(Bool()),Array(Array(Float()))],
			 [Int(),Num(),Array(Bool()),Array(Array(Float()))],[Int(),Num(),Array(Bool()),Array(String())],
			 [Int(),Num(),Array(Int()),Array(Array(Float()))],[Int(),Num(),Array(Int()),Array(String())],
			 [Int(),Bool(),Array(Bool()),Array(Array(Float()))],[Int(),Bool(),Array(Bool()),Array(String())],
			 [Int(),String(),Array(Int()),Array(String())],[Int(),String(),Array(Int()),Array(Array(Float()))]};
	
	return assertEquals(result,expect,"set[list[Type]]","getCartesiapProductFromParams");
}

