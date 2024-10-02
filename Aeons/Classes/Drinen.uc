//=============================================================================
// Drinen.
//=============================================================================
class Drinen expands ScriptedBiped;

//#exec MESH IMPORT MESH=Drinen_m SKELFILE=Drinen.ngf INHERIT=ScriptedBiped_m
//#exec MESH ALIAS Walk=Hunt Run=Hunt
//#exec MESH JOINTNAME Feather1=Hair1 Head=Hair Neck2=Head Neck1=Neck
//#exec MESH MODIFIERS Cloth:Cloth

// Animation sequence notifications.
//#exec MESH NOTIFY SEQ=Attack_Melee01 TIME=0.464 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack_Melee01 TIME=0.536 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack_Melee01 TIME=0.607 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack_Melee01 TIME=0.821 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack_Melee02 TIME=0.467 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack_Melee02 TIME=0.533 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack_Melee02 TIME=0.600 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack_Melee02 TIME=0.667 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.0 FUNCTION=StaffSpinSK	// spear spin for special kill
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.819 FUNCTION=StaffSpinSK	// spear spin for special kill
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.219 FUNCTION=StabPlayer
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.724 FUNCTION=DropPlayer
//#exec MESH NOTIFY SEQ=Attack_Melee01 TIME=0.300 FUNCTION=StartStaffBlur
//#exec MESH NOTIFY SEQ=Attack_Melee01 TIME=0.600 FUNCTION=StopStaffBlur

// Notifys from Sound Design
//#exec MESH NOTIFY SEQ=Attack_Melee01 TIME=0.366667 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee01 TIME=0.5 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Attack_Melee01 TIME=0.9 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Attack_Melee02 TIME=0.333333 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.15 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.233333 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.816667 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Death01 TIME=0.38 FUNCTION=PlaySound_N ARG="StaffDrop PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death01 TIME=0.573333 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=Death01 TIME=0.833333 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=Death02 TIME=0.733333 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=Death02 TIME=0.908333 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=Death02 TIME=0.916667 FUNCTION=PlaySound_N ARG="StaffDrop PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.466667 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Hunt TIME=0.933333 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Walk TIME=0.466667 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Walk TIME=0.933333 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Run TIME=0.466667 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Run TIME=0.933333 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Hunt_Backwards TIME=0.5 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Hunt_Backwards TIME=1.0 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Left TIME=0.461538 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Left TIME=0.923077 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Right TIME=0.461538 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Right TIME=0.923077 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Idle TIME=0.1 FUNCTION=PlaySound_N ARG="Breath PVar=0.1 V=0.2 VVar=0.05"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.233333 FUNCTION=PlaySound_N ARG="Breath PVar=0.1 V=0.2 VVar=0.05"
//#exec MESH NOTIFY SEQ=Idle_Inquisitive TIME=0.0666667 FUNCTION=PlaySound_N ARG="Breath P=0.8 PVar=0.1 V=0.2 VVar=0.05"
//#exec MESH NOTIFY SEQ=Idle_Search TIME=0.02 FUNCTION=PlaySound_N ARG="Search PVar=0.1 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Taunt TIME=0.05 FUNCTION=PlaySound_N ARG="Breath PVar=0.1 V=0.2 VVar=0.05"
//#exec MESH NOTIFY SEQ=Taunt01 TIME=0.1 FUNCTION=PlaySound_N ARG="StaffTap PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt01 TIME=0.133333 FUNCTION=PlaySound_N ARG="StaffRing PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt01 TIME=0.4 FUNCTION=PlaySound_N ARG="StaffTap PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt01 TIME=0.7 FUNCTION=PlaySound_N ARG="StaffTap PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt02 TIME=0.0777778 FUNCTION=PlaySound_N ARG="StaffSpin PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt02 TIME=0.05 FUNCTION=StaffSpinTaunt	// spear spin for taunt
//#exec MESH NOTIFY SEQ=Taunt02 TIME=0.1 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Taunt02 TIME=0.688889 FUNCTION=PlaySound_N ARG="StaffSlam PVar=0.2 V=1.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt02 TIME=0.722222 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Taunt02 TIME=0.866667 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Turn_Left TIME=0.433333 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Turn_Left TIME=0.766667 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Turn_Right TIME=0.433333 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Turn_Right TIME=0.766667 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.027 FUNCTION=PlaySound_N ARG="SpinA PVar=0.1 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.072 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.172 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.190 FUNCTION=PlaySound_N ARG="StaffSlam PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.190 FUNCTION=PlaySound_N ARG="FleshSlice PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.218 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.245 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.672 FUNCTION=PlaySound_N ARG="HeadShot PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.772 FUNCTION=PlaySound_N ARG="SpinB PVar=0.1 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.845 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.700 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.800 FUNCTION=BFallBig


//****************************************************************************
// Member vars.
//****************************************************************************
var float					SpecialNavTimer;	//
var() float					SpecialNavFreq;		//
var() float					SpecialNavStep;		//
var float					DVariance;			//
var float					DScalar;			//
var ParticleFX				StaffBlurFX;		// motion blur particle system for the staff


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	// Determine damage type (based on "damage" parameter) and trigger appropriate animation.
	if ( FRand() < 0.5 )
		PlayAnim( 'death01' );
	else
		PlayAnim( 'death02' );
}

function PlayNearAttack()
{
	if ( FRand() < 0.5 )
		PlayAnim( 'attack_melee01' );
	else
		PlayAnim( 'attack_melee02' );
}

function PlayCrouch()
{
	LoopAnim( 'idle_inquisitive' );
}

function PlayTaunt()
{
	PlayAnim( 'taunt02' );
}

function PlaySpecialKill()
{
	PlayAnim( 'death_creature_special' );
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

function PlaySoundMeleeDamage( int Which )
{
	PlaySound_P( "StaffSlam" );
}

function PlaySoundTeleport()
{
	PlaySound_P( "Teleport" );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	SpecialNavTimer = FMax( 0.0, SpecialNavTimer - DeltaTime );
}

// See if we want to use special navigation to the point.
function bool UseSpecialNavigation( NavigationPoint navPoint )
{
	local float		Dist;

	Dist = DistanceToPoint( navPoint.Location );

	if ( bSpecialNavigation &&
		 ( Dist > 100.0 ) &&
		 ( SpecialNavTimer == 0.0 ) )
		return true;

	return false;
}

// Determine if creature should use a special nav move while pursuing the player in a direct path.
function bool UseSpecialDirect( vector TargetLoc )
{
	local float		Dist;

	Dist = DistanceToPoint( TargetLoc );

	if ( bSpecialNavigation &&
		 ( Dist > 200.0 ) &&
		 ( SpecialNavTimer == 0.0 ) &&
		 ( FRand() < 0.9910 ) )
		return true;

	return false;
}

function vector FlankPosition( vector target )
{
	return target;
}

function Stoned( pawn Stoner )
{
}


//****************************************************************************
// New class functions.
//****************************************************************************
function StaffSpinTaunt()
{
	MyProp[0].PlayAnim( 'Spin3' );
}

function StaffSpinSK()
{
	MyProp[0].PlayAnim( 'Spin1' );
}

// Do the special navigation teleport.
function DoTeleport( vector ThisLoc )
{
	local vector	TLoc;
	local rotator	ARot;

	TLoc = TeleportLocation( ThisLoc );

	Spawn( class'DrinenTeleportFX', self,, Location, Rotation );
	SetLocation( TLoc );
	SetPhysics( PHYS_Falling );
	if ( Enemy != none )
	{
		ARot = rotator(Enemy.Location - TLoc);
		ARot.Pitch = 0;
		SetRotation( ARot );
	}
}

// Compute a valid teleportation location based on the location passed.
function vector TeleportLocation( vector Here )
{
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	Trace( HitLocation, HitNormal, HitJoint, Here - vect(0,0,500), Here, false );
	return HitLocation + ( vect(0,0,1) * CollisionHeight );
}

// starts a motion blur on the drinen's staff
function StartStaffBlur()
{
	if ( ( MyProp[0] != none ) && ( StaffBlurFX == none ) )
	{
		StaffBlurFX = Spawn( class'DrinenStaffFX', self,, MyProp[0].JointPlace('SpearB').Pos );
		StaffBlurFX.SetBase( MyProp[0], 'SpearB', 'root' );
	}
}

// stop a motion blur on the drinen's staff
function StopStaffBlur()
{
	if ( StaffBlurFX != none )
	{
		StaffBlurFX.SetBase( none );
		StaffBlurFX.Shutdown();
		StaffBlurFX = none;
	}
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIWait
// Wait for encounter at current location.
//****************************************************************************
state AIWait
{
	// *** ignored functions ***
	function Dispatch(){}

	// *** overridden functions ***

	// *** new (state only) functions ***

} // state AIWait


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
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		SetCollision( false );
	}

	function EndState()
	{
		DebugEndState();
		StopTimer();
		SetCollision( true );
		OpacityEffector.SetFade( 1.0, 0.50 );
	}

	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

	function Timer()
	{
		local float		Dist;

		Dist = FVariant( SpecialNavStep, SpecialNavStep * DVariance );
		if ( DistanceTo( SpecialNavPoint ) > ( Dist * DScalar ) )
		{
			DoTeleport( GetEnRoutePoint( SpecialNavPoint.Location, Dist ) );
			SetTimer( SpecialNavFreq, false );
		}
		else
			GotoState( ,'UNCLOAK' );
	}

	function Ignited()
	{
		OnFire( false );
	}

	// *** new (state only) functions ***

BEGIN:
	PlaySoundTeleport();
	OpacityEffector.SetFade( 0.25, 0.0 );
	LoopAnim( 'hunt', 0.5, MOVE_None );
	SetTimer( SpecialNavFreq, false );
	MoveToward( SpecialNavPoint, FullSpeedScale * 0.80 );
	StopTimer();
	OpacityEffector.SetFade( 1.0, 0.50 );
	PlayWait();
	PopState();

UNCLOAK:
	OpacityEffector.SetFade( 1.0, 0.50 );
	MoveToward( SpecialNavPoint, FullSpeedScale * 0.80 );
	PlayWait();
	PopState();

} // state AISpecialNavigation


//****************************************************************************
// AISpecialDirect
// Handle special navigation to TargetPoint.
//****************************************************************************
state AISpecialDirect
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		SetCollision( false );
		if ( FRand() < 0.75 )
			GotoState( 'AISpecialDirectSurprise' );
	}

	function EndState()
	{
		DebugEndState();
		StopTimer();
		SetCollision( true );
		OpacityEffector.SetFade( 1.0, 0.50 );
	}

	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

	// *** new (state only) functions ***
	function Timer()
	{
		local float		Dist;

		Dist = FVariant( SpecialNavStep, SpecialNavStep * DVariance );
		if ( DistanceToPoint( TargetPoint ) > ( Dist * DScalar ) )
		{
			DoTeleport( GetEnRoutePoint( TargetPoint, Dist ) );
			SetTimer( SpecialNavFreq, false );
		}
		else
			GotoState( ,'UNCLOAK' );
	}

	function Ignited()
	{
		OnFire( false );
	}

BEGIN:
	PlaySoundTeleport();
	OpacityEffector.SetFade( 0.25, 0.0 );
	LoopAnim( 'hunt', 0.5, MOVE_None );
	SetTimer( SpecialNavFreq, false );
	MoveTo( TargetPoint, FullSpeedScale * 0.80 );
	StopTimer();
	OpacityEffector.SetFade( 1.0, 0.50 );
	PlayWait();
	PopState();

UNCLOAK:
	if ( DistanceTo( Enemy ) < ( MeleeRange * 3.5 ) )
		PopState( 'AIAttack', 'BEGIN' );
	if ( !CloseToPoint( TargetPoint, 2.0 ) )
	{
		PlayWalk();
		MoveTo( TargetPoint, FullSpeedScale * 0.80 );
	}
	PlayWait();
	PopState();

} // state AISpecialDirect


//****************************************************************************
// AISpecialDirectSurprise
// Handle special navigation to TargetPoint.
//****************************************************************************
state AISpecialDirectSurprise extends AISpecialDirect
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		SetCollision( false );
		TargetPoint = GetGotoPoint( Enemy.Location - vector(Enemy.ViewRotation) * CollisionRadius * 4.0 );
	}

	// *** new (state only) functions ***
	function Timer()
	{
		local float		Dist;

		TargetPoint = GetGotoPoint( Enemy.Location - vector(Enemy.ViewRotation) * CollisionRadius * 4.0 );
		Dist = FVariant( SpecialNavStep, SpecialNavStep * DVariance );
		if ( DistanceToPoint( TargetPoint ) > ( Dist * DScalar * 2.0 ) )
		{
			DoTeleport( GetEnRoutePoint( TargetPoint, Dist ) );
			SetTimer( SpecialNavFreq, false );
		}
		else
		{
			DoTeleport( TargetPoint );
			if ( GetStateName() == 'AISpecialDirectSurprise' )
				GotoState( ,'UNCLOAK' );
		}
	}

	function Ignited()
	{
		OnFire( false );
	}

} // state AISpecialDirectSurprise


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***
	function PostSpecialKill()
	{
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
		GotoState( 'AIWait' );
	}

	function StartSequence()
	{
		GotoState( , 'DRINENSTART' );
	}

	// *** new (state only) functions ***


DRINENSTART:
	NoLook();
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'drinen_death', [TweenTime] 0.0  );
	PlayAnim( 'death_creature_special', [TweenTime] 0.0  );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// Def props
//****************************************************************************

defaultproperties
{
     SpecialNavFreq=0.2
     SpecialNavStep=130
     DVariance=0.1
     DScalar=1.1
     MyPropInfo(0)=(Prop=Class'Aeons.DrinenSpear',PawnAttachJointName=R_Fist,AttachJointName=Spearroot)
     bSpecialNavigation=True
     JumpDownDistance=180
     Aggressiveness=1
     MeleeInfo(0)=(Damage=20,EffectStrength=0.25,Method=Blunt)
     DamageRadius=140
     SK_PlayerOffset=(X=96)
     bHasSpecialKill=True
     WalkSpeedScale=0.65
     bGiveScytheHealth=True
     bCanStrafe=True
     MeleeRange=100
     GroundSpeed=200
     AccelRate=2000
     MaxStepHeight=45
     BaseEyeHeight=83
     Health=150
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.DrinenSoundSet'
     FootSoundClass=Class'Aeons.BareFootSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.Drinen_m'
     CollisionRadius=26
     CollisionHeight=98
     MenuName="Drinen"
     CreatureDeathVerb="speared"
}
