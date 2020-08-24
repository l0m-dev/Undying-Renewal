//=============================================================================
// TrsantiWitch.
//=============================================================================
class TrsantiWitch expands ScriptedBiped;

//#exec MESH IMPORT MESH=TrsantiWitch_m SKELFILE=TrsantiWitch.ngf INHERIT=ScriptedBiped_m
//#exec MESH MODIFIERS SkirtBack1:Cloth SkirtFront1:Cloth Hair4:RopeHair
//#exec MESH ALIAS Hunt=Walk


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=attack_knives TIME=0.412 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_knives TIME=0.441 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_knives TIME=0.471 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_knives TIME=0.500 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_knives TIME=0.441 FUNCTION=ThrowKnives
//#exec MESH NOTIFY SEQ=draw_knives TIME=0.290 FUNCTION=DrawKnives
//#exec MESH NOTIFY SEQ=specialkill TIME=0.884 FUNCTION=StickPlayer
//#exec MESH NOTIFY SEQ=specialkill TIME=0.955 FUNCTION=OJDidItAgain

//#exec MESH NOTIFY SEQ=attack_knives TIME=0.382 FUNCTION=PlaySound_N ARG="DaggerWhsh PVar=0.2"
//#exec MESH NOTIFY SEQ=attack_knives TIME=0.382 FUNCTION=PlaySound_N ARG="VEffort PVar=0.2"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.085 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=specialkill TIME=0.170 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=specialkill TIME=0.183 FUNCTION=PlaySound_N ARG="WitchMvmt"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.285 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=specialkill TIME=0.367 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=specialkill TIME=0.401 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=specialkill TIME=0.455 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=specialkill TIME=0.602 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=specialkill TIME=0.627 FUNCTION=PlaySound_N ARG="WitchKiss"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.1 FUNCTION=PlaySound_N ARG="EventTaunt"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.849 FUNCTION=PlaySound_N ARG="DaggerWhsh"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.859 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.952 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=walk TIME=0.103 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=walk TIME=0.620 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=defense_spell TIME=0.774 FUNCTION=PlaySound_N ARG="ShieldUp"


//****************************************************************************
// Structure defs.
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************
var SPShield				Shield;				//
var() vector				ShieldOffset;		//
var() float					MinRangedDistance;	//
var() int					ShieldDispelLevel;	//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	PlayAnim( 'attack_knives' );
}

function PlayTaunt()
{
	PlayAnim( 'taunt' );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool AcceptDamage( DamageInfo DInfo )
{
	if ( Shield != none )
	{
		Shield.BufferDamage( DInfo );
		if ( Shield.Strength < 0.0 )
		{
			PlaySound_P( "ShieldDn" );
			Shield.Shrink();
			Shield = none;
		}
		else
			PlaySound_P( "ShieldHit" );
		return false;
	}
	return true;
}

function bool DoFarAttack()
{
	if ( DistanceTo( Enemy ) > MinRangedDistance )
		return super.DoFarAttack();
	else
		return false;
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	return JointStrikeValid( Victim, 'l_wrist', DamageRadius );
}

function int Dispel( optional bool bCheck )
{
	if ( bCheck )
		return ShieldDispelLevel;
	else if ( Shield != none )
	{
		PlaySound_P( "ShieldDn" );
		Shield.Shrink();
		Shield = none;
	}
}


//****************************************************************************
// New class functions.
//****************************************************************************
function CastShield()
{
	Shield = Spawn( class'SPShield', self,, Location, Rotation );
	if ( Shield != none )
		Shield.Offset = ShieldOffset;
}

function bool NeedShieldCast()
{
	return ( Shield == none );
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

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
		if ( NeedShieldCast() )
		{
			PushState( GetStateName(), 'RESUME' );
			StopMovement();
			GotoState( 'AICastShield' );
			return;
		}
		else
			super.Dispatch();
	}

	// *** new (state only) functions ***

} // state AIAttack


//****************************************************************************
// AICastShield
// Cast the shield spell.
//****************************************************************************
state AICastShield
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

	// *** new (state only) functions ***
	function DefenseSpell()
	{
		CastShield();
		// PlaySound();
	}


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	if ( Enemy != none )
		TurnToward( Enemy, 60 * DEGREES );
	PlayAnim( 'defense_spell',, MOVE_None );
	FinishAnim();
	PopState();
} // state AICastShield


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
		GotoState( , 'WITCHSTART' );
	}

	function BeginNav()
	{
		if ( Shield != none )
		{
			Shield.Shrink();
			Shield = none;
		}
	}

	// *** new (state only) functions ***
	function StickPlayer()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('pelvis').pos;
		for ( lp = 0; lp < 4; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'pelvis', 'root');
	}

	function OJDidItAgain()
	{
		PlayerBleedOutFromJoint( 'pelvis' );
	}


WITCHSTART:
	NoLook();
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'witch_death', [TweenTime] 0.0  );
	PlayAnim( 'specialkill', [TweenTime] 0.0  );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     ShieldOffset=(X=30)
     MinRangedDistance=400
     ShieldDispelLevel=2
     MyPropInfo(0)=(Prop=Class'Aeons.WitchDaggers',PawnAttachJointName=rt_handle,AttachJointName=knife1)
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=25,EffectStrength=0.25,Method=RipSlice)
     WeaponClass=Class'Aeons.SPSkullStorm'
     WeaponJoint=R_Hand1
     WeaponAccuracy=0.75
     DamageRadius=100
     SK_PlayerOffset=(X=68)
     bHasSpecialKill=True
     WalkSpeedScale=0.35
     MeleeRange=65
     AccelRate=1800
     SightRadius=1500
     Health=60
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.TrsantiWitchSoundSet'
     FootSoundClass=Class'Aeons.SandalFootSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.TrsantiWitch_m'
}
