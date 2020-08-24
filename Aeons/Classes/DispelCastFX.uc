//=============================================================================
// DispelCastFX.
//=============================================================================
class DispelCastFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=4096)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     AngularSpreadWidth=(Base=360)
     Speed=(Base=500,Rand=1000)
     Lifetime=(Base=1.5,Rand=0.5)
     ColorStart=(Base=(R=64,G=203,B=255))
     ColorEnd=(Base=(R=159,B=255))
     SizeWidth=(Base=16)
     SizeLength=(Base=16)
     SizeEndScale=(Rand=1)
     SpinRate=(Base=-4,Rand=4)
     ParticlesMax=512
     Textures(0)=Texture'Aeons.Particles.Star8_pfx'
}
