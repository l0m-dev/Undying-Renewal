//=============================================================================
// RainSplashFX.
//=============================================================================
class RainSplashFX expands WeatherParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=0)
     SourceWidth=(Base=128)
     SourceHeight=(Base=128)
     SourceDepth=(Base=128)
     AngularSpreadWidth=(Base=20)
     AngularSpreadHeight=(Base=20)
     Speed=(Base=100)
     Lifetime=(Base=1.25)
     ColorStart=(Base=(R=128,B=128))
     ColorEnd=(Base=(R=128,G=128,B=128))
     SizeWidth=(Base=2)
     SizeLength=(Base=1)
     GravityModifier=0.5
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     RenderPrimitive=PPRIM_Liquid
     LODBias=50
}
