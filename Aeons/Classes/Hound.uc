//=============================================================================
// Hound.
//=============================================================================
class Hound expands ScriptedPawn;

// #exec OBJ LOAD FILE=\Aeons\Textures\HoundSpawn.utx PACKAGE=HoundSpawn

//#exec MESH IMPORT MESH=Hound_m SKELFILE=Hound.ngf
//#exec MESH MODIFIERS Cloth:Hair Cloth_Head:Hair Cloth_L_Arm:Hair Cloth_R_Arm:Hair Cloth_Spine:Hair


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.304 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.348 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.341 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.390 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.439 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_headbutt TIME=0.151 FUNCTION=DoNearDamage3	//
//#exec MESH NOTIFY SEQ=attack_headbutt TIME=0.189 FUNCTION=DoNearDamage3	//
//#exec MESH NOTIFY SEQ=jump TIME=0.195 FUNCTION=DoNearDamage3			//
//#exec MESH NOTIFY SEQ=jump TIME=0.293 FUNCTION=DoNearDamage3			//
//#exec MESH NOTIFY SEQ=jump TIME=0.390 FUNCTION=DoNearDamage3			//
//#exec MESH NOTIFY SEQ=jump TIME=0.488 FUNCTION=DoNearDamage3			//
//#exec MESH NOTIFY SEQ=jump TIME=0.585 FUNCTION=DoNearDamage3			//
//#exec MESH NOTIFY SEQ=jump TIME=0.683 FUNCTION=DoNearDamage3			//
//#exec MESH NOTIFY SEQ=jump TIME=0.780 FUNCTION=DoNearDamage3			//
//#exec MESH NOTIFY SEQ=jump TIME=0.878 FUNCTION=DoNearDamage3			//
//#exec MESH NOTIFY SEQ=creature_special_kill TIME=0.103 FUNCTION=GrabPlayer	//
//#exec MESH NOTIFY SEQ=creature_special_kill TIME=0.776 FUNCTION=DropPlayer	//
//#exec MESH NOTIFY SEQ=Thrown_Ambrose TIME=0.380 FUNCTION=ThrownWarpOutStart	//
//#exec MESH NOTIFY SEQ=Thrown_Ambrose TIME=0.400 FUNCTION=ThrownWarpOutEffect
//#exec MESH NOTIFY SEQ=Thrown_Ambrose TIME=1.00 FUNCTION=ThrownWarpOutEnd	//
//#exec MESH NOTIFY SEQ=jump TIME=0.171 FUNCTION=TriggerJump				//
//#exec MESH NOTIFY SEQ=Warpout TIME=0.505 FUNCTION=WarpOutEffect
//#exec MESH NOTIFY SEQ=Warpout TIME=1.000 FUNCTION=EndWarpOut

//#exec MESH NOTIFY SEQ=Attack_Bite TIME=0.0192308 FUNCTION=PlaySound_N ARG="Attack PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Bite TIME=0.269231 FUNCTION=PlaySound_N ARG="Bite PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.0196078 FUNCTION=PlaySound_N ARG="Attack PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.235294 FUNCTION=PlaySound_N ARG="Swipe PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.607843 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Attack_Headbutt TIME=0.0566038 FUNCTION=PlaySound_N ARG="Attack PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Headbutt TIME=0.301887 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Attack_Headbutt TIME=0.566038 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Attack_Headbutt TIME=0.849057 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=run TIME=0.193548 FUNCTION=PlaySound_N ARG="Charge CHANCE=0.3 PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=run TIME=0.741935 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=run TIME=0.741935 FUNCTION=PlaySound_N ARG="CarpetS PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=run TIME=0.870968 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=run TIME=0.870968 FUNCTION=PlaySound_N ARG="CarpetS PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=run TIME=0.903226 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=run TIME=0.903226 FUNCTION=PlaySound_N ARG="CarpetS PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=Creature_Special_Kill TIME=0.0344828 FUNCTION=PlaySound_N ARG="SpecialKill V=1.3"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.0196078 FUNCTION=PlaySound_N ARG="Damage PVar=0.2 V=1.4 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.352941 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.509804 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Death TIME=0.0322581 FUNCTION=PlaySound_N ARG="Death PVar=0.1 V=1.4 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.225806 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Hunt TIME=0.225806 FUNCTION=PlaySound_N ARG="CarpetS PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.451613 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Hunt TIME=0.451613 FUNCTION=PlaySound_N ARG="CarpetS PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.677419 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Hunt TIME=0.677419 FUNCTION=PlaySound_N ARG="CarpetS PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.903226 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Hunt TIME=0.903226 FUNCTION=PlaySound_N ARG="CarpetS PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.0333333 FUNCTION=PlaySound_N ARG="Idle CHANCE=0.3 PVar=0.2 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Sniff TIME=0.0571429 FUNCTION=PlaySound_N ARG="Sniff PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle_Sniff TIME=0.371429 FUNCTION=PlaySound_N ARG="Sniff PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle_Sniff TIME=0.6 FUNCTION=PlaySound_N ARG="Sniff PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=Jump TIME=0.15 FUNCTION=PlaySound_N ARG="Jump PVar=0.2 V=0.6 VVar=0.1"
//#exec MESH NOTIFY SEQ=Jump TIME=0.475 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Jump TIME=0.475 FUNCTION=PlaySound_N ARG="CarpetS PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=Jump TIME=0.525 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Jump TIME=0.525 FUNCTION=PlaySound_N ARG="CarpetS PVar=0.2 V=0.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=Struggle_Ambrose TIME=0.0333333 FUNCTION=PlaySound_N ARG="Attack CHANCE=0.5 PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt_Howl TIME=0.166667 FUNCTION=PlaySound_N ARG="Taunt PVar=0.2 V=1.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt_Roar TIME=0.0243902 FUNCTION=PlaySound_N ARG="Roar PVar=0.2 V=1.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Thrown_Ambrose TIME=0.36 FUNCTION=PlaySound_N ARG="VDamage PVar=0.2 V=0.6 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_180 TIME=0.411765 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Turn_180 TIME=0.441176 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Turn_180 TIME=0.558824 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Turn_180 TIME=0.647059 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Warpout TIME=0.0111111 FUNCTION=PlaySound_N ARG="Idle PVar=0.2 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Warpout TIME=0.511111 FUNCTION=PlaySound_N ARG="Swipe PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Warpout TIME=0.555556 FUNCTION=PlaySound_N ARG="GhelFire P=0.75 PVar=0.2 VVar=0.1"

//****************************************************************************
// Animation notes:
// Renamed animation sequences:
// Hunt_Prowl -> hunt (with _Morph)
// Charge -> run (with _Morph)

//****************************************************************************
// Member vars.
//****************************************************************************
var	ScriptedPawn			HoundAmbrose;	// Hound's reference to ambrose.
var vector					AmbroseBitePoint;
var(BossFight) float		HoundStruggleTime;
var SPDrawScaleEffector		DrawScaleEffector;
var() sound HowlSounds[2];
var bool					bGetThrown;

var bool	bMeleeAttackFail;	// used to hack howler's freezing during near attacks

//****************************************************************************
// Animation trigger functions.
//****************************************************************************
// Play close-range attack animation.
function PlayNearAttack()
{
	switch ( Rand(3) )
	{
		case 0:
			PlayAnim( 'attack_bite', 1.25 );
			break;
		case 1:
			PlayAnim( 'attack_claw', 1.25 );
			break;
		default:
			PlayAnim( 'attack_headbutt', 1.25 );
			break;
	}
}

function PlayJumpAttack()
{
	PlayAnim( 'jump',, MOVE_None );
}

function bool PlayLanding()
{
	return false;
}

function PlayTaunt()
{
	if ( Rand(2) == 0 )
		PlayAnim( 'taunt_roar' );
	else
		PlayAnim( 'taunt_howl' );
}

function PlayStunDamage()
{
	PlayAnim( 'damage_stun',, MOVE_None );
}

function PlaySpecialKill()
{
	PlayAnim( 'creature_special_kill' );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'death' );
}


//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage PVar=0.2 V=1.4 VVar=0.1" );
}

function PlaySoundDeath()
{
	PlaySound_P( "VDeath PVar=0.1 V=1.4 VVar=0.1" );
}

function C_BareFS()
{
	super.C_BareFS();
	PlaySound_P( "FootSweetener" );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	if (RGC())
	{
		DamageRadius = 130;
		MeleeRange = 100;
		GroundSpeed = 600;
		Health = 600;
	}
	super.PreBeginPlay();
}

function BeginPlay()
{
	Super.BeginPlay();
	GotoState('AISpawn');
}

function PreSetMovement()
{
	super.PreSetMovement();
	bCanJump = true;
}

function bool DoFarAttack()
{
	local float		dist;
	
	if (!RGC())
		return Super.DoFarAttack();

	dist = DistanceTo( Enemy );
	if ( ( dist > ( MeleeRange * 2.5 ) ) &&
		 ( dist < ( MeleeRange * 4.0 ) ) &&
		 actorReachable( Enemy ) )
		return true;
	else
		return false;
}

// Near damage is applied based on specific joints.
function bool NearStrikeValid( actor Victim, int DamageNum )
{
	if ( DamageNum == 1 )
		return JointStrikeValid( Victim, 'head', DamageRadius );
	else
		return JointStrikeValid( Victim, 'r_hand', DamageRadius );
}

function InitEffectors()
{
	if( DrawScaleEffector == none )
		DrawScaleEffector = SPDrawScaleEffector(SpawnEffector( class'SPDrawScaleEffector' ));

	super.InitEffectors();
}

//****************************************************************************
// New class functions.
//****************************************************************************
function InitState(PlayerPawn P);


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************
function SetAmbrose( ScriptedPawn a, vector bitePoint )
{
	HoundAmbrose = a;
	AmbroseBitePoint = GetGotoPoint( bitePoint );
}

function EndWarpOut()
{
}

function WarpOutEffect()
{
	Spawn( class'GhelzRingFX',,, Location );
	PlaySound_P( "Spawn" );
	OpacityEffector.SetFade(0.0, GetNotifyTime( 'Warpout', 'EndWarpOut' ) - GetNotifyTime( 'Warpout', 'WarpOutEffect' ));
}

function ThrownWarpOutStart()
{
	DrawScaleEffector.SetFade(0.05, 0.4);
}

function ThrownWarpOutEffect()
{
	local vector x, y, z;
	local HoundSpawnEffect FX;

	GetAxes( Rotation, x, y, z );
//	FX = Spawn( class'HoundSpawnEffect',,, Location - x*400 );
//	FX.rate = 0.08;
	Spawn( class'GhelzRingFX',,, Location - x*400 );
	PlaySound_P( "Spawn" );
}

function ThrownWarpOutEnd()
{
	Destroy();
}

function StartStruggle()
{
	LoopAnim( 'Struggle_Ambrose', 1.0 );
}

function GetThrown()
{
	DebugInfoMessage( ".GetThrown() called." );
	PlayAnim( 'Thrown_Ambrose', 1.0, MOVE_Anim );
}

state AmbroseBossFight expands AIScriptedState
{
	function BeginState()
	{
		super.BeginState();
		SetPhysics( PHYS_Walking );
	}

	function Timer()
	{
		if( !bGetThrown )
		{
			DebugInfoMessage( ".AmbroseBossFight, didn't reach target point" );
			HoundAmbrose.GotoState( 'AmbroseBossFightGiantNormal' );
			GotoState( 'AmbroseBossFightJustLeave' );
		}
		else
		{
			DebugInfoMessage( ".AmbroseBossFight.Timer() -- ambrose throws." );
			StopTimer();
			HoundAmbrose.GotoState( 'AmbroseBossFightGiantThrowHound' );
		}
	}

Begin:
	bGetThrown = false;
	SetTimer( 10.0, false );
//	SetCollisionSize( 5.0, CollisionHeight );

GOTOPT:
	if ( !CloseToPoint( AmbroseBitePoint, 1.0 ) )
	{
		if ( pointReachable( AmbroseBitePoint ) )
		{
			PlayRun();
			MoveTo( AmbroseBitePoint, 1.0 );
			DebugInfoMessage( ".AmbroseBossFight, reached target point." );
		}
		else
		{
			DebugInfoMessage( ".AmbroseBossFight BitePoint( " $ AmbroseBitePoint $ ") is not reachable from " $ Location $ ".");
			PathObject = PathTowardPoint( AmbroseBitePoint );
			if ( PathObject != none )
			{
				// can path to TargetPoint
				PlayRun();
				MoveToward( PathObject, 1.0 );
				goto 'GOTOPT';
			}
			else
			{
				// couldn't path to point -- what's an AI to do? -- sleep until the timer fires
				DebugInfoMessage( ".AmbroseBossFight, couldn't reach target point" );
				HoundAmbrose.GotoState( 'AmbroseBossFightGiantNormal' );
				GotoState( 'AmbroseBossFightJustLeave' );
			}
		}
	}

PlayBite:
	SetTimer( 0.0, false );
	PlayWait();
	StopMovement();
	if( CloseToPoint( AmbroseBitePoint, 1.0 ) )
	{
		TurnToward( HoundAmbrose );
		if( SetLocation( AmbroseBitePoint ) )
		{
			bGetThrown = true;
			SetTimer( HoundStruggleTime, false );
			SendCreatureComm( HoundAmbrose, "HoundAttack" );
			Stop;
		}
	}
	HoundAmbrose.GotoState( 'AmbroseBossFightGiantNormal' );
	GotoState( 'AmbroseBossFightJustLeave' );
}

state AmbroseBossFightJustLeave expands AIScriptedState
{
	function TriggerJump() {}

Begin:
	PlayAnim( 'Warpout' );
	FinishAnim();
	Destroy();
}

//****************************************************************************
// AINearAttack
// attack near enemy (melee)
//****************************************************************************
state AINearAttack
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		if ( Enemy != none )
			DebugBeginState( " Enemy is " $ Enemy.name );
		else
			DebugBeginState( " Enemy is NONE" );
		StopTimer();
		bPendingBump = false;
	}

	function AnimEnd()
	{
		if( bMeleeAttackFail )
		{
			DebugInfoMessage( ".AINearAttack.AnimEnd(), going to BEGIN" );
			GotoState( , 'BEGIN' );
		}

		if ( !bDidMeleeAttack )
		{
			DebugInfoMessage( ".AINearAttack.AnimEnd(), going to DOATTACK" );
			GotoState( , 'DOATTACK' );
		}
		else
		{
			DebugInfoMessage( ".AINearAttack.AnimEnd(), going to ATTACKED" );
			GotoState( , 'ATTACKED' );
		}
	}

	function Timer()
	{
		if ( !bDidMeleeAttack )
		{
			DebugInfoMessage( ".AINearAttack.Timer(), going to DOATTACK" );
			GotoState( , 'DOATTACK' );
		}
		else
		{
			DebugInfoMessage( ".AINearAttack.Timer(), going to ATTACKED" );
			GotoState( , 'ATTACKED' );
		}
	}

	function Bump( actor Other )
	{
		bPendingBump = true;
		BumpedPawn = pawn(Other);
	}

	function bool HandlePowderOfSiren( actor Other )
	{
		DispatchPowder( Other );
		return true;
	}

	// *** new (state only) functions ***
	function PostAttack()
	{
		GotoState( 'AIAttack' );
	}

	function bool MoveInAttack()
	{
		return bCanFly;
	}

// Entry point when returning from AITakeDamage
DAMAGED:

// Entry point when resuming this state
RESUME:
	GotoState( 'AIAttack' );

// Default entry point
BEGIN:
	if (RGC())
	{
		StopMovement();
		PlayWait();

		if( DistanceTo( Enemy ) > DamageRadius )
		{
			bDidMeleeAttack = false;

			if( FRand() < 0.25 * (Level.Game.Difficulty + 1) || DistanceTo( Enemy ) > 2.5*DamageRadius )
			{
				bMeleeAttackFail = false;
				GotoState( 'AIFarAttack' );
			}
			else
			{
				PlayRun();
				MoveToward( Enemy, FullSpeedScale );

				bMeleeAttackFail = true;	// if not set previously, helps to avoid second TurnToward
				goto 'BEGIN';
			}
		}

		if ( VSize(Enemy.Velocity) < 10.0 )
		{
			bDidMeleeAttack = false;
			SetTimer( 2.0, false );

			if( !bMeleeAttackFail ) // if there was no previous attack
			{
				TurnToward( Enemy, TurnTowardThreshold( 20 * DEGREES ) );
			}
		}

		bMeleeAttackFail = false;
	}
	else
	{
		if ( !bCanFly || ( VSize(Enemy.Velocity) < 10.0 ) )
		{
			StopMovement();
			PlayWait();
			bDidMeleeAttack = false;
			SetTimer( 2.0, false );
			TurnToward( Enemy, TurnTowardThreshold( 20 * DEGREES ) );
		}
	}
DOATTACK:
	bDidMeleeDamage = false;
	bDidMeleeAttack = true;
	DebugInfoMessage( " playing near attack" );
	PlayNearAttack();
	SetTimer( 5.0, false );		// BUGBUG: using timer to bail out when no animation present

INATTACK:
	if (RGC())
	{
		if( DistanceTo(Enemy) > DamageRadius )	// enemy lost
		{
			//StopTimer();
			//GotoState( 'AIFarAttack' );
			
			//PostAttack();
			bMeleeAttackFail = true;
			StopTimer();
			//TweenAnim( 'Idle_Alert', FVariant(0.15,0.05) );
			goto 'BEGIN';
		}
	}
	else
	{
		if ( MoveInAttack() )
		{
			MoveTarget = Enemy;
			if ( VSize(Enemy.Velocity) < 10.0 )
				MoveToward( Enemy, FullSpeedScale * 0.70 );
			else
				MoveToward( Enemy, FullSpeedScale );
		}
		else
		{
			MoveTarget = Enemy;
			//TurnToward( Enemy );
		}
	}
	Sleep( 0.1 );
	goto 'INATTACK';

ATTACKED:
	StopTimer();
	if ( bPendingBump )
		CreatureBump( BumpedPawn );
	PostAttack();
} // state AINearAttack

//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***


JUMPED:
	FinishAnim();
	GotoState( 'AIAttack' );

// Entry point when returning from AITakeDamage.
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state.
RESUME:

// Default entry point.
BEGIN:
	if ( FacingToward( Enemy.Location, 0.96 ) )
		SlowMovement();
	else
		StopMovement();
	PushState( GetStateName(), 'JUMPED' );
	GotoState( 'AIJumpAtEnemy' );
} // state AIFarAttackAnim


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

	function StartSequence()
	{
		GotoState( , 'HOUNDSTART' );
	}

	// *** new (state only) functions ***


HOUNDSTART:
	NoLook();
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'hound_death', [TweenTime] 0.0  );
	PlayAnim( 'creature_special_kill', [TweenTime] 0.0  );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// AISpawn
//****************************************************************************
auto state AISpawn
{
	function Bump( actor Other ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorHearNoise( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( Pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		DrawScale = 0.05;
	}

	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		if ( DrawScale < 1.0 )
			DrawScale = FClamp( DrawScale + DeltaTime, 0, 1 );
	}

	// *** new (state only) functions ***
	function InitState( PlayerPawn P )
	{
		P.PlaySound(HowlSounds[Rand(2)]);
		SetEnemy( P );
	}

	function FinishSpawn()
	{
		GotoState( 'AIAttackPlayer' );
	}


BEGIN:
	PlayAnim( 'Jump',, MOVE_Anim );
//	Spawn( class'HoundSpawnEffect',,, Location );
	Spawn( class'GhelzRingFX',,, Location );
	PlaySound_P( "Spawn" );
//	Enable( 'Tick' );
	FinishAnim();
	FinishSpawn();

} // state AISpawn

//****************************************************************************
// AIJumpAtEnemy
// try to jump toward Enemy
//****************************************************************************
state AIJumpAtEnemy
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool PlayJumpAttackLanding()
	{
		if (RGC())
			return true;
		return PlayLanding();
	}
	
	// trigger the jump toward the enemy
	function TriggerJump()
	{
		local vector EnemyVelocity;
		local vector EnemyAdjustedLoc;
		
		if (RGC())
		{
			EnemyVelocity = Enemy.Velocity; // * GetJumpAttackTime()
			EnemyVelocity.Z *= 0.1;
			
			EnemyAdjustedLoc = Enemy.Location - vect(0,0,1) * Enemy.CollisionHeight;
			// don't add velocity if player is coming towards us
			if (Normal(EnemyAdjustedLoc + EnemyVelocity - Location) dot Normal(EnemyAdjustedLoc - Location) > 0.0)
				AddVelocity( EnemyVelocity );
			
			AirSpeed = 999999;
			JumpTo( EnemyAdjustedLoc );
			AirSpeed = default.AirSpeed;
			GotoState( , 'JUMPED' );
		}
		else
		{
			JumpTo( Enemy.Location + ( Enemy.Velocity * GetJumpAttackTime() ) - ( vect(0,0,1) * Enemy.CollisionHeight ) );
			GotoState( , 'JUMPED' );
		}
	}
} // state AIJumpAtEnemy

//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     HoundStruggleTime=12
     HowlSounds(0)=Sound'CreatureSFX.Hound.C_Hound_DistHowl01'
     HowlSounds(1)=Sound'CreatureSFX.Hound.C_Hound_DistHowl02'
     JumpDownDistance=200
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=25,EffectStrength=0.35,Method=Bite)
     MeleeInfo(1)=(Damage=25,EffectStrength=0.35,Method=RipSlice)
     MeleeInfo(2)=(Damage=25,EffectStrength=0.35,Method=Blunt)
     DamageRadius=120
     SK_PlayerOffset=(X=95)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.55
     bGiveScytheHealth=True
     PhysicalScalar=0.25
     FireScalar=0
     ConcussiveScalar=0.5
     FallDamageScalar=0.2
     MeleeRange=80
     GroundSpeed=700
     AirSpeed=1200
     AccelRate=3000
     MaxStepHeight=50
     SightRadius=1000
     BaseEyeHeight=54
     Health=500
     SoundSet=Class'Aeons.HoundSoundSet'
     FootSoundClass=Class'Aeons.BareFootSoundSet'
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.Hound_m'
     CollisionRadius=60
     CollisionHeight=60
     Mass=1000
}
