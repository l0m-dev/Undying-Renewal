//=============================================================================
// MakePatDead.
//=============================================================================
class MakePatDead expands Info;


function Trigger(Actor Other, Pawn Instigator)
{
	local AeonsPlayer Player;
	
	ForEach AllActors(class 'AeonsPlayer', Player)
	{
		break;
	}
	
	if (Player != none)
	{
		Player.GotoState('InstantFadingDeath');
	}
}

defaultproperties
{
}
