//=============================================================================
// InvokeFX.
//=============================================================================
class InvokeFX expands ScriptedFX;

var name JointNames[64];
var int NumJoints;

function PreBeginPlay()
{
	local int i;
	local name JointName;
	
	Disable('Tick');
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
	} else {
		AddParticle(1, Owner.Location);
	}
	
	Enable('Tick');
	bUpdate = true;
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
     Lifetime=(Base=1,Rand=1)
     ColorStart=(Base=(R=0,G=255,B=179))
     ColorEnd=(Base=(R=210,G=0,B=255))
     AlphaEnd=(Base=0)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2,Rand=1)
     Gravity=(Z=10)
     Textures(0)=Texture'Aeons.Particles.Flare'
     RenderPrimitive=PPRIM_Billboard
}
