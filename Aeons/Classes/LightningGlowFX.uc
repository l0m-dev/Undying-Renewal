//=============================================================================
// LightningGlowFX.
//=============================================================================
class LightningGlowFX expands GlowScriptedFX;

function PreBeginPlay()
{
	super.PreBeginPlay();
	Enable('Tick');

	Shutdown();
	GotoState('GenSmoke');
}

state GenSmoke
{

	Begin:
		sleep(0.35);
		spawn(class 'LightningScorchFX',Owner,,Location);
}

function Tick(float DeltaTime)
{
	local int i;
	
	if ( Owner == none )
		Destroy();
	
	setLocation(Owner.Location);

	if ( NumJoints > 0 )
	{
		for (i=0; i<NumJoints; i++)
		{
			GetParticleParams(i,Params);
			Params.Position = Owner.JointPlace(JointNames[i]).pos;
			SetParticleParams(i, Params);
		}
	} else {
		GetParticleParams(1,Params);
		Params.Position = Owner.Location;
		SetParticleParams(1, Params);
	}
}

defaultproperties
{
     Lifetime=(Base=1)
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=255,G=255,B=255))
     AlphaEnd=(Base=0)
     SpinRate=(Base=-8,Rand=16)
     AlphaDelay=0.75
     Textures(0)=Texture'Aeons.Particles.BallLightning'
}
