//=============================================================================
// RainFX.
//=============================================================================
class RainFX expands WeatherParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     SourceWidth=(Base=400)
     SourceHeight=(Base=400)
     SourceDepth=(Base=400)
     Speed=(Base=2000,Rand=1000)
     Lifetime=(Base=0.25)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaEnd=(Base=1)
     SizeWidth=(Base=24,Rand=8)
     SizeLength=(Base=4)
     WindModifier=0.25
     Textures(0)=Texture'Aeons.Particles.Rain1'
     RenderPrimitive=PPRIM_Liquid
     CollisionRadius=1000
     CollisionHeight=1500
}
