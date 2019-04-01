//=============================================================================
// VeragoExplosionFX.
//=============================================================================
class VeragoExplosionFX expands ExplosionFX;

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
     ColorStart=(Base=(R=10,G=38,B=90))
     ColorEnd=(Base=(R=43,G=72,B=121))
     SizeWidth=(Base=14,Rand=2)
     SizeLength=(Base=14,Rand=2)
     AlphaDelay=1
     Elasticity=0.35
     Gravity=(Z=-950)
     ParticlesMax=256
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
}
