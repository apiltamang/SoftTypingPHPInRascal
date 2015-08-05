module tests::soft::typing::php::constraints::Test_GetConstraints_Suite1
import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::constraints::GetConstraints;
import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::constraints::Test_GetConstraints_Helper;

import List;
import IO;

import soft::typing::php::declarations::PublicDataTypes;

test bool test1()
{
	
	str expr="$a=1"; 		//test stmt
	set[Constraint]soln={ //expected soln
	  yieldFlow(
	    lab(1),
	    lab(2)),
	  yieldFlow(
	    lab(3),
	    lab(2)),
	  yieldType(
	    lab(2),
	    typeSet({Int()}))
	};
	
	return assertEquals(soln,expr);
}
					 
test bool test2()
{
	str expr="$b--";
	set[Constraint]soln={
	  yieldType(
	  	lab(1),
	  	fromVar(var("b"))),
	  expectType(
	    lab(1),
	    typeSet({Int()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()}))
	};
	
	return assertEquals(soln,expr);
}

test bool test3()
{
	str expr="$c++";
	set[Constraint]soln={
	  yieldType(
	  	lab(1),
	  	fromVar(var("c"))),
	  expectType(
	    lab(1),
	    typeSet({Int()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()}))
	};
	
	return assertEquals(soln,expr);
}

test bool test4()
{
	str expr="++$d";
	set[Constraint]soln={
	
	  yieldType(
	  	lab(1),
	  	fromVar(var("d"))),
	  expectType(
	    lab(1),
	    typeSet({Int()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()}))
	};
	
	return assertEquals(soln,expr);
}	

test bool test5()
{
	str expr="!($e)";
	set[Constraint]soln={
	  yieldType(
	  	lab(1),
	  	fromVar(var("e"))),
	  expectType(
	    lab(1),
	    typeSet({Bool()})),
	  yieldType(
	    lab(2),
	    typeSet({Bool()}))
	};
	return assertEquals(soln,expr);	
}	

test bool test6()
{
	str expr="-($f)";
	set[Constraint]soln={
	  yieldType(
	  	lab(1),
	  	fromVar(var("f"))),
	  expectType(
	    lab(1),
	    typeSet({Num()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()}))
	};	
	return assertEquals(soln,expr);
}	

test bool test7()
{
	str expr="1+2";
	set[Constraint]soln={
	  expectType(
	    lab(1),
	    typeSet({Num()})),
	  expectType(
	    lab(2),
	    typeSet({Num()})),
	  yieldType(
	    lab(3),
	    typeSet({Num()})),
	  yieldType(
	    lab(1),
	    typeSet({Int()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()}))
	};
	
	return assertEquals(soln,expr);
}

test bool test8()
{
	str expr="$b+1";
	set[Constraint]soln={
	  yieldType(
	    lab(1),
	    fromVar(var("b"))),
	  expectType(
	    lab(1),
	    typeSet({Num()})),
	  expectType(
	    lab(2),
	    typeSet({Num()})),
	  yieldType(
	    lab(3),
	    typeSet({Num()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()}))
	};
	return assertEquals(soln,expr);
}

test bool test9()
{
	str expr="$a=1+2+3";
	set[Constraint]soln={
	  yieldFlow(
	    lab(1),
	    lab(6)),
	  yieldFlow(
	    lab(7),
	    lab(6)),
	  expectType(
	    lab(4),
	    typeSet({Num()})),
	  expectType(
	    lab(5),
	    typeSet({Num()})),
	  yieldType(
	    lab(6),
	    typeSet({Num()})),
	  expectType(
	    lab(2),
	    typeSet({Num()})),
	  expectType(
	    lab(3),
	    typeSet({Num()})),
	  yieldType(
	    lab(4),
	    typeSet({Num()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()})),
	  yieldType(
	    lab(3),
	    typeSet({Int()})),
	  yieldType(
	    lab(5),
	    typeSet({Int()}))
	};
	return assertEquals(soln,expr);
}

test bool test10()
{
	str expr="$a=($b+3)*9";
	set[Constraint]soln={
	  yieldFlow(
	    lab(1),
	    lab(6)),
	  yieldFlow(
	    lab(7),
	    lab(6)),
	  expectType(
	    lab(4),
	    typeSet({Num()})),
	  expectType(
	    lab(5),
	    typeSet({Num()})),
	  yieldType(
	    lab(6),
	    typeSet({Num()})),
	  expectType(
	    lab(2),
	    typeSet({Num()})),
	  expectType(
	    lab(3),
	    typeSet({Num()})),
	  yieldType(
	    lab(4),
	    typeSet({Num()})),
	  yieldType(
	    lab(3),
	    typeSet({Int()})),
	  yieldType(
	    lab(5),
	    typeSet({Int()})),
	  yieldType(
	  	lab(2),
	  	fromVar(var("b")))
	};
	return assertEquals(soln,expr);
}	

test bool test11()
{
	str expr="$c=$a.$b.$c";
	set[Constraint]soln={
	  yieldFlow(
	    lab(1),
	    lab(6)),
	  yieldFlow(
	    lab(7),
	    lab(6)),
	  expectType(
	    lab(4),
	    typeSet({String()})),
	  expectType(
	    lab(5),
	    typeSet({String()})),
	  yieldType(
	    lab(6),
	    typeSet({String()})),
	  expectType(
	    lab(2),
	    typeSet({String()})),
	  expectType(
	    lab(3),
	    typeSet({String()})),
	  yieldType(
	    lab(4),
	    typeSet({String()})),
	  yieldType(
	  	lab(2),
	  	fromVar(var("a"))), 
	  yieldType(
	  	lab(3),
	  	fromVar(var("b"))), 
	  yieldType(
	  	lab(5),
	  	fromVar(var("c"))) 

	};
	return assertEquals(soln,expr);
}
test bool test12()
{
	str expr="$c=$a.\"hello\" ";
	set[Constraint]soln={  
	  yieldFlow(
	    lab(1),
	    lab(4)),
	  yieldFlow(
	    lab(5),
	    lab(4)),
	  expectType(
	    lab(2),
	    typeSet({String()})),
	  expectType(
	    lab(3),
	    typeSet({String()})),
	  yieldType(
	    lab(4),
	    typeSet({String()})),
	  yieldType(
	    lab(3),
	    typeSet({String()})),
	  yieldType(
	  	lab(2),
	  	fromVar(var("a")))
	};
	return assertEquals(soln,expr);
}	

test bool test13()
{
	str expr="$a=( ($left==$right)? \"strIfTrue\" : $anUnknownVar)";
	set[Constraint]soln={
	  yieldFlow(
	    lab(8),
	    lab(7)),
	  expectFlow(
	    lab(2),
	    lab(3)),
	  yieldType(
	    lab(4),
	    typeSet({Bool()})),
	  yieldType(
	    lab(7),
	    fromLabels({lab(5),lab(6)})
	    ),
	  expectType(
	    lab(4),
	    typeSet({Bool()})),
	  yieldType(
	    lab(5),
	    typeSet({String()})),
	  yieldFlow(
	    lab(1),
	    lab(7)),
	  yieldType(
	  	lab(2),fromVar(var("left"))),
	  yieldType(
	  	lab(3),
	  	fromVar(var("right"))),
	  yieldType(
	  	lab(6),
	  	fromVar(var("anUnknownVar")))
	  	
	};
	 return assertEquals(soln,expr);
}	
	
	
test bool test14()
{
	
	str expr="echo $a,\"a string\"";	
	set[Constraint]soln={
	  expectType(
	    lab(1),
	    typeSet({String()})),
	  expectType(
	    lab(2),
	    typeSet({String()})),
	  yieldType(
	    lab(2),
	    typeSet({String()})),
	  yieldType(
	  	lab(1),
	  	fromVar(var("a")))
	};	
	
	return assertEquals(soln,expr);	
}
	
test bool test15()
{
	str expr="$a *= 5";
	set[Constraint]soln={
	  yieldType(
	    lab(1),
	    typeSet({Num()})),
	  expectType(
	    lab(2),
	    typeSet({Num()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()}))
	};	
	return assertEquals(soln,expr);	
}	
	
test bool test16()
{
	str expr="$a ~=1"; //parsing this str returns a parse error 
	return true;	
}

test bool test17()
{
	str expr="$a &=$b";
	set[Constraint]soln={
	  yieldType(
	    lab(1),
	    typeSet({Int()})),
	  expectType(
	    lab(2),
	    typeSet({Int()}))
	};
	
	return assertEquals(soln,expr);	
}

test bool test18()
{
	str expr="$a |=$c"; 
	set[Constraint] soln={
	  yieldType(
	    lab(1),
	    typeSet({Int()})),
	  expectType(
	    lab(2),
	    typeSet({Int()}))
	};
	
	return assertEquals(soln,expr);	
}

test bool test20()
{	
	str expr="$a= $anExpr ?: \"Not Set\" ";
	set[Constraint]soln={
	
	  yieldType(
	    lab(3),
	    typeSet({String()})),
	  yieldFlow(
	    lab(5),
	    lab(4)),
	  yieldType(
	    lab(4),
		fromLabels({lab(2),lab(3)})
		),
	  yieldFlow(
	    lab(1),
	    lab(4)),
	  yieldType(
	  	lab(2),
	  	fromVar(var("anExpr")))
	};
	
	return assertEquals(soln,expr);
}	
	
test bool test21()
{
	str expr="if($a==$b) echo $c; ";
	set[Constraint]soln={

	  expectType(
	    lab(3),
	    typeSet({Bool()})),
	  expectFlow(
	    lab(1),
	    lab(2)),
	  yieldType(
	    lab(3),
	    typeSet({Bool()})),
	  expectType(
	    lab(4),
	    typeSet({String()})),
	  yieldType(lab(1),fromVar(var("a"))),
	  yieldType(lab(2),fromVar(var("b"))),
	  yieldType(lab(4),fromVar(var("c")))
	};
	
	return assertEquals(soln,expr);	
}

test bool test22()
{
	str expr=
		"if($x==1) 
		{ 
			$a=1;
			$b=2;
		}
		elseif($x==\"x\")
		{
			$a=\"abc\";
			$b=\"hoo\";
		} 
		elseif($x==\"y\")
		{
			$a=\"cde\";
		}
		{
			$b=\"b\";
		}"; 
	set[Constraint] soln={
	  expectType(
	    lab(3),
	    typeSet({Bool()})),
	  expectType(
	    lab(14),
	    typeSet({Bool()})),
	  expectType(
	    lab(25),
	    typeSet({Bool()})),
	  expectFlow(
	    lab(1),
	    lab(2)),
	  yieldType(
	    lab(3),
	    typeSet({Bool()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()})),
	  yieldFlow(
	    lab(4),
	    lab(5)),
	  yieldFlow(
	    lab(6),
	    lab(5)),
	  yieldType(
	    lab(5),
	    typeSet({Int()})),
	  yieldFlow(
	    lab(8),
	    lab(9)),
	  yieldFlow(
	    lab(10),
	    lab(9)),
	  yieldType(
	    lab(9),
	    typeSet({Int()})),
	  expectFlow(
	    lab(12),
	    lab(13)),
	  yieldType(
	    lab(14),
	    typeSet({Bool()})),
	  yieldType(
	    lab(13),
	    typeSet({String()})),
	  yieldFlow(
	    lab(15),
	    lab(16)),
	  yieldFlow(
	    lab(17),
	    lab(16)),
	  yieldType(
	    lab(16),
	    typeSet({String()})),
	  yieldFlow(
	    lab(19),
	    lab(20)),
	  yieldFlow(
	    lab(21),
	    lab(20)),
	  yieldType(
	    lab(20),
	    typeSet({String()})),
	  expectFlow(
	    lab(23),
	    lab(24)),
	  yieldType(
	    lab(25),
	    typeSet({Bool()})),
	  yieldType(
	    lab(24),
	    typeSet({String()})),
	  yieldFlow(
	    lab(26),
	    lab(27)),
	  yieldFlow(
	    lab(28),
	    lab(27)),
	  yieldType(
	    lab(27),
	    typeSet({String()})),
	  yieldFlow(
	    lab(31),
	    lab(32)),
	  yieldFlow(
	    lab(33),
	    lab(32)),
	  yieldType(
	    lab(32),
	    typeSet({String()})),
	  yieldType(lab(23),fromVar(var("x"))),
	  yieldType(lab(1),fromVar(var("x"))),
	  yieldType(lab(12),fromVar(var("x")))
	};			
	
	return assertEquals(soln,expr);
}
	
test bool test23()
{
	str expr=
	"if($x==1) 
	{ 
		$a=1;
		$b=2;
	}
	else
	{
		$a=true;
 	}";
	
	set[Constraint]soln={
	
	  expectType(
	    lab(3),
	    typeSet({Bool()})),
	  expectFlow(
	    lab(1),
	    lab(2)),
	  yieldType(
	    lab(3),
	    typeSet({Bool()})),
	  yieldType(
	    lab(2),
	    typeSet({Int()})),
	  yieldFlow(
	    lab(4),
	    lab(5)),
	  yieldFlow(
	    lab(6),
	    lab(5)),
	  yieldType(
	    lab(5),
	    typeSet({Int()})),
	  yieldFlow(
	    lab(8),
	    lab(9)),
	  yieldFlow(
	    lab(10),
	    lab(9)),
	  yieldType(
	    lab(9),
	    typeSet({Int()})),
	  yieldFlow(
	    lab(12),
	    lab(13)),
	  yieldFlow(
	    lab(14),
	    lab(13)),
	  yieldType(
	    lab(13),
	    typeSet({Bool()})),
	  yieldType(lab(1),fromVar(var("x")))
	};
	
	return assertEquals(soln,expr);
}

test bool test24()
{
	str expr=
	"switch( $a ) 
	{ 
		case ($b):
			echo $a;
			break;
		case (1):
			echo $a;
			break;
		case(\"a\"):
			echo $a;
			break;
		default:
			echo $a;
	}";	
	
	set[Constraint] soln={
	  yieldFlow(
	    lab(1),
	    lab(2)),
	  yieldFlow(
	    lab(1),
	    lab(6)),
	  yieldFlow(
	    lab(1),
	    lab(10)),
	  expectType(
	    lab(3),
	    typeSet({String()})),
	  yieldType(
	    lab(6),
	    typeSet({Int()})),
	  expectType(
	    lab(7),
	    typeSet({String()})),
	  yieldType(
	    lab(10),
	    typeSet({String()})),
	  expectType(
	    lab(11),
	    typeSet({String()})),
	  expectType(
	    lab(14),
	    typeSet({String()})),
	yieldType(lab(1),fromVar(var("a"))),
	yieldType(lab(2),fromVar(var("b"))),
	yieldType(lab(3),fromVar(var("a"))),
	yieldType(lab(7),fromVar(var("a"))),
	yieldType(lab(11),fromVar(var("a"))),
	yieldType(lab(14),fromVar(var("a")))	    
	};
	
	return assertEquals(soln,expr);
}

test bool test25()
{
	str expr=
			"while( $a )
	{
		$b=2;
		$c=1;
	}";
	
	set[Constraint] soln={
	  expectType(
	    lab(1),
	    typeSet({Bool()})),
	  yieldFlow(
	    lab(2),
	    lab(3)),
	  yieldFlow(
	    lab(4),
	    lab(3)),
	  yieldType(
	    lab(3),
	    typeSet({Int()})),
	  yieldFlow(
	    lab(6),
	    lab(7)),
	  yieldFlow(
	    lab(8),
	    lab(7)),
	  yieldType(
	    lab(7),
	    typeSet({Int()})),
	  yieldType(lab(1),fromVar(var("a")))
	};
	
	return assertEquals(soln,expr);
		
}

test bool test26()
{
	str expr=
	"$a=0;
	do
	{
		$a=$a+1;
	}while($a\<5);";
	
	set[Constraint]soln={
	  yieldFlow(
	    lab(1),
	    lab(2)),
	  yieldFlow(
	    lab(3),
	    lab(2)),
	  yieldType(
	    lab(2),
	    typeSet({Int()})),
	  expectType(
	    lab(7),
	    typeSet({Bool()})),
	  expectType(
	    lab(5),
	    typeSet({Num()})),
	  expectType(
	    lab(6),
	    typeSet({Num()})),
	  yieldType(
	    lab(7),
	    typeSet({Bool()})),
	  yieldType(
	    lab(6),
	    typeSet({Int()})),
	  yieldFlow(
	    lab(8),
	    lab(11)),
	  yieldFlow(
	    lab(12),
	    lab(11)),
	  expectType(
	    lab(9),
	    typeSet({Num()})),
	  expectType(
	    lab(10),
	    typeSet({Num()})),
	  yieldType(
	    lab(11),
	    typeSet({Num()})),
	  yieldType(
	    lab(10),
	    typeSet({Int()})),
	  yieldType(
	  	lab(9),
	  	fromVar(var("a"))),
	  yieldType(lab(5),fromVar(var("a")))
	};
	
	return assertEquals(soln,expr);	
	
}	

test bool test27()
{
	str expr=
	"for($a=\"a\",$b=0; $a \< \"abc\", $b\<5; $a++,$b++)
	{
		//do something useful
		$c=1;
	}";
	
	set[Constraint]soln={
	  yieldType(
	  	lab(13),
	  	fromVar(var("a"))),
	  yieldType(
	  	lab(15),
	  	fromVar(var("b"))),
	  expectType(
	    lab(9),
	    typeSet({Bool()})),
	  expectType(
	    lab(12),
	    typeSet({Bool()})),
	  yieldFlow(
	    lab(1),
	    lab(2)),
	  yieldFlow(
	    lab(3),
	    lab(2)),
	  yieldType(
	    lab(2),
	    typeSet({String()})),
	  yieldFlow(
	    lab(4),
	    lab(5)),
	  yieldFlow(
	    lab(6),
	    lab(5)),
	  yieldType(
	    lab(5),
	    typeSet({Int()})),
	  expectType(
	    lab(7),
	    typeSet({Num()})),
	  expectType(
	    lab(8),
	    typeSet({Num()})),
	  yieldType(
	    lab(9),
	    typeSet({Bool()})),
	  yieldType(
	    lab(8),
	    typeSet({String()})),
	  expectType(
	    lab(10),
	    typeSet({Num()})),
	  expectType(
	    lab(11),
	    typeSet({Num()})),
	  yieldType(
	    lab(12),
	    typeSet({Bool()})),
	  yieldType(
	    lab(11),
	    typeSet({Int()})),
	  expectType(
	    lab(13),
	    typeSet({Int()})),
	  yieldType(
	    lab(14),
	    typeSet({Int()})),
	  expectType(
	    lab(15),
	    typeSet({Int()})),
	  yieldType(
	    lab(16),
	    typeSet({Int()})),
	  yieldFlow(
	    lab(17),
	    lab(18)),
	  yieldFlow(
	    lab(19),
	    lab(18)),
	  yieldType(
	    lab(18),
	    typeSet({Int()})),
	  yieldType(lab(7),fromVar(var("a"))),
	  yieldType(lab(10),fromVar(var("b")))
	  
	};
	
	return assertEquals(soln,expr);
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	