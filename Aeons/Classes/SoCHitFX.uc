//=============================================================================
// SoCHitFX. 
//=============================================================================
class SoCHitFX expands HitFX;

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=0,Rand=50)
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(R=128,G=131,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaStart=(Base=0.5,Rand=0.5)
     SizeEndScale=(Base=6)
     Damping=2
     Gravity=(Z=200)
     ParticlesMax=16
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
