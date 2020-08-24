//=============================================================================
// SigilExplosionFX.
//=============================================================================
class SigilExplosionFX expands ExplosionFX;

defaultproperties
{
     ParticlesPerSec=(Base=2048)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=100,Rand=500)
     Lifetime=(Base=2,Rand=1)
     ColorEnd=(Base=(R=13,G=255))
     SizeWidth=(Base=16)
     SizeLength=(Base=3,Rand=2)
     AlphaDelay=1
     Elasticity=0.35
     Gravity=(Z=-950)
     ParticlesMax=256
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     RenderPrimitive=PPRIM_Liquid
}
