//=============================================================================
// OnFireParticleFX. 
//=============================================================================
class OnFireParticleFX expands AeonsParticleFX;

function PreBeginPlay()
{
	super.PreBeginPlay();
	setTimer(0.5, true);
}

function Timer()
{
	if (Owner == none)
		bShuttingDown = true;
}

defaultproperties
{
     ParticlesPerSec=(Base=1,Rand=2)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     bSteadyState=True
     Speed=(Base=0,Rand=20)
     Lifetime=(Base=0.25,Rand=0.25)
     ColorStart=(Base=(G=155,B=45))
     AlphaStart=(Base=0.25,Rand=0.75)
     SizeWidth=(Base=16)
     SizeLength=(Base=16)
     SizeEndScale=(Base=0,Rand=8)
     SpinRate=(Base=-8,Rand=16)
     Damping=1
     WindModifier=1
     Gravity=(Z=700)
     Textures(0)=Texture'Aeons.Particles.PotFire07'
     LODBias=10
}
