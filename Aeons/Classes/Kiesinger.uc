//=============================================================================
// Kiesinger.
//=============================================================================
class Kiesinger expands ScriptedFlyer;
//#exec MESH IMPORT MESH=Kiesinger_m SKELFILE=Kiesinger.ngf INHERIT=ScriptedBiped_m
//#exec MESH JOINTNAME Neck=Head
//#exec MESH MODIFIERS Skirt1:ClothCollide Cape1:ClothingBack LSleeve1:Cloth RSleeve1:Cloth

//#exec MESH NOTIFY SEQ=Attack_Chest TIME=0.200 FUNCTION=PushBack		//
//#exec MESH NOTIFY SEQ=Attack_Chest TIME=0.9500 FUNCTION=PushBackDone
//#exec MESH NOTIFY SEQ=Attack_Chest TIME=0.2 FUNCTION=CastShield

//#exec MESH NOTIFY SEQ=defense_spell TIME=0.800 FUNCTION=CastDefenseSpell
//#exec MESH NOTIFY SEQ=attack_dispell TIME=0.9500 FUNCTION=CastDispel

//#exec MESH NOTIFY SEQ=attack_spell TIME=0.1000 FUNCTION=WarnEnemyOfAttack
//#exec MESH NOTIFY SEQ=attack_spell TIME=0.9500 FUNCTION=CastAttackSpell

//#exec MESH NOTIFY SEQ=attack_traditional TIME=0.585 FUNCTION=CastLightning

//#exec MESH NOTIFY SEQ=Lightning_Fingers TIME=0.25 FUNCTION=SummonSkull
//#exec MESH NOTIFY SEQ=Lightning_Fingers TIME=0.50 FUNCTION=SummonSkull
//#exec MESH NOTIFY SEQ=Lightning_Fingers TIME=0.75 FUNCTION=SummonSkull

//#exec MESH NOTIFY SEQ=attack_chest TIME=0.147 FUNCTION=PlaySound_N ARG="ForceBlast"
//#exec MESH NOTIFY SEQ=attack_chest TIME=0.235294 FUNCTION=C_FS
//#exec MESH NOTIFY SEQ=attack_chest TIME=0.941176 FUNCTION=C_FootScuff
//#exec MESH NOTIFY SEQ=attack_traditional TIME=0.000 FUNCTION=PlaySound_N ARG="LightBuild"
//#exec MESH NOTIFY SEQ=attack_traditional TIME=0.47619 FUNCTION=C_FS
//#exec MESH NOTIFY SEQ=attack_traditional TIME=0.833333 FUNCTION=C_FootScuff
//#exec MESH NOTIFY SEQ=attack_dispell TIME=0.2 FUNCTION=C_FS
//#exec MESH NOTIFY SEQ=attack_dispell TIME=0.925 FUNCTION=C_FootScuff
//#exec MESH NOTIFY SEQ=kill_suck TIME=0.000 FUNCTION=PlaySound_N ARG="Suck"
//#exec MESH NOTIFY SEQ=kill_suck TIME=0.670 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=kill_suck TIME=0.141304 FUNCTION=C_FS
//#exec MESH NOTIFY SEQ=kill_suck TIME=0.793478 FUNCTION=C_FootScuff
//#exec MESH NOTIFY SEQ=laugh TIME=0.170 FUNCTION=PlaySound_N ARG="Laugh"

// Head only mesh
//#exec MESH IMPORT MESH=KiesingerHead_m SKELFILE=head\KiesingerHead.ngf

//****************************************************************************
// Member vars.
//****************************************************************************

enum EKeisingerState
{
	K_None,
	K_Harass,
	K_Fight,
	K_Ambush
};

enum EKeisingerDefenseSpell
{
	K_Shield,
	K_Vortex,
};

var(AICombat) float			MomentumTransfer;	// Coefficient used for "push back" attack.
var(AICombat) float			ShieldTimer;		// Time the shield stays up.
var(AICombat) float			ShieldRecastTimer;	// Minimum time between casting shield.
//var Shield3rdPerson			ShieldMesh;			// Representation of shield.
var KeisingerHalo			ShieldMesh;			// Representation of shield.
var(AICombat) float			ShieldHitPoints;	// Number of hit points the shield can absorb.
var(AICombat) float			VortexTimer;		// Time Shala's Vortex stays up.
var(AICombat) float			VortexRecastTimer;	// Minimum time between casting vortex.
var float					VortexRecastTime;
var(AICombat) float			DispelRecastTimer;	// Minimum time between casting dispels.
var float					DispelRecastTime;
var actor					LightningTarget;	// What we're trying to hit with the lightning.
var(AICombat) float			LightningDuration;	// Duration of lightning attack.
var(AICombat) float			LightningRange;		// Range of Lightning attack.
var(AICombat) float			SkullStormTimer;	// Minimum time between casting Skull Storm.
var(AICombat) float			PhoenixTimer;		// Minimum time between casting Skull Storm.
var(AICombat) name			LightningAnim;		// Animation to play when casting lightning.
var(AICombat) name			SkullStormAnim;		// Animation to play when casting Skull Storm.
var(AICombat) name			PhoenixAnim;		// Animation to play when casting Phoenix.
var(AICombat) name			DispelAnim;			// Animation to play when casting dispel.
var(AICombat) name			VortexAnim;			// Animation to play when casting Shala's Vortex.
var(AICombat) name			ShieldAnim;			// Animation to play when casting shield.
var(AICombat) name			PushBackAnim;		// Animation to play when pushing enemy back.
var() float					TransitionToFightHealth;
var() float					TransitionToAmbushHealth;
var			  name			SpellAnim;			// Animation to play when casting a spell.

var SPLightningBolt			LightningBolt;		// Lightning bolt object.

var(AI) name				FightAlarmTag;		// Tag of actor to go to when entering fight substate.
var(AI) name				AmbushAlarmTag;		// Tag of actor to go to when entering ambush substate.
var(AI) name				FightEvent;
var(AI) name				AmbushEvent;

var()	EKeisingerState		SubState;		//
var		EKeisingerDefenseSpell	DefensiveSpell;

var		Skull2_proj			Skull[3];
var		int					NumSkulls;

var		vector				LBEndPoint;

//****************************************************************************
// <Begin> Animation trigger functions.
//****************************************************************************

function CastAttackSpell()
{
	if( SubState == K_Harass )
		CastLightningBoltOfGods();
	else
		CastPhoenix();
}

function WarnEnemyOfAttack()
{
	local vector HitNormal, Start, End;
	local int HitJoint, Flags;

	if( (SubState == K_Harass) && (Enemy != none) )
	{
		Start = Enemy.Location + Enemy.Velocity * 0.5f + vect(0, 0, 500);
		End = Start + vect(0, 0, -65536);
		
		Trace( LBEndPoint, HitNormal, HitJoint, End, Start, false );
		// PlaySound???
	}
}

function PushBack()
{
	local vector x, y, z, momentum, dir;
	
	DebugInfoMessage( ".PushBack() called." );
	GetAxes(ViewRotation, x, y, z);
	
	// spawn(class 'GhelziabahrRing',self,,Location,rot(0,0,0));
	spawn(class 'GhelzRingFX',self,,Location + 100*x,rot(0,0,0));
		
	spawn(class 'PulseWind',,,Location + 100*x);

	if( Enemy != none )
	{
		dir = Enemy.Location - Location;
		if( VSize( dir ) < 2.0 * MeleeRange )
		{
			dir.Z = 0.0;
			dir = Normal(dir);
			if( (dir dot x) > 0.0 )
			{
				Enemy.SetPhysics( PHYS_Falling );
				dir.Z = 0.25;
				momentum = dir * MomentumTransfer;
				DebugInfoMessage( ".PushBack() on " $ Enemy.Name $ " momentum = " $ momentum $ "." );
				Enemy.Velocity = momentum;
			}
			else
				DebugInfoMessage( ".PushBack() not facing." );
		}
		else
			DebugInfoMessage( ".PushBack() too far away." );
	}
}
	
function PushBackDone()
{
	DebugInfoMessage( ".PushBackDone() called." );
	GotoState( 'AIAttack' );
}

function bool CanCastDispel()
{
	if( DispelRecastTime <= 0.0 )
		return true;
	return false;
}

function CastDispel()
{
/*
	local actor A;
	local int dispelCost;
	
	forEach RadiusActors(class 'Actor',A, 1280, Location)
	{
		if ( (A != self) && (A.Owner != self) && (FastTrace(Location, A.Location)) )
		{
			if ( A.Dispel(true) > -1 )
			{
				GenerateSeeker(A);
			}
		}
	}
*/
}

function GenerateSeeker(Actor A)
{
	spawn(class 'DispelSeeker_proj', A, , Location);
}

function CastShield()
{
	if( (SubState == K_None) || ((ShieldTimer <= 0.0) && (ShieldRecastTimer <= 0.0)) )
	{
//		ShieldMesh = spawn(class 'Shield3rdPerson',self,,Location + (Vector(Rotation) * 32), Rotation );
		ShieldMesh = spawn(class 'KeisingerHalo',self,, Location, Rotation);
		ShieldMesh.SetBase( self, JointName(0) );
		PlaySound_P( "ShieldUp" );
	}

	if( SubState != K_None )
	{
		ShieldRecastTimer = 0.0;
		ShieldTimer = Default.ShieldTimer;
		ShieldHitPoints = Default.ShieldHitPoints;
	}
}

function DestroyShield()
{
	ShieldMesh.Destroy();
	ShieldMesh = none;
	ShieldTimer = 0.0;
	ShieldRecastTimer = Default.ShieldRecastTimer;
	PlaySound_P( "ShieldDn" );
}

function int Dispel( optional bool bCheck )
{
	if( bCheck && (ShieldTimer > 0.0) && (ShieldHitPoints > 0.0) )
	{
		return 2;
	}

	DestroyShield();
	return 0;
}

function ShieldAdjustDamage( out DamageInfo DInfo )
{
	DInfo.Damage = Max(0, DInfo.Damage - ShieldHitPoints);
	ShieldHitPoints = ShieldHitPoints - DInfo.Damage;
	if( ShieldHitPoints <= 0 )
		DestroyShield();
	else
		PlaySound_P( "ShieldHit" );
}

function bool CanCastVortex()
{
//	if( VortexRecastTime <= 0.0 )
//		return true;
	return false;
}

function CastVortex()
{
	AddVortexParticles();

	VortexRecastTime = VortexRecastTimer;
	SetTimer( VortexTimer, false );
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
		A.SetBase(self,JointName(i), 'root');
	}
}

function RemoveVortexParticles()
{
	local Actor A;
	
	ForEach AllActors(class 'Actor', A)
		if ( A.Owner == self )
			if ( A.IsA('MandorlaParticleFX') )
				ParticleFX(A).Shutdown();
}

function DestroyVortex()
{
	RemoveVortexParticles();
}
	
function VortexAdjustDamage( out DamageInfo DInfo )
{
	if( DInfo.bMagical )
		DInfo.Damage = 0;
}


function CastDefenseSpell()
{
	if( DefensiveSpell == K_Shield )
	{
		CastShield();
	}
	else if( DefensiveSpell == K_Vortex )
	{
		CastVortex();
	}
}

function bool CanCastPhoenix()
{
	if( ((SubState == K_None) || (SubState == K_Ambush)) && PhoenixTimer <= 0.0 )
		return true;
	return false;
}

function CastPhoenix()
{
	local SPPhoenix Phoenix;
	local float SpawnDistance;

	SpawnDistance = 1.25 * (CollisionRadius + class'SPPhoenix'.Default.CollisionRadius);
	
	Phoenix = Spawn( class'SPPhoenix', self,, Location + (Vector(Rotation) * SpawnDistance), Rotation );
	Phoenix.Init( Enemy );

	PhoenixTimer = Default.PhoenixTimer;

	PlaySound_P( "PLaunch" );
}

function bool CanCastSkullStorm()
{
	if( (SubState == K_Fight) && SkullStormTimer <= 0.0 )
		return true;
	return false;
}
	
function SummonSkull()
{
	local rotator RAim;

	if( NumSkulls >= 3 )
		return;

	if ( Enemy != none )
		RAim = WeaponAimAt( Enemy, Location, WeaponAccuracy, true, class'Skull2_proj'.default.MaxSpeed );
	else
		RAim = WeaponAim( Location + vector(Owner.Rotation) * 100.0, Location, WeaponAccuracy );

	Skull[NumSkulls] = Spawn( class'Skull2_proj', self,, Location, RAim );
	Skull[NumSkulls].Tag = Name;
	Skull[NumSkulls].SetOffset(NumSkulls);

	NumSkulls++;
}

function bool CanCastLightning()
{
	return ( (SubState == K_Harass) || (SubState == K_Fight) );
}

function bool CanCastLightningBoltOfGods()
{
//	return ( SubState == K_Harass );
	return false;
}

function bool DoFarAttack()
{
	if( CanCastPhoenix() )
		return (FRand() < 0.65);
	
	if( (CanCastSkullStorm() || CanCastLightning() || CanCastLightningBoltOfGods()) && (DistanceTo(Enemy) < LongRangeDistance) )
		return (FRand() < 0.40);
}

function name ChooseAttackSpell()
{
	if( (SubState == K_Ambush) || (SubState == K_None) )
	{
		return 'AICastPhoenix';
	}
	else if( SubState == K_Fight )
	{
		if( (FRand() < 0.5) && CanCastSkullStorm() )
		{
			return 'AICastSkullStorm';
		}
		else if( CanCastLightning() )
		{
			return 'AICastLightning';
		}
	}
	else if( CanCastLightning() )
	{
		return 'AICastLightning';
	}
	else
	{
		return 'AICastNone';
	}	
}

//****************************************************************************
// Inherited functions.
//****************************************************************************

function PreBeginPlay()
{
	local float OriginalHealth, Multiplier;

	OriginalHealth = Health;
	super.PreBeginPlay();

	Multiplier = Health / OriginalHealth;

	ShieldTimer = 0.0;
	if( (Level.Game.Difficulty == 0) && (SubState == K_Ambush) )
	{
		Health *= 2.0;
	}

	if( SubState == K_Harass )
	{
		Health = Multiplier * (OriginalHealth - TransitionToFightHealth) + TransitionToFightHealth;
	}
	if( SubState == K_Fight )
	{
		Health = Multiplier * (OriginalHealth - TransitionToAmbushHealth) + TransitionToAmbushHealth;
	}
}

// Play death animation, based on damage type.
function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'die_falling' );
}

function bool PlayDamage( DamageInfo DInfo )
{
	return PlayAnim( 'damage_stun' );
}


// Calculate and adjust aim at a target Pawn.  Adjust for speed of target and projectile, if desired.
// Will factor in BaseEyeHeight to try to make a head shot.
function rotator WeaponAimAt( pawn Target, vector ProjStart, float Accuracy, optional bool bLeadTarget, optional float ProjSpeed )
{
	local vector		TLocation;

	if ( EyesCanSee( Target.Location ) )
	{
		if ( bLeadTarget )
			TLocation = Target.Location + Target.Velocity * ( VSize(Target.Location - ProjStart) / ProjSpeed );
		else
			TLocation = Target.Location;
	}
	else
		TLocation = LastSeenPos;
	TLocation = TLocation + vect(0, 0, 0.5) * Target.BaseEyeHeight;
	return WeaponAim( TLocation, ProjStart, Accuracy );
}

//
function vector LightningStartPoint()
{
	return JointPlace( 'R_Wrist' ).pos + Vector(Rotation)*16.0;
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

function Tick( float deltaTime )
{
	local vector LightningStart;

	super.Tick( deltaTime );

	if( LightningBolt != none )
	{
		if( LightningBolt.Shaft != none )
		{
			LightningStart = LightningStartPoint();

			LightningBolt.Update( deltaTime, LightningStart, LightningEndPoint( LightningStart ) );
		}
		else
		{
			LightningBolt.Destroy();
			LightningBolt = none;
			PopState();
		}
	}

	if( ShieldTimer > 0.0 )
	{
		ShieldTimer -= deltaTime;
		if( ShieldTimer <= 0.0 )
		{
			DestroyShield();
		}
	}

	if( (SubState == K_Harass) && (Health < TransitionToFightHealth) )
	{
		GotoState( 'KeisingerFight' );
	}
	if( (SubState == K_Fight) && (Health < TransitionToAmbushHealth) )
	{
		GotoState( 'KeisingerAmbush' );
	}
	
	if( SubState == K_Fight && (GetStateName() != 'AIRetreatNextStage') )
	{
		if( ShieldRecastTimer > 0.0 )
		{
			ShieldRecastTimer -= deltaTime;
			if( ShieldRecastTimer <= 0.0 )
			{
				if( GetStateName() == 'AIRetreat' )
					PushState( 'AIRetreat', 'Resume' );
				else
					PushState( 'AIAttack', 'Begin' );
				GotoState( 'AICastShield' );
			}
		}

		if( VortexRecastTime > 0.0 )
		{
			VortexRecastTime -= deltaTime;
		}

		if( DispelRecastTime > 0.0 )
		{
			DispelRecastTime -= deltaTime;
		}
	}

	if( PhoenixTimer > 0.0 )
	{
		PhoenixTimer -= deltaTime;
	}
}

function EncroachedBy( actor Other )
{
	if( Other.Owner != self )
		super.EncroachedBy( Other );
}

function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo )
{
	if( Instigator != self )
		super.TakeDamage( Instigator, HitLocation, Momentum, DInfo );
}

function AdjustDamage( out DamageInfo DInfo )
{
	if( SubState == K_None )
		DInfo.Damage = 0;

	if( ShieldTimer > 0.0 )
		ShieldAdjustDamage( DInfo );

	super.AdjustDamage( DInfo );
}

function PlayStunDamage()
{
	PlayAnim( 'takehit_chest', 1.50, MOVE_None );
}

function PlayWait()
{
	LoopAnim( 'Flight_Cycle' );
}

function PlayLocomotion( vector dVector )
{
//	if( VSize( dVector ) < 0.01 )
		LoopAnim( 'Flight_Cycle', 1.0 );
//	else
//		LoopAnim( 'Fly_Forward', 1.0 );
}

//function bool FlankEnemy( )
//{
//	return false;
//}

function PreSetMovement()
{
	super.PreSetMovement();
	bCanFly = true;
}

//
function SetMovementPhysics()
{
	SetPhysics( PHYS_Flying );
}

function SpellCastNotify( name SpellName, pawn Caster )
{
	// Will cast Shala's Vortex or Dispel as appropriate (or nothing).
	if( CanCastVortex() && 
		((SpellName == 'Lightning') ||
		 (SpellName == 'Ectoplasm')) )
	{	// cast Vortex.
		PushState( GetStateName(), 'RESUME' );
		GotoState( 'AICastShalasVortex' );
	}
	else if ( CanCastDispel() && 
			  ((SpellName == 'Phoenix') ||
			   (SpellName == 'PowerWord')) )
	{	// cast Dispel.
		PushState( GetStateName(), 'RESUME' );
		GotoState( 'AICastDispel' );
	}
}

//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

state KeisingerFight
{
	function TriggerKeisingerFightEvent()
	{
		local actor		A;

		if ( FightEvent != '' )
			foreach AllActors( class'Actor', A, FightEvent )
				A.Trigger( self, self );
	}

	function BeginState()
	{
		Super.BeginState();
		
		TriggerKeisingerFightEvent();
		SubState = K_Fight;
		RetreatPointTag = FightAlarmTag;
		GotoState( 'AIRetreatNextStage' );
//		AlarmTag = FightAlarmTag;
//		GotoState( 'AIAlarm' );
	}	
}

state KeisingerAmbush
{
	function TriggerKeisingerAmbushEvent()
	{
		local actor		A;

		if ( AmbushEvent != '' )
			foreach AllActors( class'Actor', A, AmbushEvent )
				A.Trigger( self, self );
	}

	function BeginState()
	{
		super.BeginState();

		TriggerKeisingerAmbushEvent();
		SubState = K_Ambush;
		RetreatPointTag = AmbushAlarmTag;
		GotoState( 'AIRetreatNextStage' );
//		AlarmTag = AmbushAlarmTag;
//		GotoState( 'AIAlarm' );	// Want to retreat into the ziggurat -- so set up alarm points appropriately.
	}
}

state AIPushBackEnemy
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
	PlayAnim( PushBackAnim, 1.0 );
}

state AICastDispel
{
	// *** ignored functions ***
	function SpellCastNotify( name SpellName, pawn Caster ) {}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Bump( actor Other ){}

Begin:
Resume:
	TurnToward( Enemy );
	PlayAnim( DispelAnim, 1.0 );
	FinishAnim();

// Entry point when returning from AITakeDamage
DAMAGED:
	PopState();
}

state AICastShield
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
Resume:
	DefensiveSpell = K_Shield;
	TurnToward( Enemy );
	PlayAnim( ShieldAnim, 1.0 );
	FinishAnim();

// Entry point when returning from AITakeDamage
DAMAGED:
	PopState();
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
	function SpellCastNotify( name SpellName, pawn Caster ) {}

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

// Entry point when returning from AITakeDamage
DAMAGED:
	DestroyVortex();
	PopState();

Begin:
Resume:
	DefensiveSpell = K_Vortex;
	TurnToward( Enemy );
	PlayAnim( VortexAnim, 1.0 );
	FinishAnim();
	PlayWait();
}

state AICastPhoenix
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
Resume:
	StopMovement();
	if( Enemy == none )
		SetEnemy( FindPlayer() );
	TurnToward( Enemy );
	PlayAnim( PhoenixAnim, 1.0 );
	FinishAnim();

// Entry point when returning from AITakeDamage
DAMAGED:
	PopState();
}

function CastLightningBoltOfGods()
{
	local vector Start, End, HitLocation, HitNormal;
	local int Flags, HitJoint;
	local LightningBoltOfTheGods lbg;

	Start = LBEndPoint;
	End = Start + vect(0, 0, 65536);

	Trace( HitLocation, HitNormal, HitJoint, End, Start, false );

	DebugInfoMessage( ".CastLightningBoltOfGods() from " $ HitLocation $ " to " $ LBEndPoint $ "." );

	lbg = spawn( class'LightningBoltOfTheGods',self,, Location );
	lbg.Strike( HitLocation, Start );
}

state AICastLightningBoltOfGods
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
Resume:
	PlayAnim( 'attack_spell', 1.0 );
	FinishAnim();

DAMAGED:
	PopState();
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

	function CastLightning()
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
	}

Begin:
Resume:
	TurnToward( Enemy );
	PlayAnim( LightningAnim );
	FinishAnim();

DAMAGED:
	PopState();
}

state AICastSkullStorm
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Bump( actor Other ){}
	function SpellCastNotify( name SpellName, pawn Caster ) {}
	
	function EndState()
	{
		local int i;
		super.EndState();

		for( i = 0; i < NumSkulls; ++i )
		{
			Skull[i].Fire();
			Skull[i] = none;
		}

		NumSkulls = 0;
	}

Resume:
Begin:
	PlayAnim( SkullStormAnim, 1.0 );
	FinishAnim();

Damaged:
	PopState();
}

state AICastNone
{
	function BeginState()
	{
		DebugBeginState();
		PopState();
	}
}

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

//		if ( dist < 1.25*MeleeRange )
//		{
//			// Push back enemy.
//			DebugInfoMessage( ".AIAttack.Dispatch(), Dist is < 1.25*MeleeRange" );
//			GotoState( 'AIPushBackEnemy' );
//		}
//		else
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
		GotoState( ChooseAttackSpell() );
	}
	else
	{
		PushState( GetStateName(), 'MOVED' );
		GotoState( 'AIRepositionAttack' );
	}

FIRED:
	PlayWait();
//	Evaluate();
//	goto 'BEGIN';
	GotoState( 'AIAttack' );
} // state AIFarAttack

//****************************************************************************
// AIAvoidEnemy
// Avoid Enemy within SafeDistance, pick a retreat point and seek it
//****************************************************************************
state AIAvoidEnemy
{
	/*** overridden functions ***/

	// Check if point is (still, while pathing) a good avoidance point.
	function bool GoodAvoidPoint( NavigationPoint cPoint )
	{
		if ( VSize( cPoint.Location - Enemy.Location ) < (1.2 * SafeDistance) )
			return false;
		if ( cPoint.Location.Z < (Enemy.Location.Z - 4*CollisionHeight) )
			return false;
		return true;
	}
}

state AILost
{
	function BeginState()
	{
		GotoState( 'AIChasePlayer' );
	}
}

state AIAmbush
{
	function BeginState()
	{
		GotoState( 'AIChasePlayer' );
	}
}

state AIRetreatNextStage expands AIRetreat
{
	function TakeDamage( Pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}	

	function Timer()
	{
		Destroy();
	}

Begin:
	StopMovement();
	
	PlayAnim( 'attack_dispell' );
	FinishAnim();

	PlayWait();

	spawn( class'KeisingerFadeFX', self,, Location );
	spawn( class'KeisingerFadeSmokeFX', self,, Location );

	OpacityEffector.SetFade( 0.0, 1.0 );
	SetTimer( 1.0, false );
	
}

state AIReallyAmbush expands AIAmbush
{
	function BeginState()
	{
		DebugBeginState();
	}
}

defaultproperties
{
     MomentumTransfer=1000
     ShieldTimer=5
     ShieldRecastTimer=2
     ShieldHitPoints=50
     VortexTimer=0.5
     VortexRecastTimer=3.5
     DispelRecastTimer=0.75
     LightningDuration=2
     LightningRange=2048
     LightningAnim=Attack_Traditional
     SkullStormAnim=Lightning_Fingers
     PhoenixAnim=Attack_Spell
     DispelAnim=Attack_Dispell
     VortexAnim=Defense_Spell
     ShieldAnim=Attack_Chest
     PushBackAnim=Attack_Chest
     TransitionToFightHealth=500
     TransitionToAmbushHealth=150
     FightAlarmTag=FightPoint
     AmbushAlarmTag=AmbushPoint
     FightEvent=KeisingerFight
     AmbushEvent=KeisingerAmbush
     HoverAltitude=100
     HoverVariance=30
     SafeDistance=500
     LongRangeDistance=1000
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=30,Method=RipSlice)
     MeleeInfo(1)=(Damage=60,Method=RipSlice)
     WeaponJoint=L_Wrist
     WeaponAccuracy=0.95
     bNoAdvance=True
     OrderState=AIHuntPlayer
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.6
     WalkSpeedScale=0.55
     PhysicalScalar=0.5
     FireScalar=0.5
     bCanStrafe=True
     bCanFly=True
     MeleeRange=100
     GroundSpeed=300
     Alertness=1
     SightRadius=9000
     BaseEyeHeight=52
     Health=600
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.KiesingerSoundSet'
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.Kiesinger_m'
     TransientSoundRadius=1500
     CollisionHeight=57
     Mass=2000
     MenuName="Keisinger"
     CreatureDeathVerb="eldritched"
}
