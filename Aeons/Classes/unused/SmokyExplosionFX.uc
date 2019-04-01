//=============================================================================
// SmokyExplosionFX. 
//=============================================================================
class SmokyExplosionFX expands ExplosionFX;

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=500,Rand=800)
     Lifetime=(Rand=2)
     ColorStart=(Base=(R=89,G=89,B=89))
     ColorEnd=(Base=(R=82,G=82,B=82))
     SizeWidth=(Base=96)
     SizeLength=(Base=96)
     SizeEndScale=(Base=2,Rand=3)
     SpinRate=(Base=-1,Rand=2)
     Elasticity=0.01
     Damping=10
     Gravity=(Z=10)
     ParticlesMax=32
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
     LODBias=10
}
