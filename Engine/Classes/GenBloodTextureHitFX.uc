//=============================================================================
// GenBloodTextureHitFX. 
//=============================================================================
class GenBloodTextureHitFX expands GenTextureHitFX;

defaultproperties
{
     SourceHeight=(Base=0)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     Speed=(Base=100,Rand=200)
     Lifetime=(Rand=1)
     ColorStart=(Base=(G=23,B=23))
     ColorEnd=(Base=(R=151,G=0,B=0))
     AlphaStart=(Base=1,Rand=0)
     SizeWidth=(Base=4,Rand=4)
     SizeLength=(Base=3)
     Elasticity=0.25
     Gravity=(Z=-950)
     ParticlesMax=32
     RenderPrimitive=PPRIM_Liquid
}
