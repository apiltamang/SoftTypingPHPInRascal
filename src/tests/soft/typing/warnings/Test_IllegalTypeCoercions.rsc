module tests::soft::typing::warnings::Test_IllegalTypeCoercions
import IO;
import lang::php::analysis::cfg::Label;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::Utils::Analysis;
import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::warnings::TypeCoercionCheckers;

import tests::soft::typing::php::helper::Test_SetComparator;

private loc localP=rootP+"Test_IllegalTypeCoercions";

test bool getWarningValues()
{
	Type tInt=Int();
	Type tNum=Num();
	Type tBoo=Bool();
	Type tStr=String();
	Type tAny=Any();
	Type tFlt=Float();
	
	list[num] solns=[];
	
	
	solns+=[generateTypeCoercionValue(tBoo,tFlt)]; //1
	
	solns+=[generateTypeCoercionValue(tAny,tAny)]; //0
	
	solns+=[generateTypeCoercionValue(Array(tInt),Array(tInt))]; //0
	
	solns+=[generateTypeCoercionValue(Array(tInt),Array(tAny))]; //0
	
	solns+=[generateTypeCoercionValue(Array(tBoo),Array(tInt))]; //1
	
	solns+=[generateTypeCoercionValue(Array(tAny),Array(tInt))]; //0
	
	solns+=[generateTypeCoercionValue(Array(Array(tBoo)),Array(tFlt))]; //1.
	
	solns+=[generateTypeCoercionValue(Array(Array(tBoo)),Array(Array(tBoo)))];  //0
	
	solns+=[generateTypeCoercionValue(Array(Array(tStr)),Array(Array(tBoo)))];  //1
	
	solns+=[generateTypeCoercionValue(Array(Array(tBoo)),Array(Array(tAny)))];  //0
	
	list[num] expect= [1,0,0,0,1,0,1,0,1,0];
	
	return (solns==expect);
}

test bool test_IllegalIntCoercions()
{
	fileTest="IllegalIntCoercions.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo= <("IllegalIntCoercions.php":(
	    lab(20):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()})
	    ),
	    lab(22):(
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot()
	    ),
	    lab(23):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()})
	    ),
	    lab(17):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()})
	    ),
	    lab(7):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({String()}),
	      var("c"):nullTypeRoot()
	    ),
	    lab(3):(
	      var("a"):typeSet({Int()}),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot()
	    ),
	    lab(14):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()})
	    ),
	    lab(11):(
	      var("a"):typeSet({Int()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()})
	    )
	  )),("IllegalIntCoercions.php":[
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(16). Got: String(). Expected from: {Int()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(19). Got: Float(). Expected from: {Int()}.")
	  ])>;	
	//return <AppExitEnvms,AppWarnings>;
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generateWarnings");	
}

test bool test_IllegalBoolCoercions()
{

	fileTest="IllegalBoolCoercions.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo= <("IllegalBoolCoercions.php":(
	    lab(21):(
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(16):(
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(28):(
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    ),
	    lab(29):(
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(26):(
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(7):(
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    ),
	    lab(3):(
	      var("a"):typeSet({Bool()}),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    ),
	    lab(11):(
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):nullTypeRoot()
	    )
	  )),("IllegalBoolCoercions.php":[
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(19). Got: String(). Expected from: {Bool()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(24). Got: Float(). Expected from: {Bool()}.")
	  ])>;	
	  
	  
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generateWarnings");	
}

test bool test_IllegalNumCoercions()
{

	fileTest="IllegalNumCoercions.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectInfo= <("IllegalNumCoercions.php":(
	    lab(20):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Int()})
	    ),
	    lab(30):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Int()})
	    ),
	    lab(25):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Int()})
	    ),
	    lab(37):(
	      var("d"):nullTypeRoot(),
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    ),
	    lab(38):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Int()})
	    ),
	    lab(7):(
	      var("d"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    ),
	    lab(15):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):nullTypeRoot()
	    ),
	    lab(11):(
	      var("d"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):nullTypeRoot()
	    ),
	    lab(35):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Int()})
	    ),
	    lab(3):(
	      var("d"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    )
	  )),("IllegalNumCoercions.php":[
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(18). Got: Bool(). Expected from: {Num()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(23). Got: String(). Expected from: {Num()}.")
	  ])>;	
	//return <AppExitEnvms,AppWarnings>;
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generateWarnings");

}

test bool test_IllegalBinaryNumOpCoercions()
{

	fileTest="IllegalBinaryNumOpCoercions.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	expectInfo= <("IllegalBinaryNumOpCoercions.php":(
	    lab(21):(
	      var("d"):typeSet({Int()}),
	      var("foo"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Num()})
	    ),
	    lab(61):(
	      var("d"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    ),
	    lab(62):(
	      var("d"):typeSet({Int()}),
	      var("foo"):typeSet({Num()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Num()})
	    ),
	    lab(33):(
	      var("d"):typeSet({Int()}),
	      var("foo"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Num()})
	    ),
	    lab(3):(
	      var("d"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    ),
	    lab(45):(
	      var("d"):typeSet({Int()}),
	      var("foo"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Num()})
	    ),
	    lab(15):(
	      var("d"):typeSet({Int()}),
	      var("foo"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):nullTypeRoot()
	    ),
	    lab(11):(
	      var("d"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):nullTypeRoot()
	    ),
	    lab(59):(
	      var("d"):typeSet({Int()}),
	      var("foo"):typeSet({Num()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Num()})
	    ),
	    lab(27):(
	      var("d"):typeSet({Int()}),
	      var("foo"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Num()})
	    ),
	    lab(39):(
	      var("d"):typeSet({Int()}),
	      var("foo"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("test"):typeSet({Num()})
	    ),
	    lab(7):(
	      var("d"):nullTypeRoot(),
	      var("foo"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    )
	  )),("IllegalBinaryNumOpCoercions.php":[
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(30). Got: Bool(). Expected from: {Num()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(31). Got: String(). Expected from: {Num()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(36). Got: String(). Expected from: {Num()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(43). Got: Bool(). Expected from: {Num()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(57). Got: String(). Expected from: {Num()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(53). Got: String(). Expected from: {Num()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(49). Got: Bool(). Expected from: {Num()}.")
	  ])>;	
	//return <AppExitEnvms,AppWarnings>;
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generateWarnings");	

}

test bool test_IllegalStringInConcatOpCoercions()
{

	fileTest="IllegalStringInConcatOpCoercions.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo= <("IllegalStringInConcatOpCoercions.php":(
	    lab(21):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({String()})
	    ),
	    lab(27):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({String()})
	    ),
	    lab(33):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({String()})
	    ),
	    lab(3):(
	      var("d"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(15):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):nullTypeRoot()
	    ),
	    lab(41):(
	      var("d"):nullTypeRoot(),
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(42):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({String()})
	    ),
	    lab(11):(
	      var("d"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):nullTypeRoot()
	    ),
	    lab(39):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({String()})
	    ),
	    lab(7):(
	      var("d"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    )
	  )),("IllegalStringInConcatOpCoercions.php":[
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(24). Got: Bool(). Expected from: {String()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(25). Got: Float(). Expected from: {String()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(30). Got: Float(). Expected from: {String()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(31). Got: Int(). Expected from: {String()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(37). Got: Bool(). Expected from: {String()}.")
	  ])>;	
	//return <AppExitEnvms,AppWarnings>;
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generateWarnings");	

}

test bool test_IllegalCondExprInTernaryOp()
{

	fileTest="IllegalCondExprInTernaryOp.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectInfo= <("IllegalCondExprInTernaryOp.php":(
	    lab(22):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({
	          String(),
	          Int()
	        })
	    ),
	    lab(48):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({
	          String(),
	          Int()
	        })
	    ),
	    lab(31):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({
	          String(),
	          Int()
	        })
	    ),
	    lab(7):(
	      var("d"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(3):(
	      var("d"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(44):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):nullTypeRoot()
	    ),
	    lab(46):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({
	          String(),
	          Int()
	        })
	    ),
	    lab(15):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):nullTypeRoot()
	    ),
	    lab(40):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({
	          String(),
	          Int()
	        })
	    ),
	    lab(42):(
	      var("d"):nullTypeRoot(),
	      var("a"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("t"):nullTypeRoot()
	    ),
	    lab(43):(
	      var("d"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):typeSet({
	          String(),
	          Int()
	        })
	    ),
	    lab(11):(
	      var("d"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("t"):nullTypeRoot()
	    )
	  )),("IllegalCondExprInTernaryOp.php":[
	    varHasMultipleTypes("Var t acquired more than one types at lab(22)."),
	    //varHasMultipleTypes("Var t acquired more than one types at lab(46)."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(27). Got: String(). Expected from: {Bool()}."),
	    //varHasMultipleTypes("Var t acquired more than one types at lab(31)."),
	    //varHasMultipleTypes("Var t acquired more than one types at lab(48)."),
	    equalTypesExpectedFail("Type-set yield for lab(34): {Float()}. Type-set yield for lab(35): {String()}.")
	    //varHasMultipleTypes("Var t acquired more than one types at lab(40).")
	  ])>;	
	//return <AppExitEnvms,AppWarnings>;
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generateWarnings");	

}

/*
test bool test_IllegalCondExprInTernaryOp_2()
{

	fileTest="IllegalCondExprInTernaryOp_2.php";
	exitEnvm=runAnalysis(localP,fileTest);
	
	return false;
}*/

test bool test_IllegalArrayCoercions()
{

	fileTest="IllegalArrayCoercions.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectInfo=
	<("IllegalArrayCoercions.php":(
	    lab(54):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):typeSet({Array(Int())}),
	      var("t"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(82):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):typeSet({Array(Int())}),
	      var("t"):typeSet({String()}),
	      var("a"):typeSet({Array(Bool())}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(31):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):nullTypeRoot(),
	      var("t"):typeSet({String()}),
	      var("a"):typeSet({Bool()}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(88):(
	      var("d"):typeSet({Int()}),
	      var("e"):typeSet({Array(String())}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):typeSet({Array(Int())}),
	      var("t"):typeSet({String()}),
	      var("a"):typeSet({Array(Bool())}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(25):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):nullTypeRoot(),
	      var("t"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(68):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):typeSet({Array(Int())}),
	      var("t"):typeSet({String()}),
	      var("a"):typeSet({Bool()}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(37):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):nullTypeRoot(),
	      var("t"):typeSet({Void()}),
	      var("a"):typeSet({Bool()}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(102):(
	      var("d"):typeSet({Int()}),
	      var("e"):typeSet({Array(String())}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):typeSet({Array(Int())}),
	      var("t"):typeSet({String()}),
	      var("a"):typeSet({Array(Bool())}),
	      var("arr"):typeSet({
	          Array(String()),
	          Array(Float())
	        })
	    ),
	    lab(7):(
	      var("d"):nullTypeRoot(),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):nullTypeRoot(),
	      var("numArr"):nullTypeRoot(),
	      var("t"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("arr"):nullTypeRoot()
	    ),
	    lab(3):(
	      var("d"):nullTypeRoot(),
	      var("e"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("numArr"):nullTypeRoot(),
	      var("t"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("arr"):nullTypeRoot()
	    ),
	    lab(76):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):typeSet({Array(Int())}),
	      var("t"):typeSet({String()}),
	      var("a"):typeSet({Bool()}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(104):(
	      var("d"):nullTypeRoot(),
	      var("e"):nullTypeRoot(),
	      var("b"):nullTypeRoot(),
	      var("c"):nullTypeRoot(),
	      var("numArr"):nullTypeRoot(),
	      var("t"):nullTypeRoot(),
	      var("a"):nullTypeRoot(),
	      var("arr"):nullTypeRoot()
	    ),
	    lab(105):(
	      var("d"):typeSet({Int()}),
	      var("e"):typeSet({Array(String())}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):typeSet({Array(Int())}),
	      var("t"):typeSet({String()}),
	      var("a"):typeSet({Array(Bool())}),
	      var("arr"):typeSet({
	          Array(String()),
	          Array(Float())
	        })
	    ),
	    lab(42):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):nullTypeRoot(),
	      var("t"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(11):(
	      var("d"):nullTypeRoot(),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):nullTypeRoot(),
	      var("t"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("arr"):nullTypeRoot()
	    ),
	    lab(94):(
	      var("d"):typeSet({Int()}),
	      var("e"):typeSet({Array(String())}),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):typeSet({Array(Int())}),
	      var("t"):typeSet({String()}),
	      var("a"):typeSet({Array(Bool())}),
	      var("arr"):typeSet({
	          Array(String()),
	          Array(Float())
	        })
	    ),
	    lab(62):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):typeSet({Array(Int())}),
	      var("t"):typeSet({Num()}),
	      var("a"):typeSet({Bool()}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(47):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):nullTypeRoot(),
	      var("t"):typeSet({Int()}),
	      var("a"):typeSet({Bool()}),
	      var("arr"):typeSet({Array(String())})
	    ),
	    lab(15):(
	      var("d"):typeSet({Int()}),
	      var("e"):nullTypeRoot(),
	      var("b"):typeSet({String()}),
	      var("c"):typeSet({Float()}),
	      var("numArr"):nullTypeRoot(),
	      var("t"):nullTypeRoot(),
	      var("a"):typeSet({Bool()}),
	      var("arr"):nullTypeRoot()
	    )
	  )),("IllegalArrayCoercions.php":[
	    readFromNonArrayVal("Expected array @ lab(34). Got Non-array: typeSet({Float()})."),
	    usingVoidTypeForExpr("Computed typeSet for lab(33) has Void type."),
	    assignVoidTypeToVar("Assigning a Void type to var(t) @ lab(33)."),
	    typeOfVarChanged(" Var(t) changed type @ lab(33) from {String()} to {Void()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(34). Got: Float(). Expected from: {Array(Any())}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(40). Got: Int(). Expected from: {Array(Any())}."),
	    typeOfVarChanged(" Var(t) changed type @ lab(64) from {Num()} to {String()}."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(66). Got: Array(Int()). Expected from: {String()}."),
	    typeCoercionWarning("Trying to add key -\> value pair to non-Array: var(a) @ lab(78)."),
	    typeOfVarChanged(" Var(a) changed type @ lab(78) from {Bool()} to {Array(Bool())}."),
	    noWarning("Processed constraint to add new Array: var(e) @ lab(84)."),
	    noWarning("Processed constraint to add type to Array: var(arr) @ lab(90)."),
	    typeOfVarChanged(" Var(arr) changed type @ lab(90) from {Array(String())} to {Array(String()),Array(Float())}."),
	    varHasMultipleTypes("Var arr acquired more than one types at lab(94)."),
	    typeCoercionWarning("Possible Illegal Type Coercion @ lab(100). Got: Float(). Expected from: {String()}.")
	  ])>;
	  //return <AppExitEnvms,AppWarnings>;
	  return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generateWarnings");
}

test bool test_IllegalArrayCoercions2()
{

	fileTest="IllegalArrayCoercions2.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectInfo=

	<("IllegalArrayCoercions2.php":(lab(22):(
	      var("arr"):typeSet({
	          Array(String()),
	          Array(Array(Int()))
	        }),
	      var("brr"):typeSet({String()})
	    ),
	    lab(28):(
	      var("arr"):typeSet({
	          Array(String()),
	          Array(Array(Int()))
	        }),
	      var("brr"):typeSet({
	          Array(String()),
	          Array(Int())
	        })
	    ),
	    lab(30):(
	      var("arr"):nullTypeRoot(),
	      var("brr"):nullTypeRoot()
	    ),
	    lab(31):(
	      var("arr"):typeSet({
	          Array(String()),
	          Array(Array(Int()))
	        }),
	      var("brr"):typeSet({
	          Array(String()),
	          Array(Int())
	        })
	    ),
	    lab(13):(
	      var("arr"):typeSet({Array(String())}),
	      var("brr"):typeSet({String()})
	    ),
	    lab(9):(
	      var("arr"):typeSet({Array(String())}),
	      var("brr"):nullTypeRoot()
	    )
	  )),("IllegalArrayCoercions2.php":[
	    noWarning("Processed constraint to add type to Array: var(arr) @ lab(15)."),
	    typeOfVarChanged(" Var(arr) changed type @ lab(15) from {Array(String())} to {Array(String()),Array(Array(Int()))}."),
	    varHasMultipleTypes("Var arr acquired more than one types at lab(22)."),
	    typeCoercionWarning("Trying to add key -\> value pair to non-Array: var(brr) @ lab(24)."),
	    typeOfVarChanged(" Var(brr) changed type @ lab(24) from {String()} to {Array(String()),Array(Int())}."),
	    varHasMultipleTypes("Var brr acquired more than one types at lab(28).")
	  ])>;	
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generateWarnings");
}