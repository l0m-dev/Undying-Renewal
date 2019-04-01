//=============================================================================
// SaintSummonFX. 
//=============================================================================
class SaintSummonFX expands SummonFX;

defaultproperties
{
     ParticlesPerSec=(Base=4096)
     SourceWidth=(Base=64)
     SourceHeight=(Base=128)
     SourceDepth=(Base=64)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=1000,Rand=1000)
     Lifetime=(Base=0.5,Rand=1.5)
     ColorStart=(Base=(R=176,G=160,B=142))
     ColorEnd=(Base=(R=148,G=122,B=107))
     SizeWidth=(Base=32,Rand=32)
     SizeLength=(Base=32,Rand=32)
     SizeEndScale=(Base=4,Rand=4)
     SpinRate=(Base=-2,Rand=4)
     Damping=30
     Gravity=(Z=30)
     ParticlesMax=32
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
