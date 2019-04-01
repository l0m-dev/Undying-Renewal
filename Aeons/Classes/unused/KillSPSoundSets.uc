//=============================================================================
// KillSPSoundSets.
//=============================================================================
class KillSPSoundSets expands Info;

var ScriptedPawn SP;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	ForEach AllActors (class 'ScriptedPawn', SP)
	{
		SP.SoundSet = none;
	}

}

defaultproperties
{
}
