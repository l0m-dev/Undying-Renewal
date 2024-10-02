//=============================================================================
// TriggeredViewFlash.
//=============================================================================
class TriggeredViewFlash expands Info;

//#exec TEXTURE IMPORT FILE=TriggeredViewFlash.pcx GROUP=System Mips=Off

var PlayerPawn Player;
var() float Strength;
var() vector Fog;

function Trigger(Actor Other, Pawn Instigator)
{
	ForEach AllActors(class 'PlayerPawn', Player)
	{
		Player.ClientFlash(Strength, fog);
	}
}

defaultproperties
{
     Strength=1
     fog=(X=1000,Y=1000,Z=1000)
     Texture=Texture'Aeons.System.TriggeredViewFlash'
}
