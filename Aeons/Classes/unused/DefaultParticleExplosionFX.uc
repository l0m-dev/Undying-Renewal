//=============================================================================
// DefaultParticleExplosionFX. 
//=============================================================================
class DefaultParticleExplosionFX expands ExplosionFX;

function PreBeginPlay()
{
	super.PreBeginPlay();
	spawn(class 'ParticleExplosion',,,Location);

}

defaultproperties
{
     ParticlesPerSec=(Base=512)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=0,Rand=500)
     ColorStart=(Base=(R=245,G=255,B=125))
     ColorEnd=(Base=(R=242,G=54))
     SizeWidth=(Base=48)
     SizeLength=(Base=48)
     SizeEndScale=(Base=4,Rand=2)
     SpinRate=(Base=1,Rand=1)
     Elasticity=3
     Attraction=(X=3,Y=3,Z=3)
     Damping=1
     ParticlesMax=16
     Textures(0)=Texture'Aeons.Particles.Flare'
}
