//=============================================================================
// SarcophagusDustFX.
//=============================================================================
class SarcophagusDustFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=20)
     SourceWidth=(Base=48)
     SourceHeight=(Base=8)
     SourceDepth=(Base=48)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=100,Rand=50)
     Lifetime=(Base=4,Rand=1)
     ColorStart=(Base=(R=254,G=247,B=192))
     ColorEnd=(Base=(G=255,B=255))
     AlphaStart=(Base=0.5,Rand=0.5)
     SizeWidth=(Base=70)
     SizeLength=(Base=70)
     SizeEndScale=(Base=6)
     Damping=2
     Gravity=(Z=350)
     ParticlesMax=37
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
