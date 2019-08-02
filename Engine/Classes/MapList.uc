//=============================================================================
// MapList.
//
// contains a list of maps to cycle through
//
//=============================================================================
class MapList extends Info;

var(Maps) config string Maps[32];
var config int MapNum;

function string GetNextMap()
{
	local string CurrentMap;
	local int i;

	CurrentMap = GetURLMap();

	// BUGBUG HACKHACK
	// Hardwired extensions.

	if ( CurrentMap != "" )
	{
		if ( Right(CurrentMap,4) ~= ".sac" )
			CurrentMap = CurrentMap;
		else
			CurrentMap = CurrentMap$".sac";

		for ( i=0; i<ArrayCount(Maps); i++ )
		{
			if ( CurrentMap ~= Maps[i] )
			{
				MapNum = i;
				break;
			}
		}
	}

	// search vs. w/ or w/out .sac extension

	MapNum++;
	if ( MapNum > ArrayCount(Maps) - 1 )
		MapNum = 0;
	if ( Maps[MapNum] == "" )
		MapNum = 0;

	SaveConfig();
	return Maps[MapNum];
}

defaultproperties
{
}
