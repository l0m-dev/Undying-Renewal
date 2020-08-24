//=============================================================================
// ScytheSparksFX. 
//=============================================================================
class ScytheSparksFX expands WeaponParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=2048)
     SourceWidth=(Base=1)
     SourceHeight=(Base=1)
     SourceDepth=(Base=1)
     AngularSpreadWidth=(Base=30)
     AngularSpreadHeight=(Base=30)
     Speed=(Base=100,Rand=300)
     Lifetime=(Base=0.25,Rand=1.5)
     ColorStart=(Base=(R=252,G=255,B=117))
     ColorEnd=(Base=(R=244,G=140))
     AlphaStart=(Base=0.25,Rand=0.5)
     SizeWidth=(Base=2)
     SizeLength=(Base=1,Rand=1)
     SizeEndScale=(Base=0.25,Rand=0.75)
     Elasticity=0.25
     Damping=1
     Gravity=(Z=-950)
     ParticlesMax=16
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     RenderPrimitive=PPRIM_Liquid
}
