//=============================================================================
// AudioTrackScene.
//=============================================================================
class AudioTrackCutScene expands CutSceneChar;

function Tick(float DeltaTime)
{
	bHidden = true;
	Texture = none;
}

defaultproperties
{
     bHidden=True
     DrawType=DT_Sprite
}
