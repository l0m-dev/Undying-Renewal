//=============================================================================
// GhelzRingFX. 
//=============================================================================
class GhelzRingFX expands WeaponParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=4096)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=800,Rand=500)
     Lifetime=(Base=0.25,Rand=0.25)
     ColorStart=(Base=(R=175,G=81,B=238))
     ColorEnd=(Base=(R=0,G=255,B=6))
     SizeEndScale=(Rand=0.5)
     Chaos=64
     ChaosDelay=0.25
     Damping=2
     ParticlesMax=1024
     Textures(0)=Texture'Aeons.Particles.EctoFX03'
}
