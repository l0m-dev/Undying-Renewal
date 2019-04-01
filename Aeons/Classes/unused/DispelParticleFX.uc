//=============================================================================
// DispelParticleFX. 
//=============================================================================
class DispelParticleFX expands SpellParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=4096)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=0,Rand=100)
     Lifetime=(Base=2,Rand=2)
     ColorStart=(Base=(R=64,G=255,B=193))
     ColorEnd=(Base=(R=159,B=255))
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2,Rand=3)
     Damping=2
     WindModifier=1
     bWindPerParticle=True
     ParticlesMax=64
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
