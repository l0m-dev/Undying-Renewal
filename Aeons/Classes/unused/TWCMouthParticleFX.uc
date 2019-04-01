//=============================================================================
// TWCMouthParticleFX. 
//=============================================================================
class TWCMouthParticleFX expands TWCNoseParticleFX;

function BeginPlay();

defaultproperties
{
     ParticlesPerSec=(Base=32)
     Speed=(Rand=300)
     Lifetime=(Rand=0.5)
     ColorStart=(Base=(R=143,G=135,B=194))
     ColorEnd=(Base=(R=16,G=0,B=210))
     SizeWidth=(Base=4)
     SizeLength=(Base=4)
     SizeEndScale=(Base=4)
     bVelocityRelative=False
     bSystemRelative=True
     Elasticity=0.0001
}
