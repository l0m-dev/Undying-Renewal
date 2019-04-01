//=============================================================================
// DynamiteFuseFX. 
//=============================================================================
class DynamiteFuseFX expands WeaponParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=64,Rand=64)
     SourceWidth=(Base=1)
     SourceHeight=(Base=1)
     SourceDepth=(Base=1)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     Speed=(Base=100,Rand=200)
     Lifetime=(Base=0.15,Rand=0.25)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(G=117,B=15))
     AlphaEnd=(Base=1)
     SizeWidth=(Base=4,Rand=8)
     SizeLength=(Base=1)
     SizeEndScale=(Base=0)
     Gravity=(Z=-100)
     Textures(0)=Texture'Aeons.Particles.SparkB02'
     RenderPrimitive=PPRIM_Liquid
     LODBias=10
     SpriteProjForward=0
}
