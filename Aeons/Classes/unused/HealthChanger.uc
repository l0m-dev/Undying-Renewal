//=============================================================================
// HealthChanger.
//=============================================================================
class HealthChanger expands Info;

var PlayerPawn Player;
var() int NewHealth;

function FindPlayer()
{
	ForEach AllActors(class 'PlayerPawn', Player)
	{
		break;
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	if ( Player == none )
		FindPlayer();
	
	if ( Player != none )
		Player.Health = NewHealth;
}

defaultproperties
{
     NewHealth=100
}
