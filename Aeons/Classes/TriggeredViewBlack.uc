//=============================================================================
// TriggeredViewBlack.
//=============================================================================
class TriggeredViewBlack expands Info;

var PlayerPawn Player;

function FIndPlayer()
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
		Player.ClientFlash( 1, vect(-1000, -1000, -1000));
}

defaultproperties
{
     Texture=Texture'Aeons.System.TriggeredViewFlash'
}
