//=============================================================================
// CantripParticleFX. 
//=============================================================================
class CantripParticleFX expands SpellParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=256)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     Speed=(Base=20,Rand=20)
     Lifetime=(Base=0.25,Rand=0.25)
     ColorStart=(Base=(R=251,G=255))
     SizeWidth=(Base=0.5,Rand=1)
     SizeLength=(Base=0.5,Rand=1)
     SizeEndScale=(Rand=2)
     SpinRate=(Base=-2,Rand=4)
     ParticlesMax=32
     Textures(0)=Texture'Aeons.Particles.PotFire08'
}
