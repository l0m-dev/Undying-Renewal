//=============================================================================
// MonkAbbott.
//=============================================================================
class MonkAbbott expands ScriptedBiped;

//#exec MESH IMPORT MESH=MonkAbbott_m SKELFILE=MonkAbbott.ngf INHERIT=ScriptedBiped_m


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=taunt_lookup_start TIME=1.00 FUNCTION=taunt_lookup_cycle
//#exec MESH NOTIFY SEQ=taunt_lookup_cycle TIME=1.00 FUNCTION=taunt_lookup_cycle

//#exec MESH NOTIFY SEQ=idle_drop_book TIME=0.272727 FUNCTION=PlaySound_N ARG="DropBook"
//#exec MESH NOTIFY SEQ=idle_turn_page TIME=0.695652 FUNCTION=PlaySound_N ARG="PageTurn V=0.6"
//#exec MESH NOTIFY SEQ=impale TIME=0.0625 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=impale TIME=0.8125 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=taunt_lookup_end TIME=0.375 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=taunt_lookup_start TIME=0.823529 FUNCTION=PlaySound_N ARG="MvmtHeavy CHANCE=0.8 PVar=0.2 V=0.4 VVar=0.2"


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool IsAlert()
{
	return false;
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
// AIRead
// wait for encounter at current location
//****************************************************************************
state AIRead extends AIWait
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Timer()
	{
		PlayAnim( 'idle_turn_page' );
		GotoState( , 'ANIMWAIT' );
	}

	function CueNextEvent()
	{
		SetTimer( FVariant( 3.0, 1.0 ), false );
	}

	function PlayWaitAnim()
	{
		LoopAnim( 'idle_read' );
	}

	// *** new (state only) functions ***

} // state AIRead



//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     Aggressiveness=1
     bHasNearAttack=False
     bHasFarAttack=True
     WeaponClass=Class'Aeons.SPSkullStorm'
     WeaponJoint=R_Hand1
     WeaponAccuracy=0.5
     bTakeFootShot=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     bGiveScytheHealth=True
     GroundSpeed=325
     AccelRate=1600
     Alertness=1
     SightRadius=1500
     PeripheralVision=0.5
     BaseEyeHeight=55
     AttitudeToPlayer=ATTITUDE_Ignore
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.MonkAbbottSoundSet'
     FootSoundClass=Class'Aeons.SandalFootSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.MonkAbbott_m'
     CollisionRadius=28
     CollisionHeight=60
}
