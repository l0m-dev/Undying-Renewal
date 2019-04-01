//=============================================================================
// PortalFX.
//=============================================================================
class PortalFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=80)
     SourceWidth=(Base=80)
     SourceHeight=(Base=80)
     SourceDepth=(Base=192)
     bSteadyState=True
     Speed=(Base=20)
     Lifetime=(Base=3)
     ColorStart=(Base=(R=72,G=129,B=247))
     AlphaStart=(Base=0.75)
     SizeWidth=(Base=6)
     SizeLength=(Base=6)
     Chaos=15
     ChaosDelay=0.1
     Attraction=(X=10,Y=10)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     LightBrightness=140
     LightHue=170
     LightSaturation=100
}
