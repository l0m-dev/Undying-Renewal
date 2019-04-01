//=============================================================================
// ShalasVortex_particles. 
//=============================================================================
class ShalasVortex_particles expands ParticleFX;

//BaseParams=(ParticlesPerSec=50.000000,SourceWidth=32.000000,SourceHeight=32.000000,AngularSpreadWidth=30.000000,AngularSpreadHeight=30.000000,Lifetime=1.500000,ColorStart=(R=0,G=255),ColorEnd=(R=0,G=255,B=255),SizeWidth=4.000000)

state Kill
{
	function Timer()
	{
		Destroy();
	}

	begin:
		ParticlesPerSec.Base = 0;
		setTimer(2.0, false);
}

defaultproperties
{
}
