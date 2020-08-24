//=============================================================================
// SmokeSignalFX.
//=============================================================================
class SmokeSignalFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=512)
     SourceWidth=(Base=64)
     SourceHeight=(Base=16)
     SourceDepth=(Base=64)
     Speed=(Base=0)
     Lifetime=(Base=3,Rand=2)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaStart=(Base=0.25,Rand=0.75)
     SizeWidth=(Base=64)
     SizeLength=(Base=64)
     SizeEndScale=(Base=2,Rand=2)
     Elasticity=0.1
     Damping=0.5
     WindModifier=1
     Gravity=(Z=100)
     ParticlesMax=256
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
