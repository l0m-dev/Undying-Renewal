//=============================================================================
// Howler.
//=============================================================================
class Howler expands ScriptedPawn;

// BURT - All exec imports were ripped since it is just an update

//****************************************************************************
// Member vars.
//****************************************************************************
var NavigationPoint			LastSpclNavPoint;	// Last navigation point where special action was performed.
var float					JumpAttackTime;		// Length of jump attack (in air) time.
var Actor					Head;				// Magnus' Head - for the special Kill sequence.

// VVA 20.12.04
var bool	bMeleeAttackFail;	// used to hack howler's freezing during near attacks

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

// VVA 20.12.04

//****************************************************************************
// AINearAttack
// attack near enemy (melee)
// hack howlers stay still while biting
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
		StopTimer();
		bPendingBump = false;
	}

	function AnimEnd()
	{
		if( bMeleeAttackFail )
		{
			GotoState( , 'BEGIN' );
		}

		if ( !bDidMeleeAttack )
		{
			GotoState( , 'DOATTACK' );
		}
		else
		{
			GotoState( , 'ATTACKED' );
		}
	}

	function Timer()
	{
		if ( !bDidMeleeAttack )
		{
			GotoState( , 'DOATTACK' );
		}
		else
		{
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

	StopMovement();
	PlayWait();


	if( DistanceTo( Enemy ) > DamageRadius )
	{
		bDidMeleeAttack = false;

		if( FRand()>0.75 || VSize( Location-Enemy.Location ) > 2.5*DamageRadius )
		{
			// check difficulty
			switch( Level.Game.Difficulty )
			{
			case 0:	// Easy
				sleep( FVariant( 1.0, 0.5 ) );
				break;
			case 1:	// Normal
				sleep( FVariant( 0.5, 0.25 ) );
				break;
			case 2: // Hard
				sleep( FVariant( 0.2, 0.1 ) );
				break;
			}		// Very Hard will no wait

			bMeleeAttackFail = false;
			GotoState( 'AIFarAttack' );
		}
		else
		{
			// check difficulty
			switch( Level.Game.Difficulty )
			{
			case 0:	// Easy
				sleep( FVariant( 0.5, 0.25 ) );
				break;
			case 1:	// Normal
				sleep( FVariant( 0.2, 0.1 ) );
				break;
			}

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

DOATTACK:
	bDidMeleeDamage = false;
	bDidMeleeAttack = true;
	PlayNearAttack();
	SetTimer( 5.0, false );		// BUGBUG: using timer to bail out when no animation present

INATTACK:
	if( DistanceTo(Enemy) > DamageRadius )	// enemy lost
	{
		//PostAttack();
		bMeleeAttackFail = true;
		StopTimer();
		TweenAnim( 'Idle_Alert', FVariant(0.15,0.05) );
		//StopMovement();
		//PlayWait();
		goto 'BEGIN';
	}
	Sleep( 0.1 );
	goto 'INATTACK';

ATTACKED:
	StopTimer();
	if ( bPendingBump )
		CreatureBump( BumpedPawn );
	PostAttack();
} // state AINearAttack

// END OF VVA 20.12.04

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
     bNoEncounterTaunt=True
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
     Health=60
     SoundSet=Class'Aeons.HowlerSoundSet'
     FootSoundClass=Class'Aeons.HandClawFootSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.Howler_m'
     ShadowRange=300
     SoundRadius=32
     CollisionRadius=24
     CollisionHeight=34
}