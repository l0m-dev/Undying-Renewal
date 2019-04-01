//=============================================================================
// BubbleFuseFX. 
//=============================================================================
class BubbleFuseFX expands DynamiteFuseFX;

defaultproperties
{
     Speed=(Base=0)
     Lifetime=(Base=0,Rand=0.5)
     ColorEnd=(Base=(B=255))
     AlphaEnd=(Base=0)
     SizeWidth=(Rand=0)
     SizeLength=(Base=4)
     SizeEndScale=(Rand=2)
     Gravity=(Z=100)
     Textures(0)=Texture'Aeons.Particles.Bubble'
     RenderPrimitive=PPRIM_Billboard
     LODBias=1
}
