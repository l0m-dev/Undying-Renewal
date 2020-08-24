//=============================================================================
// InvokingFX.
//=============================================================================
class InvokingFX expands ScriptedFX;

var name JointNames[64];
var int NumJoints;

function PreBeginPlay()
{
	local int i;
	local name JointName;
	local Actor A;
	local float p;

	A = Owner;

	p = A.CollisionHeight / 48.0;
	ColorStart.Base = PlayerPawn(A.Owner).InvokeColor;
	SizeWidth.Base = FClamp((48 * p), 8, 96);
	SizeLength.Base = FClamp((48 * p), 8, 96);

	Disable('Tick');
	if (Owner == none)
	{
		bShuttingDown = true;
		log ("Invoking Effect shutting down - Owner is none", 'Misc');
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
	
	if ( Owner == none)
	{
		bShuttingDown = true;
		return;
	} else {
	
		SetLocation(Owner.Location);

		if ( NumJoints > 0 )
		{
			for (i=0; i<NumJoints; i++)
			{
				if ( FRand() > 0.80 )
					AddParticle(i, Owner.JointPlace(JointNames[i]).pos);
			}
		}
	}
}

defaultproperties
{
     AngularSpreadWidth=(Rand=180)
     AngularSpreadHeight=(Rand=180)
     Speed=(Rand=200)
     Lifetime=(Rand=2)
     ColorStart=(Base=(R=0,G=255,B=0))
     ColorEnd=(Base=(R=0,G=0,B=255))
     AlphaStart=(Rand=0.5)
     AlphaEnd=(Base=0)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=0)
     Elasticity=0.25
     Gravity=(Z=-900)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     RenderPrimitive=PPRIM_Billboard
}
