//=============================================================================
// TriggeredBump.
//=============================================================================
class TriggeredBump expands Info;

var ScriptedPawn SP;

function Trigger(Actor Other, Pawn Instigator)
{
	local PlayerPawn Player;

	ForEach AllActors (class 'PlayerPawn', Player)
	{
		break;
	}
	
	if ( Player != none )
	{
		ForEach AllActors(class 'ScriptedPawn', SP, Event)
		{
			SP.Bump(Player);
		}
	}
}

defaultproperties
{
}
