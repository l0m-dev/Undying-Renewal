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

simulated function Tick( float DeltaTime)
{
	local BreakAwayEffect B;
	local PlayerPawn P;

	if (Level.NetMode == NM_Standalone)
	{
		if (Player == none)
			FindPlayer();

		if (Player != none)
		{
			ForEach RadiusActors  ( class 'BreakAwayEffect', B, 384, Player.Location )
			{
				if ( VSize(Player.Location - B.Location) < 256 )
				{
					B.Trigger(Player, none);
				}
				else
				{
					B.UnTrigger(Player, none);
				}
			}
		}
	}
	else if (Level.NetMode != NM_DedicatedServer)
	{
		ForEach AllActors(class 'PlayerPawn', P)
		{
			ForEach RadiusActors  ( class 'BreakAwayEffect', B, 384, P.Location )
			{
				if ( VSize(P.Location - B.Location) < B.BreakAwayDistance )
				{
					B.Trigger(P, none);
				}
				else
				{
					B.UnTrigger(P, none);
				}
			}
		}
	}
}

defaultproperties
{
	 bNetTemporary=True
	 bAlwaysRelevant=True
	 RemoteRole=ROLE_SimulatedProxy
}
