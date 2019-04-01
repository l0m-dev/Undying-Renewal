//=============================================================================
// LightningHitFX. 
//=============================================================================
class LightningHitFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=64)
     SourceWidth=(Base=1)
     SourceHeight=(Base=1)
     SourceDepth=(Base=1)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     Speed=(Rand=200)
     Lifetime=(Base=2,Rand=2)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(R=127,G=127,B=127))
     SizeWidth=(Base=4)
     SizeLength=(Base=1,Rand=1)
     Elasticity=0.3333
     Damping=0.5
     WindModifier=1
     Gravity=(Z=-950)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     RenderPrimitive=PPRIM_Liquid
}
