//=============================================================================
// CarnageDecal.
//=============================================================================
class CarnageDecal expands AeonsDecal;

simulated function PreBeginPlay()
{
     SetRotation(rotator(vect(0,0,1))); // rotation won't be replicated so this is needed
     Super.PreBeginPlay();
}

defaultproperties
{
     DecalTextures(0)=Texture'BloodAndGuts.DeadGuyGibs01'
     DecalTextures(1)=Texture'BloodAndGuts.DeadGuyGibs02'
     NumDecals=2
     DecalLifetime=120
     LifeSpan=120
     Style=STY_AlphaBlend
     DrawScale=0.75
     RemoteRole=ROLE_SimulatedProxy
}
