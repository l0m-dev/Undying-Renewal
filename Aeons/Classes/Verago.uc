//=============================================================================
// Verago.
//=============================================================================
class Verago expands ScriptedFlyer;

//#exec MESH IMPORT MESH=Verago_m SKELFILE=Verago.ngf
//#exec MESH MODIFIERS Cloth1:Cloth

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=telekinesis TIME=0.550 FUNCTION=SpawnAll
//#exec MESH NOTIFY SEQ=telekinesis TIME=0.700 FUNCTION=ThrowProj1
//#exec MESH NOTIFY SEQ=suicide_burst TIME=0.789 FUNCTION=Burst
//#exec MESH NOTIFY SEQ=specialkill TIME=0.150 FUNCTION=OJDidIt

//#exec MESH NOTIFY SEQ=defensechant TIME=0.015873 FUNCTION=PlaySound_N ARG="Wind CHANCE=0.3 PVar=0.2 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=defensechant TIME=0.015873 FUNCTION=PlaySound_N ARG="Whisper CHANCE=0.03 PVar=0.15 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=defensechant TIME=0.412698 FUNCTION=PlaySound_N ARG="Chant CHANCE=0.03 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=strafe_left TIME=0.016129 FUNCTION=PlaySound_N ARG="Wind CHANCE=0.2 PVar=0.2 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=strafe_left TIME=0.016129 FUNCTION=PlaySound_N ARG="Whisper CHANCE=0 PVar=0.15 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=strafe_left TIME=0.016129 FUNCTION=PlaySound_N ARG="Chant CHANCE=0 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=strafe_right TIME=0.016129 FUNCTION=PlaySound_N ARG="Wind CHANCE=0.5 PVar=0.2 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=strafe_right TIME=0.016129 FUNCTION=PlaySound_N ARG="Whisper CHANCE=0 PVar=0.15 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=strafe_right TIME=0.016129 FUNCTION=PlaySound_N ARG="Chant CHANCE=0 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=idle TIME=0.016129 FUNCTION=PlaySound_N ARG="Wind CHANCE=0.5 PVar=0.2 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=idle TIME=0.016129 FUNCTION=PlaySound_N ARG="Whisper CHANCE=0.2 PVar=0.15 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=idle TIME=0.016129 FUNCTION=PlaySound_N ARG="Chant CHANCE=0 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=idle_alert TIME=0.016129 FUNCTION=PlaySound_N ARG="Wind PVar=0.2 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=idle_alert TIME=0.016129 FUNCTION=PlaySound_N ARG="Whisper CHANCE=0.1 PVar=0.15 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=idle_alert TIME=0.016129 FUNCTION=PlaySound_N ARG="Chant CHANCE=0.2 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.00980392 FUNCTION=PlaySound_N ARG="SpKill"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.792 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=suicide_burst TIME=0.0108696 FUNCTION=PlaySound_N ARG="Suicide"
//#exec MESH NOTIFY SEQ=telekinesis TIME=0.0123457 FUNCTION=PlaySound_N ARG="Tele"
//#exec MESH NOTIFY SEQ=lotuspose TIME=0.016129 FUNCTION=PlaySound_N ARG="Wind CHANCE=0.5 PVar=0.2 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=lotuspose TIME=0.016129 FUNCTION=PlaySound_N ARG="Whisper CHANCE=0.3 PVar=0.15 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=lotuspose TIME=0.016129 FUNCTION=PlaySound_N ARG="Chant CHANCE=0 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk_backwards TIME=0.0322581 FUNCTION=PlaySound_N ARG="Wind CHANCE=0.05 PVar=0.2 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=walk_backwards TIME=0.0322581 FUNCTION=PlaySound_N ARG="Whisper CHANCE=0 PVar=0.15 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk_backwards TIME=0.0322581 FUNCTION=PlaySound_N ARG="Chant CHANCE=0 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.0322581 FUNCTION=PlaySound_N ARG="Wind CHANCE=.05 PVar=0.2 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=walk TIME=0.0322581 FUNCTION=PlaySound_N ARG="Whisper CHANCE=0 PVar=0.15 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.0322581 FUNCTION=PlaySound_N ARG="Chant CHANCE=0 PVar=0.15 V=0.9 VVar=0.1"


//****************************************************************************
// Structure defs.
//****************************************************************************
enum EVeragoState
{
	VERAGO_None,
	VERAGO_Banding,
	VERAGO_Banded,
	VERAGO_Casting,
	VERAGO_Casted,
	VERAGO_Suicide
};


//****************************************************************************
// Member vars.
//****************************************************************************
var EVeragoState			VeragoState;		//
var Projectile				Projs[2];			//
var Verago					BandLeader;			//
var Verago					Member1;			//
var Verago					Member2;			//
var int						BandCount;			//
var int						BandPos;			//
var() float					ProjSpeed;			//
var vector					ProjTrajectory;		//
var vector					CastLocation;		//
var float					SpellSpeedScale;	// Movement scale while spellcasting.
var float					SpellAngle;			//
var float					SpellRate;			//
var() float					SpellLength;		//
var ParticleFX				VeragoFX;			//
var() float					SuicideThreshold;	//
var() int					DispelLevel;		//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayStunDamage()
{
	PlayAnim( 'takehit',, MOVE_None );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
//	DebugInfoMessage( ".PlayDying(), damage is " $ damage );
	ClearAnims();
//	ApplyMod( JointName(0), class'ClothCollapse' );
	KillPFX();
	AmbientSound = none;
}

function PlayMindshatterDamage()
{
	LoopAnim( 'takehit',, MOVE_None );
}

function PlaySpecialKill()
{
	PlayAnim( 'specialkill',, MOVE_None );
}


//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage PVar=0.15 V=0.9 VVar=0.1" );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool DoFarAttack()
{
	local float		Dist;

	Dist = DistanceTo( Enemy );

	if ( Dist > LongRangeDistance )
		return ( FRand() < 0.05 );
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

function CommMessage( actor sender, string message, int param )
{
	local Verago	CSender;

//	DebugInfoMessage( ".CommMessage(), got message " $ message $ "(" $ param $ ") from " $ sender.name );
	CSender = Verago(sender);
	if ( //( sender != self ) &&
		 ( CSender != none ) )
	{
		if ( ( message == "REQX" ) &&
			 ( CSender == BandLeader ) &&
			 ( BandPos == param ) )
		{
			SendCreatureComm( CSender, "ACKX", BandPos );
		}
		else if ( message == "ACKX" )
		{
			if ( param == 1 )
				Member1 = CSender;
			else if ( param == 2 )
				Member2 = CSender;
		}
		else if ( message == "BAND" )
		{
			if ( VeragoState == VERAGO_None )
			{
				if ( param == 0 )
				{
					BandPos = CSender.BandPosition();
					if ( BandPos > 0 )
					{
//						DebugInfoMessage( ".CommMessage(), entered CHANTER_Banding, position is " $ BandPos $ ", leader is " $ CSender.name );
						BandLeader = CSender;
						VeragoState = VERAGO_Banding;
						SetEnemy( CSender.Enemy );
					}
				}
				else if ( param == 1 )
				{
				}
				else if ( param == 2 )
				{
				}
			}
		}
		else if ( message == "CAST" )
		{
			if ( ( VeragoState == VERAGO_Banded ) &&
				 ( CSender == BandLeader ) )
				GotoState( 'AICastPowerword' );
		}
		else if ( message == "QUIT" )
		{
			if ( VeragoState != VERAGO_Suicide )
			{
				VeragoState = VERAGO_None;
				BandLeader = none;
				GotoState( 'AIAttack' );
			}
		}
	}
}

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	VeragoFX = Spawn( class'VeragoFaceFX', self,, JointPlace('head').pos );
	if ( VeragoFX != none )
		VeragoFX.SetBase( self, 'head' );
}

simulated function Destroyed()
{
	KillPFX();
	super.Destroyed();
}

function bool AcknowledgeDamageFrom( pawn Damager )
{
	return ( ( Damager != none ) && Damager.bIsPlayer );
}

function Ignited()
{
}

function DamageInfo getDamageInfo( optional name DamageType )
{
	local DamageInfo	DInfo;

	if ( DamageType == 'dispel' )
	{
		DInfo.Deliverer = self;
		DInfo.DamageMultiplier = 1.0;
		DInfo.DamageType = 'dispel';
		DInfo.Damage = 1000;
	}
	else
	{
		DInfo.Deliverer = self;
		DInfo.DamageMultiplier = OutDamageScalar;
		DInfo.DamageType = 'gen_concussive';
		DInfo.Damage = 100;
	}
	return DInfo;
}

function bool CanPerformSK( pawn P )
{
	local vector	X, Y, Z;

	GetAxes( P.Rotation, X, Y, Z );
	SK_WorldLoc = P.Location + ( SK_PlayerOffset.X * X ) + ( SK_PlayerOffset.Y * Y ) + ( SK_PlayerOffset.Z * Z );

	return true;
}

function pawn ViewSKFrom()
{
	return SK_TargetPawn;
}

function int Dispel( optional bool bCheck )
{
	if ( bCheck )
		return DispelLevel;
	TakeDamage( none, Location, vect(0,0,0), getDamageInfo( 'dispel' ) );
	return 0;
}

function SetOpacity( float OValue )
{
	super.SetOpacity( OValue );
	if ( VeragoFX != none )
		VeragoFX.Opacity = OValue;
}


//****************************************************************************
// New class functions.
//****************************************************************************
// Spawn projectiles to throw.
function SpawnAll()
{
	local float		ZSeek;

	ZSeek = Location.Z + CollisionHeight;
	Projs[0] = SpawnProj( -65 * DEGREES, ZSeek );
	Projs[1] = SpawnProj( 65 * DEGREES, ZSeek );
//	Projs[0] = SpawnProj( -75 * DEGREES, ZSeek );
//	Projs[1] = SpawnProj( -25 * DEGREES, ZSeek );
//	Projs[2] = SpawnProj( 25 * DEGREES, ZSeek );
//	Projs[3] = SpawnProj( 75 * DEGREES, ZSeek );
}

// Spawn a single projectile at the specified offset.
function Projectile SpawnProj( int YawOffset, float ZSeek )
{
	local rotator			DRot;
	local vector			DVect;
	local vector			HitLocation, HitNormal;
	local int				HitJoint;
	local VeragoProjectile	Proj;

//	YawOffset = IVariant( YawOffset, 5 );

	DRot = Rotation;
	DRot.Yaw += YawOffset;
//	DVect = Location + vector(DRot) * FVariant( 70.0 + CollisionRadius, 10.0 );
	DVect = Location + vector(DRot) * ( 70.0 + CollisionRadius );

//	if ( Trace( HitLocation, HitNormal, HitJoint, DVect - vect(0,0,500), DVect, false ) != none )
//	{
//		Proj = Spawn( class'VeragoProjectile', self,, HitLocation + vect(0,0,6), Rotation );
		Proj = Spawn( class'VeragoProjectile', self,, DVect - vect(0,0,38), Rotation );
		if ( Proj != none )
		{
			ZSeek = FVariant( ZSeek, 40.0 );
			Proj.SetPhysics( PHYS_None );
			Proj.Setup( ZSeek, 0.50 );
			return Proj;
		}
//	}
//	return none;
}

// Throw spawned projectile.
function ThrowProj( int Which )
{
	if ( Projs[Which] != none )
	{
		Projs[Which].SetRotation( rotator(ProjTrajectory) );
		Projs[Which].GotoState( 'Flying' );
		Projs[Which].RemoteRole = ROLE_DumbProxy;
//		Projs[Which].Velocity = ProjTrajectory * FVariant( Projs[Which].Speed, Projs[Which].Speed * 0.10 );
//		Projs[Which].SetPhysics( PHYS_Falling );
		Projs[Which] = none;
	}
}

function ThrowProj1()
{
	ProjTrajectory = vector(WeaponAimAt( Enemy, EyeLocation(), WeaponAccuracy, true, ProjSpeed ));
	ThrowProj( 0 );
	ThrowProj( 1 );
}

function ThrowProj2()
{
	ThrowProj( 2 );
}

function ThrowProj3()
{
	ThrowProj( 0 );
}

function ThrowProj4()
{
	ThrowProj( 3 );
}

// Return the banding position of the responding Verago.
function int BandPosition()
{
	BandCount += 1;
//	DebugInfoMessage( ".BandPosition(), BandCount is " $ BandCount );
	if ( BandCount < 3 )
		return BandCount;
	else
		return -1;
}

// See if suicide burst is appropriate.
function bool SuicideCheck()
{
	if ( ( Health < ( InitHealth * SuicideThreshold ) ) &&
		 EyesCanSee( Enemy.Location ) &&
		 ( DistanceTo( Enemy ) < 1000.0 ) )
	{
		GotoState( 'AISuicide' );
		return true;
	}
	return false;
}

// Super dispatch function, return true if dispatched.
function bool DispatchVerago()
{
	if ( SuicideCheck() )
		return true;
	else if ( VeragoState == VERAGO_None )
	{
		if ( DefCon >= 5 )
			return SelectMembers();
		return false;
	}
	else if ( ( VeragoState == VERAGO_Banding ) || ( VeragoState == VERAGO_Banded ) )
	{
		if ( BandLeader != self )
		{
			TargetActor = BandLeader;
			GotoState( 'AIBand' );
			return true;
		}
		else
		{
			GotoState( 'AIBandLeader' );
			return true;
		}
	}
	return false;
}

// Select initial members for banding/chanting.
function bool SelectMembers()
{
	local Verago	aVerago;
	local Verago	Verago1, Verago2;
	local float		aDist;
	local float		Dist1, Dist2;

	Verago1 = none;
	Verago2 = none;
	foreach AllActors( class'Verago', aVerago )
	{
		if ( ( aVerago != self ) &&
			 ( aVerago.VeragoState == VERAGO_None ) &&
			 ( aVerago.Health > 0 ) )
		{
			aDist = VSize(Location - aVerago.Location);
//			DebugInfoMessage( ".Select(), distance to " $ aVerago.name $ " is " $ aDist );
			if ( Verago1 == none )
			{
				Verago1 = aVerago;
				Dist1 = aDist;
			}
			else if ( Verago2 == none )
			{
				Verago2 = aVerago;
				Dist2 = aDist;
			}
			else
			{
				if ( ( Dist1 > Dist2 ) && ( aDist < Dist1 ) )
				{
					Verago1 = aVerago;
					Dist1 = aDist;
				}
				else if ( ( Dist2 > Dist1 ) && ( aDist < Dist2 ) )
				{
					Verago2 = aVerago;
					Dist2 = aDist;
				}
			}
		}
	}

	if ( ( Verago1 != none ) && ( Verago2 != none ) )
	{
//		DebugInfoMessage( ".Select(), selected " $ Verago1.name $ "(" $ Dist1 $ ") and " $ Verago2.name $ "(" $ Dist2 $ ")" );
		BandCount = 0;
		SendCreatureComm( Verago1, "BAND", 0 );
		SendCreatureComm( Verago2, "BAND", 0 );
		SendClassComm( class'Verago', "REQX", 1 );
		SendClassComm( class'Verago', "REQX", 2 );
		VeragoState = VERAGO_Banding;
		BandLeader = self;
		GotoState( 'AIBandLeader' );
		return true;
	}
	return false;
}

// Return cast readiness.
function bool ReadyToCast()
{
	return false;
}

// Break-up the band.
function BroadcastQuit()
{
	if ( BandLeader != none )
	{
		if ( BandLeader == self )
		{
			SendCreatureComm( Member1, "QUIT", 0 );
			SendCreatureComm( Member2, "QUIT", 0 );
			SendCreatureComm( self, "QUIT", 0 );
		}
		else
			BandLeader.BroadcastQuit();
	}
}

simulated function KillPFX()
{
	if ( VeragoFX != none )
	{
		VeragoFX.Destroy();
		VeragoFX = none;
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
//		DebugInfoMessage( ".Verago.AIWait.Timer()" );
		if ( !DispatchVerago() )
		{
			if ( FRand() < 0.20 )
			{
				HoverAltitude = default.HoverAltitude + FRand() * 80.0;
				super.Timer();
				return;
			}
			CueNextEvent();
		}
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
//		DebugInfoMessage( ".AIAttack.Dispatch(), DefCon is " $ DefCon $ ", Health=" $ Health);
		if ( DispatchVerago() )
			return;
		if ( DistanceTo( Enemy ) < SafeDistance )
		{
//			DebugInfoMessage( ".AIAttack.Dispatch(), Dist is < SafeDistance" );
			GotoState( 'AIAvoidEnemy' );
			return;
		}
		if ( ( DefCon >= 1 ) &&
			 ( Enemy != none ) &&
			 ( EnemyFOVAngle() > 0.96 ) &&
			 ( FRand() < 0.20 ) )
		{
			PushState( GetStateName(), 'RESUME' );
			GotoState( 'AIDodge' );
			return;
		}
		if ( ( ScriptedPawn(Enemy) == none ) &&
			 ( VisionEffector.GetSensorLevel() < 0.75 ) &&
			 ( HearingEffector.GetSensorLevel() < 0.10 ) )
		{
			// Lost enemy.
//			DebugInfoMessage( ".AIAttack, lost enemy." );
			GotoInitState();
			return;
		}
//		if ( FastTrace( Location, Location - vect(0,0,550) ) )
//		{
//			DebugInfoMessage( ".AIAttack.Dispatch(), too far from ground to attack" );
//			GotoState( 'AIAvoidEnemy' );
//			return;
//		}
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
	// In this state, this function is called when the Verago can't find a valid avoid point
	function GotoInitState()
	{
		GotoState( 'AIFarAttack' );
	}

	function Evaluate()
	{
//		DebugInfoMessage( ".AIAvoidEnemy.Evaluate()" );
		DispatchVerago();
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
//			DebugInfoMessage( ".AICharge.Evaluate(), Dist is < SafeDistance" );
			GotoState( 'AIAvoidEnemy' );
			return;
		}
		else if ( Dist < LongRangeDistance )
		{
//			DebugInfoMessage( ".AICharge.Evaluate(), Dist is < LongRangeDistance" );
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
//	function EnemyNotVisible(){}

	// *** overridden functions ***
	function ThrowProj1()
	{
		global.ThrowProj1();
		GotoState( , 'THROWN' );
	}

	// *** new (state only) functions ***


// Entry point when resuming this state.
RESUME:

// Default entry point.
BEGIN:
	StopMovement();
	TurnToward( Enemy, 15 * DEGREES );
	PlayAnim( 'telekinesis' );
//	DebugInfoMessage( ".AIFarAttackAnim, Dist is " $ DistanceTo( Enemy ) );

TURRET:
	TurnToward( Enemy, 10 * DEGREES );
	Sleep( 0.10 );
	goto 'TURRET';

THROWN:
	FinishAnim();
	GotoState( 'AIAttack' );
} // state AIFarAttackAnim


//****************************************************************************
// AIRetreat
// retreat from Enemy, pick a retreat point and seek it
//****************************************************************************
state AIRetreat
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		GotoState( 'AIAvoidEnemy' );
	}

	// *** new (state only) functions ***

} // state AIRetreat


//****************************************************************************
// AIDodge
// Umm... dodge.
//****************************************************************************
state AIDodge
{
	// *** ignored functions ***

	// *** overridden functions ***
	function vector SetTargetPoint( float distance )
	{
		local vector	X, Y, Z;
		local vector	gSpot;

		if ( distance < 0.0 )
			distance = -125;
		else
			distance = 125;

		GetAxes( Rotation, X, Y, Z );
		gSpot = Location + ( Y * FVariant( distance, distance * 0.10 ) );

		if ( !FastTrace( gSpot, Location ) )
		{
			// hit geometry that direction, try other
			return Location - ( Y * FVariant( distance, distance * 0.10 ) );
		}
		else
			return gSpot;
	}

	// *** new (state only) functions ***

} // state AIDodge


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***
	function CommMessage( actor sender, string message, int param ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		DropProjectiles();
		BroadcastQuit();
		Spawn( class'VeragoDeathExplosion',,, JointPlace('head').pos );
		Destroy();
	}

	function bool CanBeInvoked()
	{
		return false;
	}

	// *** new (state only) functions ***
	function DropProjectiles()
	{
		local int		lp;

		for ( lp = 0; lp < ArrayCount(Projs); lp++ )
			if ( Projs[lp] != none )
			{
//				Projs[lp].GotoState( 'FallingState' );
//				Projs[lp].Velocity = vect(0,0,0);
//				Projs[lp].SetPhysics( PHYS_Falling );
				Projs[lp].Destroy();
				Projs[lp] = none;
			}
	}

} // state Dying


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginNav()
	{
		GotoState( , 'VERAGOSK' );
	}

	function PostSpecialKill()
	{
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
		GotoState( 'AIWait' );
	}

	function StartSequence()
	{
		GotoState( , 'VERAGOSTART' );
	}

	function SetOrientation()
	{
		local vector	X, Y, Z;
		local vector	DVect;

		GetAxes( SK_TargetPawn.Rotation, X, Y, Z );
		SK_WorldLoc = SK_TargetPawn.Location + ( SK_PlayerOffset.X * X ) + ( SK_PlayerOffset.Y * Y ) + ( SK_PlayerOffset.Z * Z );
		SetLocation( SK_WorldLoc );
		DVect = SK_TargetPawn.Location - SK_WorldLoc;
		DVect.Z = 0;
		DesiredRotation = rotator(DVect);
		DesiredRotation.Yaw -= 5 * DEGREES;
		SetRotation( DesiredRotation );
	}

	// *** new (state only) functions ***
	function TeleportTo( vector Loc )
	{
		local vector	DVect;

		SetLocation( Loc );
		DVect = SK_TargetPawn.Location - Location;
		DVect.Z = 0.0;
		SetRotation( rotator(DVect) );
		DesiredRotation = Rotation;
	}

	function OJDidIt()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('neck').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'head', 'root');
	}


VERAGOSK:
	StopMovement();
	OpacityEffector.SetFade( 0.0, 1.0 );
	Sleep( 1.0 );
	TeleportTo( SK_WorldLoc );
	OpacityEffector.SetFade( 1.0, 1.0 );
	PlaySound_P( "Teleport" );
	StopTimer();
	Sleep( 1.0 );
	goto 'ATPOINT';

VERAGOSTART:
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'verago_death', [TweenTime] 0.0  );
	PlayAnim( 'specialkill', [TweenTime] 0.0  );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// AIBand
// Try to reach and meet TargetActor.
//****************************************************************************
state AIBand
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
//	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		SetDefCon( 5 );
		StopTimer();
	}

	function Timer()
	{
		GotoState( , 'PICKPT' );
	}

	function bool ReadyToCast()
	{
		return ( VeragoState == VERAGO_Banded );
	}

	// *** new (state only) functions ***
	function vector GetTargetPoint( actor aActor )
	{
		local int		YawOffset;
		local rotator	DRot;

		if ( BandPos == 1 )
			YawOffset = 90 * DEGREES;
		else if ( BandPos == 2 )
			YawOffset = 270 * DEGREES;
		else
			YawOffset = 180 * DEGREES;

		DRot = rot(0,0,0);
		DRot.Yaw = aActor.Rotation.Yaw + YawOffset;
		return aActor.Location + vector(DRot) * 150.0;
	}

	function AtPoint()
	{
	}


// Entry point when returning from AITakeDamage
DAMAGED:

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:

PICKPT:
	TargetPoint = GetTargetPoint( TargetActor );
	VeragoState = VERAGO_Banding;
	if ( !CanPathToPoint( TargetPoint ) )
		TargetPoint = TargetActor.Location;
	SetMarker( TargetPoint );

	if ( FastTrace( Location, TargetPoint ) &&
		 FastTrace( Location, BandLeader.Location ) &&
		 ( DistanceToPoint( TargetPoint ) < 150.0 ) &&
		 ( DistanceTo( BandLeader ) < 150.0 ) )
		goto 'ATPOINT';

	if ( !CloseToPoint( TargetPoint, 2.0 ) )
	{
		SetTimer( FVariant( 2.0, 0.5 ), false );
GOTOPT:
		if ( pointReachable( TargetPoint ) )
		{
			PlayRun();
			MoveTo( TargetPoint, FullSpeedScale );
		}
		else
		{
			PathObject = PathTowardPoint( TargetPoint );
//			DebugInfoMessage( "." $ GetStateName() $ ", PathObject set to " $ PathObject.name );
			if ( PathObject != none )
			{
				// can path to TargetPoint
				PlayRun();
				MoveTo( FlightToNavPoint( PathObject, CollisionHeight ), FullSpeedScale );
//				DebugInfoMessage( "." $ GetStateName() $ ", got to nav point " $ PathObject.name );
				goto 'GOTOPT';
			}
			else
			{
				// couldn't path to OrderObject
//				DebugInfoMessage( "." $ GetStateName() $ ", can't reach TargetActor" );
				goto 'WAIT';
			}
		}
	}

ATPOINT:
	AtPoint();
	StopMovement();
	PlayWait();
	TurnToward( Enemy, 10 * DEGREES );
	VeragoState = VERAGO_Banded;
	SuicideCheck();
//	DebugInfoMessage( "." $ GetStateName() $ ", waiting at TargetPoint" );
WAIT:
	SetTimer( FVariant( 1.5, 0.5 ), false );
} // state AIBand


//****************************************************************************
// AIBandLeader
// Seek desirable attack location to launch spell.
//****************************************************************************
state AIBandLeader extends AIBand
{
	// *** ignored functions ***
	function Bump( actor Other ){}

	// *** overridden functions ***
	function vector GetTargetPoint( actor aActor )
	{
		local AeonsNavMarker	Marker;
		local AeonsNavMarker	bMarker;
		local AeonsNavMarker	cMarker;
		local float				bestDist;
		local float				aDist;

		bMarker = none;
		cMarker = none;
		foreach AllActors( class'AeonsNavMarker', Marker )
		{
			if ( Marker.bPWVerago )
			{
				if ( FastTrace( Marker.Location, Enemy.Location ) )
				{
					aDist = VSize(Marker.Location - Enemy.Location);
					if ( ( bMarker == none ) || ( aDist < bestDist ) )
					{
						bMarker = Marker;
						bestDist = aDist;
					}
				}
				else if ( bMarker == none )
				{
					aDist = VSize(Marker.Location - Enemy.Location);
					if ( ( cMarker == none ) || ( aDist < bestDist ) )
					{
						cMarker = Marker;
						bestDist = aDist;
					}
				}
			}
		}

		if ( bMarker != none )
		{
//			DebugInfoMessage( ".GetTargetPoint(), found optimal marker " $ bMarker.name );
			TargetActor = bMarker;
			return bMarker.Location;
		}
		else if ( cMarker != none )
		{
//			DebugInfoMessage( ".GetTargetPoint(), found close marker " $ cMarker.name );
			TargetActor = cMarker;
			return cMarker.Location;
		}
		else
		{
//			DebugInfoMessage( ".GetTargetPoint(), FOUND NO MARKER" );
			TargetActor = self;
			return Location;
		}
	}

	function Timer()
	{
		if ( ( TargetActor != none ) &&
			 ( TargetActor != self ) &&
			 FastTrace( Location, TargetActor.Location ) &&
			 FastTrace( Location, Enemy.Location ) &&
			 ( DistanceTo( TargetActor ) < 300.0 ) &&
			 ( DistanceToGround( self ) > ( DistanceToGround( TargetActor ) * 0.65 ) ) )
			GotoState( , 'ATPOINT' );
		else
			GotoState( , 'PICKPT' );
	}

	function AtPoint()
	{
		GotoState( , 'ATPOINT' );
	}

	// *** new (state only) functions ***


ATPOINT:
	StopMovement();
	PlayWait();
	TurnToward( Enemy, 10 * DEGREES );
//	DebugInfoMessage( ".AIBandLeader, waiting at TargetPoint" );
	VeragoState = VERAGO_Banded;
	SetTimer( FVariant( 1.5, 0.5 ), false );

POLL:
	if ( FastTrace( Enemy.Location, Location ) &&
		 ( Member1 != none ) &&
		 Member1.ReadyToCast() &&
		 ( Member2 != none ) &&
		 Member2.ReadyToCast() )
	{
		SendCreatureComm( Member1, "CAST" );
		SendCreatureComm( Member2, "CAST" );
		GotoState( 'AICastPowerword' );
	}
	if ( DoFarAttack() &&
		 ( FRand() < 0.10 ) )
	{
		GotoState( 'AIFarAttack' );
	}
	SuicideCheck();
	Sleep( 0.10 );
	goto 'POLL';
} // state AIBandLeader


//****************************************************************************
// AICastPowerword
// Cast the Powerword spell at the enemy
//****************************************************************************
state AICastPowerword extends AIBand
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function Timer()
	{
		local VeragoSpell		CSpell;

		if ( VeragoState == VERAGO_Casting )
		{
			VeragoState = VERAGO_Casted;
			if ( BandLeader == self )
			{
				CSpell = Spawn( class'VeragoSpell', self,, SetMarker( CastLocation ) );
				if ( CSpell != none )
				{
					CSpell.Lifespan = SpellLength;
					CSpell.DamageAmount *= OutDamageScalar;
				}
			}
			SetTimer( 8.0, false );
		}
		else if ( VeragoState == VERAGO_Casted )
		{
			VeragoState = VERAGO_Banding;
			PlayWait();
			GotoState( 'AIAttack' );
		}
	}

	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		SpellAngle += SpellRate * DeltaTime;
	}

	// *** new (state only) functions ***
	function vector SpellPosition()
	{
		local rotator	DRot;
		local vector	X, Y, Z;

		DRot = rotator(Enemy.Location - BandLeader.CastLocation);
		if ( BandLeader == self )
			DRot.Roll = SpellAngle;
		else if ( BandPos == 1 )
			DRot.Roll = BandLeader.SpellAngle + 120 * DEGREES;
		else
			DRot.Roll = BandLeader.SpellAngle + 240 * DEGREES;
		GetAxes( DRot, X, Y, Z );
		return BandLeader.CastLocation + Z * 110;
	}


BEGIN:
	VeragoState = VERAGO_Casting;
	CastLocation = Location;
	SpellAngle = 0.0;
	SpellRate = 0.0;
	LoopAnim( 'lotuspose' );
	StrafeFacing( SetMarker( SpellPosition() ), Enemy, SpellSpeedScale );
	SpellRate = default.SpellRate;
	SetTimer( 1.0, false );

TURRET:
	StrafeFacing( SetMarker( SpellPosition() ), Enemy, SpellSpeedScale );
	Sleep( 0.05 );
	goto 'TURRET';
} // state AICastPowerword


//****************************************************************************
// AISuicide
// Kamikaze the enemy.
//****************************************************************************
state AISuicide extends AIScriptedState
{
	// *** ignored functions ***
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function CommMessage( actor sender, string message, int param ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		SetMovementPhysics();
	}

	function bool CanPerformSK( pawn P )
	{
		return false;
	}

	// *** new (state only) functions ***
	function Burst()
	{
		GotoState( , 'BURST' );
	}


// Default entry point
BEGIN:
	VeragoState = VERAGO_Suicide;
	BroadcastQuit();
	PlayAnim( 'suicide_burst' );

WAIT:
	MoveToward( Enemy, FullSpeedScale * 1.25 );
	Sleep( 0.10 );
	goto 'WAIT';

BURST:
	Spawn( class'VeragoExplosion',,, JointPlace('head').pos );
	HurtRadius( 1024, 'gen_concussive', 0, Location, getDamageInfo() );
	Destroy();
} // state AISuicide


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     projSpeed=2000
     SpellSpeedScale=0.45
     SpellRate=7500
     SpellLength=6
     SuicideThreshold=0.1
     DispelLevel=3
     HoverAltitude=180
     HoverVariance=70
     HoverRadius=10
     bCanHover=True
     WaitGlideScalar=0.3
     bNoDeathSpin=True
     bNoGroundHover=True
     bNoEncounterTaunt=True
     SafeDistance=640
     LongRangeDistance=1500
     Aggressiveness=1
     bHasNearAttack=False
     bHasFarAttack=True
     WeaponAccuracy=0.5
     bTakeFootShot=True
     SK_PlayerOffset=(X=127,Z=65)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.3
     bGiveScytheHealth=True
     PhysicalScalar=0.25
     FireScalar=0.25
     bNoBloodPool=True
     bCanStrafe=True
     AirSpeed=360
     AccelRate=1500
     MaxStepHeight=35
     SightRadius=2000
     PeripheralVision=0.25
     BaseEyeHeight=70
     Health=120
     SoundSet=Class'Aeons.VeragoSoundSet'
     PE_StabEffect=Class'Aeons.VeragoBloodPuffFX'
     PE_BiteEffect=Class'Aeons.VeragoBloodPuffFX'
     PE_BluntEffect=Class'Aeons.VeragoBloodPuffFX'
     PE_BulletEffect=Class'Aeons.VeragoBloodPuffFX'
     PE_BulletKilledEffect=None
     PE_RipSliceEffect=Class'Aeons.VeragoBloodPuffFX'
     PE_GenLargeEffect=Class'Aeons.VeragoBloodPuffFX'
     PE_GenMediumEffect=Class'Aeons.VeragoBloodPuffFX'
     PE_GenSmallEffect=Class'Aeons.VeragoBloodPuffFX'
     PD_StabDecal=None
     PD_BiteDecal=None
     PD_BluntDecal=None
     PD_BulletDecal=None
     PD_RipSliceDecal=None
     PD_GenLargeDecal=None
     PD_GenMediumDecal=None
     PD_GenSmallDecal=None
     AmbientSound=Sound'CreatureSFX.Chanter.C_Chanter_AmbLoop'
     RotationRate=(Pitch=1000,Yaw=60000,Roll=0)
     Mesh=SkelMesh'Aeons.Meshes.Verago_m'
     CollisionRadius=24
     CollisionHeight=76
     bGroundMesh=False
     MenuName="Verago"
     CreatureDeathVerb="devestated"
}
