//=============================================================================
// SnowFX.
//=============================================================================
class SnowFX expands WeatherParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=350)
     SourceWidth=(Base=300)
     SourceHeight=(Base=300)
     AngularSpreadWidth=(Base=0)
     AngularSpreadHeight=(Base=0)
     Speed=(Base=0)
     Lifetime=(Base=3)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaEnd=(Base=1)
     SizeWidth=(Base=4)
     SizeLength=(Base=4)
     bSystemRelative=True
     Chaos=16
     ChaosDelay=0.5
     GravityModifier=0.1
     Textures(0)=Texture'Aeons.Particles.Star8_pfx'
     Tag=SnowFX
     CollisionRadius=500
     CollisionHeight=500
}
