//=============================================================================
// SPPhoenix.
//=============================================================================
class SPPhoenix expands ScriptedFlyer;

//#exec MESH IMPORT MESH=SPPhoenix_m SKELFILE=SPPhoenix.ngf


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************
var bool	bDiving;

//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayWalk()
{
	LoopAnim( 'hunt', FVariant( 0.50, 0.10 ) );
}

function PlayRun()
{
	bDiving = false;
	PlayWalk();
}

function PlayNearAttack()
{
	bDiving = true;
	LoopAnim( 'attack_dive' );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreSetMovement()
{
	super.PreSetMovement();
	MinHitWall = 1.0;
}

function PreSkelAnim()
{
}

function HitWall( vector hitNormal, actor hitWall, byte textureID )
{
	DebugInfoMessage(".HitWall() " $ hitWall.name );
	Explode();
}

function Bump( actor Other )
{
	DebugInfoMessage(".Bump()ed " $ Other.name );
	Explode();
}

function bool FlankEnemy()
{
	return false;
}

function vector FlankPosition( vector target )
{
	return target;
}

function DamageInfo getDamageInfo( optional name DamageType )
{
	local DamageInfo	DInfo;

	DInfo.Deliverer = self;
	DInfo.DamageMultiplier = 1.0;
	DInfo.DamageType = 'gen_concussive';
	if( bDiving )
		DInfo.Damage = 150;
	else
		DInfo.Damage = 50;

	return DInfo;
}

function PreBeginPlay()
{
	super.PreBeginPlay();
	FireMod.Activate();
}

function GiveModifiers()
{
	super.GiveModifiers();
	if ( FireMod != none )
		FireMod.Destroy();

	FireMod = Spawn( class'PhoenixFireModifier', self,, Location );
}


//****************************************************************************
// New class functions.
//****************************************************************************
function Init( pawn Target )
{
	SetEnemy( Target );
	GotoState( 'AIAttack' );
}

function Explode()
{
	LogStack();
	Spawn( class'SPPhoenixExplosion', pawn(Owner),, Location );
	Destroy();
}

function bool EncroachingOn( actor Other )
{
	local bool retval;

	retval = (Other != Owner) && super.EncroachingOn( Other );

	DebugInfoMessage( ".EncroachingOn( " $ Other.name $ " ) == " $ retval $ "." );
	return retval;
}

//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AICharge
// Charge Enemy.
//****************************************************************************
state AICharge
{
	// *** ignored functions ***

	// *** overridden functions ***
	// overridden functions
	function Tick( float deltaTime )
	{
		DesiredSpeed = 1.0;
		DesiredRotation = rotator( Normal( Enemy.Location - Location ) );
		Velocity = AirSpeed * WalkSpeedScale * Normal( Enemy.Location - Location );

		super.Tick( deltaTime );
	}

	function Bump( actor Other )
	{
		DebugInfoMessage(".Bump()ed " $ Other.name );
		Explode();
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
	function Timer()
	{
		GotoState( , 'TIMER' );
	}

	function Bump( actor Other )
	{
		DebugInfoMessage(".Bump()ed " $ Other.name );
		Explode();
	}

	// overridden functions
	function Tick( float deltaTime )
	{
		DesiredSpeed = 1.0;
		if ( bDiving || ( Enemy == none ) )
		{
			DesiredRotation = Rotation;
			Velocity = AirSpeed * vector( Rotation );
		}
		else
		{
			DesiredRotation = rotator( Normal( Enemy.Location - Location ) );
			Velocity = AirSpeed * WalkSpeedScale * Normal( Enemy.Location - Location );
		}

		super.Tick( deltaTime );
	}

	// *** new (state only) functions ***


// Default entry point
BEGIN:
	if ( FRand() < 0.75 )
		PlayNearAttack();
	else
		PlayRun();
	SetTimer( 3.0, false );

INATTACK:
	MoveTarget = Enemy;
	if ( VSize(Enemy.Velocity) < 10.0 )
		MoveToward( Enemy, FullSpeedScale * 0.70 );
	else
		MoveToward( Enemy, FullSpeedScale );
	Sleep( 0.1 );
	goto 'INATTACK';

TIMER:
	PostAttack();
} // state AINearAttack


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     HoverAltitude=800
     HoverVariance=150
     HoverRadius=600
     WaitGlideScalar=0.1
     Aggressiveness=1
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.3
     MeleeRange=800
     AirSpeed=2000
     MaxStepHeight=16
     SightRadius=3000
     PeripheralVision=0
     BaseEyeHeight=1
     Health=1000
     SoundSet=Class'Aeons.GuardianPhoenixSoundSet'
     RotationRate=(Pitch=15000,Yaw=60000,Roll=9000)
     Mesh=SkelMesh'Aeons.Meshes.GuardianPhoenix_m'
     DrawScale=0.1
     CollisionRadius=20
     CollisionHeight=16
}
