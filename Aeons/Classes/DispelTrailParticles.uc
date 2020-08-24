//=============================================================================
// DispelTrailParticles. 
//=============================================================================
class DispelTrailParticles expands SpellParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=128)
     SourceWidth=(Base=4)
     SourceHeight=(Base=4)
     SourceDepth=(Base=4)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=0,Rand=100)
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(R=64,G=255,B=193))
     ColorEnd=(Base=(R=179,B=255))
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2,Rand=4)
     DripTime=(Base=0.1,Rand=0.25)
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
