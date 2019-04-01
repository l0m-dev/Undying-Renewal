//=============================================================================
// WaterTextureHitFX. 
//=============================================================================
class WaterTextureHitFX expands TextureHitFX;

defaultproperties
{
     SourceHeight=(Base=0)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     Speed=(Base=200,Rand=400)
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=159,G=162))
     AlphaStart=(Base=1,Rand=0)
     SizeWidth=(Base=4,Rand=4)
     SizeLength=(Base=1)
     GravityModifier=0.5
     ParticlesMax=32
     RenderPrimitive=PPRIM_Liquid
}
