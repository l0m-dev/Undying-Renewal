//=============================================================================
// SmokeTrailFX. 
//=============================================================================
class SmokeTrailFX expands ParticleTrailFX;

defaultproperties
{
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     ColorStart=(Base=(R=244,G=147,B=0))
     ColorEnd=(Base=(R=122,G=122,B=122))
     AlphaStart=(Base=0.75)
     SizeWidth=(Base=6)
     SizeLength=(Base=6)
     SizeEndScale=(Base=3)
     Damping=2
     Textures(0)=Texture'Aeons.Particles.Shaft2'
     LODBias=10
     CollisionRadius=256
     CollisionHeight=256
}
