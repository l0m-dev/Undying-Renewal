//=============================================================================
// DecayedSaint.
//=============================================================================
class DecayedSaint expands ScriptedBiped;

//#exec MESH IMPORT MESH=DecayedSaint_m SKELFILE=SaintA.ngf INHERIT=ScriptedBiped_m
//#exec MESH ALIAS Hunt=Walk Run=Walk

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.325 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.350 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.375 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=attack_claw TIME=0.400 FUNCTION=DoNearDamage		//
//#exec MESH NOTIFY SEQ=attack_staff TIME=0.194 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_staff TIME=0.209 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_staff TIME=0.224 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_staff TIME=0.239 FUNCTION=DoNearDamage2		//
//#exec MESH NOTIFY SEQ=attack_staff TIME=0.537 FUNCTION=DoNearDamage3Reset	//
//#exec MESH NOTIFY SEQ=attack_staff TIME=0.552 FUNCTION=DoNearDamage3		//
//#exec MESH NOTIFY SEQ=attack_staff TIME=0.582 FUNCTION=DoNearDamage3		//
//#exec MESH NOTIFY SEQ=attack_staff TIME=0.597 FUNCTION=DoNearDamage3		//
//#exec MESH NOTIFY SEQ=attack_grab_throw TIME=0.087 FUNCTION=SpawnRock		//
//#exec MESH NOTIFY SEQ=attack_grab_throw TIME=0.413 FUNCTION=ThrowRock		//
//#exec MESH NOTIFY SEQ=special_kill TIME=0.147 FUNCTION=Spurt				//
//#exec MESH NOTIFY SEQ=special_kill TIME=0.327 FUNCTION=SpurtAgain			//
//#exec MESH NOTIFY SEQ=special_kill TIME=0.314 FUNCTION=RipYerHeartOut		//
//#exec MESH NOTIFY SEQ=special_kill TIME=0.653 FUNCTION=EatYerHeartOut		//

//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.025 FUNCTION=PlaySound_N ARG="VEffort PVAR=.15 V=.5"
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.125 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.6"
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.275 FUNCTION=PlaySound_N ARG="VAttack PVAR=.15"
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.3 FUNCTION=PlaySound_N ARG="Whoosh PVAR=.2"
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.375 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.9 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=Attack_Claw TIME=0.75 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.3"
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.0 FUNCTION=PlaySound_N ARG="VAttack PVAR=.15"
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.134328 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.820895 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.164179 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.2"
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.820895 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.2"
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.194 FUNCTION=PlaySound_N ARG="Whoosh PVAR=.2"
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.223881 FUNCTION=PlaySound_N ARG="VEffort PVAR=.15 V=.7"
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.283582 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.6"
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.522388 FUNCTION=PlaySound_N ARG="VEffort PVAR=.15"
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.552239 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.4"
//#exec MESH NOTIFY SEQ=Attack_Staff TIME=0.537 FUNCTION=PlaySound_N ARG="Whoosh PVAR=.2"
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.0434783 FUNCTION=PlaySound_N ARG="Whoosh PVAR=.2 V=.4"
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.0434783 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.369565 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.847826 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.0434783 FUNCTION=PlaySound_N ARG="VEffort PVAR=.15 V=.5"
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.0652174 FUNCTION=PlaySound_N ARG="Impact P=1.2 PVAR=.15"
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.0652174 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.3"
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.391304 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.3"
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.217391 FUNCTION=PlaySound_N ARG="VAttack PVAR=.15"
//#exec MESH NOTIFY SEQ=Attack_Grab_Throw TIME=0.383 FUNCTION=PlaySound_N ARG="Whoosh PVAR=.2"
//#exec MESH NOTIFY SEQ=Taunt_Shriek TIME=0.0 FUNCTION=PlaySound_N ARG=TauntS
//#exec MESH NOTIFY SEQ=Taunt_Shriek TIME=0.0972222 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.6 VVAR=.2"
//#exec MESH NOTIFY SEQ=Taunt_Shriek TIME=0.152778 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.6 VVAR=.2"
//#exec MESH NOTIFY SEQ=Taunt_Shriek TIME=0.222222 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.6 VVAR=.2"
//#exec MESH NOTIFY SEQ=Taunt_Shriek TIME=0.291667 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.6 VVAR=.2"
//#exec MESH NOTIFY SEQ=Taunt_Shriek TIME=0.361111 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.6 VVAR=.2"
//#exec MESH NOTIFY SEQ=Taunt_Shriek TIME=0.430556 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.6 VVAR=.2"
//#exec MESH NOTIFY SEQ=Taunt_Shriek TIME=0.5 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.6 VVAR=.2"
//#exec MESH NOTIFY SEQ=Walk TIME=0.0 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=Walk TIME=0.533333 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=Walk TIME=0.166667 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.25"
//#exec MESH NOTIFY SEQ=Walk TIME=0.7 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.25"
//#exec MESH NOTIFY SEQ=run TIME=0.0 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=run TIME=0.533333 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=run TIME=0.166667 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.25"
//#exec MESH NOTIFY SEQ=run TIME=0.7 FUNCTION=PlaySound_N ARG="Mvmt PVAR=.2 V=.25"
//#exec MESH NOTIFY SEQ=Taunt_Head TIME=0.0833333 FUNCTION=PlaySound_N ARG=TauntH
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.186441 FUNCTION=PlaySound_N ARG="Mvmt C=.7 PVAR=.2 V=.1 VVAR=.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.711864 FUNCTION=PlaySound_N ARG="Mvmt C=.7 PVAR=.2 V=.1 VVAR=.1"
//#exec MESH NOTIFY SEQ=get_up TIME=0.111111 FUNCTION=PlaySound_N ARG="VEffort PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.135802 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.382716 FUNCTION=C_BackRight						//
//#exec MESH NOTIFY SEQ=get_up TIME=0.469136 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.567901 FUNCTION=C_BackLeft						//
//#exec MESH NOTIFY SEQ=special_kill TIME=0.000 FUNCTION=PlaySound_N ARG="SPKill"
//#exec MESH NOTIFY SEQ=special_kill TIME=0.163 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=special_kill TIME=0.081 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=special_kill TIME=0.138 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=special_kill TIME=0.333 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=special_kill TIME=0.365 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.25"
//#exec MESH NOTIFY SEQ=special_kill TIME=0.373 FUNCTION=PlaySound_N ARG="Heartbeat P=1.2"
//#exec MESH NOTIFY SEQ=special_kill TIME=0.390 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=special_kill TIME=0.528 FUNCTION=PlaySound_N ARG="Heartbeat P=0.95"
//#exec MESH NOTIFY SEQ=special_kill TIME=0.634 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.4 VVar=0.2"

//#exec MESH NOTIFY SEQ=emerge TIME=0.046 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=emerge TIME=0.200 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=emerge TIME=0.262 FUNCTION=PlaySound_N ARG="VEffort PVAR=.15 V=.7"
//#exec MESH NOTIFY SEQ=emerge TIME=0.408 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=emerge TIME=0.538 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=emerge TIME=0.577 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=emerge TIME=0.577 FUNCTION=PlaySound_N ARG="VEffort PVAR=.15 V=.7"
//#exec MESH NOTIFY SEQ=emerge TIME=0.692 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=emerge TIME=0.723 FUNCTION=PlaySound_N ARG="VEffort PVAR=.15 V=.7"
//#exec MESH NOTIFY SEQ=emerge TIME=0.777 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=emerge TIME=0.808 FUNCTION=C_BoneFS
//#exec MESH NOTIFY SEQ=emerge TIME=0.815 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=emerge TIME=0.931 FUNCTION=PlaySound_N ARG="Mvmt PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=emerge TIME=0.046 FUNCTION=C_FrontRight
//#exec MESH NOTIFY SEQ=emerge TIME=0.192 FUNCTION=C_FrontRight
//#exec MESH NOTIFY SEQ=emerge TIME=0.408 FUNCTION=C_FrontLeft
//#exec MESH NOTIFY SEQ=emerge TIME=0.600 FUNCTION=C_FrontLeft
//#exec MESH NOTIFY SEQ=emerge TIME=0.638 FUNCTION=C_FrontRight
//#exec MESH NOTIFY SEQ=emerge TIME=0.762 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=emerge TIME=0.786 FUNCTION=C_BackRight


//#exec AUDIO IMPORT FILE="C_DSaint_ClawHit01.wav" NAME="C_DSaint_ClawHit01" GROUP="Impacts"
//#exec AUDIO IMPORT FILE="C_DSaint_StaffHit01.wav" NAME="C_DSaint_StaffHit01" GROUP="Impacts"


// a static pose of the mesh - 
//#exec MESH IMPORT MESH=Saint_OnGround_m SKELFILE=Poses\Saint_OnGround.ngf

//****************************************************************************
// Member vars.
//****************************************************************************
var Projectile				RockRight;			//
var bool					bReallyDead;		//
var int						ThrowCount;			//
var actor					PHeart;				//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	if ( Rand(2) == 0 )
		PlayAnim( 'attack_claw', 1.25 );
	else
		PlayAnim( 'attack_staff', 1.25 );
}

function PlayFarAttack()
{
	PlayAnim( 'attack_grab_throw' );
}

function PlayTaunt()
{
	if ( Rand(2) == 0 )
		PlayAnim( 'taunt_head' );
	else
		PlayAnim( 'taunt_shriek' );
}


//****************************************************************************
// Audio trigger functions.
// These functions used to trigger creature-specific SFX when animation that would
// normally do so has been inhibited or state code knows that animation can not
// use normal animation notification to play sound.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage PVAR=.15" );
}

function PlaySoundScream()
{
	PlaySound_P( "TauntS" );
}

function PlaySoundAlerted()
{
}

function PlaySoundMeleeDamage( int Which )
{
	if ( Which == 0 )
		PlaySound( sound'Aeons.Impacts.C_DSaint_ClawHit01', SLOT_Misc );
	else
		PlaySound( sound'Aeons.Impacts.C_DSaint_StaffHit01', SLOT_Misc );
}


//****************************************************************************
// Animation/audio notification handlers [SFX].
//****************************************************************************
function C_FS()
{
	C_BoneFS();
}

function C_BoneFS()
{
	local texture	HitTexture;
	local int		Flags;

	HitTexture = TraceTexture( Location + vect(0,0,-1.5) * CollisionHeight, Location, Flags );
	if ( HitTexture != none )
		PlayFootSound( 1, HitTexture, 0, Location );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreSetMovement()
{
	super.PreSetMovement();
	bCanSwim = false;
}

function PreBeginPlay()
{
	super.PreBeginPlay();
	GenSpawnFX();
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	FindTeam();
}

function bool DoFarAttack()
{
	if( ( Team != none ) &&
		( DecayedSaint(Team.Leader) != none ) &&
		( DecayedSaint(Team.Leader).ThrowCount > 2 ) )
		return false;
	else
		return super.DoFarAttack();
}

function TeamNewLeader( pawn OldLeader )
{
	// Transfer the count of others throwing
	if ( DecayedSaint(OldLeader) != none )
		ThrowCount = DecayedSaint(OldLeader).ThrowCount;
}

function Ignited()
{
}

function AdjustDamage( out DamageInfo DInfo )
{
	if( (DInfo.Deliverer != none) && DInfo.Deliverer.IsA( 'Lizbeth' ) )
		DInfo.Damage *= 4.0;
	
	super.AdjustDamage( DInfo );
}

function bool CanBeInvoked()
{
	return ( Health > 0 );
}

function Invoke( actor Other )
{
	DebugInfoMessage( ".Invoke()" );
	bIsInvoked = true;
	GotoState( 'AIInvokeDeath' );
}

function bool Gibbed( name damageType )
{
	return false;
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	if ( DamageNum == 2 )
		return JointStrikeValid( Victim, 'l_wrist', DamageRadius );
	else
		return JointStrikeValid( Victim, 'r_wrist', DamageRadius );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
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

function C_FrontRight()
{
	PlayEffectAtJoint( 'r_wrist', 'FrontRight' );
}

function C_FrontLeft()
{
	PlayEffectAtJoint( 'l_wrist', 'FrontLeft' );
}


//****************************************************************************
// New class functions.
//****************************************************************************
function GenSpawnFX()
{
	Spawn( class'SaintSummonFX',,, Location );
	PlaySound_P( "Appear" );
}

// Spawn a rock in hand.
function SpawnRock()
{
	// This is the projectile type he throws
	RockRight = Spawn( class'SaintProjectile', self,, JointPlace('r_hand1').pos );
	if ( RockRight != none )
	{
		RockRight.SetPhysics( PHYS_None );
		RockRight.SetBase( self, 'r_hand1' );
	}
}

// Throw the rock.
function ThrowRock()
{
	local vector	TargetDirection;

	if ( RockRight != none )
	{
		TargetDirection = vector(WeaponAimAt( Enemy, RockRight.Location, WeaponAccuracy, true, RockRight.Speed ));

		// Detach it
		RockRight.SetBase( none );
		RockRight.GotoState( 'FallingState' );
		// send it on it's way
		RockRight.Velocity = TargetDirection * FVariant( RockRight.Speed, RockRight.Speed * 0.10 );
		if ( Region.Zone.bWaterZone )
			RockRight.Velocity *= 0.50;
		RockRight.SetPhysics( PHYS_Falling );
		RockRight.Enable( 'Tick' );
		RockRight = none;
	}
}

// E3 temporary: find a team of other DSaints and join
function FindTeam()
{
	local DecayedSaint	DSaint;

	if( Team != none )
		return;

	bIsTeamLeader = true;
	InitTeamObject();

	foreach AllActors( class'DecayedSaint', DSaint )
	{
		if ( ( DSaint != self ) && DSaint.bIsTeamLeader && ( DSaint.Health > 0 ) )
		{
			bIsTeamLeader = false;
			bIsTeamMember = true;
			Team.RegisterMember( DSaint );
//			log( name $ " added self to list, new team is:" );
//			LogTeamList();
//			DebugInfoMessage( ".DSaint.FindTeam(), set leader is " $ Team.Leader.name );
			return;
		}
	}
//	DebugInfoMessage( ".DSaint.FindTeam(), set leader to self" );
//	log( name $ " added self to list, new team is:" );
//	LogTeamList();
}

//
function Throw()
{
	ThrowCount += 1;
//	DebugInfoMessage( ".DSaint.Throw(), count is " $ ThrowCount );
}

//
function UnThrow()
{
	ThrowCount -= 1;
//	DebugInfoMessage( ".DSaint.UnThrow(), count is " $ ThrowCount );
}

// Destroy the rock object, if there is one.
function DestroyRock()
{
	if ( RockRight != none )
	{
		RockRight.Destroy();
		RockRight = none;
	}
}

//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***
	function EnemyNotVisible(){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		if ( (Team != none) && (DecayedSaint(Team.Leader) != none) )
			DecayedSaint(Team.Leader).Throw();
		DestroyRock();
	}

	function EndState()
	{
		super.EndState();
		if ( (Team != none) && (DecayedSaint(Team.Leader) != none) )
			DecayedSaint(Team.Leader).UnThrow();
		DestroyRock();
	}

	// *** new (state only) functions ***

} // state AIFarAttackAnim


//****************************************************************************
// AIHibernate
// Hibernating, waiting to regenerate.
//****************************************************************************
state AIHibernate
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function LongFall(){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}

	// *** overridden functions ***
	function Timer()
	{
		GotoState( , 'REGEN' );
	}

	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo )
	{
//		DebugInfoMessage( ".AIHibernate.TakeDamage(), damage is " $ DInfo.Damage $ ", Health is " $ Health );
		if ( Health <= 0 )
			bReallyDead = true;
		else
		{
			// DSaint has health, so must be reanimated
			super.TakeDamage( Instigator, HitLocation, Momentum, DInfo );
		}
	}

	function bool CanBeInvoked()
	{
		return true;
	}


DAMAGED:
	GotoState( 'AIEncounter' );
	goto 'END';

REGEN:
	SetCollision( InitCollideActors, InitBlockActors, InitBlockPlayers );
	PlayAnim( 'get_up' );
	FinishAnim();
	Health = InitHealth;
	if ( ( FireMod != none ) && FireMod.bActive )
		FireMod.SetBurnout( FVariant( 2.0, 0.50 ) );
	FindTeam();
	PlayTaunt();
	FinishAnim();
	PlayWait();
	GotoState( 'AIHuntPlayer' );
	goto 'END';

BEGIN:
	SetTimer( FVariant( 12.0, 2.0 ), false);

END:
} // state AIHibernate


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		DestroyRock();
	}

	function PostAnim()
	{
		if ( Health > -20 )
			GotoState( 'AIHibernate' );
	}

	function bool CanBeInvoked()
	{
		return true;
	}

	function Invoke( actor Other )
	{
		global.Invoke( Other );
	}

} // state Dying


//****************************************************************************
// AIInvokeDeath
// 
//****************************************************************************
state AIInvokeDeath expands Dying
{
	// *** overridden functions ***
	function bool CanBeInvoked()
	{
		return false;
	}

	// *** new (state only) functions ***


BEGIN:
	StopMovement();
	if ( !Region.Zone.bWaterZone )
		Spawn( class'DecayedSaintDeathFX', self,, Location );
	SendKilledNotifications( none, 'invoke' );

	if ( Health > 0 )
	{
		PlaySoundDeath();
		PlayAnim( 'death_gun_backhead' );
	}

	Health = 0.0;
	OpacityEffector.SetFade( 0.0, 2.0 );
	Sleep( 2.0 );
	Destroy();

} // state AIInvokeDeath


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***
	function PostSpecialKill()
	{
		TargetActor = SK_TargetPawn;
		SK_TargetPawn.GotoState('SpecialKill', 'SpecialKillComplete');
		GotoState( 'AIDance', 'DANCE' );
	}

	function StartSequence()
	{
		GotoState( , 'SAINTSTART' );
	}

	// *** new (state only) functions ***
	function Spurt()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('spine3').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'spine3', 'root');
	}

	function SpurtAgain()
	{
		local vector	DVect;
		local int		lp;

		DVect = SK_TargetPawn.JointPlace('spine3').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
	}

	function RipYerHeartOut()
	{
		PHeart = Spawn( class'PlayersHeart',,, JointPlace('r_hand1').pos );
		PHeart.SetBase( self, 'r_hand1', 'root' );
		PlayerRandomDeathAnim();
	}

	function EatYerHeartOut()
	{
		PHeart.Destroy();
		PlayerBleedOutFromJoint('spine3');
	}


SAINTSTART:
	NoLook();
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'saint_death' );
	PlayAnim( 'special_kill' );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     MyPropInfo(0)=(Prop=Class'Aeons.SaintStaff',PawnAttachJointName=Bone03,AttachJointName=staff-bone)
     LongRangeDistance=1000
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=10,EffectStrength=0.35,Method=RipSlice)
     MeleeInfo(1)=(Damage=25,EffectStrength=0.7,Method=Blunt)
     MeleeInfo(2)=(Damage=25,EffectStrength=0.7,Method=Blunt)
     WeaponAccuracy=0.5
     DamageRadius=110
     SK_PlayerOffset=(X=120)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.75
     bNoBloodPool=True
     bSpecialInvoke=True
     MeleeRange=80
     GroundSpeed=225
     Alertness=1
     SightRadius=1500
     PeripheralVision=0.5
     BaseEyeHeight=58
     SoundSet=Class'Aeons.DecayedSaintSoundSet'
     PI_StabSound=(Sound_1=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact01',Sound_2=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact02',Sound_3=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact03')
     PI_BiteSound=(Sound_1=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact01',Sound_2=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact02',Sound_3=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact03')
     PI_BluntSound=(Sound_1=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact01',Sound_2=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact02',Sound_3=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact03')
     PI_BulletSound=(Sound_1=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact01',Sound_2=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact02',Sound_3=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact03')
     PI_RipSliceSound=(Sound_1=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact01',Sound_2=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact02',Sound_3=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact03')
     PI_GenLargeSound=(Sound_1=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact01',Sound_2=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact02',Sound_3=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact03')
     PI_GenMediumSound=(Sound_1=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact01',Sound_2=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact02',Sound_3=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact03')
     PI_GenSmallSound=(Sound_1=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact01',Sound_2=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact02',Sound_3=Sound'CreatureSFX.DecayedSaint.C_DSaint_Impact03')
     PE_StabEffect=Class'Aeons.DustPuffFX'
     PE_StabKilledEffect=Class'Aeons.RevolverHitFX'
     PE_BiteEffect=Class'Aeons.DustPuffFX'
     PE_BiteKilledEffect=Class'Aeons.RevolverHitFX'
     PE_BluntEffect=Class'Aeons.DustPuffFX'
     PE_BluntKilledEffect=Class'Aeons.RevolverHitFX'
     PE_BulletEffect=Class'Aeons.DustPuffFX'
     PE_BulletKilledEffect=Class'Aeons.SaintChunk0'
     PE_RipSliceEffect=Class'Aeons.SaintChunk0'
     PE_RipSliceKilledEffect=Class'Aeons.RevolverHitFX'
     PE_GenLargeEffect=Class'Aeons.RevolverHitFX'
     PE_GenLargeKilledEffect=Class'Aeons.RevolverHitFX'
     PE_GenMediumEffect=Class'Aeons.SaintChunk0'
     PE_GenMediumKilledEffect=Class'Aeons.RevolverHitFX'
     PE_GenSmallEffect=Class'Aeons.RevolverHitFX'
     PE_GenSmallKilledEffect=Class'Aeons.RevolverHitFX'
     PD_StabDecal=None
     PD_BiteDecal=None
     PD_BluntDecal=None
     PD_BulletDecal=None
     PD_RipSliceDecal=None
     PD_GenLargeDecal=None
     PD_GenMediumDecal=None
     PD_GenSmallDecal=None
     FootSoundClass=Class'Aeons.BoneFootSoundSet'
     Buoyancy=0
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.DecayedSaint_m'
     CollisionRadius=18
     CollisionHeight=60
     bHackable=False
}
