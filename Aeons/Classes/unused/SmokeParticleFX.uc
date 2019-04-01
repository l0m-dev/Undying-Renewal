//=============================================================================
// SmokeParticleFX. 
//=============================================================================
class SmokeParticleFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=32)
     SourceWidth=(Base=2)
     SourceHeight=(Base=2)
     SourceDepth=(Base=2)
     AngularSpreadWidth=(Base=45)
     AngularSpreadHeight=(Base=45)
     bSteadyState=True
     Speed=(Base=0,Rand=10)
     Lifetime=(Base=1.5,Rand=3)
     ColorStart=(Base=(R=0,G=0,B=0))
     ColorEnd=(Base=(G=255,B=255))
     AlphaStart=(Base=0.5,Rand=0.5)
     SizeEndScale=(Base=8,Rand=4)
     SpinRate=(Base=-2,Rand=4)
     Damping=2
     WindModifier=1
     Gravity=(Z=20)
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
