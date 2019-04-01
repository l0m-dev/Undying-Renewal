//=============================================================================
// SphereOfCold_particles. 
//=============================================================================
class SphereOfCold_particles expands SpellParticleFX
	transient;

defaultproperties
{
     ParticlesPerSec=(Base=128)
     SourceWidth=(Base=32)
     SourceHeight=(Base=32)
     SourceDepth=(Base=32)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(R=13,B=255))
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2,Rand=2)
     Damping=0.2
     WindModifier=1
     Gravity=(Z=-50)
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
     LODBias=5
}
