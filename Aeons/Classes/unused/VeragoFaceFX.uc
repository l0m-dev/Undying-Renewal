//=============================================================================
// VeragoFaceFX.
//=============================================================================
class VeragoFaceFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=45)
     SourceWidth=(Base=15)
     SourceHeight=(Base=15)
     bSteadyState=True
     Lifetime=(Base=0.5)
     ColorStart=(Base=(R=64,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaStart=(Base=0.75)
     SizeWidth=(Base=6)
     SizeLength=(Base=6)
     Attraction=(X=50,Y=50,Z=50)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
}
