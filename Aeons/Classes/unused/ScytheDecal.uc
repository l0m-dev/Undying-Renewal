//=============================================================================
// ScytheDecal.
//=============================================================================
class ScytheDecal expands AeonsDecal;

simulated event PostBeginPlay();
function StartLevel();
simulated function AttachToSurface(optional vector DecalDir)
{
	if( AttachDecal(64, DecalDir) == None )
		Destroy();
}

defaultproperties
{
     DecalTextures(0)=Texture'Aeons.Decals.ScytheDecal01'
     DecalTextures(1)=Texture'Aeons.Decals.ScytheDecal02'
     DecalTextures(2)=Texture'Aeons.Decals.ScytheDecal03'
     NumDecals=3
     LifeSpan=5
     Style=STY_AlphaBlend
     DrawScale=0.35
}
