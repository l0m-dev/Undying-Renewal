//=============================================================================
// Sheep.
//=============================================================================
class Sheep expands ScriptedPawn;

//#exec MESH IMPORT MESH=Sheep_m SKELFILE=Sheep.ngf
//#exec MESH ORIGIN MESH=Sheep_m X=10
//#exec MESH JOINTNAME Head=Neck Head1=Head

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=graze TIME=0.450 FUNCTION=GrazeLoop

//#exec MESH NOTIFY SEQ=death TIME=0.4 FUNCTION=PlaySound_N ARG="BodyFall PVar=0.2 V=0.6 VVar=0.1"
//#exec MESH NOTIFY SEQ=graze TIME=0.0153846 FUNCTION=PlaySound_N ARG="Graze CHANCE=0.25 PVar=0.2 V=0.7 VVar=0.3"
//#exec MESH NOTIFY SEQ=graze_cycle TIME=0.0285714 FUNCTION=PlaySound_N ARG="Chewing CHANCE=0.25 PVar=0.2 V=0.35 VVar=0.2"
//#exec MESH NOTIFY SEQ=graze_cycle TIME=0.0285714 FUNCTION=PlaySound_N ARG="Graze CHANCE=0.25 PVar=0.2 V=0.7 VVar=0.3"
//#exec MESH NOTIFY SEQ=idle TIME=0.0333333 FUNCTION=PlaySound_N ARG="Graze CHANCE=0.15 PVar=0.2 V=0.7 VVar=0.3"
//#exec MESH NOTIFY SEQ=walk TIME=0.0333333 FUNCTION=PlaySound_N ARG="Hoof PVar=0.2 V=0.4 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.0666667 FUNCTION=PlaySound_N ARG="Hoof PVar=0.2 V=0.4 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.433333 FUNCTION=PlaySound_N ARG="Hoof PVar=0.2 V=0.4 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.466667 FUNCTION=PlaySound_N ARG="Hoof PVar=0.2 V=0.4 VVar=0.1"


//****************************************************************************
// Member vars.
//****************************************************************************
var(AIDistance) float		ShieldDistance;		//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayStunDamage()
{
	PlayAnim( 'damage_stun',, MOVE_None );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'death' );
}

function PlayMindshatterDamage()
{
	LoopAnim( 'damage_stun',, MOVE_None );
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


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
// Animation/audio notification handlers [SFX].
//****************************************************************************
function GrazeLoop()
{
	LoopAnim( 'graze_cycle',, MOVE_None );
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
	function DefConChanged( int OldValue, int NewValue ){}

	// *** overridden functions ***
	function CueNextEvent()
	{
		if ( FRand() < 0.05 )
		{
			GotoState( , 'WALKAHEAD' );
			return;
		}
		switch ( Rand(3) )
		{
			case 0:
				GotoState( , 'IDLE' );
				break;
			case 1:
				GotoState( , 'GRAZE' );
				break;
			case 2:
				GotoState( , 'LOOKAROUND' );
				break;
		}
	}

	// *** new (state only) functions ***

IDLE:
	PlayWait();
	Sleep( FVariant( 3.0, 1.0 ) );
	CueNextEvent();

GRAZE:
	PlayAnim( 'graze',, MOVE_None );
	Sleep( FVariant( 6.0, 1.0 ) );
	CueNextEvent();

LOOKAROUND:
	PlayAnim( 'lookaround',, MOVE_None );
	FinishAnim();
	PlayWait();
	Sleep( FVariant( 3.0, 2.0 ) );
	CueNextEvent();

WALKAHEAD:
	TargetPoint = GetGotoPoint( Location + vector(Rotation) * CollisionRadius * FVariant( 2.5, 1.0 ) );
	if ( pointReachable( TargetPoint ) )
	{
		PlayWalk();
		MoveTo( TargetPoint, WalkSpeedScale );
		StopMovement();
	}
	PlayWait();
	Sleep( FVariant( 3.0, 1.0 ) );
	CueNextEvent();

} // state AIWait


//****************************************************************************
// AIBumpAvoid
// Bumped into BumpedPawn, try to avoid or move around, return via state stack.
//****************************************************************************
state AIBumpAvoid
{
	// *** ignored functions ***

	// *** overridden functions ***
	function float ScatterDistance()
	{
		return default.CollisionRadius * FVariant( 10.0, 3.0 );
	}

	function float GetWalkSpeedScale()
	{
		if ( ScriptedPawn(BumpedPawn) != none )
			return WalkSpeedScale;
		else
			return FullSpeedScale;
	}

	// *** new (state only) functions ***

} // state AIBumpAvoid


//****************************************************************************
// AIAttack
// primary attack dispatch state
//****************************************************************************
state AIAttack
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		if ( bIsInvoked )
		{
			RetreatThreshold = 0.0;
			GotoState( 'AIShieldOwner' );
		}
		else
			super.BeginState();
	}

	// *** new (state only) functions ***

} // state AIAttack


//****************************************************************************
// AIShieldOwner
// Shield my Owner.
//****************************************************************************
state AIShieldOwner
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
	}

	function bool HandleBump( actor Other )
	{
//		DebugInfoMessage( ".AIShieldOwner, HandleBump()" );
		if ( Other == TargetActor )
		{
			GotoState( , 'BACKOFF' );
			return true;
		}
		return false;
	}

	// *** new (state only) functions ***
	function vector GetShieldPoint( actor Other )
	{
		local vector	DVect;
		local vector	SPoint;

//		DebugInfoMessage( "GetShieldPoint(), Owner is " $ Other.name $ ", Enemy is " $ Enemy.name );
		DVect = Normal(Enemy.Location - Other.Location);
		SPoint = Other.Location + DVect * FVariant( ShieldDistance, ShieldDistance * 0.20 );
		SPoint = GetGotoPoint( SPoint );
		if ( CanPathToPoint( SPoint ) )
			return SPoint;

		SPoint = Other.Location + DVect * ( CollisionRadius + Other.CollisionRadius ) * 1.75;
		return GetGotoPoint( SPoint);
	}

	function AtPoint()
	{
	}

	function WaitPoint()
	{
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	TargetActor = Owner;
	WaitForLanding();

PICKPT:
//	if ( LineOfSightTo( TargetActor ) && ( DistanceTo( TargetActor ) < FollowDistance * 1.50 ) )
//		goto 'ATPOINT';

BACKOFF:
	TargetPoint = GetShieldPoint( TargetActor );
	if ( CloseToPoint( TargetPoint, 1.0 ) )
		goto 'ATPOINT';

GOTOPT:
	SetMarker( TargetPoint );	// TEMP
	if ( pointReachable( TargetPoint ) )
	{
		if ( ShouldRunToPoint( TargetPoint ) )
		{
			PlayRun();
			MoveTo( TargetPoint, FullSpeedScale, 2.0 );
		}
		else
		{
			PlayWalk();
			MoveTo( TargetPoint, WalkSpeedScale, 2.0 );
		}
	}
	else
	{
		PathObject = PathTowardPoint( TargetPoint );
		if ( PathObject != none )
		{
			// can path to TargetPoint
			if ( ShouldRunTo( PathObject ) )
			{
				PlayRun();
				MoveToward( PathObject, FullSpeedScale, 2.0 );
			}
			else
			{
				PlayWalk();
				MoveToward( PathObject, WalkSpeedScale, 2.0 );
			}
			if ( LineOfSightTo( TargetActor ) )
				goto 'PICKPT';
			else
				goto 'GOTOPT';
		}
		else
		{
			// couldn't path to OrderObject
			StopMovement();
			PlayWait();
			Sleep( 2.0 );
		}
	}
	goto 'PICKPT';

ATPOINT:
	AtPoint();
	StopMovement();
	PlayWait();

WAITPT:
	WaitPoint();
//	TurnToward( TargetActor, 20 * DEGREES );
	TargetPoint = GetShieldPoint( TargetActor );
	if ( CloseToPoint( TargetPoint, 1.0 ) )
	{
		Sleep( 0.2 );
		goto 'WAITPT';
	}
	else
		goto 'GOTOPT';

LOST:
	GotoState( 'AIFollowOwner' );

} // state AIShieldOwner


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     ShieldDistance=150
     bHasNearAttack=False
     RetreatThreshold=1
     bGiveScytheHealth=True
     GroundSpeed=250
     AccelRate=300
     BaseEyeHeight=22
     Health=60
     AttitudeToPlayer=ATTITUDE_Ignore
     SoundSet=Class'Aeons.SheepSoundSet'
     LODBias=5
     Mesh=SkelMesh'Aeons.Meshes.Sheep_m'
     CollisionRadius=34
     CollisionHeight=26
}
