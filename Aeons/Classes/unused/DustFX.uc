//=============================================================================
// DustFX.
//=============================================================================
class DustFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=128)
     SourceWidth=(Base=128)
     SourceHeight=(Base=128)
     SourceDepth=(Base=32)
     AngularSpreadWidth=(Base=45)
     AngularSpreadHeight=(Base=45)
     Speed=(Base=256)
     Lifetime=(Base=3)
     ColorStart=(Base=(R=89,G=89,B=89))
     ColorEnd=(Base=(R=128,G=128,B=128),Rand=(R=192,G=192,B=192))
     SizeWidth=(Base=64)
     SizeLength=(Base=64)
     SizeEndScale=(Base=2,Rand=3)
     SpinRate=(Base=-2,Rand=4)
     Chaos=16
     Elasticity=0.1
     Damping=5
     WindModifier=1
     GravityModifier=0.1
     ParticlesAlive=256
     ParticlesMax=384
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
     Tag=DustFX
}
