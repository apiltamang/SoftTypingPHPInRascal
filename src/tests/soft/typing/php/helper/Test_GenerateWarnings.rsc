module tests::soft::typing::php::helper::Test_GenerateWarnings

import soft::typing::php::declarations::PublicDataTypes;
import IO;

public void generateWarnings(map[str,list[Warning]] mapp)
{

	for(str aKey <- mapp)
	{
		println(<aKey>);
		println("\\begin {enumerate}");
		for(Warning aW <- mapp[aKey])
			println("\\item <aW>");
		
		println("\\end {enumerate}"); 
	}
}