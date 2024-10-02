//=============================================================================
// LBGGlowFX.
//=============================================================================
class LBGGlowFX expands ScriptedFX;

var name JointNames[64];
var int NumJoints;

function PreBeginPlay()
{
	local int i;
	local name JointName;
	
	disable('Tick');
	
	if (Owner == none)
	{
		Destroy();
		return;
	}

	setLocation(Owner.Location);
	setBase(Owner);
	NumJoints = Owner.NumJoints();
	
	if (NumJoints > 0)
	{
		// Iterate the joints
		for (i=0; i<NumJoints; i++)
		{
			JointNames[i] = Owner.JointName(i);
			AddParticle(i, Owner.JointPlace(JointNames[i]).pos);
		}
		Enable('Tick');
	} else {
		AddParticle(1, Owner.Location);
	}
}

function Tick(float DeltaTime)
{
	local int i;
	
	if ( Owner == none )
	{
		Destroy();
		return;
	}
	
	setLocation(Owner.Location);

	if ( NumJoints > 0 )
	{
		for (i=0; i<NumJoints; i++)
		{
			GetParticleParams(i,Params);
			Params.Position = Owner.JointPlace(JointNames[i]).pos;
			Params.Alpha = Owner.Opacity;
			SetParticleParams(i, Params);
		}
	} else {
		GetParticleParams(1,Params);
		Params.Position = Owner.Location;
		SetParticleParams(1, Params);
	}
}

/*
state ShutDownState
{
	Begin:
		Destroy();
}
*/

defaultproperties
{
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=255,G=255,B=255))
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     Textures(0)=Texture'Aeons.Particles.EctoFX03'
     RenderPrimitive=PPRIM_Billboard
}
