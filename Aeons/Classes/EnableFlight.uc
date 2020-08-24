//=============================================================================
// EnableFlight.
//=============================================================================
class EnableFlight expands Info;

function Trigger(Actor Other, Pawn Instigator)
{
	Level.bAllowFlight = true;
}

defaultproperties
{
}
