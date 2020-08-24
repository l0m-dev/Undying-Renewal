//=============================================================================
// GhelzSmallRingFX. 
//=============================================================================
class GhelzSmallRingFX expands WeaponParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=4096)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=130,Rand=50)
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(R=175,G=81,B=238))
     ColorEnd=(Base=(R=0,G=255,B=6))
     SizeWidth=(Base=3)
     SizeLength=(Base=3)
     SizeEndScale=(Rand=2)
     Chaos=16
     ChaosDelay=0.75
     Elasticity=0.01
     Damping=5
     ParticlesMax=512
     Textures(0)=Texture'Aeons.Particles.EctoFX03'
}
