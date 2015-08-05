module soft::typing::php::Utils::GenericHelpers
import List;
import soft::typing::php::declarations::PublicDataTypes;
import soft::typing::php::declarations::PrintFormatter;


import Exception;
//method declaration
public &T getElementFromSingletonList(list[&T] myList)
{
	if(size(myList)>1){
		
		throw AssertionFailed( "List is greater than expected size of 1");
	}
	else if(size(myList)==0)
		throw AssertionFailed("Expected one element. Got empty list.");
	else
		return myList[0];
}

