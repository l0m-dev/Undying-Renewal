//=============================================================================
// ScriptedProjectile.
//=============================================================================
class ScriptedProjectile expands ScriptedPawn;

#exec OBJ LOAD FILE=\Aeons\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX
#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts
#exec OBJ LOAD FILE=\Aeons\Sounds\Footsteps.uax PACKAGE=Footsteps
#exec OBJ LOAD FILE=\Aeons\Sounds\LevelMechanics.uax PACKAGE=LevelMechanics


//****************************************************************************
// Member vars.
//****************************************************************************
var() float					ActivatedHoverAltitude;
var() float					ActivationTime;
var() float					HoverHoldTime;
var() float					ProjectileSpeed;
var() bool					DumbFire;
var() EPhysics				StartingPhysics;
var() class<ScriptedFX>		GlowEffectClass;
var ScriptedFX				GlowEffect;
var float					GlowStrength;
var bool					bHovering;
var(Sounds) Sound			LaunchSound;		// Sound played on launch.
var(Sounds) Sound			ExplodeSound;		// Sound played on level contact.
var(Sounds) Sound			ContactSound;		// Sound played on pawn contact.
var() bool					bNoTurret;			//
var() class<ParticleFX>		ExplodeFX;			//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();

	DesiredRotation = Rotation;
	if ( bNoTurret )
		RotationRate.Roll = 0;
}

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
	PlaySound( ExplodeSound );
	Explode();
}

function Bump( actor Other )
{
	if ( Other.IsA('pawn') && !Other.IsA(class.name) )
	{
		PlaySound( ContactSound );
		Explode();
	}
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
	DInfo.EffectStrength = MeleeInfo[0].EffectStrength;
	DInfo.DamageType = MeleeInfo[0].Method;
	DInfo.Damage = MeleeInfo[0].Damage;

	return DInfo;
}

function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo )
{
}

function SetMovementPhysics()
{
	SetPhysics( StartingPhysics );
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
	HurtRadius( 3 * CollisionRadius, 'gen_concussive', 0, Location, getDamageInfo() );
	MakeNoise( 1.0 );
	if ( ExplodeFX != none )
		Spawn( ExplodeFX,,, Location );
//	PlaySound( ExplodeSound );
	GlowEffect.Destroy();
	Destroy();
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
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function Bump( actor Other ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		SetPhysics( StartingPhysics );
		Velocity = vect(0,0,0);
	}
} // state AIWait


//****************************************************************************
// AIWaitForTrigger
// wait for trigger at current location
//****************************************************************************
state AIWaitForTrigger
{
	// *** ignored functions ***
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		SetPhysics( StartingPhysics );
		Velocity = vect(0,0,0);
	}

} // state AIWaitForTrigger


//****************************************************************************
// AIEncounter
// become active at current location.
//****************************************************************************
state AIEncounter
{
	// *** ignored functions ***
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function Tick( float deltaTime )
	{
		if ( ( SensedActor != none ) && !bNoTurret )
		{
			DesiredRotation = rotator( Normal( SensedActor.Location - Location ) );
		}
		else
		{
			DesiredRotation = Rotation;
		}

		if ( bHovering )
		{
			DesiredSpeed = 0.0;
			Velocity = vect(0,0,0);
		}
		else
		{
			DesiredSpeed = 1.0;
			Velocity = vect(0,0,1) * ( ActivatedHoverAltitude / ActivationTime );
		}

		GlowStrength += deltaTime / ActivationTime;
		if ( GlowStrength > 1.0 )
			GlowStrength = 1.0;
		GlowEffect.Opacity = GlowStrength * GlowStrength;

		super.Tick( deltaTime );
	}

	function BeginState()
	{
		DebugBeginState( "SensedActor is " $ SensedActor.name $ ", SensedSense is " $ SensedSense $ ", AttitudeToPlayer is " $ AttitudeToPlayer );

		if ( !SensedActor.IsA('PlayerPawn') )
			SensedActor = FindPlayer();

		SetPhysics(PHYS_Flying);
		if ( ( SensedActor != none ) && !bNoTurret )
		{
			DesiredRotation = rotator( Normal( SensedActor.Location - Location ) );
		}
		else
		{
			DesiredRotation = Rotation;
		}

		DesiredSpeed = 1.0;
		Velocity = vect(0,0,1) * ( ActivatedHoverAltitude / ActivationTime );
		
		GlowEffect = Spawn( GlowEffectClass, self,, Location );
		GlowEffect.Opacity = 0.0;
		GlowStrength = 0.0;
	}

	function EndState()
	{
		Enable( 'Tick' );
	}

	function Timer()
	{
		GotoState( , 'HOLD' );
	}

RESUME:
HOLD:
	if ( HoverHoldTime > 0.0 )
	{
		bHovering = true;
		Sleep( HoverHoldTime );
	}

	GotoState( 'Fire' );

BEGIN:
	SetTimer( ActivationTime, false );

} // state AIEncounter


//****************************************************************************
// Fire
// become like a projectile.
//****************************************************************************
state Fire
{
	// ignored functions
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}

	// overridden functions
	function Tick( float deltaTime )
	{
		DesiredSpeed = 1.0;
		if ( DumbFire || ( SensedActor == none ) )
		{
			DesiredRotation = Rotation;
			Velocity = ProjectileSpeed * vector( Rotation );
		}
		else
		{
			if ( bNoTurret )
				DesiredRotation = Rotation;
			else
				DesiredRotation = rotator( Normal( SensedActor.Location - Location ) );
			Velocity = ProjectileSpeed * Normal( SensedActor.Location - Location );
		}

		super.Tick( deltaTime );
	}

	function Landed( vector hitNormal )
	{
		PlaySound( ExplodeSound );
		Explode();
	}

	function BeginState()
	{
		DebugBeginState();

		SetPhysics( PHYS_Falling );
		DesiredSpeed = 1.0;
		if ( SensedActor != none )
		{
			if ( bNoTurret )
				DesiredRotation = Rotation;
			else
				DesiredRotation = rotator( Normal( SensedActor.Location - Location ) );
			Velocity = ProjectileSpeed * Normal( SensedActor.Location - Location );
		}		
		else
		{
			DesiredRotation = Rotation;
			Velocity = ProjectileSpeed * Vector( Rotation );
		}

		GlowEffect.Opacity = 1.0;
	}

BEGIN:
	PlaySound( LaunchSound );

RESUME:
}


//****************************************************************************
// AIFall
// handle falling
//****************************************************************************
state AIFall
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Landed( vector hitNormal )
	{
		PlaySound( ExplodeSound );
		Explode();
	}

} // state AIFall


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     ActivatedHoverAltitude=60
     ActivationTime=2
     ProjectileSpeed=1000
     DumbFire=True
     GlowEffectClass=Class'Aeons.GlowScriptedFX'
     ExplodeFX=Class'Aeons.SProjSmallSmokeFX'
     Aggressiveness=1
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.3
     PhysicalScalar=0
     MagicalScalar=0
     FireScalar=0
     ConcussiveScalar=0
     bIllumCrosshair=False
     bScryeGlow=False
     MeleeRange=50
     AirSpeed=1000
     AccelRate=400
     MaxStepHeight=16
     SightRadius=3000
     PeripheralVision=0
     BaseEyeHeight=1
     Health=1000
     PI_StabSound=(Sound_1=None,Sound_2=None)
     PI_BiteSound=(Sound_1=None,Sound_2=None)
     PI_BluntSound=(Sound_1=None,Sound_2=None)
     PI_BulletSound=(Sound_1=None,Sound_2=None)
     PI_RipSliceSound=(Sound_1=None,Sound_2=None)
     PE_StabEffect=None
     PE_BiteEffect=None
     PE_BluntEffect=None
     PE_BulletEffect=None
     PE_BulletKilledEffect=None
     PE_RipSliceEffect=None
     PD_StabDecal=None
     PD_BiteDecal=None
     PD_BluntDecal=None
     PD_BulletDecal=None
     PD_RipSliceDecal=None
     PD_GenLargeDecal=None
     PD_GenMediumDecal=None
     PD_GenSmallDecal=None
     AmbientSound=Sound'LevelMechanics.Manor.A04_TeleHum1'
     RotationRate=(Pitch=15000,Yaw=60000,Roll=9000)
     Mesh=SkelMesh'Aeons.Meshes.Skull_proj'
     DrawScale=0.125
     SoundRadius=20
     SoundVolume=32
     CollisionRadius=20
     CollisionHeight=16
}
