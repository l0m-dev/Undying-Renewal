//=============================================================================
// WoundParticleFX. 
//=============================================================================
class WoundParticleFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=16)
     SourceWidth=(Base=3)
     SourceHeight=(Base=3)
     SourceDepth=(Base=3)
     AngularSpreadWidth=(Rand=10)
     AngularSpreadHeight=(Rand=10)
     Speed=(Base=25,Rand=25)
     Lifetime=(Base=3)
     ColorStart=(Base=(R=128,G=0,B=0))
     ColorEnd=(Base=(R=128))
     AlphaStart=(Base=0.5,Rand=0.25)
     SizeWidth=(Base=1.75)
     SizeLength=(Base=0.3)
     SizeEndScale=(Rand=1)
     GravityModifier=0.4
     Textures(0)=Texture'Aeons.Blood'
     RenderPrimitive=PPRIM_Liquid
     Style=STY_AlphaBlend
}
