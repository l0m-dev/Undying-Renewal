//=============================================================================
// HasteTrailFX. 
//=============================================================================
class HasteTrailFX expands ScriptedFX;

defaultproperties
{
     ParticlesPerSec=(Base=32)
     Lifetime=(Base=0.333)
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=255,G=255,B=255))
     AlphaStart=(Base=0.1)
     AlphaEnd=(Base=0)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=0)
     Distribution=DIST_Uniform
     Textures(0)=Texture'Aeons.Particles.SoftShaft01'
     LODBias=10
}
