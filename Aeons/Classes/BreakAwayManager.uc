//=============================================================================
// BreakAwayManager.
//=============================================================================
class BreakAwayManager expands EffectManager;

var PlayerPawn Player;

function FindPlayer()
{
	ForEach AllActors(class 'PlayerPawn', Player)
	{
		break;
	}
}

function Tick( float DeltaTime)
{
	local BreakAwayEffect B;
	
	if (Player == none)
		FindPlayer();

	if (Player != none)
	{
		ForEach RadiusActors  ( class 'BreakAwayEffect', B, 384, Player.Location )
		{
			if ( VSize(Player.Location - B.Location) < 256 )
			{
				B.Trigger(Player, none);
			} else {
				B.UnTrigger(Player, none);
			}
		}
	}
}

defaultproperties
{
}
