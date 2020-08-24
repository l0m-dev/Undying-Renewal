//=============================================================================
// BloodTextureHitFX. 
//=============================================================================
class BloodTextureHitFX expands TextureHitFX;

defaultproperties
{
     SourceHeight=(Base=8)
     SourceDepth=(Base=0)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     Speed=(Base=200,Rand=200)
     Lifetime=(Rand=1)
     ColorStart=(Base=(G=32,B=32))
     ColorEnd=(Base=(G=32,B=32))
     AlphaStart=(Base=0.5,Rand=0)
     AlphaEnd=(Base=0.5)
     SizeWidth=(Base=2,Rand=1)
     SizeLength=(Base=0.5)
     GravityModifier=0.3
     ParticlesMax=32
     Textures(0)=Texture'Aeons.Blood'
     RenderPrimitive=PPRIM_Liquid
     Style=STY_AlphaBlend
}
