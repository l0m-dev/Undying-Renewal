//=============================================================================
// BloodHitFX. 
//=============================================================================
class BloodHitFX expands HitFX;

defaultproperties
{
     ParticlesPerSec=(Base=5000)
     SourceWidth=(Base=1)
     SourceHeight=(Base=1)
     SourceDepth=(Base=1)
     AngularSpreadWidth=(Base=30)
     AngularSpreadHeight=(Base=30)
     Speed=(Rand=50)
     ColorStart=(Base=(R=128,G=0,B=0))
     ColorEnd=(Base=(R=128))
     AlphaEnd=(Base=0.25)
     SizeWidth=(Base=2)
     SizeLength=(Base=0.3)
     SizeEndScale=(Base=0.1)
     GravityModifier=0.4
     ParticlesMax=32
     Textures(0)=Texture'Aeons.Blood'
     RenderPrimitive=PPRIM_Liquid
     Style=STY_AlphaBlend
}
