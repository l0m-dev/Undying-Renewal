//=============================================================================
// TWCNoseParticleFX. 
//=============================================================================
class TWCNoseParticleFX expands WeaponParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     Speed=(Base=100,Rand=200)
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(R=147,G=138,B=255))
     SizeWidth=(Base=2)
     SizeLength=(Base=2)
     SizeEndScale=(Base=6,Rand=2)
     bVelocityRelative=True
     Damping=15
     WindModifier=0.2
     Gravity=(Z=-50)
     ParticlesMax=16
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
     RemoteRole=ROLE_None
}
