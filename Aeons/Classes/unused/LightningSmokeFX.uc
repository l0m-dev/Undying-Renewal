//=============================================================================
// LightningSmokeFX. 
//=============================================================================
class LightningSmokeFX expands LightningHitFX;

defaultproperties
{
     ParticlesPerSec=(Base=24,Rand=16)
     SourceWidth=(Base=4)
     SourceDepth=(Base=4)
     AngularSpreadWidth=(Base=30)
     AngularSpreadHeight=(Base=30)
     Speed=(Base=0,Rand=0)
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(R=0,G=0,B=0))
     ColorEnd=(Base=(R=0,G=0,B=0))
     AlphaEnd=(Rand=0.5)
     SizeWidth=(Base=24)
     SizeLength=(Base=24,Rand=0)
     SizeEndScale=(Base=2,Rand=4)
     SpinRate=(Base=-2,Rand=4)
     Elasticity=0
     Damping=4
     Gravity=(Z=150)
     Textures(0)=Texture'Aeons.Particles.Smoke32_00'
     RenderPrimitive=PPRIM_Billboard
     Style=STY_AlphaBlend
}
