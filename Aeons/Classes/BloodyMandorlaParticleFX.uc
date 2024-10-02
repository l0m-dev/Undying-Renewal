//=============================================================================
// BloodyMandorlaParticleFX. 
//=============================================================================
class BloodyMandorlaParticleFX expands AeonsParticleFX;

function PreBeginPlay()
{
	super.PreBeginPlay();
	setTimer(0.5, true);
}

function Timer()
{
	if (Owner == none)
		Shutdown();
}

defaultproperties
{
     ParticlesPerSec=(Base=4,Rand=4)
     SourceWidth=(Base=4)
     SourceHeight=(Base=4)
     SourceDepth=(Base=4)
     Speed=(Rand=20)
     Lifetime=(Base=0.25,Rand=0.25)
     ColorStart=(Base=(R=138,G=3,B=3))
     ColorEnd=(Base=(R=138,B=3))
     AlphaStart=(Base=0.25,Rand=0.75)
     SizeWidth=(Base=16)
     SizeLength=(Base=16)
     SizeEndScale=(Rand=8)
     SpinRate=(Base=-8,Rand=16)
     Damping=0.1
     WindModifier=1
     Gravity=(Z=700)
     Textures(0)=Texture'Aeons.Particles.PotFire09'
     bOwnerNoSee=True
}
