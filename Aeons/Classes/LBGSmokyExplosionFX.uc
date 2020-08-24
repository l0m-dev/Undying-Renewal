//=============================================================================
// LBGSmokyExplosionFX.
//=============================================================================
class LBGSmokyExplosionFX expands SmokyExplosionFX;

defaultproperties
{
     ParticlesPerSec=(Base=2048)
     Speed=(Base=2000,Rand=1000)
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(R=186,G=174,B=255))
     ColorEnd=(Base=(R=55,G=52,B=112))
     SizeEndScale=(Base=5,Rand=5)
     Damping=3
     ParticlesMax=256
}
