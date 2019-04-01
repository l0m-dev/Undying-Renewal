//=============================================================================
// CatchOnFire.
//=============================================================================
class CatchOnFire expands Info;

var ScriptedPawn SP;
var() bool bRadiusBased;
var() bool bTouch;

function Trigger(Actor Other, Pawn Instigator)
{
	if ( bRadiusBased )
	{
		ForEach RadiusActors(class 'ScriptedPawn', SP, CollisionRadius, Location)
		{
			SP.OnFire(true);
		}
	} else {
		ForEach AllActors(class 'ScriptedPawn', SP, Event)
		{
			SP.OnFire(true);
		}
	}
}

function Touch(Actor Other)
{
	if ( bTouch )
	{
		if ( Other.IsA('ScriptedPawn') )
		{
			ScriptedPawn(Other).OnFire(true);
		}
	}
}

defaultproperties
{
}
