//=============================================================================
// Lizbeth.
//=============================================================================
class Lizbeth expands ScriptedBiped;

//#exec MESH IMPORT MESH=Lizbeth_m SKELFILE=Lizbeth.ngf INHERIT=ScriptedBiped_m
//#exec MESH MODIFIERS Cloth:LizbethSkirt Hair:Hair Breast:Breast

// Animation sequence notifications.
//#exec MESH NOTIFY SEQ=attack1 TIME=0.500 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack1 TIME=0.533 FUNCTION=DoNearDamage			//

//#exec MESH NOTIFY SEQ=attack2 TIME=0.500 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack2 TIME=0.533 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack2 TIME=0.567 FUNCTION=DoNearDamage			//

//#exec MESH NOTIFY SEQ=attack3 TIME=0.389 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack3 TIME=0.417 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack3 TIME=0.444 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack3 TIME=0.556 FUNCTION=DoNearDamageReset		// Second swipe
//#exec MESH NOTIFY SEQ=attack3 TIME=0.583 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack3 TIME=0.611 FUNCTION=DoNearDamage			//

//#exec MESH NOTIFY SEQ=dervish1 TIME=0.778 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish1 TIME=0.833 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish1 TIME=0.889 FUNCTION=DoNearDamage2			//

//#exec MESH NOTIFY SEQ=dervish2 TIME=0.700 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish2 TIME=0.750 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish2 TIME=0.800 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish2 TIME=0.850 FUNCTION=DoNearDamage2			//

//#exec MESH NOTIFY SEQ=dervish3 TIME=0.560 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish3 TIME=0.600 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish3 TIME=0.640 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish3 TIME=0.680 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish3 TIME=0.800 FUNCTION=DoNearDamage2Reset		//
//#exec MESH NOTIFY SEQ=dervish3 TIME=0.840 FUNCTION=DoNearDamage2			//
//#exec MESH NOTIFY SEQ=dervish3 TIME=0.880 FUNCTION=DoNearDamage2			//

//#exec MESH NOTIFY SEQ=jump_attack TIME=0.125 FUNCTION=TriggerJump		//
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.271 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.292 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.313 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.333 FUNCTION=DoNearDamage		//

//#exec MESH NOTIFY SEQ=jump_start TIME=0.286 FUNCTION=TriggerJump		//
//#exec MESH NOTIFY SEQ=jump_start TIME=1.000 FUNCTION=PlayInAir			//

//#exec MESH NOTIFY SEQ=rock_throw TIME=0.143 FUNCTION=SpawnRockRight		//
//#exec MESH NOTIFY SEQ=rock_throw TIME=0.286 FUNCTION=SpawnRockLeft		//
//#exec MESH NOTIFY SEQ=rock_throw TIME=0.629 FUNCTION=ThrowRockRight		//
//#exec MESH NOTIFY SEQ=rock_throw TIME=0.771 FUNCTION=ThrowRockLeft		//

//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.500 FUNCTION=OJDidIt
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.950 FUNCTION=OJDidItAgain

//#exec MESH NOTIFY SEQ=attack1 TIME=0.387097 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.1 V=1 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack1 TIME=0.100 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.7 PVar=0.1 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack2 TIME=0.387097 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.1 V=1 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack2 TIME=0.100 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.7 PVar=0.1 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack3 TIME=0.324324 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.1 V=1 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack3 TIME=0.100 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.7 PVar=0.1 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack3 TIME=0.486486 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.1 V=1 VVar=0.2"

//#exec MESH NOTIFY SEQ=dervish1 TIME=0.737 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.15 V=1 VVar=0.2"
//#exec MESH NOTIFY SEQ=dervish1 TIME=0.100 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.5 PVar=0.1 VVar=0.2"
//#exec MESH NOTIFY SEQ=dervish2 TIME=0.667 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.15 V=1 VVar=0.2"
//#exec MESH NOTIFY SEQ=dervish2 TIME=0.100 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.5 PVar=0.1 VVar=0.2"
//#exec MESH NOTIFY SEQ=dervish3 TIME=0.538 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.15 V=1 VVar=0.2"
//#exec MESH NOTIFY SEQ=dervish3 TIME=0.100 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.5 PVar=0.1 VVar=0.2"
//#exec MESH NOTIFY SEQ=dervish3 TIME=0.769 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.15 V=1 VVar=0.2"

//#exec MESH NOTIFY SEQ=run TIME=0.0322581 FUNCTION=C_BackLeft						//
//#exec MESH NOTIFY SEQ=run TIME=0.548387 FUNCTION=C_BackRight						//
//#exec MESH NOTIFY SEQ=death_beheading TIME=0.0543478 FUNCTION=C_BackRight			//
//#exec MESH NOTIFY SEQ=death_beheading TIME=0.326087 FUNCTION=C_BackRight			//
//#exec MESH NOTIFY SEQ=death_beheading TIME=0.576087 FUNCTION=C_BackLeft				//
//#exec MESH NOTIFY SEQ=death_beheading TIME=0.706522 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_beheading TIME=0.088 FUNCTION=PlaySound_N ARG="Scream"
//#exec MESH NOTIFY SEQ=death_beheading TIME=0.728261 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.47541 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.1 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.540984 FUNCTION=C_FS
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.639344 FUNCTION=C_FS
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.795082 FUNCTION=C_FS
//#exec MESH NOTIFY SEQ=hunt TIME=0.0 FUNCTION=C_BackLeft								//
//#exec MESH NOTIFY SEQ=hunt TIME=0.46875 FUNCTION=C_BackRight						//
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.125 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.9 PVar=0.1 VVar=0.2"
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.204082 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.1 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.122449 FUNCTION=C_BackLeft					//
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.142857 FUNCTION=C_BackRight				//
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.693878 FUNCTION=C_BackRight				//
//#exec MESH NOTIFY SEQ=jump_attack TIME=0.877551 FUNCTION=C_BackLeft					//
//#exec MESH NOTIFY SEQ=rock_throw TIME=0.600 FUNCTION=PlaySound_N ARG="VEffort CHANCE=0.7 PVar=0.1 VVar=0.2"
//#exec MESH NOTIFY SEQ=rock_throw TIME=0.138889 FUNCTION=PlaySound_N ARG="RockPU PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=rock_throw TIME=0.277778 FUNCTION=PlaySound_N ARG="RockPU PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=rock_throw TIME=0.569444 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.1 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=rock_throw TIME=0.708333 FUNCTION=PlaySound_N ARG="ClawWhsh PVar=0.1 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.163934 FUNCTION=C_BackLeft						//
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.868852 FUNCTION=C_BackLeft						//
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.131 FUNCTION=PlaySound_N ARG="Scream"
//#exec MESH NOTIFY SEQ=taunt2 TIME=0.076 FUNCTION=PlaySound_N ARG="Laugh"
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.487 FUNCTION=PlaySound_N ARG="SPKill"
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.504 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.545 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.644 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.801 FUNCTION=C_BareFS


//****************************************************************************
// Member vars.
//****************************************************************************

var 	Projectile				RockRight;			//
var 	Projectile				RockLeft;			//
var 	float					JumpAttackTime;		// Length of jump attack (in air) time.
var(AI) name					DamageThresholdState;	// State to go to when damage threshold is reached.
var(BossFight) 	float			FrenzyTimer;			// Length of time remaining in frenzy mode.
var(BossFight)	float			WeakenedTimer;
var(BossFight)	float			FrenzyGroundSpeed;
var(BossFight)  ParticleFX.FloatParams		ClawTrailWidth;
var(BossFight)	ParticleFX.FloatParams		ClawTrailLength;
var(BossFight)	ParticleFX.FloatParams		BodyTrailWidth;
var(BossFight)	ParticleFX.FloatParams		BodyTrailLength;
var(BossFight)	ParticleFX.FloatParams		GlowSize;
var(BossFight)	float			GlowAlpha;
var(BossFight)  float			FrenzyAnimSpeed;
var(AICombat)	float			RockDamage;
var(AIScript)	float			ScriptedTauntTime;
var(AIScript)	float			ScriptedTauntVariance;

var		float					ScriptedTauntTimer;
var		float					OriginalHealth;
var(BossFight)	float			MinimumHealth;
var(BossFight)	float			DamageThreshold;
var		float					HealthDelta;
var		float					FrenzyTime;
var		Weapon					LastEnemyWeapon;
var		NavigationPoint			LastSpclNavPoint;	// Last navigation point where special action was performed.

var		HasteTrailFX			LeftClawFX;
var		HasteTrailFX			RightClawFX;
var		HasteTrailFX			BodyHasteFX;
var		GlowScriptedFX			BodyGlowFX;

//****************************************************************************
//****************************************************************************
// <Begin> Animation trigger functions.
//****************************************************************************


// Basic action animation sequence trigger functions.
function PlayJumpAttack()	
{	
	DebugInfoMessage( ".PlayJumpAttack() called." );
	PlayAnim( 'jump_attack',, MOVE_None,, 0.05 );
}

function HitWall( vector hitNormal, actor hitWall, byte textureID )
{
	DebugInfoMessage( ".HitWall() called." );
}

// Play close-range attack animation.
function PlayNearAttack()
{
	local float		RandNum;

	RandNum = FRand();
	if( FrenzyTime > 0.0 )
	{
		if ( RandNum < 0.25 )
			PlayAnim( 'dervish1', FrenzyAnimSpeed );
		else if ( RandNum < 0.50 )
			PlayAnim( 'dervish2', FrenzyAnimSpeed );
		else
			PlayAnim( 'dervish3', FrenzyAnimSpeed );
	}
	else
	{
		if ( RandNum < 0.25 )
			PlayAnim( 'attack1' );
		else if ( RandNum < 0.50 )
			PlayAnim( 'attack2' );
		else
			PlayAnim( 'attack3' );
	}
}

// Play ranged attack animation.
function PlayFarAttack()
{
	PlayAnim( 'rock_throw' );
}

function bool PlayDamage( DamageInfo DInfo )
{
	return PlayAnim( 'damage_stun' );
}

// Play death animation, based on damage type.
function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	local vector	DVect;
	local int		lp;
	local actor		Blood;

	PlayAnim( 'death_beheading',, MOVE_None );

	Blood = Spawn( class'Aeons.BloodParticles', self,, JointPlace('head').pos, rotator(vect(0,0,1)) );
	Blood.SetBase( self, 'head', 'root');
	Blood.Lifespan = 10.0;
}

//
function PlayTaunt()
{
	if ( (FrenzyTime > 0.0) || Rand(2) == 0 )
		PlayAnim( 'taunt1' );
	else
		PlayAnim( 'taunt2' );
}

//****************************************************************************
//  <End>  Animation trigger functions.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// Inherited functions.
//****************************************************************************

function PreBeginPlay()
{
	super.PreBeginPlay();
	FrenzyTime = 0.0;
	Health = Health + MinimumHealth - (0.2 * Health);
	OriginalHealth = Health;
	HealthDelta = 0.2*(OriginalHealth - MinimumHealth);
	SetLimbTangible( 'cloth', false );
}

//
function PreSetMovement()
{
	super.PreSetMovement();
	JumpAttackTime = FMax( 0.0, CalcJumpAttack() );
}

function bool SpecialNavChoiceAction( NavigationPoint navPoint )
{
	if ( navPoint.IsA('AeonsNavChoicePoint') && ( navPoint != LastSpclNavPoint ) )
		return true;
	else
		return false;
}

function SpecialNavChoiceActing( NavigationPoint navPoint )
{
	LastSpclNavPoint = navPoint;
}

function bool SpecialNavTargetAction( NavChoiceTarget NavTarget )
{
	return ( FRand() < 0.10 );
}

// See whether Lizbeth wants a far (lunging swipe) attack.
function bool DoFarAttack()
{
	local float		dist;

	dist = DistanceTo( Enemy );
	if( FrenzyTime > 0.0 ) 
	{
		if( (dist > MeleeRange * 2.0 ) && (dist < MeleeRange * 3.0) )
			return true;
		else
			return false;
	}
	else if ( ( dist > ( MeleeRange * 2.0 ) ) && EyesCanSee( Enemy.Location ) && (FRand() < 0.4) )
		return true;
	else
		return false;
}


function CreatureBump( pawn aPawn )
{
	if( aPawn.Physics == PHYS_None )
		return;

	if( (HatedClass != none) && aPawn.IsA( HatedClass.name ) )
	{
		SetEnemy( aPawn );
		GotoState( 'AIAttack' );
	}
}

function SeeHatedPawn( pawn aPawn )
{
	DebugInfoMessage( ".SeeHatedPawn() called." );
	if( (aPawn != none) && (aPawn.Health <= 0) )
	{
		if( aPawn == Enemy )
			SetEnemy( none );
		return;
	}
	
	if( (Enemy != none) && (Enemy.Health <= 0) )
		SetEnemy( none );

	if( (Enemy != none) && (aPawn != none) && (DistanceTo(Enemy) < (1.1*DistanceTo(aPawn))) )
		return;

	if( (aPawn != none) && (aPawn.Enemy == none) )
		return;

	if( aPawn == Enemy )
		return;

	SetEnemy( aPawn );
	GotoState( 'AIAttack' );
}

// Sent from the VisionEffector when sensor threshold exceeded.
function EffectorSeePlayer( actor Sensed )
{
	DebugInfoMessage( ".EffectorSeePlayer() called." );
	SendTeamAIMessage( self, TM_EnemyAcquired, Sensed );
	if ( Enemy == Sensed )
		return;

	if ( ( Enemy != none ) && ( DistanceTo(Enemy) < 1.25 * DistanceTo(Sensed) ) )
		return;

	super.EffectorSeePlayer( Sensed );
}

function GotoLastState()
{
	if( LastState != '' )
		super.GotoLastState();
	else
		GotoState( 'AIChasePlayer' );
}

//****************************************************************************
// New class functions.
//****************************************************************************
// Spawn a rock in right hand.
function SpawnRockRight()
{
	RockRight = Spawn( class'LizbethProjectile', self,, JointPlace('r_wrist').pos );
	if ( RockRight != none )
	{
		RockRight.Damage = RockDamage;
		RockRight.SetBase( self, 'r_wrist' );
	}
}

// Spawn a rock in left hand.
function SpawnRockLeft()
{
	RockLeft = Spawn( class'LizbethProjectile', self,, JointPlace('l_wrist').pos );
	if ( RockLeft != none )
	{
		RockLeft.Damage = RockDamage;
		RockLeft.SetBase( self, 'l_wrist' );
	}
}

// Throw a rock.
function ThrowRock( Projectile ThisRock )
{
	if ( ThisRock != none )
	{
		ThisRock.GotoState( 'FallingState' );
		ThisRock.Velocity = vector(WeaponAimAt( Enemy, ThisRock.Location, 0.5, true, ThisRock.Speed )) * ThisRock.Speed;
		ThisRock.SetPhysics( PHYS_Falling );
		ThisRock.Enable( 'Tick' );
	}
}

// Throw the rock in right hand.
function ThrowRockRight()
{
	ThrowRock( RockRight );
	RockRight = none;
}

// Throw the rock in left hand.
function ThrowRockLeft()
{
	ThrowRock( RockLeft );
	RockLeft = none;
}

// Calculate the in-air time for the jump attack.
function float CalcJumpAttack()
{
	local float		JumpStart;
	local float		JumpDamage;

	JumpStart = GetNotifyTime( 'jump_attack', 'TriggerJump' );
	JumpDamage = GetNotifyTime( 'jump_attack', 'DoNearDamage', JumpStart );
	return GetNotifyTime( 'jump_attack' ) * ( JumpDamage - JumpStart );
}

function vector JumpBackPoint()
{
	local vector delta, dir;
	local float dist;
	local NavigationPoint aNav, bestNav;
	local float bestScore;

	if( Enemy != none )
	{
		delta = Enemy.Location - Location;
		dist = VSize( delta );
		dir = Normal( delta );

		bestScore = -0.5;
		if( dist < 1.5 * MeleeRange )
		{
			foreach RadiusActors( class'NavigationPoint', aNav, 8.0 * MeleeRange )
			{
				delta = Location - aNav.Location;
				if( VSize( delta ) > 2.0 * dist )
				{
					if( (Normal( delta ) dot dir) > bestScore )
					{
						bestNav = aNav;
						bestScore = Normal( delta ) dot dir;
					}
				}
			}

			if( bestNav != none )
				return bestNav.Location;
		}
	}

	return Location;
}
	
function bool Decapitate( optional vector Dir )
{
	return false;
}

function TakeFallDamage( float ZVel )
{
}

function AdjustDamage( out DamageInfo DInfo )
{
	super.AdjustDamage( DInfo );

	DInfo.Damage = Min( DInfo.Damage, Max( 0.0, Health - MinimumHealth ) );

	if( Health <= DamageThreshold )
	{
		if( DamageThresholdState != '' )
		{
			DebugInfoMessage( ".DamageThresholdState = " $ DamageThresholdState );
			GotoState( DamageThresholdState );
		}
	}
	if( DInfo.JointName == 'head' )
		DInfo.JointName = 'root';
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	
	if( ScriptedTauntTimer > 0.0 )
	{
		ScriptedTauntTimer -= DeltaTime;
	}
		
	if( FrenzyTime > 0.0 )
	{
		if( BodyGlowFX != none )
		{
			BodyGlowFX.Opacity += 2.0 * GlowAlpha * deltaTime;
			if( BodyGlowFX.Opacity > GlowAlpha )
				BodyGlowFX.Opacity = GlowAlpha;
		}		

		FrenzyTime -= DeltaTime;
		if( FrenzyTime <= 0.0 )
		{
			FrenzyTime = 0.0;
			GotoState( 'LizbethBossFightWeakened' );
		}
	}
	else if( (Enemy != none) && (Enemy.Weapon != LastEnemyWeapon) )
	{
		LastEnemyWeapon = Enemy.Weapon;
		DebugInfoMessage( ".Tick() enemy weapon changed to " $ Enemy.Weapon.Name $ ", class = " $ Enemy.Weapon.Class.Name );
		if( Enemy.Weapon.IsA('Scythe') )
		{
			DebugInfoMessage( ".Tick() enemy holding scythe, don't advance." );
			bNoAdvance = true;
		}
		else
		{
			DebugInfoMessage( ".Tick() advance on enemy." );
			bNoAdvance = false;
		}
	}
}

//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
//****************************************************************************
// Boss Fight States.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// LizbethBossFightStart
// Begin the boss fight.
//****************************************************************************
state LizbethBossFightStart
{
	function BeginState()
	{
		super.BeginState();
		OriginalHealth = Health;
		HealthDelta = 0.2*(OriginalHealth - MinimumHealth);
	}

Begin:
	GotoState( 'LizbethBossFightNormal' );
}

//****************************************************************************
// LizbethBossFightNormal
// "Normal" mode during boss fight.  If player is wielding scythe, will 
// 	avoid & attack with rocks.  Otherwise will close & attack with rocks &
// 	claws.
//****************************************************************************
state LizbethBossFightNormal
{
	function BeginState()
	{
		super.BeginState();
		DamageThresholdState = 'LizbethBossFightFrenzy';
		bCanStrafe = true;
	}
	
Begin:
	GotoState( 'AIAttackPlayer' );
}

//****************************************************************************
// LizbethBossFightFrenzy
// "Frenzy" mode during boss fight.  Will speed up, close and attack with
//	claws, even if player is weilding scythe.  Idea is that player will not
//	be able to execute an attack while Lizbeth is in this mode.  We may 
//	just make her invulnerable in this mode.
//****************************************************************************
state LizbethBossFightFrenzy expands AIScriptedState
{
	function BeginState()
	{
		super.BeginState();
		if( FrenzyTime <= 0.0 )
		{
		    HatedClass=Class'Aeons.DecayedSaint';
			AmbientSound = Sound'CreatureSFX.Lizbeth.C_Lizbeth_HasteLp1';

			DamageThresholdState = '';	// Don't go to any other states when damage threshold reached.
			bNoAdvance = false;
			FrenzyTime = FrenzyTimer;
			// Set 'Haste' variables.

			if( LeftClawFX == none )
				LeftClawFX = spawn( class'HasteTrailFX', self,, JointPlace('l_wrist').pos );
			if( LeftClawFX != none )
			{
				LeftClawFX.SizeWidth = ClawTrailWidth;
				LeftClawFX.SizeLength = ClawTrailLength;
				LeftClawFX.SetBase( self, 'l_wrist' );
			}
			else
				DebugInfoMessage( ".LizbethBossFightFrenzy.BeginState() couldn't spawn left claw haste effect." );
	
			if( RightClawFX == none )	
				RightClawFX = spawn( class'HasteTrailFX', self,, JointPlace('r_wrist').pos );
			if( RightClawFX != none )
			{
				RightClawFX.SizeWidth = ClawTrailWidth;
				RightClawFX.SizeLength = ClawTrailLength;
				RightClawFX.SetBase( self, 'r_wrist' );
			}
			else
				DebugInfoMessage( ".LizbethBossFightFrenzy.BeginState() couldn't spawn right claw haste effect." );
	
			if( BodyHasteFX == none )	
				BodyHasteFX = spawn( class'HasteTrailFX', self,, Location );
			if( BodyHasteFX != none )
			{
				BodyHasteFX.SizeWidth = BodyTrailWidth;
				BodyHasteFX.SizeLength = BodyTrailLength;
				BodyHasteFX.SetBase( self );
			}
			else
				DebugInfoMessage( ".LizbethBossFightFrenzy.BeginState() couldn't spawn body haste effect." );
	
			if( BodyGlowFX == none )	
				BodyGlowFX = spawn( class'GlowScriptedFX', self,, Location );
			if( BodyGlowFX != none )
			{
				BodyGlowFX.SizeWidth=GlowSize;
				BodyGlowFX.SizeLength=GlowSize;
				BodyGlowFX.Opacity = 0.0;
			}
	
			AccelRate *= (FrenzyGroundSpeed / GroundSpeed);
			RotationRate.Yaw *= (FrenzyGroundSpeed / GroundSpeed); 
			GroundSpeed = FrenzyGroundSpeed;
	
			PushState( GetStateName(), 'Taunted' );
			GotoState( 'AIQuickTaunt' );
		}
	}

Damaged:
Taunted:
Resume:
	DebugInfoMessage( ".LizbethBossFightFrenzy Taunted." );
	GotoState( 'AIAttackPlayer' );

Begin:
	DebugInfoMessage( ".LizbethBossFightFrenzy Begin." );
}

//****************************************************************************
// LizbethBossFightWeakened
// "Weakened" mode during boss fight.  Will basically stay still for approx.
//	10 seconds recovering, during which time is vulnerable to attack.  A
//	successful attack with the scythe in this mode will kill Lizbeth.
//****************************************************************************
state LizbethBossFightWeakened expands AIScriptedState
{
	function SeeHatedPawn( pawn aPawn ) { }

	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ) 
	{ 
		global.TakeDamage( Instigator, HitLocation, Momentum, DInfo );
	}

	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo )
	{
		global.Died( Killer, damageType, HitLocation, DInfo );
	}

	function Killed( pawn Killer, pawn Other, name damageType )
	{
		global.Killed( Killer, Other, damageType );
	}
	
	function KilledBy( pawn EventInstigator )
	{
		global.KilledBy( EventInstigator );
	}

	function bool Decapitate( optional vector Dir )
	{
		return super.Decapitate( Dir );
	}

	function AdjustDamage( out DamageInfo DInfo )
	{
		global.AdjustDamage( DInfo );

		DInfo.Damage = 0.0;
		switch( DInfo.Damagetype )
		{
			case 'scythe':
			case 'scythedouble':
				DInfo.Damage = 2.0 * Health; // make sure she dies.
				DInfo.JointName = 'head';
				break;
		}
	}

	function Timer()
	{
		OriginalHealth = Max(2*HealthDelta + MinimumHealth, OriginalHealth - HealthDelta);
		Health = OriginalHealth;	// Lizbeth is restored.
		GotoState( 'LizbethBossFightNormal' );
	}

	function Tick( float deltaTime )
	{
		if( BodyGlowFX != none )
		{
			BodyGlowFX.Opacity -= 1.0 * GlowAlpha * deltaTime;
			if( BodyGlowFX.Opacity < GlowAlpha )
			{
				BodyGlowFX.Opacity = 0;
				BodyGlowFX.Destroy();
				BodyGlowFX = none;
			}
		}		
	}

	function BeginState()
	{
		super.BeginState();
		DamageThresholdState = '';	// Don't go to any other states when damage threshold reached.

	    HatedClass=default.HatedClass;
		AmbientSound = default.AmbientSound;

		if( LeftClawFX != none )
		{
			LeftClawFX.Destroy();
			LeftClawFX = none;
		}

		if( RightClawFX != none )
		{
			RightClawFX.Destroy();
			RightClawFX = none;
		}

		if( BodyHasteFX != none )
		{
			BodyHasteFX.Destroy();
			BodyHasteFX = none;
		}

		RotationRate.Yaw = Default.RotationRate.Yaw;
		GroundSpeed = Default.GroundSpeed;
		AccelRate = Default.AccelRate;
	}

Damaged:
Resume:
Begin:
	StopMovement();
	TargetPoint = JumpBackPoint();
	if( TargetPoint == Location )
		goto 'Jumped';

	PushState( GetStateName(), 'Jumped' );
	GotoState( 'AIJumpToPoint' );

Jumped:
	SetTimer( WeakenedTimer, false );	// stay in this state for 12 seconds.
	LoopAnim( 'Damage_NearDeath', 1.0 );
}

state AIAvoidEnemy
{
	function BeginState()
	{
		super.BeginState();
		
		SetTimer( 10.0, false );
	}

	function Timer()
	{
		if( Enemy != none )
			GotoState( 'AIAttack' );
		else
			GotoState( 'AIAttackPlayer' );
	}
}

//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***
	// (Re)evaluate attack strategy.
	function Evaluate()
	{
		local float		distance;

		distance = DistanceTo( Enemy );
		if ( distance <= ( MeleeRange * 3.5 ) )
		{
			// Enemy is closer, re-evaluate attack.
			GotoState( 'AIAttack' );
			return;
		}
	}

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
	if ( (FrenzyTime <= 0.0) && (bNoAdvance || (DistanceTo( Enemy ) > (3.0 * MeleeRange)) || (FRand() < 0.5)) )
		goto 'THROW';
	SlowMovement();
	PushState( GetStateName(), 'JUMPED' );
	GotoState( 'AIJumpAtEnemy' );

THROW:
	StopMovement();
	TurnToward( Enemy, 20*DEGREES );
	PlayFarAttack();
	FinishAnim();

	if( (Health - MinimumHealth) > (0.5 * (OriginalHealth - MinimumHealth)) )
		GotoState( 'AIAttack' );
	else
		GotoState( 'AIAvoidEnemy' );
} // state AIFarAttackAnim

state AIThrowRockAttack expands AIFarAttackAnim
{
	function BeginState()
	{
		super.BeginState();

		if( Enemy == none )
			SetEnemy( FindPlayer() );

		bNoAdvance = true;
	}

	function EndState()
	{
		super.EndState();

		if( Enemy == none )
			bNoAdvance = false;
		else if( !Enemy.Weapon.IsA('Scythe') )
			bNoAdvance = false;
	}

// Entry point when returning from AITakeDamage
DAMAGED:
	PopState( , 'DAMAGED' );


Begin:
	StopMovement();
	TurnToward( Enemy, 20*DEGREES );
	PlayFarAttack();
	FinishAnim();
	PopState();
}

state AIAttack
{
	function Dispatch()
	{
		local float		dist;
		local bool		bFarAttack;

		dist = DistanceTo( Enemy );

		if ( TriggerSwitchToMelee() )
		{
			PushState( GetStateName(), 'RESUME' );
			StopMovement();
			GotoState( 'AISwitchToMelee' );
			return;
		}
		else if ( TriggerSwitchToRanged() )
		{
			PushState( GetStateName(), 'RESUME' );
			StopMovement();
			GotoState( 'AISwitchToRanged' );
			return;
		}

		bFarAttack = DoFarAttack();

		if ( dist <= DamageRadius )
		{
			if ( bHasNearAttack && FastTrace( Location, Enemy.Location ) && WithinStrikingZ( Enemy ) )
			{
				GotoState( 'AINearAttack' );
			}
			else if ( bHasFarAttack )
			{
				GotoState( 'AIFarAttack' );
			}
		}
		else if( (dist < SafeDistance) && bNoAdvance )
		{
			if( (Health - MinimumHealth) > 0.5 * (OriginalHealth - MinimumHealth) )
				GotoState( 'AICharge', 'NOEVAL' );	// AICharge has really become tactical movement.
			else
				GotoState( 'AIAvoidEnemy' );
		}
		else
		{
			if ( bFarAttack || bNoAdvance )
			{
				GotoState( 'AIFarAttack' );
			}
			else
			{
				// must charge to reach MeleeRange
				if ( bUseCoverPoints )
					GotoState( 'AIChargeCovered' );
				else
					GotoState( 'AICharge', 'NOEVAL' );
			}
		}
	}
}

state AICantReachEnemy
{
	function BeginState()
	{
		super.BeginState();
		
		if( (Enemy != none) && FastTrace( Location, Enemy.Location ) )
		{
			PushState( 'AIFarAttack', 'JUMPED' );
			GotoState( 'AIJumpAtEnemy' );
		}
	}
}
	
state AIAmbush
{
	function BeginState()
	{
		super.BeginState();
		GotoState( 'AIChasePlayer' );
	}
}

state AILost
{
	function BeginState()
	{
		super.BeginState();
		GotoState( 'AIChasePlayer' );
	}
}

state AIOnFire
{
	function BeginState()
	{
		super.BeginState();
		PopState();
	}
}

state AIQuickTaunt
{
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ) {}
}

state LizbethScriptedTaunt expands AIDoNothing
{
	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
	}

	function EndState()
	{
		DebugEndState();
	}

	function Landed( vector hitNormal )
	{
		DebugInfoMessage( ".Landed(), Z is " $ Velocity.Z $ ", PH=" $ Physics);
	}

Begin:
	ScriptedTauntTimer = FVariant( ScriptedTauntTime, ScriptedTauntVariance );

DAMAGED:
Choose:
	if( ScriptedTauntTimer <= 0.0 )
		PopState();

	if( FRand() < 0.5 )
		goto 'Taunt';

ThrowRocks:
	PushState( GetStateName(), 'RocksThrown' );
	GotoState( 'AIThrowRockAttack' );
RocksThrown:
	goto 'Choose';

Taunt:
	PushState( GetStateName(), 'Taunted' );
	GotoState( 'AIQuickTaunt' );
Taunted:
	goto 'ThrowRocks';
}


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();

		ScriptedTauntTime = 0.0;
		FrenzyTime = 0.0;
	}		

	function PostSpecialKill()
	{
		TargetActor = SK_TargetPawn;
		GotoState( 'AIDance', 'DANCE' );
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
	}

	function StartSequence()
	{
		GotoState( , 'LIZBETHSTART' );
	}

	// *** new (state only) functions ***
	function OJDidIt()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('head').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'head', 'root');
	}

	function OJDidItAgain()
	{
		PlayerBleedOutFromJoint('head');
	}


LIZBETHSTART:
	DebugDistance( "before anim" );
	PlaySoundTaunt();
	SK_TargetPawn.PlayAnim( 'lizbeth_death', [TweenTime] 0.0  );
	PlayAnim( 'death_creature_special', [TweenTime] 0.0  );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill

defaultproperties
{
     DamageThresholdState=AIRetreat
     FrenzyTimer=15
     WeakenedTimer=10
     FrenzyGroundSpeed=450
     ClawTrailWidth=(Base=12)
     ClawTrailLength=(Base=24)
     BodyTrailWidth=(Base=32)
     BodyTrailLength=(Base=64)
     GlowSize=(Base=32)
     GlowAlpha=0.3333
     FrenzyAnimSpeed=2
     RockDamage=8
     ScriptedTauntTime=10
     MinimumHealth=500
     DamageThreshold=525
     SafeDistance=256
     bIsBoss=True
     Aggressiveness=0.99
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=30,Method=RipSlice)
     MeleeInfo(1)=(Damage=50,Method=RipSlice)
     DamageRadius=110
     SK_PlayerOffset=(X=60)
     bHasSpecialKill=True
     JumpScalar=1.15
     MaxJumpZ=2500
     LostCounter=0
     MeleeRange=80
     AirSpeed=600
     AccelRate=1800
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.LizbethSoundSet'
     FootSoundClass=Class'Aeons.BareFootSoundSet'
     RotationRate=(Yaw=48000)
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Lizbeth_m'
     DrawScale=1.2
     TransientSoundRadius=1000
     CollisionRadius=20
     CollisionHeight=52
     Mass=2000
}
