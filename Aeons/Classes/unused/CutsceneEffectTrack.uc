//=============================================================================
// CutsceneEffectTrack.
//=============================================================================
class CutsceneEffectTrack expands Info;

var() sound SoundEffectTrack;
var() float Volume;

function Trigger(Actor Other, Pawn Instigator)
{
	local CameraProjectile cam;

	if (SoundEffectTrack != none)
	{
		ForEach AllActors(class 'CameraProjectile', cam)
		{
			break;
		}
		if (cam != none)
		{
			Cam.PlaySound(SoundEffectTrack,,Volume);
		}
	}
}

defaultproperties
{
     Volume=1
}
