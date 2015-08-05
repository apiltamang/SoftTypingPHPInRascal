module tests::soft::typing::php::constraints::Test_GetConstraints_Suite2

import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::constraints::GetConstraints; 

import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::constraints::Test_GetConstraints_Helper;
import List;
import IO;

import soft::typing::php::declarations::PublicDataTypes;

test bool test28()
{
str expr="$a[5]";
set[Constraint] soln={
  expectType(
    lab(2),
    typeSet({
        String(),
        Int()
      })),
  yieldType(
    lab(3),
    fromArray(lab(1))),
  yieldType(
    lab(2),
    typeSet({Int()})),
  expectType(
    lab(1),
    typeSet({Array(Any())}))
};
return assertEquals(soln,expr);
}

test bool test29()
{
str expr="array(\"a\",1,true)";
set[Constraint] soln={
 yieldType(
    lab(3),
    typeSet({Bool()})),
  yieldType(
    lab(1),
    typeSet({String()})),
  yieldType(
    lab(2),
    typeSet({Int()})),
  yieldType(
    lab(4),
    toArraySet({
        lab(1),
        lab(2),
        lab(3)
      }))
};
return assertEquals(soln,expr);
}

test bool test30()
{
str expr="count($a)";
set[Constraint] soln={
  yieldType(
    lab(2),
    typeSet({Int()})),
  expectType(
    lab(1),
    typeSet({Array(Any())}))
};
return assertEquals(soln,expr);
}

test bool test31()
{
str expr="$a=count($b)";
set[Constraint] soln={
  yieldFlow(
    lab(1),
    lab(3)),
  yieldFlow(
    lab(4),
    lab(3)),
  yieldType(
    lab(3),
    typeSet({Int()})),
  expectType(
    lab(2),
    typeSet({Array(Any())})),
  yieldType(lab(2),fromVar(var("b")))
};
return assertEquals(soln,expr);
}

test bool test32()
{
str expr="count(array(\"a\",1,true))";

set[Constraint] soln={
  yieldType(
    lab(5),
    typeSet({Int()})),
  expectType(
    lab(4),
    typeSet({Array(Any())})),
  yieldType(
    lab(4),
    toArraySet({
        lab(1),
        lab(2),
        lab(3)
      })),
  yieldType(
    lab(1),
    typeSet({String()})),
  yieldType(
    lab(2),
    typeSet({Int()})),
  yieldType(
    lab(3),
    typeSet({Bool()}))
};
return assertEquals(soln,expr);
}

test bool test33()
{
str expr="$a=$b[5]";
set[Constraint] soln={
  yieldFlow(
    lab(1),
    lab(4)),
  yieldFlow(
    lab(5),
    lab(4)),
  expectType(
    lab(2),
    typeSet({Array(Any())})),
  expectType(
    lab(3),
    typeSet({
        Int(),
        String()
      })),
  yieldType(
    lab(4),
    fromArray(lab(2))),
  yieldType(
    lab(3),
    typeSet({Int()})),
  yieldType(lab(2),fromVar(var("b")))
};
return assertEquals(soln,expr);
}

test bool test34()
{
str expr="$a=array(\"1\",2,true)";
set[Constraint] soln={
  yieldFlow(
    lab(1),
    lab(5)),
  yieldFlow(
    lab(6),
    lab(5)),
  yieldType(
    lab(5),
    toArraySet({
        lab(2),
        lab(3),
        lab(4)
      })),
  yieldType(
    lab(2),
    typeSet({String()})),
  yieldType(
    lab(3),
    typeSet({Int()})),
  yieldType(
    lab(4),
    typeSet({Bool()}))
};
return assertEquals(soln,expr);
}

test bool test35()
{
str expr="$a[1]=2";
set[Constraint] soln={
  yieldType(
    lab(1),
    toArray(lab(4))),
  expectType(
    lab(1),
    typeSet({Array(Any())})),
  expectType(
    lab(2),
    typeSet({
        Int(),
        String()
      })),
  yieldType(
    lab(3),
    fromArray(lab(1))),
  yieldType(
    lab(2),
    typeSet({Int()})),
  yieldType(
    lab(4),
    typeSet({Int()}))
};

return assertEquals(soln,expr);
}

test bool test36()
{
str expr="$a=2*$b[2]";
set[Constraint] soln={
  yieldFlow(
    lab(1),
    lab(6)),
  yieldFlow(
    lab(7),
    lab(6)),
  expectType(
    lab(2),
    typeSet({Num()})),
  expectType(
    lab(5),
    typeSet({Num()})),
  yieldType(
    lab(6),
    typeSet({Num()})),
  yieldType(
    lab(2),
    typeSet({Int()})),
  expectType(
    lab(3),
    typeSet({Array(Any())})),
  expectType(
    lab(4),
    typeSet({
        Int(),
        String()
      })),
  yieldType(
    lab(5),
    fromArray(lab(3))),
  yieldType(
    lab(4),
    typeSet({Int()})),
  yieldType(lab(3),fromVar(var("b")))
};
return assertEquals(soln,expr);
}

test bool test37()
{
str expr="$a[2]=$b[2]";
set[Constraint] soln={
  yieldType(
    lab(1),
    toArray(lab(6))),
  expectType(
    lab(1),
    typeSet({Array(Any())})),
  expectType(
    lab(2),
    typeSet({
        Int(),
        String()
      })),
  yieldType(
    lab(3),
    fromArray(lab(1))),
  yieldType(
    lab(2),
    typeSet({Int()})),
  expectType(
    lab(4),
    typeSet({Array(Any())})),
  expectType(
    lab(5),
    typeSet({
        Int(),
        String()
      })),
  yieldType(
    lab(6),
    fromArray(lab(4))),
  yieldType(
    lab(5),
    typeSet({Int()}))
};
return assertEquals(soln,expr);
}

test bool test38()
{
str expr="$a[3]=$a+$b*$c[\'name\']";
set[Constraint] soln={
  yieldType(
    lab(1),
    toArray(lab(10))),
  expectType(
    lab(1),
    typeSet({Array(Any())})),
  expectType(
    lab(2),
    typeSet({
        Int(),
        String()
      })),
  yieldType(
    lab(3),
    fromArray(lab(1))),
  yieldType(
    lab(2),
    typeSet({Int()})),
  expectType(
    lab(4),
    typeSet({Num()})),
  expectType(
    lab(9),
    typeSet({Num()})),
  yieldType(
    lab(10),
    typeSet({Num()})),
  expectType(
    lab(5),
    typeSet({Num()})),
  expectType(
    lab(8),
    typeSet({Num()})),
  yieldType(
    lab(9),
    typeSet({Num()})),
  expectType(
    lab(6),
    typeSet({Array(Any())})),
  expectType(
    lab(7),
    typeSet({
        Int(),
        String()
      })),
  yieldType(
    lab(8),
    fromArray(lab(6))),
  yieldType(
    lab(7),
    typeSet({String()})),
  yieldType(
    lab(6),
    fromVar(var("c"))),
  yieldType(
    lab(5),
    fromVar(var("b"))),
  yieldType(
    lab(4),
    fromVar(var("a")))
};
return assertEquals(soln,expr);
}






