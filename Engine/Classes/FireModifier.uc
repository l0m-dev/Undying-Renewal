//=============================================================================
// FireModifier.
//=============================================================================
class FireModifier expands PlayerModifier;

var() int DamagePerSec;
var() float Duration;
var float TimerLen;
var float Burnout;

function PreBeginPlay()
{
	super.PreBeginPlay();
	
	TimerLen = 1.0/DamagePerSec;

	if ( Owner != None )
	{
		SetLocation(Owner.Location);
		setBase(Owner);
	} else {
		Destroy();
	}
}

simulated function Timer();

state Damaging
{
	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		if ( Burnout > 0.0 )
		{
			Burnout -= DeltaTime;
			if ( Burnout < 0.0 )
			{
				Burnout = 0.0;
				Deactivate();
			}
		}
	}

	simulated function Timer()
	{
		local DamageInfo DInfo;

		DInfo = GetDamageInfo();
		
		if ( Pawn(Owner).AcceptDamage(DInfo) )
			Pawn(Owner).TakeDamage( none, Location, vect(0,0,0), DInfo);
	}

	Begin:
		if (Owner.IsA('PlayerPawn'))
			Deactivate();
		SetTimer(TimerLen, true);
}


function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	DInfo.DamageMultiplier = 1.0;
	DInfo.DamageType = 'Fire';
	if (RGC())
		DInfo.Damage = 5;
	else
		DInfo.Damage = 1;
	return DInfo;
}

function Activate()
{
	local int NumJoints, i;
	local name JointName;
	local Actor A, B;
	local place P;
	local DamageInfo DInfo;

	if ( (Owner != none) && (Pawn(Owner).OnFireParticles != none) && !bActive && (!Owner.IsA('PlayerPawn')))
	{
		NumJoints = Owner.NumJoints();
		if ( NumJoints > 0 )
		{
			bActive = true;
			for (i=0; i<NumJoints; i++)
			{
				if( !Owner.IsA('Pawn') || Pawn(Owner).AddParticleToJoint(i) )
				{
					JointName = Owner.JointName(i);
					P = Owner.JointPlace(JointName);
					A = Spawn(Pawn(Owner).OnFireParticles, Owner,, P.pos);
					A.SetBase(Owner,JointName, 'root');
					if ( Pawn(Owner).OnFireSmokeParticles != none )
					{
						B = Spawn(Pawn(Owner).OnFireSmokeParticles, Owner,, P.pos);
						B.SetBase(Owner,JointName, 'root');
					}
				}
			}
		}
	
		DInfo = GetDamageInfo();
		
		if ( Pawn(Owner).AcceptDamage(DInfo) )
			Pawn(Owner).TakeDamage( none, Location, vect(0,0,0), DInfo);

		setTimer(TimerLen, true);
		Burnout = Duration;
		GotoState('Damaging');
	}
}

function Deactivate()
{
	local ParticleFX P;

	bActive = false;
	setTimer(0, false);
	gotoState('');

	ForEach AllActors(class 'ParticleFX', P)
		if ( P.Owner == Owner )
		{
			P.Shutdown();
		}
}

function SetBurnout( float Duration )
{
	Burnout = Duration;
}

defaultproperties
{
     DamagePerSec=10
     Duration=7
}
