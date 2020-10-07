//=============================================================================
// FlickeringStalker.
//=============================================================================
class FlickeringStalker expands ScriptedFlyer;

//#exec MESH IMPORT MESH=FlickeringStalker_m SKELFILE=FlickeringStalker.ngf
//#exec MESH JOINTNAME Head1=Head Jaw1=Jaw

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=bite1 TIME=0.294 FUNCTION=DoNearDamageReset
//#exec MESH NOTIFY SEQ=bite1 TIME=0.353 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=bite1 TIME=0.412 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=chomp TIME=0.333 FUNCTION=DoNearDamageReset
//#exec MESH NOTIFY SEQ=chomp TIME=0.400 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=rightwhip TIME=0.282 FUNCTION=DoNearDamage2
//#exec MESH NOTIFY SEQ=rightwhip TIME=0.333 FUNCTION=DoNearDamage2
//#exec MESH NOTIFY SEQ=rightwhip TIME=0.385 FUNCTION=DoNearDamage2
//#exec MESH NOTIFY SEQ=rightwhip TIME=0.358 FUNCTION=GibPlayer
//#exec MESH NOTIFY SEQ=coil TIME=1.000 FUNCTION=hiss_1
//#exec MESH NOTIFY SEQ=alert_to_coil TIME=1.000 FUNCTION=hiss_1
//#exec MESH NOTIFY SEQ=hiss_1 TIME=1.000 FUNCTION=hiss_2
//#exec MESH NOTIFY SEQ=hiss_2 TIME=1.000 FUNCTION=hiss_2
//#exec MESH NOTIFY SEQ=cobra1 TIME=1.000 FUNCTION=cobra2
//#exec MESH NOTIFY SEQ=cobra2 TIME=1.000 FUNCTION=cobra2
//#exec MESH NOTIFY SEQ=death1a TIME=1.000 FUNCTION=death1b
//#exec MESH NOTIFY SEQ=death1b TIME=1.000 FUNCTION=death1b

//#exec MESH NOTIFY SEQ=idle_alert TIME=0.0166667 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Bite1 TIME=0.0294118 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Bite1 TIME=0.0588235 FUNCTION=PlaySound_N ARG="Atk PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Bite1 TIME=0.205882 FUNCTION=PlaySound_N ARG="Bite PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=run TIME=0.0322581 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Chomp TIME=0.0333333 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Chomp TIME=0.0666667 FUNCTION=PlaySound_N ARG="Atk PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Chomp TIME=0.333333 FUNCTION=PlaySound_N ARG="Bite PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Cobra1 TIME=0.0714286 FUNCTION=PlaySound_N ARG="TurnFast PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Cobra2 TIME=0.0166667 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Cobra2 TIME=0.366667 FUNCTION=PlaySound_N ARG="Taunt PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Cobra3 TIME=0.0555556 FUNCTION=PlaySound_N ARG="TurnSlow PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Coil TIME=0.0344828 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Coil TIME=0.0344828 FUNCTION=PlaySound_N ARG="TurnFast PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Coil TIME=0.241379 FUNCTION=PlaySound_N ARG="Taunt PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death1a TIME=0.0526316 FUNCTION=PlaySound_N ARG="TurnFast PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death1b TIME=0.0833333 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death1c TIME=0.15 FUNCTION=PlaySound_N ARG="TurnFast P=0.8 PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death1c TIME=0.15 FUNCTION=C_BFallS
//#exec MESH NOTIFY SEQ=Hiss_1 TIME=0.125 FUNCTION=PlaySound_N ARG="Taunt P=0.75 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hiss_2 TIME=0.047619 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.0222222 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=RightWhip TIME=0.0263158 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=RightWhip TIME=0.210526 FUNCTION=PlaySound_N ARG="TurnFast P=1.25 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage1 TIME=0.0333333 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=idle TIME=0.0111111 FUNCTION=PlaySound_N ARG="Mvmt P=0.75 PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=turn_left TIME=0.05 FUNCTION=PlaySound_N ARG="TurnFast PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.05 FUNCTION=PlaySound_N ARG="TurnFast PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.0227273 FUNCTION=PlaySound_N ARG="TurnSlow PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Alert_To_Coil TIME=0.0434783 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.75 VVar=0.1"

//****************************************************************************
// Member vars.
//****************************************************************************
var() int					BiteManaDrain;		// Amount of mana to take when biting.
var float					DeathFXDelay;		//
var bool					bIsHasting;			//
var float					HasteTimer;			//
var() float					HasteScalar;		//
var() float					HasteFrequency;		//
var() float					HasteVariance;		//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	switch ( Rand(5) )
	{
		case 0:
		case 1:
			PlayAnim( 'bite1' );
			break;
		case 2:
		case 3:
			PlayAnim( 'chomp' );
			break;
		default:
			PlayAnim( 'rightwhip' );
			break;
	}
}

function PlayTaunt()
{
	PlayAnim( 'coil' );
}

function PlayStunDamage()
{
	if ( FRand() < 0.40 )
		PlayAnim( 'cobra1' );
	else
		PlayAnim( 'damage1' );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'death1a' );
}

function PlayMindshatterDamage()
{
	LoopAnim( 'damage1' );
}

function PlaySpecialKill()
{
	PlayAnim( 'rightwhip' );
}


//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage P=0.8 PVar=0.2 VVar=0.1" );
}

function PlaySoundDeath()
{
	PlaySound_P( "VDeath PVar=0.2 VVar=0.1" );
}

function PlaySoundMeleeDamage( int Which )
{
	if ( Which == 1 )
		PlaySound_P( "TailHit" );
}

//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	OpacityEffector.FlickerRate = 0.05;
	SpeedFast();
}

// Fire just ignited.
function Ignited()
{
	FireMod.SetBurnout( FVariant( 7.5, 2.5 ) );
}

function bool DoEncounterAnim()
{
	return true;
}

// Damage handling.
function DamageInfo getDamageInfo( optional name DamageType )
{
	local DamageInfo	DInfo;

	DInfo = super.getDamageInfo( DamageType );
	DInfo.ManaCost = BiteManaDrain;
	return DInfo;
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	if ( HasteTimer > 0.0 )
	{
		if ( HasteTimer < DeltaTime )
		{
			if ( bIsHasting )
				SpeedSlow();
			else
				SpeedFast();
			HasteTimer = FVariant( HasteFrequency, HasteVariance );
		}
		else
			HasteTimer -= DeltaTime;
	}
}

function bool FlankEnemy()
{
	return false;
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	if ( DamageNum == 1 )
		return JointStrikeValid( Victim, 'head1', DamageRadius );
	else
		return JointStrikeValid( Victim, 'spine6', DamageRadius );
}


//****************************************************************************
// New class functions.
//****************************************************************************
function SpeedFast()
{
	bIsHasting = true;
	AirSpeed = default.AirSpeed * HasteScalar;
	HasteTimer = 1.0;
}

function SpeedSlow()
{
	bIsHasting = false;
	AirSpeed = default.AirSpeed;
	HasteTimer = 0.0;
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIQuickTaunt
// Turret toward enemy and play taunt, then return
//****************************************************************************
state AIQuickTaunt
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		StopTimer();
	}

	function Timer()
	{
		GotoState( , 'TIMER' );
	}

	// *** new (state only) functions ***


BEGIN:
	StopMovement();
	PlayWait();

	if ( Enemy != none )
		TurnToward( Enemy, 10 * DEGREES );

	PlayAnim( 'coil' );
	FinishAnim();
	if ( FRand() < 0.25 )
	{
		PlayAnim( 'cobra1' );
		Sleep( FVariant( 1.0, 0.25 ) );
		PlayAnim( 'cobra3' );
		FinishAnim();
	}
	else
	{
		SetTimer( FVariant( 1.0, 0.25 ), false );
TURRET:
		if ( Enemy != none )
			TurnToward( Enemy, 10 * DEGREES );
		Sleep( 0.10 );
		goto 'TURRET';
	}
TIMER:
	PopState();
} // state AIQuickTaunt


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
		SpeedSlow();
	}

	function EndState()
	{
		super.EndState();
		SpeedFast();
	}

	// *** new (state only) functions ***

} // state AICharge


//****************************************************************************
// AINearAttack
// attack near enemy (melee)
//****************************************************************************
state AINearAttack
{
	// *** ignored functions ***

	// *** overridden functions ***
	function PostAttack()
	{
		if ( bDidMeleeDamage )
			GotoState( 'AINearAttackRear' );
		else
			super.PostAttack();
	}

} // state AINearAttack


//****************************************************************************
// AINearAttackRear
// Post near attack action.
//****************************************************************************
state AINearAttackRear extends AINearAttack
{
	// *** ignored functions ***
	function AnimEnd(){}

	// *** overridden functions ***
	function Timer()
	{
		GotoState( 'AIAttack' );
	}

	// *** new (state only) functions ***
	// Calculate a target point to rear back to.
	function vector GetRearPoint( vector ThisLoc )
	{
		local vector	DVect;

		DVect = Location - Enemy.Location;
		DVect.Z = Abs(DVect.Z);
		return ( Location + ( Normal(DVect) * 500.0 ) );
	}


BEGIN:
	StopMovement();
	PlayAnim( 'alert_to_coil' );
	SetTimer( 3.0, false );
	TargetPoint = GetRearPoint( Enemy.Location );
//	SetMarker( TargetPoint );
	MoveTo( TargetPoint, -WalkSpeedScale * 0.50 );

TURRET:
	if ( Enemy != none )
		TurnToward( Enemy, 10 * DEGREES );
	Sleep( 0.10 );
	goto 'TURRET';
} // state AINearAttackRear


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		DeathFXDelay = 0.5;
	}

	function Landed( vector hitNormal )
	{
		PlayAnim( 'death1c' );
	}

	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		if ( DeathFXDelay > 0.0 )
		{
			DeathFXDelay -= DeltaTime;
			if ( DeathFXDelay < 0.0 )
			{
				bHidden = true;
				Spawn( class'FlickeringStalkerDeathFX', self,, Location );
				SetCollision( false, false, false );
			}
		}
	}

	// *** new (state only) functions ***

} // state Dying


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***
	function PostSpecialKill()
	{
		TargetActor = SK_TargetPawn;
		GotoState( 'AIDance', 'DANCE' );
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
	}

	function BeginNav()
	{
		AirSpeed = default.AirSpeed * 0.60;
	}

	// *** new (state only) functions ***
	function GibPlayer()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('head').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'head', 'root');

		SK_TargetPawn.Decapitate();
		SK_TargetPawn.PlayAnim( 'death_gun_left' );

		// Hide the players held weapon
		if ( SK_TargetPawn.IsA('PlayerPawn') )
			PlayerPawn(SK_TargetPawn).Weapon.ThirdPersonMesh = none;

		PlaySound_P( "FleshSlice" );
		PlaySound_P( "FleshStab" );
	}

} // state AISpecialKill


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     BiteManaDrain=20
     HasteScalar=4
     HasteFrequency=4
     HasteVariance=0.5
     HoverAltitude=400
     HoverVariance=75
     HoverRadius=600
     bCanHover=True
     WaitGlideScalar=0.5
     Aggressiveness=1
     MeleeInfo(0)=(Damage=15,EffectStrength=0.15,Method=Bite)
     MeleeInfo(1)=(Damage=15,EffectStrength=0.15,Method=RipSlice)
     DamageRadius=55
     SK_PlayerOffset=(X=70,Z=65)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.3
     bGiveScytheHealth=True
     PhysicalScalar=0.5
     FireScalar=0
     ConcussiveScalar=0.5
     bNoBloodPool=True
     MeleeRange=40
     AirSpeed=600
     MaxStepHeight=16
     SightRadius=1500
     PeripheralVision=0.25
     BaseEyeHeight=1
     Health=150
     SoundSet=Class'Aeons.FlickeringStalkerSoundSet'
     RotationRate=(Pitch=20000,Yaw=60000,Roll=9000)
     Mesh=SkelMesh'Aeons.Meshes.FlickeringStalker_m'
     CollisionRadius=16
     CollisionHeight=12
     bGroundMesh=False
}
