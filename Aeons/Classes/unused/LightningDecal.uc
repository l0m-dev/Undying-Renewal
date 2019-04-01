//=============================================================================
// LightningDecal.
//=============================================================================
class LightningDecal expands AeonsDecal;

simulated event PostBeginPlay();
function StartLevel();

simulated function AttachToSurface(optional vector DecalDir)
{
	if( AttachDecal(64, DecalDir) == None )
		Destroy();
}

defaultproperties
{
     DecalTextures(0)=Texture'Aeons.Decals.LightningDecal01'
     NumDecals=1
     DecalRange=8
     LifeSpan=15
     DrawScale=0.75
}
