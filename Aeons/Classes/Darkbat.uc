//=============================================================================
// Darkbat.
//=============================================================================
class Darkbat expands ScriptedFlyer;

//#exec MESH IMPORT MESH=Darkbat_m SKELFILE=Darkbat.ngf


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=death_start TIME=1.000 FUNCTION=PlayDeathCycle
//#exec MESH NOTIFY SEQ=death_cycle TIME=1.000 FUNCTION=PlayDeathCycle
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.429 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.476 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.524 FUNCTION=DoNearDamage

//#exec MESH NOTIFY SEQ=Attack_Bite TIME=0.0434783 FUNCTION=PlaySound_N ARG="Atk PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Bite TIME=0.434783 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Dive TIME=0.0666667 FUNCTION=PlaySound_N ARG="Dive PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.133333 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.4 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_End TIME=0.222222 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=1.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_Start TIME=0.0769231 FUNCTION=PlaySound_N ARG="VDeath PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_Start TIME=0.307692 FUNCTION=PlaySound_N ARG="VDeath PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.0666667 FUNCTION=PlaySound_N ARG="Hunt CHANCE=0.3 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.266667 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.0666667 FUNCTION=PlaySound_N ARG="Alert CHANCE=0.3 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Wake TIME=0.0833333 FUNCTION=PlaySound_N ARG="Wake CHANCE=0.5 PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Wake TIME=0.166667 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"


//****************************************************************************
// Member vars.
//****************************************************************************
var float					BatTurnCounter;		//
var bool					BatTurnState;		//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayWalk()
{
	LoopAnim( 'hunt', FVariant( 1.2, 0.4 ) );
}

function PlayRun()
{
	PlayWalk();
}

function PlayNearAttack()
{
	PlayAnim( 'attack_bite' );
}

function PlayStunDamage()
{
	PlayAnim( 'damage_stun' );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'death_start',, MOVE_None );
}

function PlayMindshatterDamage()
{
	LoopAnim( 'damage_stun' );
}

function PlayDeathCycle()
{
	PlayAnim( 'death_cycle',, MOVE_None );
}

//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage PVar=0.2 VVar=0.1" );
}

function PlaySoundDeath()
{
	PlaySound_P( "VDeath PVar=0.2 VVar=0.1" );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	if ( BatTurnCounter > 0.0 )
	{
		if ( BatTurnCounter < DeltaTime )
		{
			if ( BatTurnState )
			{
				NormalTurns();
				BatTurnState = false;
				BatTurnCounter = FVariant( 2.5, 0.5 );
			}
			else
			{
				FastTurns();
				BatTurnState = true;
				BatTurnCounter = 1.0;
			}
		}
		else
			BatTurnCounter -= DeltaTime;
	}
}


//****************************************************************************
// New class functions.
//****************************************************************************
function FastTurns()
{
	RotationRate.Yaw = default.RotationRate.Yaw * 8.0;
	RotationRate.Pitch = default.RotationRate.Pitch * 8.0;
}

function SlowTurns()
{
	RotationRate = default.RotationRate;
	RotationRate.Yaw = default.RotationRate.Yaw * WaitGlideScalar;
}

function NormalTurns()
{
	RotationRate = default.RotationRate;
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
	function BeginState()
	{
		super.BeginState();
		SlowTurns();
		BatTurnCounter = 0.0;
	}

	function EndState()
	{
		super.EndState();
		NormalTurns();
		BatTurnCounter = default.BatTurnCounter;
	}

	// *** new (state only) functions ***

} // state AIWait


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
			GotoState( 'AINearAttackRun' );
		else
			super.PostAttack();
	}

} // state AINearAttack


//****************************************************************************
// AINearAttackRun
// Post near attack action.
//****************************************************************************
state AINearAttackRun extends AINearAttack
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
	function vector GetRunPoint( vector ThisLoc )
	{
		local vector	DVect;

		DVect = Location - Enemy.Location;
		DVect.Z = Abs(DVect.Z);
		return ( Location + ( Normal(DVect) * 350.0 ) );
	}


BEGIN:
	SetTimer( 3.0, false );
	TargetPoint = GetRunPoint( Enemy.Location );
	PlayRun();
	MoveTo( TargetPoint, FullSpeedScale );
	Timer();

} // state AINearAttackRun


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Landed( vector hitNormal )
	{
		PlayAnim( 'death_end',, MOVE_None );
	}

	function PoolOfBlood()
	{
		local vector	HitLocation, HitNormal;
		local int		HitJoint;
		
		// Bleed out.
		Trace( HitLocation, HitNormal, HitJoint, Location + vect(0,0,-512), Location, true );
		Spawn( class'SmallBloodDripDecal',,, HitLocation, rotator(HitNormal) );
	}

} // state Dying


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     BatTurnCounter=5
     HoverAltitude=800
     HoverVariance=150
     HoverRadius=600
     WaitGlideScalar=0.1
     Aggressiveness=1
     MeleeInfo(0)=(Damage=2)
     DamageRadius=70
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.3
     bGiveScytheHealth=True
     MeleeRange=50
     AirSpeed=600
     MaxStepHeight=16
     SightRadius=1500
     BaseEyeHeight=1
     Health=10
     SoundSet=Class'Aeons.DarkbatSoundSet'
     RotationRate=(Pitch=15000,Yaw=60000,Roll=9000)
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.Darkbat_m'
     DrawScale=0.1
     CollisionRadius=16
     CollisionHeight=16
     MenuName="Bat"
     CreatureDeathVerb="rabied"
}
