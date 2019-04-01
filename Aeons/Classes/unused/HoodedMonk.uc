//=============================================================================
// HoodedMonk.
//=============================================================================
class HoodedMonk expands ScriptedBiped;

#exec MESH IMPORT MESH=HoodedMonk_m SKELFILE=HoodedMonk.ngf INHERIT=ScriptedBiped_m
#exec MESH JOINTNAME Head=Hair Neck=Head

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
#exec MESH NOTIFY SEQ=attack_staff TIME=0.194 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=attack_staff TIME=0.209 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=attack_staff TIME=0.224 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=attack_staff TIME=0.239 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=attack_staff TIME=0.537 FUNCTION=DoNearDamageReset
#exec MESH NOTIFY SEQ=attack_staff TIME=0.552 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=attack_staff TIME=0.582 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=attack_staff TIME=0.597 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=special_kill TIME=0.111 FUNCTION=DropPlayer
#exec MESH NOTIFY SEQ=special_kill TIME=0.639 FUNCTION=StabPlayer

#exec MESH NOTIFY SEQ=taunt_figure8 TIME=0.0454545 FUNCTION=PlaySound_N ARG="Figure8"
#exec MESH NOTIFY SEQ=attack_crossbow TIME=0.823529 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"
#exec MESH NOTIFY SEQ=bow TIME=0.351351 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"
#exec MESH NOTIFY SEQ=bow TIME=0.837838 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"
#exec MESH NOTIFY SEQ=crossbow_lift TIME=0.571429 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"
#exec MESH NOTIFY SEQ=walk TIME=0.25 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"
#exec MESH NOTIFY SEQ=walk TIME=0.333333 FUNCTION=C_BackRight
#exec MESH NOTIFY SEQ=walk TIME=0.75 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"
#exec MESH NOTIFY SEQ=walk TIME=0.861111 FUNCTION=C_BackLeft
#exec MESH NOTIFY SEQ=attack_staff TIME=0.0 FUNCTION=PlaySound_N ARG="VAttack PVar=0.15"
#exec MESH NOTIFY SEQ=attack_staff TIME=0.117647 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=attack_staff TIME=0.132353 FUNCTION=C_BackLeft
#exec MESH NOTIFY SEQ=attack_staff TIME=0.161765 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.2"
#exec MESH NOTIFY SEQ=attack_staff TIME=0.191176 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=attack_staff TIME=0.220588 FUNCTION=PlaySound_N ARG="VEffort PVar=0.15 V=0.7"
#exec MESH NOTIFY SEQ=attack_staff TIME=0.279412 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.6 VVar=0.2"
#exec MESH NOTIFY SEQ=attack_staff TIME=0.514706 FUNCTION=PlaySound_N ARG="VEffort PVar=0.15"
#exec MESH NOTIFY SEQ=attack_staff TIME=0.544118 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
#exec MESH NOTIFY SEQ=attack_staff TIME=0.558824 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=attack_staff TIME=0.808824 FUNCTION=C_BackRight
#exec MESH NOTIFY SEQ=attack_staff TIME=0.808824 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.2"
#exec MESH NOTIFY SEQ=special_kill TIME=0.000 FUNCTION=PlaySound_N ARG="SpKill"
#exec MESH NOTIFY SEQ=special_kill TIME=0.616 FUNCTION=PlaySound_N ARG="PatDeath"


//****************************************************************************
// Member vars.
//****************************************************************************
var() float					PrayerSpeedScale;	//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	PlayAnim( 'attack_staff' );
}

function PlayTaunt()
{
	PlaySoundTaunt();
	PlayAnim( 'taunt_figure8' );
}

function PlaySpecialKill()
{
	PlayAnim( 'special_kill' );
}


//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundMeleeDamage( int Which )
{
	PlaySound_P( "StaffSlam" );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	WalkSpeedScale = PrayerSpeedScale;
}

function DefConChanged( int OldValue, int NewValue )
{
	if ( NewValue > 0 )
		WalkSpeedScale = default.WalkSpeedScale;
}

function bool AcknowledgeDamageFrom( pawn Damager )
{
	if ( Damager != none )
		return !Damager.IsA(class.name);
	else
		return true;
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** ignored functions ***

	// *** overridden functions ***
	function PostSpecialKill()
	{
		TargetActor = SK_TargetPawn;
		GotoState( 'AIDance', 'DANCE' );
		SK_TargetPawn.GotoState('SpecialKill', 'SpecialKillComplete');
	}

	// *** new (state only) functions ***
	function DropPlayer()
	{
//		SK_TargetPawn.PlayAnim( 'death_chargedspear' );
		SK_TargetPawn.PlayAnim( 'death_gun_back',, MOVE_None );
	}

	function StabPlayer()
	{
	}

} // state AISpecialKill


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     PrayerSpeedScale=0.2
     MyPropInfo(0)=(Prop=Class'Aeons.MonkStaff',PawnAttachJointName=Handposition,AttachJointName=MStaff_Att_Hand)
     Aggressiveness=1
     MeleeInfo(0)=(Damage=35,EffectStrength=0.35,Method=Blunt)
     DamageRadius=95
     SK_PlayerOffset=(X=100)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.65
     bGiveScytheHealth=True
     MeleeRange=70
     GroundSpeed=325
     AccelRate=1600
     Alertness=1
     SightRadius=1500
     PeripheralVision=0.5
     BaseEyeHeight=54
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.MonkSoldierSoundSet'
     FootSoundClass=Class'Aeons.SandalFootSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.HoodedMonk_m'
     DrawScale=1.1
     CollisionRadius=22
     CollisionHeight=58
}
