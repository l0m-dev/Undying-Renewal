//=============================================================================
// Mist.
//=============================================================================
class Mist expands ScriptedFlyer;

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************


//****************************************************************************
// Structure defs.
//****************************************************************************
enum EMistLimbState
{
	EMIST_Orbit,
	EMIST_Whip,
	EMIST_Attack,
	EMIST_Retract,
	EMIST_Burn
};

struct MistLimbInfo
{
	var() ParticleFX		PFX;				//
	var() rotator			Rotation;			//
	var() rotator			RotationRate;		//
	var() float				OrbitDistance;		//
	var vector				Location;			//
	var vector				TargetLocation;		//
	var float				Velocity;			//
	var EMistLimbState		State;				//
};


//****************************************************************************
// Member vars.
//****************************************************************************
var ParticleFX				MistFX;				//
var() MistLimbInfo			MistLimb[8];		//
var int						AttackLimb;			//
var() rotator				RotateSpeed[4];		//
var() float					OrbitBase;			// TEMP
var() float					OrbitPlusOrMinus;	// TEMP
var() float					AttackVelocityBase;	// TEMP
var() float					AttackVelocityPlusOrMinus;	// TEMP
var() float					PreAttackWhipDistance;		// TEMP


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
simulated function PreBeginPlay()
{
	local int	lp;

	DrawType = DT_None;

	super.PreBeginPlay();
	MistFX = Spawn( class'MistParticleFX', self,, Location );
	if ( MistFX != none )
		MistFX.SetBase( self );

	for ( lp=0; lp<ArrayCount(MistLimb); lp++ )
	{
		MistLimb[lp].PFX = Spawn( class'MistLimbFX', self,, Location );
		MistLimb[lp].OrbitDistance = FVariant( OrbitBase, OrbitPlusOrMinus );
		MistLimb[lp].Rotation.Yaw = Rand(65500);
		MistLimb[lp].Rotation.Pitch = 16000 - Rand(32000);
		MistLimb[lp].RotationRate = RotateSpeed[Rand(ArrayCount(RotateSpeed))];
		MistLimb[lp].Velocity = FVariant( AttackVelocityBase, AttackVelocityPlusOrMinus );
	}

	if ( FireMod != none )
	{
		FireMod.Destroy();
		FireMod = none;
	}
}

simulated function Destroyed()
{
	local int	lp;

	if ( MistFX != none )
		MistFX.Destroy();

	for ( lp=0; lp<ArrayCount(MistLimb); lp++ )
		if ( MistLimb[lp].PFX != none )
			MistLimb[lp].PFX.Destroy();

	super.Destroyed();
}

function Tick( float DeltaTime )
{
	local int		lp;
	local vector	X, Y, Z;

	super.Tick( DeltaTime );

	for ( lp=0; lp<ArrayCount(MistLimb); lp++ )
	{
		if ( MistLimb[lp].PFX != none )
		{
			switch ( MistLimb[lp].State )
			{
				case EMIST_Orbit:
					UpdateOrbit( MistLimb[lp], DeltaTime, true );
					break;
				case EMIST_Whip:
					if ( UpdateWhip( MistLimb[lp], DeltaTime ) )
					{
						MistLimb[lp].State = EMIST_Attack;
						MistLimb[lp].TargetLocation = Enemy.Location + vect(0,0,1) * Enemy.EyeHeight;
					}
					break;
				case EMIST_Attack:
					if ( UpdateAttack( MistLimb[lp], DeltaTime ) )
					{
						MistLimb[lp].PFX.SizeWidth.Base = MistLimb[lp].PFX.default.SizeWidth.Base;
						MistLimb[lp].PFX.SizeLength.Base = MistLimb[lp].PFX.default.SizeLength.Base;
						MistLimb[lp].State = EMIST_Retract;
					}
					DoNearDamage();
					break;
				case EMIST_Retract:
					UpdateOrbit( MistLimb[lp], DeltaTime, false );
					if ( UpdateRetract( MistLimb[lp], DeltaTime ) )
						MistLimb[lp].State = EMIST_Orbit;
					break;
				case EMIST_Burn:
					UpdateBurn( MistLimb[lp], DeltaTime );
					break;
			}

			MistLimb[lp].PFX.SetLocation( MistLimb[lp].Location );
			MistLimb[lp].PFX.SetRotation( MistLimb[lp].Rotation );
		}
	}
}

function PlayLocomotion( vector dVector )
{
}

function bool DoFarAttack()
{
	local float		Dist;

	Dist = DistanceTo( Enemy );

	if ( Dist > LongRangeDistance )
		return false;
	else if ( DistanceTo( Enemy ) > SafeDistance )
		return ( FRand() < 0.45 );
	else
		return false;
}

function bool FlankEnemy()
{
	return false;
}

function vector FlankPosition( vector target )
{
	return target;
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	return LocationStrikeValid( Victim, MistLimb[AttackLimb].Location, DamageRadius );
}

function DamageInfo getDamageInfo( optional name DamageType )
{
	local DamageInfo	DInfo;

	if ( DamageType == 'nearattack' )
	{
		DInfo.Deliverer = self;
		DInfo.DamageMultiplier = 1.0;
		DInfo.DamageType = DamageType;
		DInfo.Damage = MeleeInfo[0].Damage;
		DInfo.EffectStrength = MeleeInfo[0].EffectStrength;
		DInfo.bMagical = true;
		return DInfo;
	}
	else
		return super.getDamageInfo( DamageType );
}

function vector GetGotoPoint( vector thisLocation )
{
	return thisLocation;
}


//****************************************************************************
// New class functions.
//****************************************************************************
function UpdateOrbit( out MistLimbInfo ThisLimb, float DeltaTime, bool bUpdateLoc )
{
	ThisLimb.Rotation.Yaw += ThisLimb.RotationRate.Yaw * DeltaTime;
	ThisLimb.Rotation.Pitch += ThisLimb.RotationRate.Pitch * DeltaTime;
	if ( bUpdateLoc )
		ThisLimb.Location = LocalToWorld( vector(ThisLimb.Rotation) * ThisLimb.OrbitDistance );
}

function bool UpdateWhip( out MistLimbInfo ThisLimb, float DeltaTime )
{
	local vector	DVect;

	DVect = ThisLimb.TargetLocation - ThisLimb.Location;
	ThisLimb.Location += Normal(DVect) * ThisLimb.Velocity * DeltaTime;
	if ( VSize(DVect) < 10.0 )
		return true;
	return false;
}

// Update position of attacking limb, return true if close to target.
function bool UpdateAttack( out MistLimbInfo ThisLimb, float DeltaTime )
{
	local vector	DVect;

	DVect = ThisLimb.TargetLocation - ThisLimb.Location;
	ThisLimb.Location += Normal(DVect) * ThisLimb.Velocity * DeltaTime;
	if ( VSize(DVect) < 25.0 )
		return true;
	return false;
}

function bool UpdateRetract( out MistLimbInfo ThisLimb, float DeltaTime )
{
	local vector	DVect;

	ThisLimb.TargetLocation = LocalToWorld( vector(ThisLimb.Rotation) * ThisLimb.OrbitDistance );
	DVect = ThisLimb.TargetLocation - ThisLimb.Location;
	ThisLimb.Location += Normal(DVect) * 500.0 * DeltaTime;
	if ( VSize(DVect) < 10.0 )
		return true;
	return false;
}

function UpdateBurn( out MistLimbInfo ThisLimb, float DeltaTime )
{
	ThisLimb.Rotation.Yaw += ThisLimb.RotationRate.Yaw * DeltaTime * 3.0;
	ThisLimb.Rotation.Pitch = 0;
//	ThisLimb.Rotation.Pitch += ThisLimb.RotationRate.Pitch * DeltaTime;
	ThisLimb.Location = LocalToWorld( vector(ThisLimb.Rotation) * ThisLimb.OrbitDistance );
}

function WhipAttack()
{
	local vector	X, Y, Z;

	DebugInfoMessage( ".WhipAttack(), AttackLimb is " $ AttackLimb );
	AttackLimb += 1;
	if ( AttackLimb == ArrayCount(MistLimb) )
		AttackLimb = 0;
	if ( MistLimb[AttackLimb].PFX != none )
	{
		GetAxes( Rotation, X, Y, Z );
		if ( ( ( MistLimb[AttackLimb].Location - Location ) dot Y ) > 0.0 )
			MistLimb[AttackLimb].TargetLocation = Location + Y * PreAttackWhipDistance;
		else
			MistLimb[AttackLimb].TargetLocation = Location - Y * PreAttackWhipDistance;
		MistLimb[AttackLimb].State = EMIST_Whip;
		MistLimb[AttackLimb].PFX.SizeWidth.Base = MistLimb[AttackLimb].PFX.default.SizeWidth.Base * 5.0;
		MistLimb[AttackLimb].PFX.SizeLength.Base = MistLimb[AttackLimb].PFX.default.SizeLength.Base * 5.0;
	}
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIWait
// wait for encounter at current location
//****************************************************************************
state AIWait
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Timer()
	{
		DebugInfoMessage( ".Mist.AIWait.Timer()" );
		if ( FRand() < 0.20 )
		{
			HoverAltitude = default.HoverAltitude + FRand() * 80.0;
			super.Timer();
			return;
		}
		CueNextEvent();
	}

	function CueNextEvent()
	{
		SetTimer( 2.0, false );
	}

	function SlowMovement()
	{
		StopMovement();
	}

	// *** new (state only) functions ***

} // state AIWait


//****************************************************************************
// AIAmbush
// wait for encounter in heightened alert
//****************************************************************************
state AIAmbush
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		GotoState( 'AIWait' );
	}

	// *** new (state only) functions ***

} // state AIAmbush


//****************************************************************************
// AIAttack
// primary attack dispatch state
//****************************************************************************
state AIAttack
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Dispatch()
	{
		DebugInfoMessage( ".AIAttack.Dispatch(), DefCon is " $ DefCon $ ", Health=" $ Health);
		if ( DistanceTo( Enemy ) < SafeDistance )
		{
			DebugInfoMessage( ".AIAttack.Dispatch(), Dist is < SafeDistance" );
			GotoState( 'AIAvoidEnemy' );
			return;
		}
		/*
		if ( ( ScriptedPawn(Enemy) == none ) &&
			 ( VisionEffector.GetSensorLevel() < 0.75 ) &&
			 ( HearingEffector.GetSensorLevel() < 0.10 ) )
		{
			// Lost enemy.
			DebugInfoMessage( ".AIAttack, lost enemy." );
			GotoInitState();
			return;
		}
		*/
		super.Dispatch();
	}

	// *** new (state only) functions ***

} // state AIAttack


//****************************************************************************
// AIAvoidEnemy
// Avoid Enemy within SafeDistance, pick a retreat point and seek it
//****************************************************************************
state AIAvoidEnemy
{
	// *** ignored functions ***

	// *** overridden functions ***
	// In this state, this function is called when the Mist can't find a valid avoid point
	function GotoInitState()
	{
		GotoState( 'AIFarAttack' );
	}

	// *** new (state only) functions ***

} // state AIAvoidEnemy


//****************************************************************************
// AICharge
// Charge Enemy.
//****************************************************************************
state AICharge
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		Evaluate();
	}

	function Evaluate()
	{
		local float		Dist;

		Dist = DistanceTo( Enemy );

		if ( Dist < SafeDistance )
		{
			DebugInfoMessage( ".AICharge.Evaluate(), Dist is < SafeDistance" );
			GotoState( 'AIAvoidEnemy' );
			return;
		}
		else if ( Dist < LongRangeDistance )
		{
			DebugInfoMessage( ".AICharge.Evaluate(), Dist is < LongRangeDistance" );
			GotoState( 'AIAttack' );
			return;
		}
	}

	// *** new (state only) functions ***

} // state AICharge


//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Timer()
	{
		GotoState( , 'ATTACKED' );
	}

	// *** new (state only) functions ***
	function bool AttackFinished()
	{
		local int	lp;

		for ( lp=0; lp<ArrayCount(MistLimb); lp++ )
			if ( MistLimb[lp].State != EMIST_Orbit )
				return false;
		return true;
	}


// Entry point when resuming this state.
RESUME:

// Default entry point.
BEGIN:
	StopMovement();
	TurnToward( Enemy, 15 * DEGREES );
	WhipAttack();
	SetTimer( 5.0, false );
	DebugInfoMessage( ".AIFarAttackAnim, Dist is " $ DistanceTo( Enemy ) );

TURRET:
	if ( AttackFinished() )
		goto 'ATTACKED';
	TurnToward( Enemy, 10 * DEGREES );
	Sleep( 0.10 );
	goto 'TURRET';

ATTACKED:
	GotoState( 'AIAttack' );
} // state AIFarAttackAnim


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** ignored functions ***

	// *** overridden functions ***
	function PostSpecialKill()
	{
		TargetActor = SK_TargetPawn;
		GotoState( 'AIDance', 'DANCE' );
		SK_TargetPawn.GotoState('SpecialKill', 'SpecialKillComplete');
	}

	function AtPoint()
	{
		GotoState( , 'BURN' );
	}

	// *** new (state only) functions ***
	function SetAllLimbs( EMistLimbState LState )
	{
		local int	lp;

		for ( lp=0; lp<ArrayCount(MistLimb); lp++ )
			if ( MistLimb[lp].PFX != none )
				MistLimb[lp].State = LState;
	}


BURN:
	SetAllLimbs( EMIST_Burn );
	SK_TargetPawn.PlayAnim( 'death_powerword_start',, MOVE_Anim );
	Sleep( 5.0 );
	SetAllLimbs( EMIST_Orbit );
	SK_TargetPawn.PlayAnim( 'death_powerword_end' );
	PostSpecialKill();

} // state AISpecialKill


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     RotateSpeed(0)=(Pitch=12000,Yaw=10000)
     RotateSpeed(1)=(Pitch=-10000,Yaw=-7500)
     RotateSpeed(2)=(Pitch=7500,Yaw=-10000)
     RotateSpeed(3)=(Pitch=-10000,Yaw=7500)
     OrbitBase=60
     OrbitPlusOrMinus=20
     AttackVelocityBase=725
     AttackVelocityPlusOrMinus=25
     PreAttackWhipDistance=200
     HoverAltitude=180
     HoverVariance=70
     HoverRadius=10
     bCanHover=True
     WaitGlideScalar=0.3
     bNoDeathSpin=True
     SafeDistance=250
     LongRangeDistance=500
     Aggressiveness=1
     bHasNearAttack=False
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=15)
     DamageRadius=40
     SK_PlayerOffset=(Z=60)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.3
     PhysicalScalar=0
     MagicalScalar=0
     FireScalar=0
     bCanStrafe=True
     MeleeRange=250
     AirSpeed=300
     MaxStepHeight=35
     SightRadius=2000
     PeripheralVision=0
     BaseEyeHeight=1
     Health=120
     RotationRate=(Pitch=16000,Yaw=60000,Roll=0)
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Particle'
     CollisionRadius=12
     CollisionHeight=12
     bCollideActors=False
     LightType=LT_Steady
     LightEffect=LE_TorchWaver
     LightBrightness=222
     LightHue=150
     LightSaturation=25
     LightRadius=40
}
