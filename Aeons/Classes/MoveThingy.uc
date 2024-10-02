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
			if (A.RemoteRole == ROLE_SimulatedProxy)
				A.RemoteRole = ROLE_DumbProxy;
			A.SetLocation(Location);
		}
}

defaultproperties
{
}
