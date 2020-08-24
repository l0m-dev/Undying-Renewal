//=============================================================================
// ChargedSoCHitFX. 
//=============================================================================
class ChargedSoCHitFX expands HitFX;

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     SourceWidth=(Base=16)
     SourceHeight=(Base=16)
     SourceDepth=(Base=16)
     AngularSpreadWidth=(Base=45)
     AngularSpreadHeight=(Base=45)
     Speed=(Rand=50)
     Lifetime=(Rand=1.5)
     ColorStart=(Base=(R=79,G=64,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaStart=(Base=0.5,Rand=0.5)
     SizeEndScale=(Base=8,Rand=8)
     Damping=1.5
     Gravity=(Z=50)
     ParticlesMax=24
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
