//=============================================================================
// JileProjectileFX.
//=============================================================================
class JileProjectileFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=60)
     SourceWidth=(Base=15)
     SourceHeight=(Base=15)
     Lifetime=(Base=0.65)
     ColorStart=(Base=(R=64,G=255,B=128))
     ColorEnd=(Base=(R=16,G=128,B=32))
     AlphaStart=(Base=0.75)
     SizeWidth=(Base=20)
     SizeLength=(Base=20)
     Attraction=(X=50,Y=50,Z=50)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
}
