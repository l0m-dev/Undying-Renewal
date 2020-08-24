//=============================================================================
// SandParticleFX. 
//=============================================================================
class SandParticleFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=4096)
     SourceWidth=(Base=4)
     SourceHeight=(Base=4)
     SourceDepth=(Base=4)
     AngularSpreadWidth=(Base=10,Rand=10)
     AngularSpreadHeight=(Base=10,Rand=10)
     Speed=(Base=200,Rand=1000)
     Lifetime=(Base=10)
     ColorStart=(Base=(R=192,G=162,B=126))
     ColorEnd=(Base=(R=227,G=220,B=215))
     AlphaStart=(Base=0.75,Rand=0.25)
     SizeWidth=(Base=2,Rand=2)
     SizeLength=(Base=2,Rand=2)
     Elasticity=0.2
     Damping=0.5
     WindModifier=1
     Gravity=(Z=-950)
     ParticlesMax=512
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
     LODBias=100
     CollisionRadius=1000
     CollisionHeight=1000
}
