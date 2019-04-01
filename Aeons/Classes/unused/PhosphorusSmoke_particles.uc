//=============================================================================
// PhosphorusSmoke_particles.
//=============================================================================
class PhosphorusSmoke_particles expands Phosphorus_particles;

defaultproperties
{
     ParticlesPerSec=(Base=8)
     Lifetime=(Base=1,Rand=1)
     SizeEndScale=(Base=4)
     Gravity=(Z=200)
     Textures(0)=Texture'Aeons.Particles.Smoke32_01'
     Style=STY_AlphaBlend
}
