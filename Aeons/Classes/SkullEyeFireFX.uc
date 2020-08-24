//=============================================================================
// SkullEyeFireFX. 
//=============================================================================
class SkullEyeFireFX expands FireParticleFX;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	SetTimer(1.5, false);
}

function Timer()
{
	bShuttingDown = true;
}

defaultproperties
{
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     SourceDepth=(Base=0)
     Speed=(Rand=100)
     Lifetime=(Base=0.1,Rand=0.25)
     SizeWidth=(Base=6)
     SizeLength=(Base=6)
     bVelocityRelative=True
}
