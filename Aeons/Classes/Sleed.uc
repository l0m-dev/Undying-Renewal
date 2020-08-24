//=============================================================================
// Sleed.
//=============================================================================
class Sleed expands ScriptedPawn;

//#exec MESH IMPORT MESH=SleedDead1_m SKELFILE=poses\SleedDead1.ngf
//#exec MESH IMPORT MESH=Sleed_m SKELFILE=Sleed.ngf
//#exec MESH JOINTNAME Head_1=Head

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=attack1 TIME=0.500 FUNCTION=DoNearDamageReset
//#exec MESH NOTIFY SEQ=attack1 TIME=0.583 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack2 TIME=0.375 FUNCTION=DoNearDamageReset
//#exec MESH NOTIFY SEQ=attack2 TIME=0.625 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=walk TIME=0.360 FUNCTION=DoNearDamageReset
//#exec MESH NOTIFY SEQ=walk TIME=0.480 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=walk TIME=0.560 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=spawnstart TIME=1.000 FUNCTION=spawncycle
//#exec MESH NOTIFY SEQ=spawncycle TIME=1.000 FUNCTION=spawncycle

//#exec MESH NOTIFY SEQ=Attack1 TIME=0.037037 FUNCTION=PlaySound_N ARG="VAttack1 CHANCE=0.7 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack1 TIME=0.296296 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack1 TIME=0.555556 FUNCTION=PlaySound_N ARG="Bite PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.111111 FUNCTION=PlaySound_N ARG="VAttack2 CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.111111 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.333333 FUNCTION=PlaySound_N ARG="Bite PVar=0.15"
//#exec MESH NOTIFY SEQ=Curlup TIME=0.192308 FUNCTION=PlaySound_N ARG="VAttack2 CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Curlup TIME=0.192308 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Curlup TIME=0.192308 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=Curlup TIME=0.5 FUNCTION=PlaySound_N ARG="Bite PVar=0.15"
//#exec MESH NOTIFY SEQ=Curlup TIME=0.653846 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death1Cycle TIME=0.03125 FUNCTION=PlaySound_N ARG="Death1 CHANCE=0.9 PVar=0.15"
//#exec MESH NOTIFY SEQ=Death1end TIME=0.1 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death1end TIME=0.5 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death2cycle TIME=0.025 FUNCTION=PlaySound_N ARG="Death2 PVar=0.15"
//#exec MESH NOTIFY SEQ=Death2cycle TIME=0.65 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death2end TIME=0.0217391 FUNCTION=PlaySound_N ARG="Death2 PVar=0.15"
//#exec MESH NOTIFY SEQ=Death2end TIME=0.586957 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=Falling TIME=0.125 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.0384615 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.115385 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.269231 FUNCTION=PlaySound_N ARG="VAttack2 CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.5 FUNCTION=PlaySound_N ARG="Bite PVar=0.15"
//#exec MESH NOTIFY SEQ=walk TIME=0.884615 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=1.0 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=idle TIME=0.32967 FUNCTION=PlaySound_N ARG="VIdle1 CHANCE=0.2 PVar=0.15"
//#exec MESH NOTIFY SEQ=Idle2 TIME=0.266667 FUNCTION=PlaySound_N ARG="VIdle1 CHANCE=0.2 PVar=0.15"
//#exec MESH NOTIFY SEQ=Idle2 TIME=0.383333 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle2 TIME=0.783333 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle3 TIME=0.0909091 FUNCTION=PlaySound_N ARG="VIdle1 CHANCE=0.2 PVar=0.15"
//#exec MESH NOTIFY SEQ=Idle3 TIME=0.363636 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Jump TIME=0.0 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Jump TIME=0.0714286 FUNCTION=PlaySound_N ARG="VAttack2 CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Jump TIME=0.285714 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=Jump TIME=0.357143 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Jump TIME=0.857143 FUNCTION=PlaySound_N ARG="Bite PVar=0.15"
//#exec MESH NOTIFY SEQ=Land TIME=0.545455 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Land TIME=0.909091 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=Rear TIME=0.047619 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Rear TIME=0.285714 FUNCTION=PlaySound_N ARG="VAttack2 CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Rear TIME=0.380952 FUNCTION=PlaySound_N ARG="Bite PVar=0.15"
//#exec MESH NOTIFY SEQ=Rear TIME=0.428571 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Spawnend TIME=0.0909091 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Spawnend TIME=0.0909091 FUNCTION=PlaySound_N ARG="VAttack2 CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Spawnend TIME=0.545455 FUNCTION=PlaySound_N ARG="Bite PVar=0.15"
//#exec MESH NOTIFY SEQ=Spawnend TIME=0.454545 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Spawnstart TIME=0.3 FUNCTION=PlaySound_N ARG="Spawn PVar=0.15"
//#exec MESH NOTIFY SEQ=Sleed_Special_Kill TIME=0.0 FUNCTION=PlaySound_N ARG="SpKill"
//#exec MESH NOTIFY SEQ=Sleed_Special_Kill TIME=0.065 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=Taunt1 TIME=0.0434783 FUNCTION=PlaySound_N ARG="Taunt1 PVar=0.15"
//#exec MESH NOTIFY SEQ=Uncurl TIME=0.125 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Uncurl TIME=0.375 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"
//#exec MESH NOTIFY SEQ=Uncurl TIME=0.458333 FUNCTION=PlaySound_N ARG="VAttack2 CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Uncurl TIME=0.458333 FUNCTION=PlaySound_N ARG="Shell PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Uncurl TIME=0.875 FUNCTION=PlaySound_N ARG="Bite PVar=0.15"
//#exec MESH NOTIFY SEQ=Uncurl TIME=0.875 FUNCTION=PlaySound_N ARG="Foot PVar=0.15 VVar=0.1"


//****************************************************************************
// Member vars.
//****************************************************************************
var int						DyingAnim;			//
var float					DyingAnimDelay;		//
var() int					Clique;				//
var() float					BounceZ;			// TEMP edit


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	if ( !FastTrace( Location, Location - vect(0,0,1.25) * CollisionHeight ) )
		JumpTo( Enemy.Location );

	if ( FRand() < 0.50 )
		PlayAnim( 'attack1' );
	else
		PlayAnim( 'attack2' );
}

function PlayTaunt()
{
	PlayAnim( 'taunt1' );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	if ( FRand() < 0.50 )
	{
		LoopAnim( 'death1cycle' );
		DyingAnim = 1;
	}
	else
	{
		LoopAnim( 'death2cycle', FVariant( 1.50, 0.50 ) );
		DyingAnim = 2;
	}
}

function PlayMindshatterDamage()
{
	LoopAnim( 'taunt1' );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	HatedTag = 'HatedSleed';
	HatedID = HatedTag;
	if ( Clique == 0 )
		Clique = int(Level.TimeSeconds);
}

function PreSetMovement()
{
	super.PreSetMovement();
	bCanJump = true;
	bCanFly = true;		// Sleed can't really fly, but this allows them to navigate normally, with their small CollisionHeight.
}

// Sleed hate all Sleed by default, so must ignore those of identical clique.
function bool IsHatedPawn( pawn Other )
{
	if ( Sleed(Other) != none )
		return ( Sleed(Other).Clique != Clique );
	else
		return Other.bIsHated;
}

/*
function bool FlankEnemy()
{
	return false;
}

function vector FlankPosition( vector target )
{
	return target;
}
*/

// Animation needs to play regardless of movement.
function PlayLocomotion( vector dVector )
{
	if ( VSize( dVector ) < 0.01 )
		PlayWaiting();
	else
		LoopAnim( 'walk',, MOVE_None );
}

// Override default behavior to prevent transition to flight.
singular function Falling()
{
	if ( health > 0 )
		SetFall();
}

// Have Sleed always jump off forward, if possible.
function JumpOffPawn()
{
	local vector	X, Y, Z;

	Velocity.Z = 0.0;
	if ( VSize(Velocity) < 0.05 )
	{
		GetAxes( Rotation, X, Y, Z );
		Velocity = X;
		Velocity.Z = 0.0;
	}
	Velocity = Normal(Velocity) * AirSpeed * 0.50;
	Velocity.Z = BounceZ * JumpScalar;
//	DebugInfoMessage( ".JumpOffPawn(), Vel is " $ Velocity );
	if ( Health > 0 )
		SetFall();
}

// Fixes uncrouching player gibbing Sleed.
function EncroachedBy( actor Other )
{
	if ( ( pawn(Other) != none ) &&
		 pawn(Other).bIsPlayer &&
		 ( Location.Z > Other.Location.Z ) )
		JumpOffPawn();
	else
		super.EncroachedBy( Other );
}

// Ignore damage from Sleed of same clique.
function bool AcknowledgeDamageFrom( pawn Damager )
{
	if ( ( Damager != none ) &&
		 ( Sleed(Damager) != none ) &&
		 ( Sleed(Damager).Clique == Clique ) )
		return false;
	return true;
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	return JointStrikeValid( Victim, 'jaw_1', DamageRadius );
}

// Adjust the pending jump's height.
function float AdjustJumpHeight( float oldZ )
{
	local float		newZ;

	newZ = FMin( oldZ * JumpScalar, BounceZ );
//	DebugInfoMessage( ".AdjustJumpHeight(), old is " $ oldZ $ ", new is " $ newZ );
	return FVariant( newZ, newZ * 0.10 );
}

// Set parameters for bounce.
function JumpTo( vector thisLoc )
{
	local vector	addVel;

	addVel = CalculateJump( thisLoc );
	Velocity = vect(0,0,0);
	AddVelocity( addVel );
}

function bool CanPerformSK( pawn P )
{
	bCanFly = false;
	super.CanPerformSK( P );
//	bCanFly = true;
	return true;
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AINearAttack
// attack near enemy (melee)
//****************************************************************************
state AINearAttack
{
	// *** ignored functions ***
	function Bump( actor Other ){}

	// *** overridden functions ***
	function bool MoveInAttack()
	{
		return true;
	}

	function PostAttack()
	{
		PlayWait();
		super.PostAttack();
	}

	// *** new (state only) functions ***

} // state AINearAttack


//****************************************************************************
// AICharge
// Charge Enemy.
//****************************************************************************
state AICharge
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool UseSpecialDirect( vector TargetLoc )
	{
//		DebugInfoMessage( ".(Sleed)AICharge.UseSpecialDirect" );
		return true;
	}

	function bool UseSpecialNavigation( NavigationPoint navPoint )
	{
//		DebugInfoMessage( ".(Sleed)AICharge.UseSpecialNavigation" );
		return true;
	}

	// *** new (state only) functions ***

} // state AICharge


//****************************************************************************
// AIChargePoint
// Charge to TargetPoint.
//****************************************************************************
state AIChargePoint
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		TargetPoint = GetGotoPoint( TargetPoint );
	}

	function bool UseSpecialDirect( vector TargetLoc )
	{
//		DebugInfoMessage( ".(Sleed)AIChargePoint.UseSpecialDirect" );
		return true;
	}

	function bool UseSpecialNavigation( NavigationPoint navPoint )
	{
//		DebugInfoMessage( ".(Sleed)AIChargePoint.UseSpecialNavigation" );
		return true;
	}

	// *** new (state only) functions ***

} // state AIChargePoint


//****************************************************************************
// AISpecialDirect
// Handle special navigation move directly to TargetPoint.
//****************************************************************************
state AISpecialDirect
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		GotoState( 'AISleedBounce' );
	}

	// *** new (state only) functions ***

} // state AISpecialDirect


//****************************************************************************
// AISpecialNavigation
// Handle special navigation to SpecialNavPoint.
//****************************************************************************
state AISpecialNavigation
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		TargetPoint = SpecialNavPoint.Location;
		GotoState( 'AISleedBounce' );
	}

	// *** new (state only) functions ***

} // state AISpecialNavigation


//****************************************************************************
// AISleedBounce
// Head to TargetPoint using bounce.
//****************************************************************************
state AISleedBounce
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function Landed( vector hitNormal )
	{
		StopMovement();
		super.Landed( hitNormal );
		if ( Health > 0 )
		{
			PlayWait();
			PopState();
		}
	}

	// *** new (state only) functions ***

BEGIN:
	SetMarker( TargetPoint );
	PlayRun();
	TurnTo( TargetPoint, 10 * DEGREES );
	JumpTo( TargetPoint );

TURRET:
	Sleep( 0.10 );
	goto 'TURRET';
} // state AISleedBounce


//****************************************************************************
// AIJumpAtEnemy
// try to jump toward Enemy
//****************************************************************************
state AIJumpAtEnemy
{
	// *** ignored functions ***

	// *** overridden functions ***
	function PlayJumpAttack()
	{
		PlayAnim( 'attack1' );
		TriggerJump();
	}

	function TriggerJump()
	{
		JumpTo( Enemy.Location + ( Enemy.Velocity * 0.5 ) + ( vect(0,0,1) * Enemy.CollisionHeight ) );
		GotoState( , 'JUMPED' );
	}

	// *** new (state only) functions ***

} // state AIJumpAtEnemy


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Tick( float DeltaTime )
	{
		if ( DyingAnimDelay > 0.0 )
		{
			DyingAnimDelay -= DeltaTime;
			if ( DyingAnimDelay <= 0.0 )
			{
				if ( DyingAnim == 1 )
					PlayAnim( 'death1end' );
				else
					PlayAnim( 'death2end' );
			}
		}
		super.Tick( DeltaTime );
	}

	function PostAnim()
	{
		DyingAnimDelay = FVariant( 1.75, 0.25 );
	}

	function PoolOfBlood()
	{
		local vector	HitLocation, HitNormal;
		local int		HitJoint;
		
		// Bleed out.
		Trace( HitLocation, HitNormal, HitJoint, Location + vect(0,0,-512), Location, true );
		Spawn( class'BloodDripDecal',,, HitLocation, rotator(HitNormal) );
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
		SK_TargetPawn.GotoState('SpecialKill', 'SpecialKillComplete');
	}

	function StartSequence()
	{
		GotoState( , 'SLEEDSTART' );
	}

	// *** new (state only) functions ***


SLEEDSTART:
	NoLook();
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'sleed_death' );
	PlayAnim( 'sleed_special_kill' );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     BounceZ=175
     Aggressiveness=1
     MeleeInfo(0)=(Damage=10,EffectStrength=0.1,Method=Bite)
     DamageRadius=75
     SK_PlayerOffset=(X=57)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.6
     WalkSpeedScale=0.75
     JumpScalar=1.5
     bGiveScytheHealth=True
     FireScalar=0.5
     bUseLooking=False
     MeleeRange=30
     GroundSpeed=400
     AirSpeed=600
     AccelRate=1600
     MaxStepHeight=16
     SightRadius=1500
     bIsHated=True
     BaseEyeHeight=1
     Health=20
     SoundSet=Class'Aeons.SleedSoundSet'
     RotationRate=(Yaw=60000)
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.Sleed_m'
     CollisionHeight=16
}
