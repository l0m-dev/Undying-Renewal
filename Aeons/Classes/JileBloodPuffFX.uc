//=============================================================================
// JileBloodPuffFX. 
//=============================================================================
class JileBloodPuffFX expands HitFX;

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     SourceWidth=(Base=1)
     SourceHeight=(Base=1)
     SourceDepth=(Base=1)
     AngularSpreadWidth=(Base=10)
     AngularSpreadHeight=(Base=10)
     Speed=(Base=100,Rand=200)
     Lifetime=(Base=0.25,Rand=0.5)
     ColorStart=(Base=(R=0,G=200,B=0))
     ColorEnd=(Base=(R=0,G=100))
     AlphaStart=(Base=0.25,Rand=0.25)
     SizeWidth=(Base=4)
     SizeLength=(Base=4)
     SizeEndScale=(Base=16)
     SpinRate=(Base=-1,Rand=1)
     Damping=4
     Gravity=(Z=30)
     ParticlesMax=4
     Textures(0)=Texture'Aeons.Particles.noisy5_pfx'
}
