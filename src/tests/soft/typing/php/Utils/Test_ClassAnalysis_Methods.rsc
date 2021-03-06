module tests::soft::typing::php::Utils::Test_ClassAnalysis_Methods
import IO;
import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::Utils::Analysis;
import lang::php::analysis::cfg::Label;
import tests::soft::typing::php::helper::Test_SetComparator;

private loc localP=rootP+"Test_ClassAnalysis_Methods";
test bool testClassMethod_TestA()
{

	fileTest="Class_InstanceMethod_TestA.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	
	expectedApplicationEnvms=
	(
	  "MyClass.returnInstanceVar":(
	    lab(65):(var("this"):nullTypeRoot()),
	    lab(66):(var("this"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("instanceVar"):typeSet({Float()})),
	              "MyClass",
	              {}))})),
	    lab(3):(var("this"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("instanceVar"):typeSet({Float()})),
	              "MyClass",
	              {}))}))
	  ),
	  "MyClass.printInstanceVar":(
	    lab(21):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("instanceVar"):nullTypeRoot()),
	              "MyClass",
	              {}))}),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({
	          String(),
	          Bool()
	        })
	    ),
	    lab(18):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):nullTypeRoot(),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({
	          String(),
	          Bool()
	        })
	    ),
	    lab(31):(
	      var("got"):typeSet({Float()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("instanceVar"):typeSet({Float()})),
	              "MyClass",
	              {}))}),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({
	          String(),
	          Bool()
	        })
	    ),
	    lab(26):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("instanceVar"):typeSet({Float()})),
	              "MyClass",
	              {}))}),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({
	          String(),
	          Bool()
	        })
	    ),
	    lab(69):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):nullTypeRoot(),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):nullTypeRoot()
	    ),
	    lab(67):(
	      var("got"):nullTypeRoot(),
	      var("this"):nullTypeRoot(),
	      var("nestObj"):nullTypeRoot(),
	      var("boolVal"):nullTypeRoot(),
	      var("intVal"):nullTypeRoot(),
	      var("test"):nullTypeRoot()
	    ),
	    lab(12):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):nullTypeRoot(),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({Bool()})
	    ),
	    lab(68):(
	      var("got"):typeSet({Float()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("instanceVar"):typeSet({Float()})),
	              "MyClass",
	              {}))}),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({
	          String(),
	          Bool()
	        })
	    ),
	    lab(4):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):nullTypeRoot(),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):nullTypeRoot()
	    ),
	    lab(70):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):nullTypeRoot(),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({
	          String(),
	          Bool()
	        })
	    ),
	    lab(38):(
	      var("got"):typeSet({Float()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("instanceVar"):typeSet({Float()})),
	              "MyClass",
	              {}))}),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({
	          String(),
	          Bool()
	        })
	    ),
	    lab(71):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):nullTypeRoot(),
	      var("boolVal"):nullTypeRoot(),
	      var("intVal"):typeSet({Int()}),
	      var("test"):nullTypeRoot()
	    ),
	    lab(39):(
	      var("got"):typeSet({Float()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("instanceVar"):typeSet({Float()})),
	              "MyClass",
	              {}))}),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({
	          String(),
	          Bool()
	        })
	    ),
	    lab(72):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):nullTypeRoot(),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):nullTypeRoot()
	    ),
	    lab(8):(
	      var("got"):nullTypeRoot(),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))}),
	      var("nestObj"):nullTypeRoot(),
	      var("boolVal"):typeSet({Bool()}),
	      var("intVal"):typeSet({Int()}),
	      var("test"):typeSet({String()})
	    )
	  ),
	  "Class_InstanceMethod_TestA.php":(
	    lab(52):(
	      var("boolVar"):nullTypeRoot(),
	      var("intVar"):typeSet({Int()}),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))})
	    ),
	    lab(48):(
	      var("boolVar"):nullTypeRoot(),
	      var("intVar"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))})
	    ),
	    lab(61):(
	      var("boolVar"):typeSet({Bool()}),
	      var("intVar"):typeSet({Int()}),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))})
	    ),
	    lab(63):(
	      var("boolVar"):nullTypeRoot(),
	      var("intVar"):nullTypeRoot(),
	      var("obj"):nullTypeRoot()
	    ),
	    lab(56):(
	      var("boolVar"):typeSet({Bool()}),
	      var("intVar"):typeSet({Int()}),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))})
	    ),
	    lab(64):(
	      var("boolVar"):typeSet({Bool()}),
	      var("intVar"):typeSet({Int()}),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):typeSet({String()})),
	              "MyClass",
	              {}))})
	    ),
	    lab(40):(
	      var("boolVar"):nullTypeRoot(),
	      var("intVar"):nullTypeRoot(),
	      var("obj"):nullTypeRoot()
	    ),
	    lab(43):(
	      var("boolVar"):nullTypeRoot(),
	      var("intVar"):nullTypeRoot(),
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("instanceVar"):nullTypeRoot()),
	              "MyClass",
	              {}))})
	    )
	  )
	);
	
	
	//check for correctness
	return assertEquals(AppExitEnvms,expectedApplicationEnvms,"map[str,map[Lab,TypeEnvironment]]","method_analysis");
}
		
test bool testClassMethod_TestB()
{
	
	fileTest="Class_StaticMethod_TestB.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectAppExitEnvms=
	(
	  "Class_StaticMethod_TestB.php":(
	    lab(20):(
	      var("gotVarA"):nullTypeRoot(),
	      var("gotVarB"):nullTypeRoot(),
	      var("aVal"):typeSet({Int()})
	    ),
	    lab(17):(
	      var("gotVarA"):nullTypeRoot(),
	      var("gotVarB"):nullTypeRoot(),
	      var("aVal"):typeSet({Int()})
	    ),
	    lab(28):(
	      var("gotVarA"):typeSet({Int()}),
	      var("gotVarB"):typeSet({Float()}),
	      var("aVal"):typeSet({Int()})
	    ),
	    lab(30):(
	      var("gotVarA"):nullTypeRoot(),
	      var("gotVarB"):nullTypeRoot(),
	      var("aVal"):nullTypeRoot()
	    ),
	    lab(31):(
	      var("gotVarA"):typeSet({Int()}),
	      var("gotVarB"):typeSet({Float()}),
	      var("aVal"):typeSet({Int()})
	    ),
	    lab(24):(
	      var("gotVarA"):typeSet({Int()}),
	      var("gotVarB"):nullTypeRoot(),
	      var("aVal"):typeSet({Int()})
	    ),
	    lab(14):(
	      var("gotVarA"):nullTypeRoot(),
	      var("gotVarB"):nullTypeRoot(),
	      var("aVal"):nullTypeRoot()
	    )
	  ),
	  "MyClass.setStaticVars":(
	    lab(7):(var("value"):typeSet({Int()})),
	    lab(32):(var("value"):nullTypeRoot()),
	    lab(33):(var("value"):typeSet({Int()})),
	    lab(34):(var("value"):typeSet({Int()})),
	    lab(3):(var("value"):typeSet({Int()})),
	    lab(9):(var("value"):typeSet({Int()}))
	  ),
	  "MyClass.getStaticVarA":(
	    lab(36):(),
	    lab(35):(),
	    lab(11):()
	  ),
	  "MyClass.getStaticVarB":(
	    lab(37):(),
	    lab(38):(),
	    lab(13):()
	  )
	);	
	return assertEquals(AppExitEnvms,expectAppExitEnvms,"map[str,map[Lab,TypeEnvironment]]","propagate");	
}

test bool testClassMethod_TestC()
{
	
	fileTest="Class_StaticMethod_TestC.php";
	//this test checks and sees if a function parameter that is bound to an object type
	//updates its value when the object undergoes change
	//while in the life of the function call.
	exitEnvm=runAnalysis(localP,fileTest);
 	expectExitEnvms=
	(
	  "MyClass.getStaticVar":(
	    lab(28):(),
	    lab(27):(),
	    lab(13):()
	  ),
	  "Class_StaticMethod_TestC.php":(
	    lab(20):(var("gotA"):typeSet({String()})),
	    lab(22):(var("gotA"):nullTypeRoot()),
	    lab(23):(var("gotA"):typeSet({String()})),
	    lab(16):(var("gotA"):nullTypeRoot()),
	    lab(1):(var("gotA"):nullTypeRoot()),
	    lab(14):(var("gotA"):nullTypeRoot())
	  ),
	  "MyClass.setStaticVar":(
	    lab(24):(var("value"):nullTypeRoot()),
	    lab(25):(var("value"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("your_class_instance_var"):typeSet({String()})),
	              "YourClass",
	              {}))})),
	    lab(26):(var("value"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("your_class_instance_var"):nullTypeRoot()),
	              "YourClass",
	              {}))})),
	    lab(5):(var("value"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("your_class_instance_var"):typeSet({String()})),
	              "YourClass",
	              {}))})),
	    lab(9):(var("value"):typeSet({Object(
	            objHd(3),
	            objInst(
	              3,
	              (var("your_class_instance_var"):typeSet({String()})),
	              "YourClass",
	              {}))}))
	  )
	);
	
	return assertEquals(AppExitEnvms,expectExitEnvms,"map[str,map[Lab,TypeEnvironment]]","propagate");
}

test bool testClassMethod_TestD()
{
	
	fileTest="Class_InstanceMethod_TestD.php";
	
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectInfo=
	<(
	  "Employee.getName":(
	    lab(38):(var("this"):nullTypeRoot()),
	    lab(39):(var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))})),
	    lab(14):(var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}))
	  ),
	  "Employee.getEmployee":(
	    lab(6):(var("a"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))})),
	    lab(33):(var("a"):nullTypeRoot()),
	    lab(34):(var("a"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))})),
	    lab(3):(var("a"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))}))
	  ),
	  "Employee.setName":(
	    lab(36):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))})
	    ),
	    lab(37):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))})
	    ),
	    lab(35):(
	      var("val"):nullTypeRoot(),
	      var("this"):nullTypeRoot()
	    ),
	    lab(10):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))})
	    )
	  ),
	  "Class_InstanceMethod_TestD.php":(
	    lab(22):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):nullTypeRoot()
	    ),
	    lab(18):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))}),
	      var("myName"):nullTypeRoot()
	    ),
	    lab(30):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):typeSet({String()})
	    ),
	    lab(31):(
	      var("obj"):nullTypeRoot(),
	      var("myName"):nullTypeRoot()
	    ),
	    lab(27):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):typeSet({String()})
	    ),
	    lab(32):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):typeSet({String()})
	    ),
	    lab(15):(
	      var("obj"):nullTypeRoot(),
	      var("myName"):nullTypeRoot()
	    )
	  )
	),(
	  "Employee.getName":[],
	  "Employee.getEmployee":[],
	  "Employee.setName":[],
	  "Class_InstanceMethod_TestD.php":[
	    usingVoidTypeForExpr("Computed typeSet for lab(22) has Void type."),
	    objChangedState("Object instance: var(obj) changed state in a func. or method body @ lab(22).")
	  ]
	)>;
	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");	
}

test bool testClassMethod_TestE()
{
	
	fileTest="Class_StaticInstanceMethod_TestE.php";
	
	exitEnvm=runAnalysis(localP,fileTest);

	expectExitEnvms=
	(
	  "Employee.getName":(
	    lab(16):(var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))})),
	    lab(38):(var("this"):nullTypeRoot()),
	    lab(39):(var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}))
	  ),
	  "Employee.getEmployee":(
	    lab(6):(var("a"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))})),
	    lab(33):(var("a"):nullTypeRoot()),
	    lab(34):(var("a"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))})),
	    lab(3):(var("a"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))}))
	  ),
	  "Class_StaticInstanceMethod_TestE.php":(
	    lab(22):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):nullTypeRoot()
	    ),
	    lab(17):(
	      var("obj"):nullTypeRoot(),
	      var("myName"):nullTypeRoot()
	    ),
	    lab(30):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):typeSet({String()})
	    ),
	    lab(31):(
	      var("obj"):nullTypeRoot(),
	      var("myName"):nullTypeRoot()
	    ),
	    lab(27):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):typeSet({String()})
	    ),
	    lab(32):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):typeSet({String()})
	    )
	  ),
	  "Employee.setName":(
	    lab(36):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))})
	    ),
	    lab(37):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))})
	    ),
	    lab(35):(
	      var("val"):nullTypeRoot(),
	      var("this"):nullTypeRoot()
	    ),
	    lab(13):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))})
	    ),
	    lab(10):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))})
	    )
	  )
	);
	
	return assertEquals(AppExitEnvms,expectExitEnvms,"map[str,map[Lab,TypeEnvironment]","propagate");	
}

test bool testClassMethod_TestF()
{
	
	fileTest="ClassMethod_TestF.php";
	
	//involves a method call that changes an object instance.
	//need to ensure that this causes the current var to update
	//its personal reference to the changed state
	exitEnvm=runAnalysis(localP,fileTest);
	
	expectInfo=
	<(
	  "Employee.setName":(
	    lab(25):(
	      var("val"):nullTypeRoot(),
	      var("this"):nullTypeRoot()
	    ),
	    lab(26):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))})
	    ),
	    lab(27):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))})
	    ),
	    lab(4):(
	      var("val"):typeSet({String()}),
	      var("this"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))})
	    )
	  ),
	  "ClassMethod_TestF.php":(
	    lab(21):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):typeSet({String()})
	    ),
	    lab(23):(
	      var("obj"):nullTypeRoot(),
	      var("myName"):nullTypeRoot()
	    ),
	    lab(16):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):nullTypeRoot()
	    ),
	    lab(24):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):typeSet({String()})),
	              "Employee",
	              {}))}),
	      var("myName"):typeSet({String()})
	    ),
	    lab(12):(
	      var("obj"):typeSet({Object(
	            objHd(2),
	            objInst(
	              2,
	              (var("name"):nullTypeRoot()),
	              "Employee",
	              {}))}),
	      var("myName"):nullTypeRoot()
	    ),
	    lab(9):(
	      var("obj"):nullTypeRoot(),
	      var("myName"):nullTypeRoot()
	    )
	  )
	),(
	  "Employee.setName":[],
	  "ClassMethod_TestF.php":[
	    usingVoidTypeForExpr("Computed typeSet for lab(16) has Void type."),
	    objChangedState("Object instance: var(obj) changed state in a func. or method body @ lab(16).")
	  ]
	)>;	
	return assertEquals(<AppExitEnvms,AppWarnings>,expectInfo,"AppInfo","generate warnings");
}