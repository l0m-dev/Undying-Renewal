//=============================================================================
// Handmaiden.
//=============================================================================
class Handmaiden expands ScriptedFlyer;
#exec MESH IMPORT MESH=Handmaiden_m SKELFILE=Handmaiden.ngf INHERIT=ScriptedBiped_m
#exec MESH JOINTNAME Neck=Head

#exec MESH NOTIFY SEQ=Attack_Lightning_Start TIME=0.99 FUNCTION=StartLightningAttack

//#exec MESH NOTIFY SEQ=taunt_end TIME=0.99 FUNCTION=EndRecharge

#exec MESH NOTIFY SEQ=Defense_Spell TIME=0.800 FUNCTION=CastVortex

//#exec MESH NOTIFY SEQ=Special_Kill_Start TIME=0.99 FUNCTION=Special_Kill_Cycle
//#exec MESH NOTIFY SEQ=Special_Kill_Cycle TIME=0.99 FUNCTION=Special_Kill_End
//#exec MESH NOTIFY SEQ=Special_Kill_End TIME=0.99 FUNCTION=FinishSpecialKill
#exec MESH NOTIFY SEQ=special_kill TIME=0.780 FUNCTION=DropPlayer


#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.0111111 FUNCTION=PlaySound_N ARG="Idle CHANCE=0.2 PVar=0.2 V=0.75 VVar=0.1"
#exec MESH NOTIFY SEQ=Special_Kill TIME=0.043 FUNCTION=PlaySound_N ARG="SKillStart V=1.25"
#exec MESH NOTIFY SEQ=Special_Kill TIME=0.457 FUNCTION=PlaySound_N ARG="SKillCycle V=1.25"
#exec MESH NOTIFY SEQ=Special_Kill TIME=0.770 FUNCTION=PlaySound_N ARG="PatDeath"
#exec MESH NOTIFY SEQ=Special_Kill TIME=0.776 FUNCTION=PlaySound_N ARG="SKillEnd V=1.25"
#exec MESH NOTIFY SEQ=Taunt_Start TIME=0.0714286 FUNCTION=PlaySound_N ARG="TauntStart PVar=0.1 V=1.25 VVar=0.1"
#exec MESH NOTIFY SEQ=Taunt_Cycle TIME=0.0166667 FUNCTION=PlaySound_N ARG="TauntCycle PVar=0.1 V=1.25 VVar=0.1"
#exec MESH NOTIFY SEQ=Taunt_End TIME=0.0277778 FUNCTION=PlaySound_N ARG="TauntEnd PVar=0.1 V=1.25 VVar=0.1"

var(AICombat) float		LightningDuration;
var(AICombat) float		LightningRange;
var(AICombat) float		RechargeDuration;
var(AICombat) float		VortexRecastTimer;
var(AICombat) float		VortexTimer;

var float						PWDeathTimer;		//
var savable float				VortexRecastTime;
var savable bool				VortexActive;

var savable SPRechargeBolt		RechargeBolt;

var Bethany					pBethany;
var AeonsHomeBase 			Home;

function PreBeginPlay()
{
	super.PreBeginPlay();
	SetLimbTangible( 'tenticle1', false );
	SetLimbTangible( 'tenticle2', false );
	SetLimbTangible( 'tenticle3', false );
	SetLimbTangible( 'tenticle4', false );
	SetLimbTangible( 'tenticle5', false );
	SetLimbTangible( 'tenticle6', false );
}

function PostBeginPlay()
{
	local float BestDist;
	local AeonsHomeBase aHome;

	super.PostBeginPlay();

	UpdateBethany();

	BestDist = 0.0;
	Home = none;
	foreach AllActors( class'AeonsHomeBase', aHome )
	{
		if( (Home == none) || (VSize(aHome.Location - Location) < BestDist) )
		{
			BestDist = VSize(aHome.Location - Location);
			Home = aHome;
		}
	}
}

function bool AcknowledgeDamageFrom( pawn Instigator )
{
	DebugInfoMessage( ".AcknowledgeDamageFrom() Instigator is a " $ Instigator.class.name );
	if( Instigator.IsA( 'Bethany' ) ||
		Instigator.IsA( 'Handmaiden' ) ||
		Instigator.IsA( 'BethanyFlickeringStalker' ) ||
		Instigator.IsA( 'BethanyMonto' ) )
	{
		DebugInfoMessage(".AcknowledgeDamageFrom() Ignoring damage.");
		return false;
	}
	else
		super.AcknowledgeDamageFrom( Instigator );
}

function ReactToDamage( pawn Instigator, DamageInfo DInfo )
{
	DebugInfoMessage( ".ReactToDamage() Instigator is a " $ Instigator.class.name );
	if( Instigator.IsA( 'Bethany' ) ||
		Instigator.IsA( 'Handmaiden' ) ||
		Instigator.IsA( 'BethanyFlickeringStalker' ) ||
		Instigator.IsA( 'BethanyMonto' ) )
	{
		DebugInfoMessage(".ReactToDamage() Ignoring damage.");
		return;
	}
	else
		super.ReactToDamage( Instigator, DInfo );
}

function bool PlayDamage( DamageInfo DInfo )
{
	return PlayAnim( 'damage_stun' );
}

function TookDamage( actor Other )
{
	if( Other.IsA( 'Bethany' ) ||
		Other.IsA( 'Handmaiden' ) ||
		Other.IsA( 'BethanyFlickeringStalker' ) ||
		Other.IsA( 'BethanyMonto' ) )
		return;
	else
		super.TookDamage( Other );
}

function UpdateBethany()
{
	local Bethany aBethany;

	if( pBethany == none )
	{
		foreach AllActors( class'Bethany', aBethany ) { pBethany = aBethany; }

		DebugInfoMessage( ".UpdateBethany() found Bethany named " $ pBethany.name $ "." );
	}
}

function CleanUp()
{

	if( RechargeBolt != none )
	{
		RechargeBolt.Destroy();
		RechargeBolt = none;
	}
}

function PlayLocomotion( vector dVector )
{
//	if( VSize( dVector ) < 0.01 )
		LoopAnim( 'Flight_Cycle', 1.0 );
//	else
//		LoopAnim( 'Fly_Forward', 1.0 );
}

function PlayExplosionDeath( vector HitLocation )
{
	local vector	DVect;

	DVect = Location - HitLocation;
//	DVect.Z = 1000.0;
	DVect.Z = FMax( DVect.Z, 10.0 );
	AddVelocity( Normal(DVect) * 500.0 );
	DebugInfoMessage( ".PlayExplosionDeath(), velocity is " $ Velocity $ ", Physics is " $ Physics );
	if ( Rand(2) == 0 )
		PlayAnim( 'death_explosion_front',, MOVE_None );
	else
		PlayAnim( 'death_explosion_left',, MOVE_None );
}

// Play death animation, based on damage type.
function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	local vector	TraceLocation, HitNormal, End;
	local int		HitJoint;

	DebugInfoMessage( ".PlayDying(), damage name is " $ damage $ ", delta to HitLocation is " $ (HitLocation - Location) );
	// Determine damage type (based on "damage" parameter) and trigger appropriate animation.
	switch ( damage )
	{
		case 'fire':
		case 'electrical':
			PlayAnim( 'death_lightning' );
			break;
		case 'chargedspear':
			PlayAnim( 'death_chargedspear' );
			break;
		case 'ectoplasm':
			PlayAnim( 'death_ectoplasm' );
			break;
		case 'dyn_concussive':
		case 'skull_concussive':
		case 'sigil_concussive':
		case 'lbg_concussive':
		case 'phx_concussive':
			PlayExplosionDeath( HitLocation );
			break;
		case 'powerword':
			bNoBloodPool = true;
			PWDeathTimer = 2.0;
			PlayAnim( 'death_powerword_start' );
			break;
/*		case 'spear':
			Trace(TraceLocation, HitNormal, HitJoint, HitLocation, HitLocation + Normal(DInfo.ImpactForce) * 512, false);
			if (TraceLocation != vect(0,0,0))
			{
				SetPhysics(PHYS_Falling);
				Velocity = (Normal(DInfo.ImpactForce) + vect(0,0,0.35)) * 1024;
			} else {
				switch ( Rand(4) )
				{
					case 0:
						PlayAnim( 'death_gun_backhead' );
						break;
					case 1:
						PlayAnim( 'death_gun_back' );
						break;
					case 2:
						PlayAnim( 'death_gun_left' );
						break;
					case 3:
						PlayAnim( 'death_lightning' );
						break;
				}
			}
			break;
		*/
		case 'scythe':
		case 'scythedouble':
		case 'bullet':
		case 'pellet':
		case 'silverbullet':
		case 'sphereofcold':
		case 'chargedsphereofcold':
		case 'creepingrot':
		default:
			bGroundMesh = true;
			switch ( Rand(4) )
			{
				case 0:
					PlayAnim( 'death_gun_backhead' );
					break;
				case 1:
					PlayAnim( 'death_gun_back' );
					break;
				case 2:
					PlayAnim( 'death_gun_left' );
					break;
				case 3:
					PlayAnim( 'death_lightning' );
					break;
			}
	}
}

function CommMessage( actor sender, string message, int param )
{
	UpdateBethany();

	DebugInfoMessage( ".CommMessage(), got message " $ message $ "(" $ param $ ") from " $ sender.name $ ", Bethany = " $ pBethany.name );

	if( (Bethany( sender ) == pBethany) && (message == "weakened") )
	{
		PushState( GetStateName(), 'Resume' );
		GotoState( 'AICastRecharge' );
	}
	else if( (Bethany( sender ) == pBethany) && (message == "recharged") )
	{
		if( RechargeBolt != none )
		{
			RechargeBolt.GotoState( 'Release' );
		}
		DebugInfoMessage( " ending recharge." );
		PlayAnim( 'taunt_end' );
	}
	else
		super.CommMessage( sender, message, param );
}

/*
function InkCloud()
{
	local vector x, y, z;
	
	DebugInfoMessage( ".InkCloud() called." );
	GetAxes(ViewRotation, x, y, z);
	
	spawn(class 'GhelzRingFX',self,,Location + 100*x,rot(0,0,0));
}
	
function InkCloudDone()
{
	DebugInfoMessage( ".InkCloudDone() called." );
	GotoState( 'AIAvoidEnemy' );
}
*/

function vector LightningStartPoint()
{
	return JointPlace( 'R_Wrist' ).pos + 50.0 * Vector(Rotation);
}

function vector LightningEndPoint( vector LightningStart )
{
	if( Enemy != none )
	{
		return LightningStart + LightningRange * Vector( WeaponAimAt( Enemy, LightningStart, WeaponAccuracy ) );
	}
	else
	{
		return LightningStart + LightningRange * Vector( Rotation );
	}
}

function vector RechargeStartPoint()
{
	return 0.5 * (JointPlace( 'R_Wrist' ).pos + JointPlace( 'L_Wrist' ).pos);
}

function vector RechargeEndPoint( vector LightningStart )
{
	if( pBethany != none )
	{
		return pBethany.Location;
	}
	else
	{
		return LightningStart + LightningRange * Vector( Rotation );
	}
}

function Tick( float deltaTime )
{
	local vector LightningStart;

	super.Tick( deltaTime );

	if( RechargeBolt != none )
	{
		if( RechargeBolt.Shaft != none )
		{
			LightningStart = RechargeStartPoint();

			RechargeBolt.Update( deltaTime, LightningStart, RechargeEndPoint( LightningStart ) );
		}
		else
		{
			RechargeBolt.Destroy();
			RechargeBolt = none;
			EndRecharge();
		}
	}

	if( VortexRecastTime > 0.0 )
	{
		VortexRecastTime -= deltaTime;
	}

	if( (Home != none) && 
		(Health > 0) &&
		(VSize( Home.Location - Location ) > Home.extent ) && 
		(StateIndex == 0) &&
		(GetStateName() != 'AIRetreat') &&
		(FRand() < deltaTime) )
	{
		RetreatPoint = Home;
		PushState( 'AIRetreat', 'BEGIN' );
		GotoState( 'AIQuickTaunt' );
	}
}

function StartLightningAttack()
{
	local vector LightningStart;
	local Rotator Dir;
	local LtngBlast_proj SP;

	LightningStart = LightningStartPoint();

	Dir = Rotator(Normal(LightningEndPoint(LightningStart) - LightningStart));

	SP = Spawn(Class 'LtngBlast_proj', self,, LightningStart, Dir);
	SP.CastingLevel = 1;
	SP.StartLoc = LightningStart;
	SP.Charge = 1;
	SP.Range = LightningRange;
	PlaySound_P( "CastLightning" );
}

state AICastLightning
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Bump( actor Other ){}
	function SpellCastNotify( name SpellName, pawn Caster ) {}

Begin:
	TurnToward( Enemy, 0.0 );
	PlayAnim( 'Attack_Lightning_Start' );
	FinishAnim();
	PlayAnim( 'Attack_Lightning_End' );
	FinishAnim();
Resume:
Damaged:
Dodged:
	PopState();
}

function StartRecharge()
{
	local vector LightningStart;

	DebugInfoMessage( ".StartRecharge() called." );
	LightningStart = RechargeStartPoint();

	RechargeBolt = spawn( class 'SPRechargeBolt', self,, Location, Rotation );
	RechargeBolt.Init( RechargeDuration, LightningStart, RechargeEndPoint(LightningStart) );
	LoopAnim( 'taunt_cycle' );
	
	SendClassComm( class'Bethany', "recharging", 0 );
}

function EndRecharge()
{
	DebugInfoMessage( ".EndRecharge() called." );
	if( !PopState() )
	{
		GotoState( 'AIAttackPlayer' );
	}
}

state AICastRecharge
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Bump( actor Other ){}
	function SpellCastNotify( name SpellName, pawn Caster ) {}
	function WeaponFireNotify( name WeaponName, Pawn Attacker ) {}
	function Killed( pawn Killer, pawn Other, name damageType )
	{
		if( Other == pBethany )
		{
			CleanUp();
			EndRecharge();
		}
		super.Killed( Killer, Other, damageType );
	}

	function BeginState()
	{
		if( pBethany == none )
			EndRecharge();
		else
			super.BeginState();
	}

Begin:
Damaged:
Resume:
	StopMovement();
	PlayWait();
	TurnToward( pBethany, 0.0 );
	PlayAnim( 'taunt_start', 5.0 );
	FinishAnim();
	StartRecharge();

Holding:
	Sleep( 0.05 );
	TurnToward( pBethany, 0.0 );
	goto 'Holding';
}


function WeaponFireNotify( name WeaponName, Pawn Attacker )
{
	// Will cast Shala's Vortex or Dispel as appropriate (or nothing).
	if( (Health > 0) && CanCastVortex() && 
		(WeaponName == 'speargun') ) // might be charged.
	{	// cast Vortex.
		PushState( GetStateName(), 'RESUME' );
		GotoState( 'AICastShalasVortex' );
	}
}

function SpellCastNotify( name SpellName, pawn Caster )
{
	// Will cast Shala's Vortex or Dispel as appropriate (or nothing).
	if( (Health > 0) && CanCastVortex() && 
		((SpellName == 'Lightning') ||
		 (SpellName == 'Ectoplasm')) )
	{	// cast Vortex.
		PushState( GetStateName(), 'RESUME' );
		GotoState( 'AICastShalasVortex' );
	}
}

function bool CanCastVortex()
{
	if( VortexRecastTime <= 0.0 )
		return true;
	return false;
}

function CastVortex()
{
	if( !VortexActive )
	{
		PlaySound_P( "CastShalas" );
		AddVortexParticles();
		VortexActive = true;
	}
}

function AddVortexParticles()
{
	local int i;
	local Actor A;
	local place P;

	for (i=0; i<NumJoints(); i++)
	{
		P = JointPlace( JointName(i) );
		A = Spawn(class 'MandorlaParticleFX', self,, P.pos);
		A.SetBase(self, JointName(i));
	}
}

function RemoveVortexParticles()
{
	local Actor A;
	
	ForEach AllActors(class 'Actor', A)
		if ( A.Owner == self )
			if ( A.IsA('MandorlaParticleFX') )
				ParticleFX(A).bShuttingDown = true;
}

function DestroyVortex()
{
	RemoveVortexParticles();
	VortexRecastTime = VortexRecastTimer;
	VortexActive = false;
}
	
function VortexAdjustDamage( out DamageInfo DInfo )
{
	if( VortexActive && DInfo.bMagical )
		DInfo.Damage = 0;
}

state AICastShalasVortex
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Bump( actor Other ){}
	function SpellCastNotify( name SpellName, pawn Caster ){}

	function Timer()
	{
		DestroyVortex();
		PopState();
	}

	function AdjustDamage( out DamageInfo DInfo )
	{
		VortexAdjustDamage( DInfo );

		global.AdjustDamage( DInfo );
	}

Resume:
Damaged:
Dodged:
	DestroyVortex();
	PopState();

Begin:
//	TurnToward( Enemy );
	PlayAnim( 'Defense_Spell', 1.0 );
	FinishAnim();
	SetTimer( VortexTimer, false );
	PlayWait();
}

/*
state AIInkCloudEscape
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Bump( actor Other ){}

Begin:
	TurnToward( Enemy );
	PlayAnim( 'defense_spell', 1.0 );
}
*/

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
		local float dist;

		DebugInfoMessage( ".AIAttack.Dispatch(), DefCon is " $ DefCon $ ", Health=" $ Health);
		dist = DistanceTo( Enemy );
		
/*
		if ( dist < 1.25*MeleeRange )
		{
			// Push back enemy.
			DebugInfoMessage( ".AIAttack.Dispatch(), Dist is < 1.25*MeleeRange" );
			GotoState( 'AIInkCloudEscape' );
		}
		else 
*/
		if ( dist < SafeDistance )
		{
			DebugInfoMessage( ".AIAttack.Dispatch(), Dist is < SafeDistance" );
			GotoState( 'AIAvoidEnemy' );
		}
		else if ( ( ScriptedPawn(Enemy) == none ) &&
			 ( VisionEffector.GetSensorLevel() < 0.75 ) &&
			 ( HearingEffector.GetSensorLevel() < 0.10 ) )
		{
			// Lost enemy.
			DebugInfoMessage( ".AIAttack, lost enemy." );
			GotoInitState();
		}
		else
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
	/*** overridden functions ***/

	function BeginState()
	{
		super.BeginState();
		
		UpdateBethany();
	}

	// Check if point is (still, while pathing) a good avoidance point.
	function bool GoodAvoidPoint( NavigationPoint cPoint )
	{
		if( (Home != none) && (VSize( cPoint.Location - Home.Location ) > 0.75*Home.extent) )
			return false;
		if ( VSize( cPoint.Location - Enemy.Location ) < (1.2 * SafeDistance) )
			return false;
		if ( cPoint.Location.Z < (Enemy.Location.Z - 4*CollisionHeight) )
			return false;
		if ( (pBethany != none ) && !FastTrace( Location, pBethany.Location ) )
			return false;
		return true;
	}
}

//****************************************************************************
// AIRetreat
// retreat from Enemy, pick a retreat point and seek it
//****************************************************************************
state AIRetreat
{
	function bool GoodCoverPoint( AeonsCoverPoint cPoint )
	{
		if( cPoint == Home )
			return true;
		else
			return super.GoodCoverPoint( cPoint );
	}

	function bool SafeRetreatPoint( AeonsCoverPoint cPoint )
	{
		if( cPoint == Home )
			return true;
		else
			return super.SafeRetreatPoint( cPoint );
	}
}

//****************************************************************************
// AIFarAttack
// attack far enemy
//****************************************************************************
state AIFarAttack
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
	}

	function EndState()
	{
		DebugEndState();
	}

	function EnemyNotVisible()
	{
		if ( FRand() < 0.5 )
		{
			if ( bCanFly )
				TargetPoint = LastSeenPos;
			else
				TargetPoint = GetGotoPoint( LastSeenPos );
			GotoState( 'AIChargePoint' );
		}
	}

	// *** new (state only) functions ***
	// (re)evaluate attack strategy
	function Evaluate()
	{
		if ( !DoFarAttack() )
			GotoState( 'AIAttack' );
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:
	GotoState( 'AIAttack' );

// Default entry point
BEGIN:
	StopMovement();

MOVED:
	TurnTo( EnemyAimSpot(), 30 * DEGREES );
	PlayWait();
	if ( ClearShot( Location, EnemyAimSpot() ) == none )
	{
		PushState( GetStateName(), 'FIRED' );
		GotoState( 'AICastLightning' );
	}
	else
	{
		PushState( GetStateName(), 'MOVED' );
		GotoState( 'AIRepositionAttack' );
	}

FIRED:
	PlayWait();
	Evaluate();
	goto 'BEGIN';
} // state AIFarAttack


//****************************************************************************
// AIQuickTaunt
// Turret toward enemy and play taunt, then return
//****************************************************************************
state AIQuickTaunt
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorHearNoise( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function LookTargetNotify( actor Sender, float Duration ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		DebugEndState();
		PopLookAt();
	}

	// *** new (state only) functions ***

// Entry point when returning from AITakeDamage
DAMAGED:
	PopState( , 'DAMAGED' );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	StopMovement();
	PlayWait();
	WaitForLanding();

	if ( Enemy != none )
		TurnToward( Enemy, 15 * DEGREES );

	PlayAnim( 'taunt_start' );
	FinishAnim();
	PlayAnim( 'taunt_cycle' );
	FinishAnim();
	PlayAnim( 'taunt_end' );
	FinishAnim();

	PopState();

AWAKEN:
	PopState();
} // state AIQuickTaunt

//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***
	function CommMessage( actor sender, string message, int param ) {}

	function PostSpecialKill()
	{
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
		GotoState( 'AIWait' );
	}

	function StartSequence()
	{
		GotoState( , 'MAIDENSTART' );
	}

	// *** new (state only) functions ***
	function DropPlayer()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		if ( SK_TargetPawn.IsA('PlayerPawn') )
			PlayerPawn(SK_TargetPawn).Weapon.ThirdPersonMesh = none;

		DVect = SK_TargetPawn.JointPlace('pelvis').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'pelvis', 'root');

		Spawn( class'Gibs',,, SK_TargetPawn.Location, rotator(vect(0,0,100)) );
		SK_TargetPawn.DestroyLimb( 'spine1' );
		SK_TargetPawn.PlayAnim( 'death_gun_backhead' );
	}


MAIDENSTART:
	NoLook();
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'handmaiden_death', [TweenTime] 0.0  );
	PlayAnim( 'special_kill', [TweenTime] 0.0  );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function CommMessage( actor sender, string message, int param ) {}
	function Tick( float DeltaTime )
	{
		if ( PWDeathTimer > 0.0 )
		{
			PWDeathTimer -= DeltaTime;
			if ( PWDeathTimer <= 0.0 )
				PlayAnim( 'death_powerword_end' );
		}
		super.Tick( DeltaTime );
	}

	function BeginState()
	{
		super.BeginState();
		SetPhysics( PHYS_Falling );
		Cleanup();
	}

	function bool CanBeInvoked()
	{
		return false;
	}

	// *** new (state only) functions ***

} // state Dying

defaultproperties
{
     LightningDuration=2
     LightningRange=2048
     RechargeDuration=2
     VortexRecastTimer=3.5
     VortexTimer=0.5
     HoverAltitude=100
     HoverVariance=30
     SafeDistance=500
     LongRangeDistance=3000
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=30,Method=RipSlice)
     MeleeInfo(1)=(Damage=60,Method=RipSlice)
     WeaponJoint=L_Wrist
     WeaponAccuracy=0.95
     bNoAdvance=True
     SK_PlayerOffset=(X=85,Z=20)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.6
     WalkSpeedScale=0.55
     bGiveScytheHealth=True
     PhysicalScalar=0.5
     FireScalar=0.75
     bCanStrafe=True
     bCanFly=True
     MeleeRange=100
     GroundSpeed=300
     AirSpeed=600
     AccelRate=1200
     Alertness=1
     SightRadius=9000
     BaseEyeHeight=52
     Health=160
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.HandmaidenSoundSet'
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Handmaiden_m'
     CollisionHeight=57
     bGroundMesh=False
}
