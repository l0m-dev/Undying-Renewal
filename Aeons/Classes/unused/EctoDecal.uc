//=============================================================================
// EctoDecal.
//=============================================================================
class EctoDecal expands AeonsDecal;

function Tick(float DeltaTime)
{
	if (DrawScale > 0.01)
		SetDrawScale(DrawScale - (DeltaTime/7.0));
	else
		Destroy();
}

defaultproperties
{
     Style=STY_AlphaBlend
     Texture=Texture'Aeons.Decals.EctoDecal1'
     DrawScale=2
}
