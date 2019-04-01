//=============================================================================
// ScriptedFlyer.
//=============================================================================
class ScriptedFlyer expands ScriptedPawn
	abstract;


//****************************************************************************
// Member vars.
//****************************************************************************
var() float					HoverAltitude;		//
var() float					HoverVariance;		//
var() float					HoverSpeedScale;	//
var() float					HoverRadius;		//
var() bool					bCanHover;			// Flyer can stop in mid air and hover.
var() float					WaitGlideScalar;	// Multiplier for turn rate when waiting.
var() bool					bNoSeekHeight;		// Set if flyer should never seek higher chase point.
var() bool					bNoDeathSpin;		// Set to prevent spinning during death plunge.
var vector					HoverStart;			//
var() bool					bNoGroundHover;		// Set to prevent HoverAltitude relative to ground.
var() float					GStoneFallTime;		// Time to spend falling when hit with the stone.
var float					PhysChangeDelay;	//


//****************************************************************************
// <Begin> Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreSetMovement()
{
	super.PreSetMovement();
	bCanFly = true;
}

function SetMovementPhysics()
{
	SetPhysics( PHYS_Flying );
}

function SetFrozenPhysics()
{
	SetPhysics( PHYS_None );
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	if ( ( Physics != PHYS_Flying ) &&
		 ( Health > 0 ) &&
		 ( PhysChangeDelay == 0.0 ) )
		PhysChangeDelay = GStoneFallTime;
	if ( ( PhysChangeDelay > 0.0 ) && ( Health > 0 ) )
	{
		PhysChangeDelay -= DeltaTime;
		if ( PhysChangeDelay < 0.0 )
		{
			PhysChangeDelay = 0.0;
			SetMovementPhysics();
		}
	}
}

// Return the location to move to when moving to Enemy.
function vector EnemyMoveToLocation()
{
	return Enemy.Location + vect(0,0,1) * Enemy.BaseEyeHeight;
}

// See if should chase using flight height advantage.
function bool ShouldChasePoint( vector ThisPoint )
{
	local vector	DVect;
	local float		DSize;

	if ( bCanFly &&
		 !bNoSeekHeight &&
		 ( FRand() < 0.30 ) &&
		 FastTrace( ThisPoint ) )
	{
		DVect = ThisPoint - Location;
		if ( VSize(DVect) > HoverAltitude )
		{
			if ( Abs(Normal(DVect).Z) < 0.50 )
				return true;		// If further than HoverAltitude from and less than about 30 degrees to point
		}
	}
	return false;
}

// Calculate a flight chase point.
function vector FlightChasePoint( vector ActualPoint )
{
	return GetHoverPoint( ActualPoint );
}


//****************************************************************************
// New class functions.
//****************************************************************************
// Calculate a "hover" point.
function vector GetHoverPoint( vector ThisPoint )
{
	local vector	HitLocation, HitNormal;
	local int		HitJoint;
	local vector	HPoint;

	if ( bNoGroundHover )
	{
		// Select point relative to passed point.
		HPoint = ThisPoint + vect(0,0,1) * FVariant( 0, HoverVariance );
	}
	else
	{
		// Select point relative to ground.
		Trace( HitLocation, HitNormal, HitJoint, ThisPoint - vect(0,0,5000), ThisPoint, false );
		HPoint = HitLocation + vect(0,0,1) * FVariant( HoverAltitude, HoverVariance );
	}
	if ( FastTrace( HPoint, ThisPoint ) )
		return HPoint;
	else
		return ThisPoint;
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
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		if ( bNoGroundHover )
			HoverStart = Location;			// Hover will be relative to current location.
		else
			HoverStart = Location + vect(0,0,1) * HoverAltitude;
		RotationRate.Yaw = default.RotationRate.Yaw * WaitGlideScalar;
	}

	function EndState()
	{
		super.EndState();
		RotationRate.Yaw = default.RotationRate.Yaw;
	}

	function Timer()
	{
		GotoState( , 'ADJUST' );
	}

	function SlowMovement()
	{
		Acceleration *= 0.1;
		DesiredSpeed *= 0.1;
	}

	// *** new (state only) functions ***
	function vector GetHoverWaitPoint()
	{
		local vector	HitLocation, HitNormal;
		local int		HitJoint;
		local vector	TStart;
		local rotator	RRot;

		if ( HoverRadius > 0.0 )
		{
			RRot.Yaw = Rand( 65536 );
			RRot.Pitch = 0;
			RRot.Roll = 0;

			TStart = HoverStart + vector(RRot) * HoverRadius * FRand();
		}
		else
			TStart = HoverStart;
		return GetHoverPoint( TStart );
	}

	function CueNextEvent()
	{
		SetTimer( FVariant( 15.0, 4.0 ), false );
	}

	function PlayWaitAnim()
	{
		PlayWait();
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	WaitForLanding();
	StopMovement();
	PlayWait();

ADJUST:
	TargetPoint = GetHoverWaitPoint();
	SetMarker( TargetPoint );	// TEMP
	if ( bCanHover && bCanStrafe &&
		 ( VSize(Location - TargetPoint) < ( FMin( CollisionRadius, CollisionHeight ) * 16.0 ) ) )
	{
		if ( TargetPoint.Z > Location.Z )
			TargetPoint.Z += CollisionHeight;
		else
			TargetPoint.Z -= CollisionHeight;
		StrafeTo( TargetPoint, Location + vector(Rotation) * 30000.0, HoverSpeedScale * 0.35 );
		StopMovement();
	}
	else if ( !CloseToPoint( TargetPoint, 1.0 ) ||
			  ( bCanHover && ( Abs(Location.Z - TargetPoint.Z) > ( CollisionHeight * 0.10 ) ) ) )
	{
		PlayWalk();
		if ( !pointReachable( TargetPoint ) )
		{
			PathObject = PathTowardPoint( TargetPoint );
			if ( PathObject != none )
				TargetPoint = PathObject.Location;
			else
			{
				HoverStart = Location + vect(0,0,1) * HoverAltitude;
				TargetPoint = LocalToWorld( vect(5,0,0) * CollisionRadius );
			}
		}

		if ( bCanHover && CloseToPoint( TargetPoint, 16.0 ) )
			StrafeTo( TargetPoint, Location + vector(Rotation) * 30000.0, HoverSpeedScale );
		else
			MoveTo( TargetPoint, WalkSpeedScale );
		DesiredRotation = Rotation;
		DesiredRotation.Pitch = 0;
		if ( bCanHover && ( DefCon == 0 ) && ( FRand() < 0.10) )
			goto 'HOVER';
		goto 'ADJUST';
	}
	CueNextEvent();
	goto 'END';

HOVER:
	SlowMovement();
	PlayWaitAnim();
	CueNextEvent();

END:
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
		SetAlertness( 1.0 );
		GotoState( 'AIWait' );
	}

} // state AIAmbush


//****************************************************************************
// AIPatrol
// follow a pre-defined patrol route
//****************************************************************************
state AIPatrol
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		RotationRate.Yaw = default.RotationRate.Yaw * WaitGlideScalar;
	}

	function EndState()
	{
		super.EndState();
		RotationRate.Yaw = default.RotationRate.Yaw;
	}

	// *** new (state only) functions ***

} // state AIPatrol


//****************************************************************************
// AIDance
// Enemy was killed.
//****************************************************************************
state AIDance
{
	// *** ignored functions ***

	// *** overridden functions ***
	//
	function SetTargetPoint()
	{
		local float		Dist;
		local rotator	DRot;
		local int		Tries;
		local vector	TPoint;

		Tries = 0;
		while ( Tries < 4 )
		{
			Tries += 1;
			Dist = ( TargetActor.CollisionRadius + CollisionRadius ) * 2 + FVariant( HoverRadius, HoverRadius * 0.10 );
			DRot.Yaw = 65535 * FRand();
			DRot.Pitch = 0;
			DRot.Roll = 0;
			TargetPoint = TargetActor.Location + ( vector(DRot) * Dist ) + ( vect(0,0,1) * FRand() * HoverAltitude );
			if ( FastTrace( TargetActor.Location, TargetPoint ) )
				return;
		}
	}

		// Called when point reached.
	function AtDancePoint()
	{
		GotoState( 'AIWait' );
	}

	// *** new (state only) functions ***

} // state AIDance


//****************************************************************************
// AIFollowOwner
// Follow my Owner.
//****************************************************************************
state AIFollowOwner
{
	// *** ignored functions ***

	// *** overridden functions ***
	function AtPoint()
	{
		DebugInfoMessage( ".(ScriptedFlyer)AIFollowOwner.AtPoint()" );
		GotoState( , 'GOTOPT');
	}

	function WaitPoint()
	{
		DebugInfoMessage( ".(ScriptedFlyer)AIFollowOwner.WaitPoint()" );
	}

	function vector GetFollowPoint( actor Other )
	{
		local vector	GPoint;

		if ( FastTrace( Other.Location, Location ) )
		{
			GPoint = Other.Location + vect(0,0,2) * Other.CollisionHeight;
			if ( FastTrace( GPoint, Location ) )
				return GetEnRoutePoint( GPoint, -( FollowDistance + CollisionRadius + Other.CollisionRadius ) );
			else
				return GetEnRoutePoint( Other.Location, -( FollowDistance + CollisionRadius + Other.CollisionRadius ) );

		}
		return Other.Location;
	}

	// *** new (state only) functions ***

GLIDE:
	Sleep( 0.25 );
	goto 'WAITPT';
} // state AIFollowOwner


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
		DesiredRotation.Pitch = 0;
		if ( ( Physics == PHYS_Flying ) || ( Physics == PHYS_None ) )
			SetPhysics( PHYS_Falling );
		else
			Landed( vect(0,0,0) );
		StopTimer();
	}

	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		if ( !bNoDeathSpin && ( Physics == PHYS_Falling ) )
		{
			DesiredRotation.Yaw = Rotation.Yaw + RotationRate.Yaw * DeltaTime * 2.0;
		}
	}

	function Landed( vector hitNormal )
	{
	}

} // state Dying


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     HoverAltitude=300
     HoverVariance=50
     HoverSpeedScale=0.3
     HoverRadius=100
     WaitGlideScalar=1
     GStoneFallTime=0.8
     AirSpeed=400
     AccelRate=2000
     RotationRate=(Pitch=10000,Yaw=30000,Roll=3000)
     SoundRadius=32
}
