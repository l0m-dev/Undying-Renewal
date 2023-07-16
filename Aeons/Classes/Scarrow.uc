//=============================================================================
// Scarrow.
//=============================================================================
class Scarrow expands ScriptedPawn;

//#exec MESH IMPORT MESH=Scarrow_m SKELFILE=Scarrow.ngf
//#exec MESH ORIGIN MESH=Scarrow_m X=-30


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=damage_stun_start TIME=1.000 FUNCTION=damage_stun_cycle
//#exec MESH NOTIFY SEQ=damage_stun_cycle TIME=1.000 FUNCTION=damage_stun_cycle
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.311 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.333 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.356 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.556 FUNCTION=DoNearDamageReset
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.578 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.600 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_spit TIME=0.567 FUNCTION=Spit
//#exec MESH NOTIFY SEQ=idle_disappear TIME=0.000 FUNCTION=Shade
//#exec MESH NOTIFY SEQ=idle_disappear TIME=0.485 FUNCTION=InShadow
//#exec MESH NOTIFY SEQ=idle_disappear TIME=0.515 FUNCTION=DisappearFade
//#exec MESH NOTIFY SEQ=idle_appear_start TIME=0.100 FUNCTION=ReappearFade
//#exec MESH NOTIFY SEQ=idle_appear_start TIME=0.492 FUNCTION=UnShade
//#exec MESH NOTIFY SEQ=death TIME=0.85 FUNCTION=CreateDeathFX

//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.0425532 FUNCTION=PlaySound_N ARG="AttackClaw PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.234043 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.510638 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Spit TIME=0.0333333 FUNCTION=PlaySound_N ARG="AttackSpit PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Spit TIME=0.2 FUNCTION=PlaySound_N ARG="Spit PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun_Cycle TIME=0.0322581 FUNCTION=PlaySound_N ARG="Stun PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun_End TIME=0.0588235 FUNCTION=PlaySound_N ARG="StunEnd PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.0166667 FUNCTION=PlaySound_N ARG="Hunt CHANCE=0.5 PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.0666667 FUNCTION=PlaySound_N ARG="Slide PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.533333 FUNCTION=PlaySound_N ARG="Slide PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.0111111 FUNCTION=PlaySound_N ARG="Idle PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Appear_End TIME=0.037037 FUNCTION=PlaySound_N ARG="AppearEnd PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Appear_Start TIME=0.0663934 FUNCTION=PlaySound_N ARG="Appear PVar=0.25 V=1.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Disappear TIME=0.030303 FUNCTION=PlaySound_N ARG="Disappear PVar=0.25 V=1.3 VVar=0.1"
//#exec MESH NOTIFY SEQ=Strafe_Left TIME=0.2 FUNCTION=PlaySound_N ARG="Slide PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Strafe_Right TIME=0.0869565 FUNCTION=PlaySound_N ARG="Slide PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt_Moan TIME=0.012987 FUNCTION=PlaySound_N ARG="Taunt PVar=0.25 V=1.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Left TIME=0.244444 FUNCTION=PlaySound_N ARG="Slide PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Right TIME=0.272727 FUNCTION=PlaySound_N ARG="Slide PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.000 FUNCTION=PlaySound_N ARG="SPKill V=1.5"
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.672 FUNCTION=PlaySound_N ARG="PatDeath"


//****************************************************************************
// Member vars.
//****************************************************************************
var float					FreezeDelay;		// Delay until unfrozen.
var SPDiffuseEffector		DiffuseEffector;	//
var() color					ShadedColor;		//
var color					NormalColor;		//
var AeonsShadowPoint		ShadowPoint;		// Shadow point.
var bool					bLanternRetreat;	// Retreat when hit with the lantern.
var() float					ReachableRange;		// Distance that enemy is considered reachable without teleport.
var float					SpitDelay;			// TEMP counter for when spit is affecting player
var() float					FadedOpacity;		// Opacity value when faded out.
var() vector				SK_SyncOffset;		//
var() int					DispelLevel;		//
var float					LanternResistanceTime;

const LanternResistanceDelay = 15.0;

//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	PlayAnim( 'attack_claw' );
}

function PlayFarAttack()
{
	PlayAnim( 'attack_spit' );
}

function PlayStunDamage()
{
	PlayAnim( 'damage_stun_start' );
}

function PlayTaunt()
{
	PlayAnim( 'taunt_moan' );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'death' );
}

function PlayShadowed()
{
	PlayAnim( 'idle_appear_start', 0.0, MOVE_None,, 0.0 );
}

function PlayMindshatterDamage()
{
	PlayAnim( 'damage_stun_start' );
}

function SnapToIdle()
{
	PlayAnim( 'idle_appear_start', 0.0, MOVE_None,, 0.0 );
}


//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage PVar=0.25 VVar=0.1" );
}

function PlaySoundDeath()
{
	PlaySound_P( "VDeath PVar=0.25 VVar=0.1" );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	DiffuseEffector = SPDiffuseEffector(SpawnEffector( class'SPDiffuseEffector' ));
}

function LanternBump( actor Other )
{
	if ( ( vector(Rotation) dot ( Other.Owner.Location - Location ) ) > 0.0 )
	{
		if (LanternResistanceTime >= Level.TimeSeconds)
		{
			OpacityEffector.SetFade((LanternResistanceTime - Level.TimeSeconds) / LanternResistanceDelay, 0.0);
		}
		else
		{
			SetEnemy( pawn(Other.Owner) );
			PushState( GetStateName(), 'RESUME' );
			GotoState( 'AIAvoidLantern' );
		}
	}
	else
		super.LanternBump( Other );
}

function bool DoFarAttack()
{
//	DebugInfoMessage( ".DoFarAttack(), A2E is " $ XYAngleToEnemy() );
	if ( bHasFarAttack &&
		 ( SpitDelay <= 0.0 ) &&	// TEMP
		 ( Enemy != none ) &&
		 EyesCanSee( Enemy.Location ) &&
		 ( XYAngleToEnemy() > WeaponAttackFOV ) )
		return super.DoFarAttack();
	else
		return false;
}

function Ignited()
{
	FireMod.SetBurnout( FVariant( 6.0, 1.0 ) );
}

function bool DoEncounterAnim()
{
	return ( DefCon == 0 );
}

function PreSkelAnim()
{
	NoLook();
}

function bool AcknowledgeDamageFrom( pawn Damager )
{
	if ( Damager != none )
		return !Damager.IsA('Scarrow');
	else
		return true;
}

function ProjectileStrikeNotify( pawn P )
{
//	DebugInfoMessage( ".ProjectileStrikeNotify(), struck " $ P.name );
	SpitDelay = 10.0;
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	if ( SpitDelay > 0.0 )
		SpitDelay = FMax( SpitDelay - DeltaTime, 0.0 );
}

function Generated()
{
//	DebugInfoMessage( ".Generated(), GetStateName() is " $ GetStateName() );
	bHidden = true;
	PushState( GetStateName(), 'BEGIN' );
	GotoState( 'AIShadowAppear' );
}

function pawn ViewSKFrom()
{
	return SK_TargetPawn;
}

function DamageInfo getDamageInfo( optional name DamageType )
{
	local DamageInfo	DInfo;

	DInfo.Deliverer = self;
	DInfo.DamageMultiplier = 1.0;
	DInfo.DamageType = 'dispel';
	DInfo.Damage = 1000;
	return DInfo;
}

function int Dispel( optional bool bCheck )
{
	if ( bCheck )
		return DispelLevel;
	else
		TakeDamage( none, Location, vect(0,0,0), getDamageInfo( 'dispel' ) );
}


//****************************************************************************
// New class functions.
//****************************************************************************
// create the dying particle fx
function CreateDeathFX()
{
	OpacityEffector.SetFade( 0, 0.25 );
	Spawn( class'ScarrowDeathFX', self,, Location );
}

// Restore color during appear anim.
function ReappearFade()
{
	OpacityEffector.SetFade( 1.0, 1.0 );
}

// Set opacity during disappear anim, override only in states that need this.
function DisappearFade()
{
}

// Set color during disappear anim, override only in states that need this.
function Shade()
{
}

// Restore color during appear anim.
function UnShade()
{
	DiffuseEffector.SetFade( NormalColor, 1.0 );
}

// Spawn long range projectile.
function Spit()
{
	local Projectile	SpitProj;
	local vector		TargetDirection;

//	DebugInfoMessage( ".Spit() @" $ Level.TimeSeconds );
	SpitProj = Spawn( class'ScarrowProjectile', self,, JointPlace('face').pos );
	if ( SpitProj != none )
	{
		TargetDirection = vector(WeaponAimAt( Enemy, SpitProj.Location, WeaponAccuracy, true, SpitProj.Speed ));
		SpitProj.GotoState( 'FallingState' );
		SpitProj.Velocity = TargetDirection * SpitProj.Speed;
		SpitProj.SetPhysics( PHYS_Falling );
		SpitProj.Enable( 'Tick' );
	}
}

// Compute a valid teleportation location based on the location passed.
function vector ComputeTeleportLocation( vector here )
{
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	Trace( HitLocation, HitNormal, HitJoint, here - vect(0,0,500), here, false );
	return HitLocation + ( vect(0,0,1) * CollisionHeight );
}

// Find nearest reachable shadow point.
function AeonsShadowPoint FindNearShadowPoint()
{
	local AeonsShadowPoint	sPoint, aPoint;
	local float				aDist, BestDist;

	sPoint = none;
	foreach AllActors( class'AeonsShadowPoint', aPoint )
	{
		if ( !aPoint.IsInUse() )
		{
			aDist = PathDistanceTo( aPoint );
			if ( ( Enemy != none ) &&
				 IsForwardProgress( Enemy.Location, aPoint.Location ) &&
				 ( DistanceTo( Enemy ) < aDist ) )
				aDist *= 1.50;
			if ( ( sPoint == none ) || ( ( aDist >= 0.0 ) && ( aDist < BestDist ) ) )
			{
				sPoint = aPoint;
				BestDist = aDist;
			}
		}
	}

	return sPoint;
}

// Find a good point to shadow-morph to.
function AeonsShadowPoint FindAmbushPoint()
{
	local AeonsShadowPoint	sPoint, aPoint, sPoint2;
	local vector			oLocation;
	local float				aDist, pDist, BestDist, BestDist2;

	oLocation = Location;
	sPoint = none;
	foreach AllActors( class'AeonsShadowPoint', aPoint )
	{
		if ( !aPoint.IsInUse() )
		{
			aDist = VSize(Enemy.Location - aPoint.Location);
			if ( ( sPoint == none ) ||
				 ( aDist < BestDist ) ||
				 ( aDist < BestDist2 ) )
			{
				SetLocation( ComputeTeleportLocation( aPoint.Location ) );
				pDist = PathDistanceTo( Enemy );
				if ( pDist < 0.0 )
					pDist = aDist * 32000.0;	// if can't path to Enemy from this point, assign arbitrary large distance
				if ( ( pDist > 0.0 ) &&
					 ( ( sPoint == none ) || ( pDist < BestDist ) ) )
				{
					if ( sPoint != none )
					{
						sPoint2 = sPoint;
						BestDist2 = BestDist;
					}
					sPoint = aPoint;
					BestDist = pDist;
				}
				else if ( ( pDist > 0.0 ) && ( sPoint2 != none ) && ( pDist < BestDist2) )
				{
					sPoint2 = aPoint;
					BestDist2 = pDist;
				}
			}
		}
	}
	SetLocation( oLocation );
	if ( ( sPoint2 != none ) && ( FRand() < 0.60 ) )
		return sPoint2;
	else
		return sPoint;
}

// Find suitable hiding/retreat shadow point.
function AeonsShadowPoint FindHidingPoint()
{
	local AeonsShadowPoint	sPoint, aPoint;
	local float				aDist, BestDist;

	sPoint = none;
	foreach AllActors( class'AeonsShadowPoint', aPoint )
	{
		if ( !aPoint.IsInUse() &&
			 !EnemyCanSee( aPoint.Location ) &&
			 !EnemyCanSee( GetGotoPoint( aPoint.Location ) + vect(0,0,1) * BaseEyeHeight ) )
		{
			aDist = VSize(Enemy.Location - aPoint.Location );
			if ( sPoint == none )
			{
				sPoint = aPoint;
				BestDist = 32000.0;
			}
			else if ( ( aDist >= 0.0 ) && ( aDist > ReachableRange ) && ( aDist < BestDist ) )
			{
				sPoint = aPoint;
				BestDist = aDist;
			}
		}
	}

	return sPoint;
}

// See if Scarrow is near a (recently) used shadow point.
function bool IsUsing( AeonsShadowPoint thisPoint )
{
	if ( ( ShadowPoint == thisPoint ) &&
		 ( DistanceTo( thisPoint ) < ( CollisionRadius * 1.5 ) ) )
		return true;
	else
		return false;
}

// Perform the shadow-moprh.
function ShadowMorphTo( vector Here )
{
	local vector	DVect;

	VisionEffector.Reset();
	SetLocation( ComputeTeleportLocation( Here ) );
	DVect = Enemy.Location - Location;
	DVect.Z = 0.0;
	SetRotation( rotator(DVect) );
	DesiredRotation = Rotation;
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
		global.BeginState();
		GotoState( 'AIHibernate' );
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
		global.BeginState();
		GotoState( 'AIHibernate' );
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
	function BeginState()
	{
		global.BeginState();
		if ( bLanternRetreat )
			GotoState( 'AIHibernate' );
	}

	function Dispatch()
	{
		local float		Dist;

		Dist = PathDistanceTo( Enemy );
		if ( ( Dist > ReachableRange ) || ( Dist < 0.0 ) )
		{
			if ( DoFarAttack() )
			{
				GotoState( 'AIFarAttack' );
			}
			else
			{
				PushState( GetStateName(), 'RESUME' );
				GotoState( 'AIShadowMorph' );
			}
		}
		else
		{
			super.Dispatch();
		}
	}

	// *** new (state only) functions ***

} // state AIAttack


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
		global.BeginState();
		if ( bLanternRetreat )
			GotoState( 'AIHibernate' );
	}

	function Timer()
	{
		local float		Dist;

		Dist = PathDistanceTo( Enemy );
		if ( ( Dist > ReachableRange ) )	//&& ( FRand() < 0.25 ) )
		{
			PushState( GetStateName(), 'RESUME' );
			GotoState( 'AIShadowMorph' );
		}
		else
			super.Timer();
	}

	// *** new (state only) functions ***

} // state AICharge


//****************************************************************************
// AIPatrol
// follow a pre-defined patrol route
//****************************************************************************
state AIPatrol
{
	// *** ignored functions ***

	// *** overridden functions ***
	function AtPoint()
	{
		GotoState( , 'MORPH' );
	}

	function Shade()
	{
		DiffuseEffector.SetFade( ShadedColor, 0.50 );
	}

	function DisappearFade()
	{
		OpacityEffector.SetFade( FadedOpacity, 0.45 );
	}

	// *** new (state only) functions ***

MORPH:
	StopMovement();
	PlayAnim( 'idle_disappear' );
	FinishAnim();
	PatrolPoint = GetNextPatrol( PatrolPoint );
	SetLocation( ComputeTeleportLocation( PatrolPoint.Location ) );
	SetRotation( PatrolPoint.Rotation );
	DesiredRotation = Rotation;
	PlayAnim( 'idle_appear_start',,,, 0.0 );
	FinishAnim();
	PlayAnim( 'idle_appear_end' );
	FinishAnim();
	goto 'DELAY';
} // state AIPatrol


//****************************************************************************
// AICantReachEnemy
// can see, but can't reach Enemy
//****************************************************************************
state AICantReachEnemy
{
	// *** ignored functions ***

	// *** overridden functions ***
	function CheckSpecialNavigation()
	{
//		DebugInfoMessage( ".AICantReachEnemy, CheckSpecialNavigation()" );
		GotoState( 'AIAttack', 'DISPATCH' );
	}

	// *** new (state only) functions ***

} // state AICantReachEnemy


//****************************************************************************
// AIHuntPlayer
// Follow the player until an encounter occurs.
//****************************************************************************
state AIHuntPlayer
{
	// *** ignored functions ***

	// *** overridden functions ***
	function SpecialHunt()
	{
		local float		Dist;

		Dist = PathDistanceTo( TargetActor );
		if ( ( Dist < 0.0 ) ||
			 ( ( Dist > ReachableRange ) && ( FRand() < 0.45 ) ) )
		{
			PushState( GetStateName(), 'MORPHED' );
			SetEnemy( pawn(TargetActor) );
			GotoState( 'AIShadowMorph' );
		}
	}

	// *** new (state only) functions ***

MORPHED:
	SetEnemy( none );
	goto 'RESUME';

} // state AIHuntPlayer


//****************************************************************************
// AIChasePlayer
// Follow the player (quickly) until an encounter occurs.
//****************************************************************************
state AIChasePlayer
{
	// *** ignored functions ***

	// *** overridden functions ***
	function SpecialChase()
	{
		local float		Dist;

		Dist = PathDistanceTo( TargetActor );
		if ( ( Dist < 0.0 ) ||
			 ( ( Dist > ReachableRange ) && ( FRand() < 0.45 ) ) )
		{
			PushState( GetStateName(), 'MORPHED' );
			SetEnemy( pawn(TargetActor) );
			GotoState( 'AIShadowMorph' );
		}
	}

	// *** new (state only) functions ***

MORPHED:
	SetEnemy( none );
	goto 'RESUME';

} // state AIChasePlayer


//****************************************************************************
// AIHibernate
// Hibernate at shadow point.
//****************************************************************************
state AIHibernate
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		ShadowImportance = -1.0;
	}

	function EndState()
	{
		global.EndState();
		ShadowPoint = none;
		OpacityEffector.SetFade( 1.0, 0.0 );
		DiffuseEffector.SetFade( NormalColor, 0.0 );
		ShadowImportance = default.ShadowImportance;
	}

	function AdjustDamage( out DamageInfo DInfo )
	{
		DInfo.Damage = 0;
	}

	function bool IsUsing( AeonsShadowPoint thisPoint )
	{
		if ( ShadowPoint == thisPoint )
			return true;
		else
			return false;
	}

	function Shade()
	{
		DiffuseEffector.SetFade( ShadedColor, 0.50 );
	}

	function DisappearFade()
	{
		OpacityEffector.SetFade( FadedOpacity, 0.45 );
	}

	// *** new (state only) functions ***
	function InShadow()
	{
		StopMovement();
		GotoState( , 'INSHADOW' );
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	SetEnemy( none );
	if ( bLanternRetreat )
	{
		bLanternRetreat = false;
		DiffuseEffector.SetFade( ShadedColor, 0.0 );
		OpacityEffector.SetFade( FadedOpacity, 0.0 );
		VisionEffector.Reset();
		goto 'RETREAT';
	}
	WaitForLanding();
	ShadowPoint = none;
	ShadowPoint = FindNearShadowPoint();
	if ( ShadowPoint != none )
		ShadowPoint.Using( self );

GOTOACT:
	if ( CloseToPoint( ShadowPoint.Location, 2.0 ) )
	{
		PlayAnim( 'idle_disappear' );
		goto 'END';
	}
	if ( actorReachable( ShadowPoint ) )
	{
		PlayRun();
		MoveTo( GetGotoPoint( GetEnRoutePoint( ShadowPoint.Location, -50.0 ) ), FullSpeedScale );
		goto 'ATPOINT';
	}
	else
	{
		OrderObject = ShadowPoint;
		PathObject = PathTowardOrder();
		if ( PathObject != none )
		{
			// can path to OrderObject
			PlayRun();
			MoveToward( PathObject, FullSpeedScale );
			goto 'GOTOACT';
		}
	}

ATPOINT:
	PlayAnim( 'idle_disappear' );
	MoveToward( ShadowPoint, FullSpeedScale * 0.60 );

INSHADOW:
	FinishAnim();

RETREAT:
	PlayShadowed();

END:
} // state AIHibernate


//****************************************************************************
// AIAvoidLantern
// Handle lantern illumination.
//****************************************************************************
state AIAvoidLantern
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}

	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		PushLookAt( none );
		bLanternRetreat = false;
		bAcceptMagicDamage = false;
		LanternResistanceTime = Level.TimeSeconds + LanternResistanceDelay;
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
		bAcceptMagicDamage = true;
	}

	function Tick( float DeltaTime )
	{
		if ( FreezeDelay > 0.0 )
		{
			FreezeDelay -= DeltaTime;
			if ( ( FreezeDelay < 0.0 ) && !bLanternRetreat )
				GotoState( , 'THAW' );
		}
	}

	function LanternBump( actor Other )
	{
		if ( !bLanternRetreat )
			FreezeDelay = 1.0;
	}

	function Timer()
	{
		bLanternRetreat = true;
		GotoState( , 'THAW' );
	}

	function bool IsUsing( AeonsShadowPoint thisPoint )
	{
		if ( ShadowPoint == thisPoint )
			return true;
		else
			return false;
	}

	function Shade()
	{
		DiffuseEffector.SetFade( ShadedColor, 0.50 );
	}

	function DisappearFade()
	{
		OpacityEffector.SetFade( FadedOpacity, 0.45 );
	}

	// *** new (state only) functions ***
	function InShadow()
	{
		StopMovement();
		GotoState( , 'INSHADOW' );
	}


BEGIN:
	OpacityEffector.SetFade( FadedOpacity, 1.0 );
	StopMovement();
	PlayAnim( 'damage_stun_start',, MOVE_None );
	FreezeDelay = 1.0;
	SetTimer( FVariant( 1.5, 0.5 ), false );

TURRET:
	TurnToward( Enemy, 20 * DEGREES );
	Sleep( 0.2 );
	goto 'TURRET';

THAW:
	FreezeDelay = 0.0;
	OpacityEffector.SetFade( 1.0, 0.5 );
	if ( bLanternRetreat )
		goto 'RETREAT';
	PlayWait();
	PopState();

RETREAT:
	ShadowPoint = none;
	ShadowPoint = FindNearShadowPoint();
	if ( ShadowPoint != none )
		ShadowPoint.Using( self );

GOTOACT:
	if ( CloseToPoint( ShadowPoint.Location, 2.0 ) )
	{
		PlayAnim( 'idle_disappear' );
		goto 'END';
	}
	if ( actorReachable( ShadowPoint ) )
	{
		PlayRun();
		MoveTo( GetGotoPoint( GetEnRoutePoint( ShadowPoint.Location, -50.0 ) ), FullSpeedScale );
		goto 'ATPOINT';
	}
	else
	{
		OrderObject = ShadowPoint;
		PathObject = PathTowardOrder();
		if ( PathObject != none )
		{
			// can path to OrderObject
			PlayRun();
			MoveToward( PathObject, FullSpeedScale );
			goto 'GOTOACT';
		}
	}

ATPOINT:
	PlayAnim( 'idle_disappear' );
	MoveToward( ShadowPoint, FullSpeedScale * 0.60 );

INSHADOW:
	FinishAnim();

	ShadowPoint = FindHidingPoint();
	if ( ShadowPoint != none )
	{
		ShadowPoint.Using( self );
		ShadowMorphTo( ShadowPoint.Location );
	}

	PlayShadowed();
	PopState();

END:
} // state AIAvoidLantern


//****************************************************************************
// AIShadowMorph
// Teleport to ambush shadow point.
//****************************************************************************
state AIShadowMorph
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function LanternBump( actor Other ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		Mass = 2000;
		ShadowImportance = -1.0;
	}

	function EndState()
	{
		global.BeginState();
		Mass = default.Mass;
		ShadowImportance = default.ShadowImportance;
	}

	function bool IsUsing( AeonsShadowPoint thisPoint )
	{
		if ( ShadowPoint == thisPoint )
			return true;
		else
			return false;
	}

	function Shade()
	{
		DiffuseEffector.SetFade( ShadedColor, 0.50 );
	}

	function DisappearFade()
	{
		OpacityEffector.SetFade( FadedOpacity, 0.45 );
	}

	// *** new (state only) functions ***
	function InShadow()
	{
		StopMovement();
		GotoState( , 'INSHADOW' );
	}


BEGIN:
	WaitForLanding();

ATPOINT:
	PlayAnim( 'idle_disappear' );

INSHADOW:
	FinishAnim();

	ShadowPoint = FindAmbushPoint();
	if ( ShadowPoint != none )
	{
		ShadowPoint.Using( self );
		ShadowMorphTo( ShadowPoint.Location );
	}
//	else
//		DebugInfoMessage( " FindAmbushPoint() found NONE" );

	PlayAnim( 'idle_appear_start',,,, 0.0 );
	FinishAnim();
	PlayAnim( 'idle_appear_end' );
	FinishAnim();
	PopState();

END:
} // state AIShadowMorph


//****************************************************************************
// AIShadowAppear
// Play appear animation at current location.
//****************************************************************************
state AIShadowAppear
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function LanternBump( actor Other ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		Mass = 2000;
		ShadowImportance = -1.0;
	}

	function EndState()
	{
		global.BeginState();
		Mass = default.Mass;
		ShadowImportance = default.ShadowImportance;
	}

	function Shade()
	{
		DiffuseEffector.SetFade( ShadedColor, 0.50 );
	}

	function DisappearFade()
	{
		OpacityEffector.SetFade( FadedOpacity, 0.45 );
	}


BEGIN:
	OpacityEffector.SetFade( FadedOpacity, 0.0 );
	WaitForLanding();
	PlayAnim( 'idle_appear_start',,,, 0.0 );
	Sleep( 0.01 );
	bHidden = false;
	FinishAnim();
	PlayAnim( 'idle_appear_end' );
	FinishAnim();
	PopState();

END:
} // state AIShadowAppear


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***
	function LanternBump( actor Other ){}

	// *** overridden functions ***
	// Do this after the animation has finished.
	function PostAnim()
	{
		// Spawn( class'SmokyExplosionFX',,, Location );
		Destroy();
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
//		TargetActor = SK_TargetPawn;
//		GotoState( 'AIDance', 'DANCE' );
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
	}

	function StartSequence()
	{
		GotoState( , 'SCARROWSTART' );
	}

	// *** new (state only) functions ***
	function SetSynchLocation( pawn P )
	{
		local vector	X, Y, Z;
		local vector	NewLoc;

		GetAxes( P.Rotation, X, Y, Z );
		NewLoc = GetGotoPoint( P.Location + ( SK_SyncOffset.X * X ) + ( SK_SyncOffset.Y * Y ) + ( SK_SyncOffset.Z * Z ) );
		SetLocation( NewLoc );
		DesiredRotation = rotator(X);
		SetRotation( DesiredRotation );
	}


SCARROWSTART:
	ShadowImportance = -1.0;
	SetCollision( false, false, false );
	DebugDistance( "before anim" );
	PlayAnim( 'idle_disappear' );
	FinishAnim();
	SetSynchLocation( SK_TargetPawn );
	SK_TargetPawn.PlayAnim( 'scarrow_death', [TweenTime] 0.0  );
	PlayAnim( 'death_creature_special', [TweenTime] 0.0  );
	FinishAnim();
	PostSpecialKill();
	Sleep( 0.5 );
	PlaySound_P( "Taunt PVar=0.25 V=1.5 VVar=0.1" );

} // state AISpecialKill


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     ShadedColor=(R=10,G=10,B=10,A=10)
     NormalColor=(R=255,G=255,B=255,A=255)
     ReachableRange=850
     FadedOpacity=0.25
     SK_SyncOffset=(X=-30,Y=-5)
     DispelLevel=1
     LongRangeDistance=1200
     JumpDownDistance=80
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=25,EffectStrength=0.35,Method=RipSlice)
     WeaponAccuracy=0.5
     ForfeitPursuit=0.2
     DamageRadius=95
     bTakeHeadShot=True
     WeaponAttackFOV=0.866025
     SK_PlayerOffset=(X=150)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.6
     WalkSpeedScale=0.75
     bGiveScytheHealth=True
     PhysicalScalar=0.25
     FireScalar=0
     ConcussiveScalar=0
     bCanStrafe=True
     MeleeRange=70
     GroundSpeed=125
     AccelRate=1000
     MaxStepHeight=35
     SightRadius=1500
     BaseEyeHeight=50
     Health=60
     SoundSet=Class'Aeons.ScarrowSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.Scarrow_m'
     CollisionRadius=60
     CollisionHeight=60
}
