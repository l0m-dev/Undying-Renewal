//=============================================================================
// ChargedSpearFX.
//=============================================================================
class ChargedSpearFX expands ScriptedFX;

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
	bShuttingDown = true;
}

function RenderOverlays(Canvas Canvas)
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
			Params.Velocity = Velocity;
			SetParticleParams(i, Params);
		}
	} else {
		GetParticleParams(1,Params);
		Params.Position = Owner.Location;
		Params.Velocity = Velocity;			
		SetParticleParams(1, Params);
	}
}

defaultproperties
{
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=255,G=255,B=255))
     AlphaEnd=(Base=0)
     SizeWidth=(Base=4)
     SizeLength=(Base=4)
     SpinRate=(Base=-8,Rand=16)
     AlphaDelay=0.75
     Textures(0)=Texture'Aeons.Particles.BallLightning'
     bHidden=True
     bDrawBehindOwner=True
}
