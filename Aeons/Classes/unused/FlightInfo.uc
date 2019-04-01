//=============================================================================
// FlightInfo.
//=============================================================================
class FlightInfo expands Info;

var AeonsPlayer Player;
var() bool bFlight;

function FIndPlayer()
{
	ForEach AllActors(class 'AeonsPlayer', Player)
	{
		break;
	}

}


function Trigger(Actor Other, Pawn Instigator)
{
	if ( Player == none )
		FindPlayer();
	
	if ( Player != none )
		Player.SetFlight(bFlight);
}

defaultproperties
{
}
