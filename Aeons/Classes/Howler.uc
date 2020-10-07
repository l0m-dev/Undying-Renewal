//=============================================================================
// Howler.
//=============================================================================
class Howler expands ScriptedPawn;

//#exec MESH IMPORT MESH=Howler_m SKELFILE=Howler.ngf
//#exec MESH JOINTNAME R_Shoulder=R_Collar R_Shoulder_Rot=R_Shoulder R_Hand=R_Hand1 R_Claw_A1=R_ClawA1 R_Claw_B1=R_ClawB1
//#exec MESH JOINTNAME L_Shoulder=L_Collar L_Shoulder_Rot=L_Shoulder L_Hand=L_Hand1 L_Claw_A1=L_ClawA1 L_Claw_B1=L_ClawB1

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.440 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.470 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.495 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.525 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=attack_standslash TIME=0.563 FUNCTION=DoNearDamage2	//
//#exec MESH NOTIFY SEQ=attack_standslash TIME=0.578 FUNCTION=DoNearDamage2	//
//#exec MESH NOTIFY SEQ=attack_standslash TIME=0.594 FUNCTION=DoNearDamage2	//
//#exec MESH NOTIFY SEQ=attack_standslash TIME=0.609 FUNCTION=DoNearDamage2	//
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.233 FUNCTION=TriggerJump			//
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.533 FUNCTION=DoNearDamage3		//
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.550 FUNCTION=DoNearDamage3		//
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.567 FUNCTION=DoNearDamage3		//
//#exec MESH NOTIFY SEQ=jump TIME=0.185 FUNCTION=TriggerJump					//
//#exec MESH NOTIFY SEQ=jump_start TIME=0.481 FUNCTION=TriggerJump			//
//#exec MESH NOTIFY SEQ=jump_start TIME=1.000 FUNCTION=PlayInAir				//
//#exec MESH NOTIFY SEQ=eat_at_corpse TIME=0.615385 FUNCTION=BloodyMouth		//
//#exec MESH NOTIFY SEQ=eat_at_corpse TIME=0.815385 FUNCTION=BloodyMouth		//
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.285 FUNCTION=DecapitatePlayer	//
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.350 FUNCTION=OJDidItAgain		//
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.769 FUNCTION=PutHeadInMouth		//
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.875 FUNCTION=SwallowHead		//
//#exec MESH NOTIFY SEQ=death TIME=0.100 FUNCTION=SpawnGoreDecal				//

//#exec MESH NOTIFY SEQ=attack_bite TIME=0.0 FUNCTION=PlaySound_N ARG="VPreAtk PVAR=.2 V=.8 VVAR=.2"
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.237288 FUNCTION=PlaySound_N ARG="VAttack PVAR=.2"
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.474576 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=attack_bite TIME=0.508475 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=attack_standslash TIME=0.0 FUNCTION=PlaySound_N ARG="VPreAtk PVAR=.2 V=.8 VVAR=.2"
//#exec MESH NOTIFY SEQ=attack_standslash TIME=0.508475 FUNCTION=PlaySound_N ARG="VAttack PVAR=.2"
//#exec MESH NOTIFY SEQ=attack_standslash TIME=0.559322 FUNCTION=PlaySound_N ARG="Whoosh PVAR=.2"
//#exec MESH NOTIFY SEQ=attack_standslash TIME=0.79661 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=attack_standslash TIME=0.830508 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.0 FUNCTION=PlaySound_N ARG="VPreAtk PVAR=.2 V=.8 VVAR=.2"
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.0625 FUNCTION=C_ClawFS
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.078125 FUNCTION=C_ClawFS
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.421875 FUNCTION=PlaySound_N ARG="VAttack PVAR=.2"
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.421875 FUNCTION=PlaySound_N ARG="Whoosh PVAR=.2"
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.53125 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=attack_slash TIME=0.5625 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=jump TIME=0.078125 FUNCTION=C_ClawFS
//#exec MESH NOTIFY SEQ=jump TIME=0.09375 FUNCTION=C_ClawFS
//#exec MESH NOTIFY SEQ=jump TIME=0.125 FUNCTION=PlaySound_N ARG="Jump PVAR=.2 V=.75 VVAR=.2"
//#exec MESH NOTIFY SEQ=jump TIME=0.484375 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=jump TIME=0.5 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=jump_start TIME=0.208333 FUNCTION=C_ClawFS
//#exec MESH NOTIFY SEQ=jump_start TIME=0.25 FUNCTION=C_ClawFS
//#exec MESH NOTIFY SEQ=jump_start TIME=0.333333 FUNCTION=PlaySound_N ARG="Jump PVAR=.2 V=.75 VVAR=.2"
//#exec MESH NOTIFY SEQ=eat_at_corpse TIME=0.0307692 FUNCTION=PlaySound_N ARG="VPreAtk CHANCE=.35 P=.75 PVAR=.2 V=.5 VVAR=.2"
//#exec MESH NOTIFY SEQ=eat_at_corpse TIME=0.276923 FUNCTION=PlaySound_N ARG="VPreAtk CHANCE=.35 P=.75 PVAR=.2 V=.5 VVAR=.2"
//#exec MESH NOTIFY SEQ=eat_at_corpse TIME=0.615385 FUNCTION=PlaySound_N ARG="Eat PVAR=.2 V=.75 VVAR=.2"
//#exec MESH NOTIFY SEQ=eat_at_corpse TIME=0.815385 FUNCTION=PlaySound_N ARG="Eat PVAR=.2 V=.75 VVAR=.2"
//#exec MESH NOTIFY SEQ=eat_at_corpse_bite TIME=0.0769231 FUNCTION=PlaySound_N ARG="VPreAtk CHANCE=.35 P=.75 PVAR=.2 V=.5 VVAR=.2"
//#exec MESH NOTIFY SEQ=eat_at_corpse_bite TIME=0.6296296 FUNCTION=PlaySound_N ARG="Eat PVAR=.2 V=.75 VVAR=.2"
//#exec MESH NOTIFY SEQ=eat_at_corpse_bite TIME=0.692308 FUNCTION=PlaySound_N ARG="VPreAtk CHANCE=.35 P=.75 PVAR=.2 V=.5 VVAR=.2"
//#exec MESH NOTIFY SEQ=howl TIME=0.0740741 FUNCTION=PlaySound_N ARG="Howl PVAR=.25 V=1.3"
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.0 FUNCTION=PlaySound_N ARG="VPreAtk V=.8 VVAR=.2"
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.201342 FUNCTION=PlaySound_N ARG="VAttack"
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.274 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.221477 FUNCTION=PlaySound_N ARG="Whoosh"
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.270536 FUNCTION=PlaySound_N ARG="ClawStab"
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.315436 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.328859 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=attack_specialkill TIME=0.484724 FUNCTION=PlaySound_N ARG="SpclKill P=.9"
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.0 FUNCTION=PlaySound_N ARG="VDamage PVAR=.2"
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.103448 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.241379 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.413793 FUNCTION=C_StunShake01_01_075_100_020_075_010
//#exec MESH NOTIFY SEQ=death TIME=0.0875 FUNCTION=PlaySound_N ARG="VDeath PVAR=.2"
//#exec MESH NOTIFY SEQ=death TIME=0.1875 FUNCTION=C_BodyFall
//#exec MESH NOTIFY SEQ=death TIME=0.3 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=death TIME=0.35 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=death TIME=0.425 FUNCTION=C_ClawFS
//#exec MESH NOTIFY SEQ=death TIME=0.5375 FUNCTION=C_ClawFS
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.0 FUNCTION=PlaySound_N ARG="Breath PVAR=.2 V=.5"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.491525 FUNCTION=PlaySound_N ARG="Breath PVAR=.2 V=.5"
//#exec MESH NOTIFY SEQ=Idle_Alert_Hang TIME=0.0169492 FUNCTION=PlaySound_N ARG="Breath PVAR=.2 V=.5"
//#exec MESH NOTIFY SEQ=Idle_Alert_Hang TIME=0.508475 FUNCTION=PlaySound_N ARG="Breath PVAR=.2 V=.5"
//#exec MESH NOTIFY SEQ=Idle_Alert_Hangawake TIME=0.0 FUNCTION=PlaySound_N ARG="VPreAtk PVAR=.2 V=.8 VVAR=.2"
//#exec MESH NOTIFY SEQ=listen TIME=0.0 FUNCTION=PlaySound_N ARG="Breath PVAR=.2 V=.5"
//#exec MESH NOTIFY SEQ=listen TIME=0.457143 FUNCTION=PlaySound_N ARG="Listen1 PVAR=.2 V=.75 VVAR=.2"
//#exec MESH NOTIFY SEQ=listen TIME=0.6 FUNCTION=PlaySound_N ARG="Listen2 PVAR=.2 V=.75 VVAR=.2"
//#exec MESH NOTIFY SEQ=Run TIME=0.7 FUNCTION=PlaySound_N ARG="Run PVAR=.2 V=.2"
//#exec MESH NOTIFY SEQ=Run TIME=0.8 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=Run TIME=0.9 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=Run TIME=0.95 FUNCTION=C_FrontRight
//#exec MESH NOTIFY SEQ=Run TIME=1.0 FUNCTION=C_FrontLeft
//#exec MESH NOTIFY SEQ=turn_left TIME=0.366667 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=turn_left TIME=0.733333 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=turn_left TIME=0.0 FUNCTION=PlaySound_N ARG="Breath PVAR=.2 V=.5"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.0 FUNCTION=PlaySound_N ARG="Breath PVAR=.2 V=.5"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.5 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=turn_right TIME=0.766667 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=jump_end TIME=0.454545 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=jump_end TIME=0.545455 FUNCTION=C_BareFS

// Poses
//#exec MESH IMPORT MESH=Howler_Pinned_m SKELFILE=Poses\Howler_Pinned.ngf

//****************************************************************************
// Member vars.
//****************************************************************************
var NavigationPoint			LastSpclNavPoint;	// Last navigation point where special action was performed.
var float					JumpAttackTime;		// Length of jump attack (in air) time.
var Actor					Head;				// Magnus' Head - for the special Kill sequence.


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayJumpAttack()
{
	PlayAnim( 'attack_slash',, MOVE_None );
}

function PlayNearAttack()
{
	if ( FRand() < 0.5 )
		PlayAnim( 'attack_bite' );
	else
		PlayAnim( 'attack_standslash',, MOVE_None );
}

function PlayStunDamage()
{
	PlayAnim( 'damage_stun',, MOVE_None );
}

function PlayMindshatterDamage()
{
	LoopAnim( 'damage_stun',, MOVE_None );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	local vector TraceLocation, HitNormal, End;
	local int HitJoint;

	switch( Damage )
	{
		/*
		case 'spear':
			Trace(TraceLocation, HitNormal, HitJoint, HitLocation, HitLocation + Normal(DInfo.ImpactForce) * 512, false);
			if ( (TraceLocation != vect(0,0,0)) && ( abs(HitNormal.z) < 0.5) )
			{
				SetPhysics(PHYS_Falling);
				Velocity = (Normal(DInfo.ImpactForce) + vect(0,0,0.35)) * 1024;
				PlayAnim( 'death',, MOVE_None );
			}
			else
				PlayAnim( 'death',, MOVE_None );
			break;
		*/
		default:
			PlayAnim( 'death',, MOVE_None );
			break;
	}
}

function PlayTaunt()
{
	PlayAnim( 'howl' );
}

function PlayOnFireDamage()
{
	PlayAnim( 'howl' );
}

function PlaySpecialKill()
{
	PlayAnim( 'attack_specialkill' );
}

function float GetJumpAttackTime()
{
	return JumpAttackTime;
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreSetMovement()
{
	super.PreSetMovement();
	bCanJump = true;
	JumpAttackTime = 0.5;
}

function bool DoFarAttack()
{
	local float		dist;

	dist = DistanceTo( Enemy );
	if ( ( dist > ( MeleeRange * 2.5 ) ) &&
		 ( dist < ( MeleeRange * 4.0 ) ) &&
		 actorReachable( Enemy ) )
		return true;
	else
		return false;
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

function WorldEventAlert( actor Alerter )
{
	DebugInfoMessage( ".WorldEventAlert() from " $ Alerter.name );
	super.WorldEventAlert( Alerter );
	if ( FRand() < 0.25 )
	{
		PushState( GetStateName(), 'RESUME' );
		GotoState( 'AIAlertReaction' );
	}
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	DebugInfoMessage( ".NearStrikeValid(), DamageNum is " $ DamageNum );
	switch ( DamageNum )
	{
		case 1:
			return JointStrikeValid( Victim, 'head', DamageRadius );
			break;
		default:
			return JointStrikeValid( Victim, 'r_hand1', DamageRadius );
			break;
	}
}

function bool AcknowledgeDamageFrom( pawn Damager )
{
	if ( ( Damager != none ) && Damager.IsA('Lizbeth') )
		return false;
	else
		return super.AcknowledgeDamageFrom( Damager );
}


//****************************************************************************
// New class functions.
//****************************************************************************
// Spawn a bloody effect for eating animation
function BloodyMouth()
{
//	if ( FRand() < 0.80 )
//		Spawn( class'BloodPuffFX', self,, JointPlace('jaw').pos, rot(49152,0,0) );
}


//****************************************************************************
// Audio trigger functions.
// These functions used to trigger creature-specific SFX when animation that would
// normally do so has been inhibited or state code knows that animation can not
// use normal animation notification to play sound.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage PVAR=.2" );
}

function PlaySoundDeath()
{
	PlaySound_P( "VDeath PVAR=.2" );
}

function PlaySoundScream()
{
	PlaySound_P( "Howl PVAR=.25 V=1.3" );
}

function PlaySoundAlerted()
{
}


//****************************************************************************
// Animation/audio notification handlers [SFX].
//****************************************************************************
// km These function are overridden to properly set the FootSoundClass for claws vs slappy-feet.
function C_BackRight()
{
	FootSoundClass = default.FootSoundClass;
	PlayEffectAtJoint( 'r_ankle', 'BackRight' );
}

function C_BackLeft()
{
	FootSoundClass = default.FootSoundClass;
	PlayEffectAtJoint( 'l_ankle', 'BackLeft' );
}

function C_FrontRight()
{
	FootSoundClass = class'Aeons.HandClawFootSoundSet';
	PlayEffectAtJoint( 'r_hand', 'FrontRight' );
}

function C_FrontLeft()
{
	FootSoundClass = class'Aeons.HandClawFootSoundSet';
	PlayEffectAtJoint( 'l_hand', 'FrontLeft' );
}

function C_BareFS()
{
	FootSoundClass = class'Aeons.BareFootSoundSet';
	super.C_BareFS();
}

function C_ClawFS()
{
	FootSoundClass = class'Aeons.HandClawFootSoundSet';
	super.C_ClawFS();
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

	// *** new (state only) functions ***
	function DecapitatePlayer()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('head').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'head', 'root');

		SK_TargetPawn.Decapitate();
		SK_TargetPawn.PlayAnim( 'death_gun_left' );
		Head = Spawn( class'PlayersHead',,, JointPlace('r_fist').pos );
		Head.SetBase( self, 'r_fist', 'root' );
	}

	function OJDidItAgain()
	{
		PlayerBleedOutFromJoint( 'head' );
	}

	function PutHeadInMouth()
	{
		Head.SetBase( self, 'mouth', 'root' );
	}

	function SwallowHead()
	{
		Head.Destroy();
	}

} // state AISpecialKill


//****************************************************************************
// AIAlertReaction
// React to being alerted
//****************************************************************************
state AIAlertReaction
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorHearNoise( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		super.EndState();
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
	Sleep( FVariant( ReactionBase, ReactionRand ) );
	PlayAnim( 'listen' );
	FinishAnim();
	PlayWait();
	PopState();
} // state AIAlertReaction


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
		return true;
	}

} // state AIJumpAtEnemy


//****************************************************************************
// Def props
//****************************************************************************

defaultproperties
{
     FollowDistance=300
     LongRangeDistance=750
     JumpDownDistance=275
     Aggressiveness=0.85
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=25,EffectStrength=0.1,Method=Bite)
     MeleeInfo(1)=(Damage=10,EffectStrength=0.25,Method=RipSlice)
     MeleeInfo(2)=(Damage=15,EffectStrength=0.5,Method=RipSlice)
     ForfeitPursuit=0.1
     DamageRadius=100
     SK_PlayerOffset=(X=77)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.2
     VisionEffectorThreshold=0.8
     WalkSpeedScale=0.65
     MaxJumpZ=2500
     bGiveScytheHealth=True
     FallDamageScalar=0.25
     MeleeRange=75
     GroundSpeed=440
     AirSpeed=840
     AccelRate=1800
     JumpZ=450
     MaxStepHeight=45
     Alertness=0.5
     SightRadius=640
     HatedClass=Class'Aeons.Servant'
     BaseEyeHeight=28
     Health=50
     SoundSet=Class'Aeons.HowlerSoundSet'
     FootSoundClass=Class'Aeons.HandClawFootSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.Howler_m'
     ShadowRange=300
     SoundRadius=32
     CollisionRadius=24
     CollisionHeight=34
}
