//=============================================================================
// HotTrailFX. 
//=============================================================================
class HotTrailFX expands ParticleTrailFX;

defaultproperties
{
     ParticlesPerSec=(Base=32)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     Lifetime=(Base=0.35)
     ColorStart=(Base=(R=255,G=251,B=64))
     ColorEnd=(Base=(G=23,B=23))
     SizeWidth=(Base=2,Rand=3)
     SizeLength=(Base=2,Rand=3)
     SizeEndScale=(Base=0)
     Textures(0)=Texture'Aeons.Particles.SoftShaft01'
     LifeSpan=10
     LODBias=10
}
