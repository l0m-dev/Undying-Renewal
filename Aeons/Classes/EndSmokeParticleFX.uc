//=============================================================================
// EndSmokeParticleFX. 
//=============================================================================
class EndSmokeParticleFX expands SmokeParticleFX;

simulated function PreBeginPlay()
{
	setTimer(0.75,false);
}

simulated function Timer()
{
	Shutdown();
}

defaultproperties
{
     ParticlesPerSec=(Base=12)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     SpinRate=(Base=0,Rand=0)
     Damping=0.2
     LODBias=5
}
