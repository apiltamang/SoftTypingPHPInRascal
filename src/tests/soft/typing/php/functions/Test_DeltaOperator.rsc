module tests::soft::typing::php::functions::Test_DeltaOperator

import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::functions::DeltaOperator;
import tests::soft::typing::php::helper::Test_SetComparator;
import IO;

import soft::typing::php::declarations::PublicDataTypes;

public bool assertEquals(TypeRoot soln,TypeRoot expect)
{
	bool passTest=false;
	if(soln is typeSet && expect is typeSet)
		return assertEquals(soln.types,expect.types,"TypeRoot","DeltaOperator");
	else if(soln is typeSingleton && expect is typeSingleton)
		return assertEquals(soln.aType,expect.aType,"TypeRoot","DeltaOperator");	
	else
		return assertEquals(soln,expect,"TypeRoot","DeltaOperator");
	}
test bool test1_0()
{
	TypeRoot t1=typeSet({Int()});
	
	TypeRoot t2=typeSet({Num()});
	
	t3=widen(t1,t2);
	return assertEquals(t3,typeSet({Num()}));	
}
test bool test1_1()
{
	TypeRoot t1=typeSet({Int()});
	
	TypeRoot t2=typeSet({Num()});
	
	t3=widen(t2,t1);
	return assertEquals(t3,typeSet({Num()}));	
}
test bool test2_0()
{
	TypeRoot t1=typeSet({Bool(),String(),Num()});
	
	TypeRoot t2=typeSet({Int()});
	
	
	
	return assertEquals(widen(t1,t2),t1);
}

test bool test2_1()
{
	TypeRoot t1=typeSet({Bool(),String(),Num()});
	
	TypeRoot t2=typeSet({Int()});
	
	
	
	return assertEquals(widen(t2,t1),t1);
}

test bool test3_0()
{
	TypeRoot t1=typeSet({Bool(),String(),Int()});
	
	TypeRoot t2=typeSet({Num()});
	
	return assertEquals(widen(t1,t2),typeSet({Bool(),String(),Num() }));
}

test bool test3_1()
{
	TypeRoot t1=typeSet({Bool(),String(),Int()});
	
	TypeRoot t2=typeSet({Num()});
	
	return assertEquals(widen(t2,t1),typeSet({Bool(),String(),Num() }));
}

test bool test4_0()
{
	t1=typeSet({Bool(),Int()});
	t2=typeSet({String(),Int()});
	
	return assertEquals(widen(t1,t2),typeSet({Bool(),String(),Int()}));
}

test bool test4_1()
{
	t1=typeSet({Bool(),Int()});
	t2=typeSet({String(),Int()});
	
	return assertEquals(widen(t2,t1),typeSet({Bool(),String(),Int()}));
}

test bool test5_0()
{
	t1=typeSet({Num()});
	t2=typeSet({String(),Bool(),Int()});
	
	soln=typeSet({Num(),Bool(),String()});
	return (assertEquals(widen(t1,t2),soln) && 
			assertEquals(widen(t2,t1),soln)  );
}

test bool test6_0()
{
	t1=typeSet({Float()});
	t2=typeSet({Num()});
	
	return assertEquals(widen(t1,t2),typeSet({Num()}));
}

test bool test6_1()
{
	t1=typeSet({Float(),String()});
	t2=typeSet({Int(),Bool()});
	
	return assertEquals(widen(t1,t2),typeSet({Num(),String(),Bool()}));
}

test bool test7_0()
{
	t1=typeSet({Num(),Bool()});
	t2=typeSet({Float()});
	return assertEquals(widen(t1,t2),typeSet({Num(),Bool()}));
}

test bool test7_1()
{
	t1=typeSet({Num()});
	t2=typeSet({Int(),Float()});
	return assertEquals(widen(t1,t2),typeSet({Num()}));
}

test bool test8()
{

	Type t=Array(Array(Array(Array(Int()))));
	depth=getArrayDepthOf(t);
	
	return assertEquals(depth,4,"Int","GetArrayDepthOf");
}

test bool test9()
{
	Type t=String();
	return assertEquals(getArrayDepthOf(t),0,"Int","GetArrayDepthOf");
}

test bool test10()
{
	Type t=getArrayAnyOfDepth(4);
	return assertEquals(t,Array(Array(Array(Array(Any())))),"Type","GetArrayAnyOfDepth");
}

test bool test11()
{
	Type t=getArrayAnyOfDepth(0);
	return assertEquals(t,Any(),"Type","GetArrayAnyOfDepth");
}

test bool test12()
{
	TypeRoot t1=typeSet({Int()});
	TypeRoot t2=typeSet({Float()});
	
	return assertEquals(widen(t1,t2),typeSet({Num()}));
}

test bool test13()
{
	TypeRoot t1=typeSet({Int(),Bool(),String(),Array(Int())});
	TypeRoot t2=typeSet({Array(String())});
	
	return assertEquals(widen(t1,t2),typeSet({Any()}));
}

test bool test14()
{
	t2=typeSet({Array(Int()),Array(Bool()),Array(String()),Array(Array(Int()))});
	t1=typeSet({Array(Any())});
	
	return assertEquals(widen(t2,t1),typeSet({Array(Any())}));
}	
test bool test14_1()
{
	t2=typeSet({Array(Int()),Array(Bool()),Array(String()),Array(Array(Int()))});
	t3=resolveNumTypes(t2.types);
	printIndLn("t3: <t3>");
	v=getMinAnyArrayDepth({tt|tt<-t3});
	
	return assertEquals(v,-1,"int","getMinArrayDepth(set[Type])");
}
test bool test15()
{
	t=typeSet({Array(Array(Any())),Int()});
	v=getMinAnyArrayDepth(t.types);
	
	return assertEquals(v,2,"int","getMinArrayDepth(set[Type])");
}

test bool test16()
{
	t=typeSet({Array(Array(Any())),Array(Int())});
	v=getMinAnyArrayDepth(t.types);
	
	return assertEquals(v,2,"int","getMinArrayDepth(set[Type])");
}

test bool test17()
{
	t=typeSet({Array(Array(Any())),Array(Any())});
	v=getMinAnyArrayDepth(t.types);
	
	return assertEquals(v,1,"int","getMinAnyArrayDepth(set[Type])");
}

test bool test18()
{
	t=typeSet({Any()});
	return assertEquals(getMinAnyArrayDepth(t.types),0,"int","getMinAnyArrayDepth(set[Type])");
}

test bool test19()
{
	t=typeSet({Array(Array(Any())),Array(Any()),Any()});
	v=getMinAnyArrayDepth(t.types);
	
	return assertEquals(v,0,"int","getMinArrayDepth(set[Type])");
}

test bool test20()
{
	t1=typeSet({Array(Int())});
	t2=typeSet({Array(Array(Int()))});
	
	t3=widen(t1,t2);
	
	return assertEquals(t3,typeSet({Array(Int()),Array(Array(Int()))}),"TypeRoot","widen");
}

test bool testFunc_combineClassInstance()
{
	map[Identifier,TypeRoot] fieldToTypeMap=
	(
		var("x"):typeSet({Int()}),
		var("y"):typeSet({Bool()})
	);
	
	str srcClass="Foobar";
	
	set[ClassTemplate] templates={};
	
	int id=1;
	
	ClassInstance inst1=objInst(
		id,
		fieldToTypeMap,
		srcClass,
		templates
	);
	
	fieldToTypeMap[var("y")]=typeSet({String()});
	
	ClassInstance inst2=objInst(
		id,
		fieldToTypeMap,
		srcClass,
		templates
	);
	
	ClassInstance result=combineClassInstances(inst1,inst2);
	
	ClassInstance expect=objInst(
		id,
		(
			var("x"):typeSet({Int()}),
			var("y"):typeSet({Bool(),String()})
		),
		srcClass,
		templates
	);
	
	if(expect==result)
		return true;
	else
	{
		iprintln("result: ");
		iprintln(expect);
		return false;
	
	}	
}

test bool tesFunc_combineObjectHandles_1()
{
	//tests the case when h1=h2, and oi1=oi2 (h: handle, oi: object instance)
	map[Identifier,TypeRoot] fieldToTypeMap=
	(
		var("x"):typeSet({Int()}),
		var("y"):typeSet({Bool()})
	);
	
	str srcClass="Foobar";
	
	set[ClassTemplate] templates={};
	
	int id=1;
	
	ClassInstance inst1=objInst(
		id,
		fieldToTypeMap,
		srcClass,
		templates
	);
	
	
	ClassInstance inst2=objInst(
		id,
		fieldToTypeMap,
		srcClass,
		templates
	);
	
	Handle h1=objHd(1);
	
	Handle h2=objHd(1);
	
	result=resolveCombinationInvolvingObjectHandles(	
		{Object(h1,inst1)}, {Object(h2,inst2)} );

	expect={Object(h1,inst1)};		
	return assertEquals(result,expect,"Type","resolveCombinationInvolvingObjectHandles");
}	

test bool tesFunc_combineObjectHandles_2()
{
	//tests the case when h1=h2, and oi1 != oi2 (h: handle, oi: object instance)
	/*e.g
	<?php
	
	$a=new ClassA( )
	
	if ( cond..)
		$a->varA="string";
	else
		$a->varA=1.234;
	...
	..
	.
	?>
	
	In the above example, $a will be pointing to the same object handles in both the forked nodes,
	however, each forked node will maintain a fixed instance of its own, i.e. oi1 and oi2 respectively,
	
	Later, when the forked node are merged during type analysis propagation, this will be used to 
	update the type information for varA
	*/
	map[Identifier,TypeRoot] fieldToTypeMap=
	(
		var("x"):typeSet({Int()}),
		var("y"):typeSet({Bool()})
	);
	
	str srcClass="Foobar";
	
	set[ClassTemplate] templates={};
	
	int id=1;
	
	ClassInstance inst1=objInst(
		id,
		fieldToTypeMap,
		srcClass,
		templates
	);
	
	//change type root of one of the fields:
	fieldToTypeMap[var("x")]=typeSet({Bool()});
	
	ClassInstance inst2=objInst(
		id,
		fieldToTypeMap,
		srcClass,
		templates
	);
	
	Handle h1=objHd(1);
	
	Handle h2=objHd(1);
	
	result=resolveCombinationInvolvingObjectHandles(	
		{Object(h1,inst1)}, {Object(h2,inst2)} );

	
	ClassInstance expectInst=objInst(
		id,
		(
			var("x"):typeSet({Bool(),Int()}),
			var("y"):typeSet({Bool()})
		),
		srcClass,
		templates
	);
			
	expect={Object(h1,expectInst)};
	
	return assertEquals(result,expect,"Type","resolveCombinationInvolvingObjectHandles");
}	

test bool tesFunc_combineObjectHandles_3()
{
	//tests the case when h1 != h2, and 
	//h1.srcClass = h2.srcClass, i.e.
	//this is caused when a new instance of the same class is constructed in a forked statement
	/* e.g.
	<?php
	
	if( <cond> )
	{
		$a = new ClassA( );
		...
		..
	}
	else
	{
		$a = new ClassA( );
		...
		..
	}
	
	In the above instance, a new handle each is created for the two forked statements. However, because
	they are spawned fro the same src class, I will assign the same object handle to both the variables, and
	combine the type information for any of the instance fields.
	*/
	map[Identifier,TypeRoot] fieldToTypeMap=
	(
		var("x"):typeSet({Int()}),
		var("y"):typeSet({Bool()})
	);
	
	str srcClass="Foobar";
	
	set[ClassTemplate] templates={};
	
	int id=1;
	
	ClassInstance inst1=objInst(
		id,
		fieldToTypeMap,
		srcClass,
		templates
	);
	
	//change type root of one of the fields:
	fieldToTypeMap[var("x")]=typeSet({Bool()});
	fieldToTypeMap[var("y")]=typeSet({Float()});
		
	ClassInstance inst2=objInst(
		id,
		fieldToTypeMap,
		srcClass,
		templates
	);
	
	Handle h1=objHd(1);
	
	Handle h2=objHd(2);
	
	
	ClassInstance expectInst=objInst(
		id,
		(
			var("x"):typeSet({Bool(),Int()}),
			var("y"):typeSet({Bool(),Float()})
		),
		srcClass,
		templates
	);
			
	//Add this to the global object store, because it will be queried for the objects pointed to
	//by any object handles in concern.
	HandleToClassInstanceMap+=(h1:inst1,h2:inst2);
	
	result=resolveCombinationInvolvingObjectHandles(	
		{Object(h1,inst1)}, {Object(h2,inst2)} );

	
	expect={Object(h1,expectInst)};
	
	return assertEquals(result,expect,"Type","resolveCombinationInvolvingObjectHandles");
}	

test bool tesFunc_combineObjectHandles_4()
{
	//tests the case when h1 != h2, and 
	//h1.srcClass != h2.srcClass, i.e.
	//this is caused when a new instance of different classes are constructed in a forked statement
	/* e.g.
	<?php
	
	if( <cond> )
	{
		$a = new ClassA( );
		...
		..
	}
	else
	{
		$a = new ClassB( );
		...
		..
	}
	
	In the above instance, a new handle each is created for the two forked statements. However, because
	they are spawned fro the same src class, I will assign the same object handle to both the variables, and
	combine the type information for any of the instance fields.
	*/

	
	set[ClassTemplate] templates={};
	
	int id=1;
	
	ClassInstance inst1=objInst(
		id,
		(
			var("x"):typeSet({Int()}),
			var("y"):typeSet({Bool()})
		),
		"ClassA",
		templates
	);
	
	ClassInstance inst2=objInst(
		id,
		(
			var("xx"):typeSet({Int()}),
			var("yy"):typeSet({Bool()})
		),
		"ClassB",
		templates
	);
	
	Handle h1=objHd(1);
	
	Handle h2=objHd(2);
	
	
			
	//Add this to the global object store, because it will be queried for the objects pointed to
	//by any object handles in concern.
	HandleToClassInstanceMap+=(h1:inst1,h2:inst2);
	
	result=resolveCombinationInvolvingObjectHandles(	
		{Object(h1,inst1)}, {Object(h2,inst2)} );

	
	expect={Object(h1,inst1),Object(h2,inst2)};
	
	return assertEquals(result,expect,"Type","resolveCombinationInvolvingObjectHandles");
}	

test bool test_widenWithObjectTypes()
{

	set[ClassTemplate] templates={};
	
	int id=1;
	
	ClassInstance inst1=objInst(
		id,
		(
			var("x"):typeSet({Int()}),
			var("y"):typeSet({Bool()})
		),
		"ClassA",
		templates
	);
	
	ClassInstance inst2=objInst(
		id,
		(
			var("xx"):typeSet({Int()}),
			var("yy"):typeSet({Bool()})
		),
		"ClassB",
		templates
	);
	
	Handle h1=objHd(1);
	
	Handle h2=objHd(2);
	
	
			
	//Add this to the global object store, because it will be queried for the objects pointed to
	//by any object handles in concern.
	HandleToClassInstanceMap+=(h1:inst1,h2:inst2);
	
	t1=typeSet({Int(),Object(h1,inst1)});
	t2=typeSet({Object(h2,inst2)});
	
	expect=typeSet({Int(),Object(h1,inst1),Object(h2,inst2)});

	
	result=widen(t1,t2);
	
	return assertEquals(result,expect,"TypeRoot","widen");
	

}