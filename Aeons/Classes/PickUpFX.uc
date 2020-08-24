//=============================================================================
// PickUpFX.
//=============================================================================
class PickUpFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=32)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     Speed=(Base=0)
     Lifetime=(Base=1.5,Rand=1)
     ColorStart=(Rand=(R=128,G=128,B=64))
     ColorEnd=(Base=(R=192,G=192,B=192),Rand=(G=128))
     SizeEndScale=(Base=0,Rand=0.5)
     SpinRate=(Base=-2,Rand=4)
     Chaos=2
     Gravity=(Z=32)
     Tag=PickUpFX
}
