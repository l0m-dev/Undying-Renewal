//=============================================================================
// Phosphorus_particles. 
//=============================================================================
class Phosphorus_particles expands WeaponParticleFX;

#exec Texture Import File=Phos.pcx Name=Phos GROUP="Gradients" Mips=Off

defaultproperties
{
     ParticlesPerSec=(Base=64)
     SourceWidth=(Base=4)
     SourceHeight=(Base=4)
     SourceDepth=(Base=4)
     AngularSpreadWidth=(Base=30)
     AngularSpreadHeight=(Base=30)
     Speed=(Base=0)
     Lifetime=(Base=0.25,Rand=0.5)
     ColorStart=(Base=(R=247,G=255,B=81))
     ColorEnd=(Base=(G=96))
     AlphaStart=(Base=0.5,Rand=0.5)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2,Rand=6)
     SpinRate=(Base=-3,Rand=6)
     Damping=6
     Gravity=(Z=100)
     Textures(0)=Texture'Aeons.Particles.PotFire08'
     ColorPalette=Texture'Aeons.Gradients.Phos'
     LODBias=100
     AmbientSound=Sound'Aeons.Weapons.E_Wpn_MoltFireLoop01'
     SoundVolume=24
     CollisionRadius=2
     CollisionHeight=2
}
