module soft::typing::php::functions::DeltaOperator
import soft::typing::php::constraints::ConstraintHelper;
import IO;
import Set;

import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;


private int ceiling=4;



public TypeRoot widen(TypeRoot t1, TypeRoot t2) 
{
	//The combination of t1 and t2 must follow certain well-defined guidelines:
	//TODO: Refine on this
	
	bool t1TypeIsInt=false;
	bool t2TypeIsInt=false;
	//For now, just combine the two typeroots	
	
	//first check that neither of them are nullTypeRoots
	if(t1 is nullTypeRoot)
		return t2;

	if(t2 is nullTypeRoot)
		return t1;

	if(t1==t2)
		return t2;

	objectTypesOfT1=getObjectTypesFrom(t1);
	
	objectTypesOfT2=getObjectTypesFrom(t2);
	
	
	combinedObjectHandles=
		resolveCombinationInvolvingObjectHandles(objectTypesOfT1,objectTypesOfT2);
	
	//get the elements from sets t1 and t2 and combine into a set
	set[Type]combinedSet={};

	combinedSet += t1.types;
	combinedSet += t2.types;
	
	combinedSet -= objectTypesOfT1;
	combinedSet -= objectTypesOfT2;
	combinedSet += combinedObjectHandles;
	
	//Now resolve the case when the set has int, float and Num

	combinedSet=resolveNumTypes(combinedSet);

	TypeRoot toReturn;
	//make a distinction between whether the set has 1 or more element. If the set has
	//only one element, then return a typeSingleton without further due
	if( size(combinedSet)==1)
		//return typeSingleton(toList(combinedSet)[0]);
		return typeSet({toList(combinedSet)[0]});
		

	//a crucial and previously overlooked step is as follows:
	
	//1. get the min. array depth of a type that ends with 'Any()'
	minAnyArrayDepth=getMinAnyArrayDepth(combinedSet);

	//2. Throw away all types whose array depth is > min. depth evaluated above
	/*
	 *e.g. if originally: {Int,Array(Int),Array(Any)}, then keep: {Int,Array(Any)}
	 *e.g. if originally: {Int,Str,Any,Array(Any)}, then keep: {Any}
	 *e.g. if originally: {Int,Array(Bool()),Array(Array(Int)),Array(Array(Str))),Array(Array(Any))},
	 *					  then keep: {Int,Array(Bool()),Array(Array(Any))}
	*/

	//-1 signifies that no 'Any()' types were found, in which case leave the set unmodified
	if(minAnyArrayDepth != -1) 
		/*
		 *if minAnyArrayDepth value is found then,
		 * a) add all elements whose array depth < minAnyArrayDepth, and
		 * b) add the type: Array^i(Any()) where i == minAnyArrayDepth 
		 */
		combinedSet= {tt|tt<-combinedSet,getArrayDepthOf(tt)<minAnyArrayDepth}
					+{getArrayAnyOfDepth(minAnyArrayDepth)};

	//now see if the size of the set is less than prescribed value
	if( size(combinedSet)<=ceiling)
	{
		
		return typeSet(combinedSet);
	}
	else
	{
		if(size({tt|tt<-combinedSet,tt is ObjectType})>0)
			throw "Error loc 923-147292098. CombinedSet: <combinedSet>. Since combinedSet has ObjectType, and its"+
			"size is greater than ceiling, then support for traversing the type-lattice tree not supported yet.";
			
		// determining the array depth of each element in the set
		set[int]arrDepthOfCombinedSet={getArrayDepthOf(aT)|aT<-combinedSet  };
		
		//determine the minimum value of the above set	
		minArrayDepth=min(arrDepthOfCombinedSet);
		
		//return array^i[any]
		//return typeSingleton(getArrayAnyOfDepth(minArrayDepth));
		return typeSet({getArrayAnyOfDepth(minArrayDepth)});
	}
	
}

public set[Type] getObjectTypesFrom(TypeRoot t)
{
	set[Type] toReturn={};
	
	if(t is typeSet)
		toReturn +={tt|tt<-t.types,tt is Object};
	/*
	else if(t is typeSingleton)
		if(t.aType is ObjectType)
			toReturn += {t.aType};
	*/
	else
		;
	
	return toReturn;
}

public int getMinAnyArrayDepth(set[Type] tSet)
{
	tempSet={getArrayDepthOf(tt)| tt<-tSet,/Any():=tt};
	if(! isEmpty(tempSet) )
		return min(tempSet );
	else
		return -1;
}

public Type getArrayAnyOfDepth(int depth)
{
	if(depth==0)
		return Any();
	else
		return Array(getArrayAnyOfDepth(depth-1));
}

public int getArrayDepthOf(Type tParam)
{
	if(Array(Type d):=tParam)
		return getArrayDepthOf(d)+1;
	else
		return 0;
}
public set[Type] resolveNumTypes(set[Type] combinedSet)
{
	bool hasInt=false;
	bool hasFloat=false;
	bool hasNum=false;
	
	for(Type aT<-combinedSet)
	{
		if(aT is Int)
			hasInt=true;
		else if(aT is Float)
			hasFloat=true;
		else if(aT is Num)
			hasNum=true;
	}	
	
	if (hasInt && hasFloat)
	{
		combinedSet+=Num();
		hasNum=true;
	}
	
	if(hasNum)
		combinedSet=combinedSet-{Int(),Float()};
	
	return combinedSet;
}

public ClassInstance combineClassInstances(ClassInstance inst1,ClassInstance inst2)
{
	printIndLn("************Combining Class Instance****************");
	assert inst1.srcClass==inst2.srcClass : 
		"Two class instances with different src class cannot be combined. Error loc 2092198."+
		"inst1.srcClass: <inst1.srcClass>, inst2.srcClass: <inst2.srcClass>";
	
	ClassInstance returnInst=inst1;
	
	for(Identifier idf<-inst1.fieldToTypeMap)
	{
		printIndLn("inst1.fieldToTypeMap[<idf>]: <inst1.fieldToTypeMap[idf]>");
		
		printIndLn("inst2.fieldToTypeMap[<idf>]: <inst2.fieldToTypeMap[idf]>");
		
		temp=
			widen(inst1.fieldToTypeMap[idf],inst2.fieldToTypeMap[idf]);
		returnInst.fieldToTypeMap[idf]=temp;
	}
	//TODO: change other things about the class..
	//For now, ignore class templates.
	return returnInst;
}

public set[Type] 
		resolveCombinationInvolvingObjectHandles(set[Type] set1,set[Type] set2)
{
	if(isEmpty(set1))
		return set2;
	if(isEmpty(set2))
		return set1;
	if(set1==set2)
		return set1;
		
	set[Type] toReturn={};
	
	for(Type t1 <- set1)
		if(Object(Handle h1, ClassInstance oi1):=t1)
		{
			for(Type t2<-set2)
				if(Object(Handle h2, ClassInstance oi2):=t2)
				{
					if(h1==h2)
					{
						//both of them point to the same object in the global object store
						if(oi1==oi2)
						{
							//they're the same, trigger no change...
							toReturn+= t1;
						}
						else
						{
							//they both point to the same object, but the oi's are different.
							//This may occur in the case of branch-merge, or a looping construct
							//such that one of the instance fields have now changed.
							
							//Need to reflect this change to the object in the global object store!
							
							//STep 1: merge the class instances resolving any typechange
							ClassInstance temp=combineClassInstances(oi1,oi2);
							
							//Step 2: replace the object in the object store using the new object instance
							HandleToClassInstanceMap[h1]=temp;
							
							//Step 3: Return this object as an objectType with the handle 
							toReturn+=Object(h1,temp);
						
						}//end if (oi1==oi2)
						
					}
					else //h1 not-equals h2
					{
						//in this case, t1 and t2 are two different handles, each pointing to
						//an object in the object store. I need to distinguish if they are
						//instances of the same class or different ones!
						
						if(HandleToClassInstanceMap[h1].srcClass==
							HandleToClassInstanceMap[h2].srcClass)
						{
							//if they were both instantiated off of the same class, then
							
							//A: merge the two class instances...
							ClassInstance temp=combineClassInstances(oi1,oi2);
							
							//B: replace the object in the object store using the new merged instance
							HandleToClassInstanceMap[h1]=temp;
							
							//C: return this object along with the handle as an ObjectType
							toReturn+=Object(h1,temp);
							
						}
						else // (h1 != h2) AND (srcClass of h1 != srcClass of h2) 
						{
							toReturn +=t1; 
							toReturn +=t2;
						}//end if (srcClass of h1 != srcClass of h2)
							
						
					}// end if (h1==h2)
					 
											
				}// if( ObjectType(Handle,ClassElement):=t2 )
				else
				{
					throw "Error loc: 059821098. Expected t2 to be ObjectType(Handle,ClassElement). Got: <t2>. ";
				}// end if ( ObjectType(Handle,ClassElement):=t2 )
			
			//end for(Type t2<- set2)
		
		}//if( ObjectType(Handle,ClassElement):=t1)
		else
		{
			throw "Error loc: 231056772. Expected t1 to be ObjectType(Handle,ClassElement). Got: <t1>";
		}//end if( ObjectType(Handle,ClassElement):=t1)
	
	//end for(Type t1<- set1)
	return toReturn;
}
