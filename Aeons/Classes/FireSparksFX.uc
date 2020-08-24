//=============================================================================
// FireSparksFX. 
//=============================================================================
class FireSparksFX expands FireParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=20)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     Speed=(Rand=75)
     Lifetime=(Base=0.5)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(G=255))
     AlphaStart=(Base=1,Rand=0)
     AlphaEnd=(Base=0.25,Rand=0.5)
     SizeWidth=(Base=2)
     SizeLength=(Base=2)
     SizeEndScale=(Base=1,Rand=1)
     DripTime=(Rand=0)
     Damping=0.2
     Textures(0)=Texture'Aeons.Particles.Flare'
     LightEffect=LE_TorchWaver
     LightBrightness=255
     LightRadius=16
     LightRadiusInner=8
     LightCone=0
}
