//=============================================================================
// PersistentWound.
//=============================================================================
class PersistentWound expands Wound
	Abstract;

var name AttachJoint;
var ParticleFX P;
var float inc, d;
var Pawn PawnOwner;
var() float BleedTime;

var() class<ParticleFX> Particles;

var int NumDrips;

function BeginPlay()
{
	if ( (Pawn(Owner) == none) || (AeonsPlayer(Owner) != none) )
	{
		Destroy();
	} else {
		PawnOwner = Pawn(Owner);
	}
}

simulated function Setup()
{
	d = 1.0;
	P = spawn(Particles,,,Location,Rotation);
	P.SetBase(self);
	SetBase(Owner, AttachJoint, 'none');

	GotoState('Spurting');
}

state Spurting
{
	simulated function Tick(float DeltaTime)
	{
		local float Str;

		d -= DeltaTime / BleedTime;
		inc += (PawnOwner.HeartRate * 2 * 0.016667) * DeltaTime;
		Str = abs(cos(inc));
		if (Str > 0.99)
		{
			if (NumDrips < 3)
			{
				NumDrips ++;
				Spawn(class 'FallingBloodDrip',,,Location, Rotation);
			}
		}
		P.ParticlesPerSec.Base = P.default.ParticlesPerSec.Base * Str * d;
		P.Speed.Base = PawnOwner.BloodPressure * Str * d;
	}

	simulated function Timer()
	{
		P.bShuttingDown = true;
		Destroy();
	}

	Begin:
		setTimer(BleedTime, false);
}

defaultproperties
{
     BleedTime=5
     Particles=Class'Aeons.WoundParticleFX'
     bHidden=False
     Style=STY_AlphaBlend
}
