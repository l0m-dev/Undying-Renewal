//=============================================================================
// GlowFX.
//=============================================================================
class GlowFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=192)
     SourceWidth=(Base=128)
     SourceHeight=(Base=256)
     AngularSpreadWidth=(Base=1)
     AngularSpreadHeight=(Base=1)
     Speed=(Base=0)
     Lifetime=(Base=2)
     ColorStart=(Base=(R=128,G=255,B=255),Rand=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=0,G=128,B=128),Rand=(G=64,B=128))
     AlphaStart=(Base=0.4)
     SizeWidth=(Base=64)
     SizeLength=(Base=64)
     SizeEndScale=(Base=0,Rand=2)
     SpinRate=(Base=-1,Rand=2)
     Chaos=2
     Textures(0)=Texture'Aeons.MuzzleFlashes.Ghelz_Glow'
     LODBias=8
     Tag=GlowFX
}
