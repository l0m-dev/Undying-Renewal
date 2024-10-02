//=============================================================================
// TriggeredViewBlack.
//=============================================================================
class TriggeredViewBlack expands Info;

var PlayerPawn Player;

function Trigger(Actor Other, Pawn Instigator)
{
	ForEach AllActors(class 'PlayerPawn', Player)
	{
		Player.ClientFlash(1, vect(-1000, -1000, -1000));
	}
}

defaultproperties
{
     Texture=Texture'Aeons.System.TriggeredViewFlash'
}
