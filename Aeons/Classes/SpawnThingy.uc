//=============================================================================
// SpawnThingy.
//=============================================================================
class SpawnThingy expands Info;

//#exec TEXTURE IMPORT FILE=SpawnThingy.pcx GROUP=System Mips=On Flags=2

var() class<Actor> SpawnClass;
var() name ActorTag;
var() name ActorEvent;


function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;

	if ( SpawnClass != none )
	{
		A = Spawn(SpawnClass,,,Location);
		
		// Tag
		if ( ActorTag != 'none' )
			A.Tag = ActorTag;
		
		// Event
		if ( ActorEvent != 'none' )
			A.Event = ActorEvent;
	}
}

defaultproperties
{
     Style=STY_Masked
     Texture=Texture'Aeons.System.SpawnThingy'
}
