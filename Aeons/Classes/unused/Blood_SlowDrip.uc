//=============================================================================
// Blood_SlowDrip.
//=============================================================================
class Blood_SlowDrip expands BloodParticles;

defaultproperties
{
     ParticlesPerSec=(Base=0.25,Max=0)
     SourceHeight=(Base=0)
     bSteadyState=True
     Speed=(Base=0,Rand=0)
     ColorStart=(Max=(R=0),Rand=(R=64,B=64))
     ColorEnd=(Max=(R=0),Rand=(R=64))
     AlphaEnd=(Base=0.75)
     SizeWidth=(Base=3,Rand=0)
     SizeLength=(Base=1,Max=0)
     SizeEndScale=(Base=2,Rand=0)
     DripTime=(Base=0.25)
}
