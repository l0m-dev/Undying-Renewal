//=============================================================================
// GhelzTrailFX. 
//=============================================================================
class GhelzTrailFX expands ScriptedFX;

defaultproperties
{
     ParticlesPerSec=(Base=32)
     Lifetime=(Base=0.333)
     ColorStart=(Base=(R=31,G=255,B=63))
     ColorEnd=(Base=(R=31,G=255,B=63))
     AlphaStart=(Base=0.3)
     AlphaEnd=(Base=0)
     SizeWidth=(Base=12)
     SizeLength=(Base=24)
     SizeEndScale=(Base=0)
     Distribution=DIST_Uniform
     Textures(0)=Texture'Aeons.Particles.SoftShaft01'
     LODBias=10
}
