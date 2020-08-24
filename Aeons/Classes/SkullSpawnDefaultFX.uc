//=============================================================================
// SkullSpawnDefaultFX. 
//=============================================================================
class SkullSpawnDefaultFX expands SpellParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=2048)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=20,Rand=50)
     Lifetime=(Base=0.25,Rand=0.75)
     ColorStart=(Base=(G=64))
     ColorEnd=(Base=(R=183,G=183,B=183))
     AlphaStart=(Base=0.5,Rand=0.5)
     SizeEndScale=(Rand=3)
     Damping=5
     Gravity=(Z=100)
     ParticlesMax=32
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
