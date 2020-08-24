//=============================================================================
// WindFX.
//=============================================================================
class WindFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=64)
     SourceWidth=(Base=128)
     SourceHeight=(Base=256)
     Speed=(Base=0)
     Lifetime=(Base=4)
     ColorStart=(Base=(R=0,G=255,B=255),Rand=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=128,B=128),Rand=(R=64,B=64))
     SizeWidth=(Base=0,Rand=16)
     SizeLength=(Base=0,Rand=8)
     SizeEndScale=(Base=0,Rand=2)
     SpinRate=(Base=1,Rand=-2)
     AlphaDelay=3
     Chaos=128
     ChaosDelay=1
     Damping=1
     WindModifier=1
     Tag=WindFX
}
