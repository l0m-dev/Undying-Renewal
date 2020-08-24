//=============================================================================
// MoveThingy.
//=============================================================================
class MoveThingy expands Info;

var() name MoveTag;

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;

	if ( MoveTag != 'none' )
		ForEach AllActors (class 'Actor', A, MoveTag)
		{
			log("MoveThingy Moving "$A.name, 'Misc');
			A.SetLocation(Location);
		}
}

defaultproperties
{
}
