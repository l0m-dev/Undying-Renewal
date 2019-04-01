//=============================================================================
// GlassFX.
//=============================================================================
class GlassFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=128)
     SourceWidth=(Base=128)
     SourceHeight=(Base=128)
     Speed=(Base=0,Rand=256)
     Lifetime=(Base=12)
     ColorStart=(Base=(R=0,G=255,B=255))
     ColorEnd=(Base=(R=0,G=255,B=255))
     AlphaStart=(Base=0.5)
     SizeWidth=(Rand=8)
     SizeLength=(Rand=8)
     AlphaDelay=10
     Elasticity=0.1
     GravityModifier=1
     ParticlesMax=192
     RenderPrimitive=PPRIM_Shard
}
