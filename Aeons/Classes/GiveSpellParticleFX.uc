//=============================================================================
// GiveSpellParticleFX.
//=============================================================================
class GiveSpellParticleFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=512)
     SourceWidth=(Base=256)
     SourceHeight=(Base=512)
     SourceDepth=(Base=256)
     Speed=(Base=0)
     Lifetime=(Base=0.7)
     ColorStart=(Base=(R=9,G=15,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaEnd=(Base=1)
     SizeWidth=(Base=1)
     SizeLength=(Base=1)
     SizeEndScale=(Base=16)
     Chaos=16
     Attraction=(X=5,Y=5,Z=5)
     Textures(0)=Texture'Aeons.Particles.Flare'
     Tag=GiveSpellParticleFX
}
