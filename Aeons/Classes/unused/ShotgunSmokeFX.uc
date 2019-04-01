//=============================================================================
// ShotgunSmokeFX. 
//=============================================================================
class ShotgunSmokeFX expands WeaponParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     SourceWidth=(Base=1)
     SourceHeight=(Base=1)
     SourceDepth=(Base=1)
     AngularSpreadWidth=(Base=10)
     AngularSpreadHeight=(Base=10)
     Speed=(Base=100,Rand=500)
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(R=90,G=80,B=141))
     ColorEnd=(Base=(R=156,G=156,B=158))
     AlphaStart=(Base=0.25,Rand=0.25)
     SizeWidth=(Base=4)
     SizeLength=(Base=4)
     SizeEndScale=(Base=16)
     SpinRate=(Base=-1,Rand=1)
     Damping=4
     Gravity=(Z=30)
     ParticlesMax=32
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
