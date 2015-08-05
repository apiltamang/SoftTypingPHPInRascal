module soft::typing::php::elements::Class

import lang::php::ast::AbstractSyntax;
import lang::php::analysis::cfg::Label;

import soft::typing::php::constraints::ConstraintHelper;
import soft::typing::php::Utils::Analysis;
import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;


import soft::typing::php::constraints::GetConstraints;
import soft::typing::php::Utils::GenericHelpers;
import Set;
import IO;
public map[str, ClassScheme] extractClassDefs(Script scr)
{
	definedClasses = {cd| /cd:class(_,_,_,_,_) := scr };
	
	map[str,ClassScheme] classMap =( );
	
	for(ClassDef aClass<- definedClasses)
	{
		//declare some variables
		set[ClassElement] fields={}; //container to hold the fields
		
		//container to hold default value types for class fields
		map[Identifier,TypeRoot] fieldToTypeMap=( ); 
		
		//containter to hold default types for static class fields only
		map[Identifier,TypeRoot] staticFieldToTypeMap=( );
		
		//define container for methods;
		set[ClassElement] methods={ };
		
		//for each class..
		for(ClassItem item<-aClass.members)
		{
			//grab the class fields
			if(property(_,_):=item)
			{
				for(Property prop<-item.prop)
				{
					ClassElement aField=
						field(item.modifiers,var(prop.propertyName));
					fields+=aField;
					
					//Now see if the field has been instantiated to any 
					//constant or literal value;
					if(static() in item.modifiers)
						staticFieldToTypeMap +=(var(prop.propertyName):getDefaultTypeOfClassField(prop));
					else
						fieldToTypeMap +=(var(prop.propertyName):getDefaultTypeOfClassField(prop));
					
							
				}
			}//end if
			
			//grab references to class methods
			if(method(name,modifiers,byRef,params,body):=item)
				methods+=method(modifiers,name,params);
			
			
		}//end for, iterate through class members
		
		//instantiate an initInst classinstance type. This will store the initialization
		//value of all the non-static fields declared in the class definition
		thisInitialInstance=
			initInst(fieldToTypeMap);
		
		//instantiate a statInst classInstance type. This will store typeRoot information 
		//for all static variables in the class definition.
		ClassInstanceId=ClassInstanceId+1;
		thisStaticInstance=
			statInst(ClassInstanceId,staticFieldToTypeMap,aClass.className);
		
		//Now store this static instance of the class to the global class-instance store
		HandleToClassInstanceMap[objHd(ClassInstanceId)]=thisStaticInstance;
		
		//define a temporary empty handle set. This will eventually store object instances
		//that were spawned from this class.
		set[Handle] emptyHandleSet={ };
			
		classMap +=
		(aClass.className:
			classScheme(aClass.className
					   ,getParentOfClass(aClass),fields,methods,thisInitialInstance,
					   thisStaticInstance, emptyHandleSet)
		);
			
	}//end for, iterate through class definitions
	
	return classMap;
}

public str getParentOfClass(ClassDef aClass)
{
	OptionName pName=aClass.extends;
	if(someName(name(str parentName)):=pName)
		return parentName;
	else if(noName():=pName)
		return "";
	else
		throw Exception("Error while getting parent name of a class.\n Got name: <pName>");
}

//get default types
public TypeRoot getDefaultTypeOfClassField(Property prop)
{
	OptionExpr defexpr=prop.defaultValue;
	if(defexpr is someExpr)
	{
		constraints=extractConstraints(defexpr.expr);
		assert(size(constraints)==1)
			:"a class field initialization must generate only one constraints";
		
		if(yieldType(Lab l,TypeRoot gotTypeRoot):=getOneFrom(constraints))
			return gotTypeRoot;
		else
			throw Exception("a class field initialization must generate only one
				constraints of type: yieldType.\n Got constraints: <constraints>\n");
		
		
	}
	else if(defexpr is noExpr)
	{
		
		return nullTypeRoot();
	}
	else
	{
		throw Exception("Invalid OptionExpr node received while determining
			defaultValue of a Class field. \n
			Expected: noExpr() or someExpr(Expr expr), but got: <expr>");
	}//end if
}//end method

public map[Identifier,TypeRoot] 
	mapConstructorParamsToClassFields(str cName,list[TypeRoot] paramsType)
{
	//For all the instance fields that are provided as parameters, 
	//initialize them as available. For fields that are not provided,
	//set them to null.
	
	ClassScheme currClass=GlobalClassDeclsMap[cName]; 
	map[Identifier,TypeRoot] toRet=();
	
	
	//look for all instance variables in the class scheme.
	instanceIdfs={v.prop|
		v<-currClass.fields, static() notin v.modifiers};
	
	//Now see if you can find any variables that were initialized in the class
	//declaration... this information is stored in the initInst parameter 
	//of the object. For any variables not initialized, they're assigned a 
	//default value of nullTypeRoot.
	ClassInstance initInstance=GlobalClassDeclsMap[cName].initInstance;
	
	//iterate through all the non-static fields
	for(Identifier idf<- instanceIdfs)
	{
		assert idf in initInstance.fieldToTypeMap : 
			"Static Instance Of Class must have reference to all instance fields.";
		toRet[idf]=initInstance.fieldToTypeMap[idf];	
	} 
		
	return toRet; //return empty map for now.
	
}

public set[ClassTemplate] getMemberClassTemplates(map[Identifier,TypeRoot] fieldToTypeMap)
{
	set[ClassTemplate] templates={};
	return templates; //return empty set for now
}


public tuple[TypeRoot got,list[Warning] warns] getTypeRootOfFieldFromObject(ClassInstance obj, Identifier fieldName,list[Warning] warns, Lab l)
{
	TypeRoot temp=nullTypeRoot();
	
	if(fieldName in obj.fieldToTypeMap)
	{
		temp =obj.fieldToTypeMap[fieldName];
		
		if(temp is nullTypeRoot) //which it could be if object field hasn't been initialized yet,
		{
			temp=typeSet({Void()});
			warns+=[readUninitializedClassProperty("Attempt to read un-initialized object property: var(<fieldName.name>) @ <l>.")]; 
		}	
	}
	else
	{
		temp=typeSet({Void()});
		warns+=[accessUndefinedClassProperty("Attempt to access un-defined object property: var(<fieldName.name>) @ <l>.")];
	}
	
	return <temp,warns>;
		
}

//---------------------------------------------------
public str getMethodCallType(str srcClass,str fName)
{
	//at this point, it has already been checked and
	//verified that definiton for srcClass exists, so no need to check again
	
	//get the class decl of given src class:
	ClassScheme thisClass=GlobalClassDeclsMap[srcClass];
	
	set[ClassElement] methods=thisClass.methods;
	
	methodName=srcClass+"."+fName;
	if(methodName notin GlobalFuncDeclsMap)
		return "non-exist-method";
		
	//also, already verified that fName is in the class; if not, returns
	// 'non-exist-method'. See previous statement...
	myMethod=getElementFromSingletonList([mm | mm<-methods,mm.name==fName]);
	
	set[Modifier] myModifiers=myMethod.modifiers;
	
	Modifier staticModifier=static();
	//now finally, see if it static or instance method
	if(staticModifier in myModifiers)
		return "staticCall";
	else
		return "instanceCall";
	
}