//=============================================================================
// DebugParticleFX. 
//=============================================================================
class DebugParticleFX expands ParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=32)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     Speed=(Base=0)
     Lifetime=(Base=30)
     ColorStart=(Base=(R=64,G=255,B=255))
     ColorEnd=(Base=(B=255))
     AlphaEnd=(Base=1)
     LODBias=100
     CollisionRadius=2048
     CollisionHeight=2048
}
