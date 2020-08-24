//=============================================================================
// GhostPFX1.
//=============================================================================
class GhostPFX1 expands AeonsParticleFX;

defaultproperties
{
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Rand=100)
     Lifetime=(Base=0.5,Rand=0.5)
     ColorStart=(Base=(R=0,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaStart=(Base=0.5,Rand=0.25)
     SizeEndScale=(Base=16)
     SpinRate=(Base=-8,Rand=8)
     Attraction=(X=20,Y=20,Z=20)
     Textures(0)=Texture'Aeons.Particles.Star8_pfx'
     Textures(2)=Texture'Aeons.Particles.Star4_pfx'
     Textures(4)=Texture'Aeons.Particles.Soft_pfx'
     LODBias=4
}
