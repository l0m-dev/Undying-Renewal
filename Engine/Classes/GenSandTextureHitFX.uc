//=============================================================================
// GenSandTextureHitFX. 
//=============================================================================
class GenSandTextureHitFX expands GenTextureHitFX;

defaultproperties
{
     ParticlesPerSec=(Base=2048)
     SourceHeight=(Base=0)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=45)
     AngularSpreadHeight=(Base=45)
     Speed=(Base=200,Rand=200)
     Lifetime=(Base=0.7,Rand=1)
     ColorStart=(Base=(R=197,G=155,B=114))
     ColorEnd=(Base=(R=171,G=151,B=139))
     AlphaStart=(Base=1,Rand=0)
     SizeWidth=(Base=2,Rand=2)
     SizeLength=(Base=1,Rand=1)
     Elasticity=0.25
     Damping=4
     Gravity=(Z=-950)
     ParticlesMax=64
     RenderPrimitive=PPRIM_Liquid
}
