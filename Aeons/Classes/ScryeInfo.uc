//=============================================================================
// ScryeInfo.
//=============================================================================
class ScryeInfo expands Info;

//#exec TEXTURE IMPORT FILE=ScryeInfo.pcx GROUP=System Mips=Off

var AeonsPlayer Player;

var() float NewScryeTimer;

function Trigger(Actor Other, Pawn Instigator)
{
	ForEach AllActors(class 'AeonsPlayer', Player)
	{
		Player.ScryeFullTime = NewScryeTimer;
		Player.ScryeTimer = NewScryeTimer;
		//Player.ScryeMod.GotoState('Activated');
		//Player.ScryeMod.CastingLevel = 1;
	}
}

defaultproperties
{
     Texture=Texture'Aeons.System.ScryeInfo'
}
