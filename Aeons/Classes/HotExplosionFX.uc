//=============================================================================
// HotExplosionFX. 
//=============================================================================
class HotExplosionFX expands ExplosionFX;

simulated function Tick(float deltaTime)
{
	LightBrightness = FClamp( (LightBrightness - (deltaTime * 255)), 0, 255);


}

defaultproperties
{
     ParticlesPerSec=(Base=2048)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=200,Rand=600)
     Lifetime=(Base=0.25,Rand=0.75)
     ColorStart=(Base=(R=250,G=255,B=36))
     ColorEnd=(Base=(G=21,B=21))
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2)
     SpinRate=(Base=-1,Rand=2)
     Damping=10
     Gravity=(Z=10)
     ParticlesMax=48
     Textures(0)=Texture'Aeons.Particles.PotFire08'
     LODBias=10
     LightType=LT_Steady
     LightBrightness=255
     LightHue=19
     LightSaturation=97
     LightRadius=24
}
