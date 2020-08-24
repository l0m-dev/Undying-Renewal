//=============================================================================
// Rat.
//=============================================================================
class Rat expands ScriptedPawn;

//#exec MESH IMPORT MESH=Rat_m SKELFILE=Rat.ngf
//#exec MESH MODIFIERS tail4:Hair tail3:Hair tail2:Hair tail1:Hair


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=hunt TIME=0.500 FUNCTION=DoNearDamage

//#exec MESH NOTIFY SEQ=death1 TIME=0.666667 FUNCTION=PlaySound_N ARG="Bodyfall PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=death2 TIME=0.833333 FUNCTION=PlaySound_N ARG="Bodyfall PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=hunt TIME=0.0625 FUNCTION=PlaySound_N ARG="Hunt CHANCE=0.1 PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=hunt TIME=0.8125 FUNCTION=PlaySound_N ARG="Footstep PVar=0.2 V=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Look TIME=0.2 FUNCTION=PlaySound_N ARG="Hunt CHANCE=0.1 PVar=0.2 V=0.5 VVar=0.1"


//****************************************************************************
// Member vars.
//****************************************************************************
var float					SpeedUpdate;		//
var() int					RGBTable[8];		//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	PlayAnim( 'hunt' );
}

function PlayTaunt()
{
	PlayAnim( 'idle_look' );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	if ( Rand(2) == 0 )
		PlayAnim( 'death1' );
	else
		PlayAnim( 'death2' );
}


//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundDeath()
{
	PlaySound_P( "VDeath PVar=0.2 V=0.5 VVar=0.1" );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	local int	RGB;

	super.PreBeginPlay();
	if ( FRand() < 0.25 )
	{
		RGB = RGBTable[Rand(8)];
		Lighting[0].Diffuse = MakeRGBA( RGB, RGB, RGB, RGB );
		Lighting[0].TextureMask = -1;
	}
	GroundSpeed = FVariant( default.GroundSpeed, default.GroundSpeed * 0.40 );
}

function GiveModifiers()
{
	super.GiveModifiers();
	if ( FireMod != none )
		FireMod.Destroy();

	FireMod = Spawn( class'RatFireModifier', self,, Location );
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	return JointStrikeValid( Victim, 'head', DamageRadius );
}

function ReactToDamage( pawn Instigator, DamageInfo DInfo )
{
}

function bool AcknowledgeDamageFrom( pawn Damager )
{
	return ( ( Damager != none ) && Damager.bIsPlayer );
}

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
	Velocity = Normal(Velocity) * GroundSpeed * 0.50;
	Velocity.Z = 100.0 * JumpScalar;
	DebugInfoMessage( ".JumpOffPawn(), Vel is " $ Velocity );
	SetFall();
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	SpeedUpdate -= DeltaTime;
	if ( SpeedUpdate < 0.0 )
	{
		FullSpeedScale = FVariant( 0.8, 0.2 );
		SpeedUpdate = FVariant( 1.25, 0.25 );
	}
}

function AdjustDamage( out DamageInfo DInfo )
{
	super.AdjustDamage( DInfo );

	if ( ( DInfo.Damagetype == 'stomped' ) &&
		 !DInfo.Deliverer.IsA('Rat') )
	{
		DInfo.Damage = InitHealth * 0.5;
	}
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
// AIWait
// wait for encounter at current location
//****************************************************************************
state AIWait
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Timer()
	{
		if ( FRand() < 0.25 )
		{
			PlayTaunt();
			GotoState( , 'ANIMWAIT' );
		}
		else
			CueNextEvent();
	}

	function CueNextEvent()
	{
		SetTimer( FVariant( 5.0, 2.0 ), false );
	}

	// *** new (state only) functions ***

} // state AIWait


//****************************************************************************
// AIRetreat
// retreat from Enemy, pick a retreat point and seek it
//****************************************************************************
state AIRetreat
{
	// *** ignored functions ***

	// *** overridden functions ***
	function CreatureBump( pawn Other )
	{
		if ( ( Other == none ) || ( Other == Enemy ) )
			return;
		if ( ( ScriptedPawn(Other) != none ) ||
			 ( ( PlayerPawn(Other) != none ) && ( AttitudeTo( Other ) == ATTITUDE_Ignore ) ) )
		{
			PushState( GetStateName(), 'GOTPOINT' );
			BumpedPawn = Other;
			GotoState( 'AIBumpAvoid' );
		}
	}

	// *** new (state only) functions ***

} // state AIRetreat


//****************************************************************************
// AIBumpAvoid
// Bumped into BumpedPawn, try to avoid or move around, return via state stack.
//****************************************************************************
state AIBumpAvoid
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***
	function Dispatch()
	{
		local vector	X, Y, Z, EX;
		local vector	DVect;
		local float		ESpeed;
		local float		MySpeed;

		GetAxes( BumpedPawn.Rotation, EX, Y, Z );
		GetAxes( Rotation, X, Y, Z );
		ESpeed = VSize(BumpedPawn.Velocity);
		MySpeed = VSize(Velocity);
		DVect = Normal(BumpedPawn.Location - Location);

		// Check for different priorities first.
		if ( ScriptedPawn(BumpedPawn) != none )
		{
			if ( ScriptedPawn(BumpedPawn).bBumpPriority && !bBumpPriority )
			{
				BumpPoint = GetRatBumpPoint( X, Y, DVect );
				GotoState( , 'GOAROUND' );
				return;
			}
			else if ( !ScriptedPawn(BumpedPawn).bBumpPriority && bBumpPriority )
			{
				PopState();
				return;
			}
		}

		if ( BumpedPawn.Health <= 0 )
		{
			BumpPoint = GetRatBumpPoint( X, Y, DVect );
			GotoState( , 'GOAROUND' );
			return;
		}

		// Priorities are the same.
		if ( ( X dot EX ) > 0.0 )
		{
			// Headed in similar directions.
			if ( ( X dot DVect ) > 0.0 )
			{
				// I'm "behind" the BumpedPawn, so I'll stop or go around
				if ( //( ESpeed < 10.0 ) || 
					 ( ( ESpeed < MySpeed ) && ( FRand() < 0.90 ) ) )
				{
					BumpPoint = GetRatBumpPoint( X, Y, DVect );
					GotoState( , 'GOAROUND' );
				}
				else
					GotoState( , 'STOPWAIT' );
			}
			else
			{
				// Headed similar direction, I'm in front.
				if ( MySpeed < 10.0 )
				{
					BumpPoint = GetPointAhead( -DVect );
					GotoState( , 'GOAROUND' );	// I'm blocking, better move.
				}
				else
					PopState();		// I'm moving, just continue
			}
		}
		else
		{
			// Headed in opposite directions.
			BumpPoint = GetRatBumpPoint( X, Y, DVect );
			GotoState( , 'GOAROUND' );
		}
	}

	function vector GetRatBumpPoint( vector XAxis, vector YAxis, vector EXAxis )
	{
		local float		Dist;

		Dist = default.CollisionRadius * FVariant( 3.0, 1.0 );
		if ( ( YAxis dot EXAxis ) > 0.0 )
			return GetGotoPoint( Location + ( XAxis * Dist ) - ( YAxis * Dist * 1.5 ) );
		else
			return GetGotoPoint( Location + ( XAxis * Dist ) + ( YAxis * Dist * 1.5 ) );
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	PopState( , 'DAMAGED' );
	goto 'END';

GOAROUND:
	PlayRun();
	MoveTo( BumpPoint, FullSpeedScale, FVariant( 1.0, 0.5 ) );
	PopState();
	goto 'END';

STOPWAIT:
	DebugInfoMessage( ".AIBumpAvoid, STOPWAIT" );
	StopMovement();
	if ( FRand() < 0.125 )
	{
		PlayTaunt();
		FinishAnim();
	}
	else
	{
		PlayWait();
		Sleep( FVariant( 0.30, 0.10 ) );
	}
	PopState();

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	Dispatch();

END:
} // state AIBumpAvoid


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function PoolOfBlood()
	{
		local vector	HitLocation, HitNormal;
		local int		HitJoint;
		
		// Bleed out.
		Trace( HitLocation, HitNormal, HitJoint, Location + vect(0,0,-512), Location, true );
		Spawn( class'SmallBloodDripDecal',,, HitLocation, rotator(HitNormal) );
	}

	// *** new (state only) functions ***

} // state Dying


//****************************************************************************
// AIAlarm
// find alarm point and seek it
//****************************************************************************
state AIAlarm
{
	// *** ignored functions ***

	// *** overridden functions ***
	function StartAlarmPathing()
	{
		StopTimer();
		if ( FRand() < 0.75 )
			SetTimer( FVariant( 3.0, 1.0 ), false );
	}

	function Timer()
	{
		GotoState( , 'RATWAIT' );
	}

	// *** new (state only) functions ***


RATWAIT:
	StopMovement();
	PlayTaunt();
	FinishAnim();
	if ( FRand() < 0.25 )
	{
		PlayWait();
		Sleep( FVariant( 0.30, 0.10 ) );
		PlayTaunt();
		FinishAnim();
	}
	goto 'GOTOACT';

} // state AIAlarm


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     RGBTable(0)=192
     RGBTable(1)=160
     RGBTable(2)=64
     RGBTable(3)=64
     RGBTable(4)=64
     RGBTable(5)=64
     RGBTable(6)=64
     RGBTable(7)=32
     MeleeInfo(0)=(Damage=2)
     DamageRadius=40
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.75
     bGiveScytheHealth=True
     MeleeRange=30
     GroundSpeed=150
     AccelRate=2500
     MaxStepHeight=12
     SightRadius=1500
     BaseEyeHeight=1
     Health=10
     AttitudeToPlayer=ATTITUDE_Ignore
     SoundSet=Class'Aeons.RatSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.Rat_m'
     CollisionRadius=7
     CollisionHeight=6
     Mass=75
}
