//=============================================================================
// ColdEffect_particles. 
//=============================================================================
class ColdEffect_particles expands SphereOfCold_particles;

function PreBeginPlay()
{
	super.PreBeginPlay();
	setTimer(0.5,true);
}

function Timer()
{
	if (Owner == none)
		Shutdown();
}

defaultproperties
{
     SourceHeight=(Base=96)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=20,Rand=30)
     Lifetime=(Base=0.25)
     AlphaStart=(Base=0.25,Rand=0.75)
     SpinRate=(Base=-4,Rand=8)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
}
