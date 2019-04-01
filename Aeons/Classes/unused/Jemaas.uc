//=============================================================================
// Jemaas.
//=============================================================================
class Jemaas expands ScriptedBiped;


#exec MESH IMPORT MESH=JemaasDead0_m SKELFILE=Poses\JemaasDead0.ngf
#exec MESH IMPORT MESH=JemaasDead1_m SKELFILE=Poses\JemaasDead1.ngf

#exec MESH IMPORT MESH=JemaasHanging_m SKELFILE=Poses\JemaasHanging.ngf
#exec MESH IMPORT MESH=JemaasPinned_m SKELFILE=Poses\JemaasPinned.ngf

#exec MESH IMPORT MESH=Jemaas_m SKELFILE=Jemaas.ngf INHERIT=ScriptedBiped_m
#exec MESH JOINTNAME Neck=Head

#exec TEXTURE IMPORT FILE=Tribesman01Rock.pcx GROUP=Jemaas Mips=On
#exec TEXTURE IMPORT FILE=Tribesman02Rock.pcx GROUP=Jemaas Mips=On

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
#exec MESH NOTIFY SEQ=attack_spear_jab TIME=0.286 FUNCTION=DoNearDamage				//
#exec MESH NOTIFY SEQ=attack_spear_jab TIME=0.333 FUNCTION=DoNearDamage				//
#exec MESH NOTIFY SEQ=attack_spear_jab TIME=0.381 FUNCTION=DoNearDamage				//
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.231 FUNCTION=DoNearDamage		//
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.269 FUNCTION=DoNearDamage		//
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.327 FUNCTION=DoNearDamage2Reset	//
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.365 FUNCTION=DoNearDamage2		//
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.481 FUNCTION=DoNearDamage2Reset	//
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.519 FUNCTION=DoNearDamage2		//
#exec MESH NOTIFY SEQ=attack_speardraw TIME=0.200 FUNCTION=DrawSpearL				//
#exec MESH NOTIFY SEQ=attack_speardraw TIME=0.280 FUNCTION=DrawSpearR				//
#exec MESH NOTIFY SEQ=attack_speargun_reload TIME=0.415 FUNCTION=SpawnSpearR		//
#exec MESH NOTIFY SEQ=attack_speargun_reload TIME=0.691 FUNCTION=RemoveSpearR		//

#exec MESH NOTIFY SEQ=attack_speargun_fire TIME=0.47619 FUNCTION=PlaySound_N ARG="VEffort CHANCE=0.7 PVar=0.2 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_speargun_reload TIME=0.03125 FUNCTION=PlaySound_N ARG="VEffort CHANCE=0.7 PVar=0.2 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_speargun_reload TIME=0.09375 FUNCTION=C_BackLeft		//
#exec MESH NOTIFY SEQ=attack_speargun_reload TIME=0.572917 FUNCTION=PlaySound_N ARG="VGrunt CHANCE=0.7 PVar=0.2 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_spear_jab TIME=0.0681818 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.2 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_spear_jab TIME=0.204545 FUNCTION=PlaySound_N ARG="VEffort PVar=0.2 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_spear_jab TIME=0.25 FUNCTION=C_BackLeft				//
#exec MESH NOTIFY SEQ=attack_spear_jab TIME=0.295455 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=attack_spear_jab TIME=0.590909 FUNCTION=C_BackLeft			//
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.0545455 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.2 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.218182 FUNCTION=C_BackLeft		//
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.236364 FUNCTION=PlaySound_N ARG="VEffort PVar=0.2 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.290909 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.363636 FUNCTION=C_BackRight		//
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.472727 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.509091 FUNCTION=PlaySound_N ARG="VEffort CHANCE=0.5 PVar=0.2 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_spear_jabswipe TIME=0.527273 FUNCTION=C_BackRight		//
#exec MESH NOTIFY SEQ=specialkill TIME=0.0 FUNCTION=PlaySound_N ARG="SPKill"
#exec MESH NOTIFY SEQ=specialkill TIME=0.724 FUNCTION=PlaySound_N ARG="PatDeath"
#exec MESH NOTIFY SEQ=hunt TIME=0.354839 FUNCTION=PlaySound_N ARG="VExhale CHANCE=0.8 PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=hunt TIME=0.451613 FUNCTION=C_BackLeft						//
#exec MESH NOTIFY SEQ=hunt TIME=0.935484 FUNCTION=C_BackRight						//
#exec MESH NOTIFY SEQ=idle_alert TIME=0.0163934 FUNCTION=PlaySound_N ARG="VExhale PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=idle_alert TIME=0.1 FUNCTION=PlaySound_N ARG="SpeakImp CHANCE=.05 PVar=0.2 V=0.6 VVar=0.1"
#exec MESH NOTIFY SEQ=idle_alert TIME=0.278689 FUNCTION=PlaySound_N ARG="VInhale CHANCE=0.7 PVar=0.2 V=0.3 VVar=0.2"
#exec MESH NOTIFY SEQ=idle_alert TIME=0.52459 FUNCTION=PlaySound_N ARG="VExhale PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=idle_alert TIME=0.803279 FUNCTION=PlaySound_N ARG="VInhale CHANCE=0.7 PVar=0.2 V=0.3 VVar=0.2"
#exec MESH NOTIFY SEQ=idle_alert_withgun TIME=0.0163934 FUNCTION=PlaySound_N ARG="VExhale PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=idle_alert_withgun TIME=0.1 FUNCTION=PlaySound_N ARG="SpeakImp CHANCE=.05 PVar=0.2 V=0.6 VVar=0.1"
#exec MESH NOTIFY SEQ=idle_alert_withgun TIME=0.278689 FUNCTION=PlaySound_N ARG="VInhale CHANCE=0.7 PVar=0.2 V=0.3 VVar=0.2"
#exec MESH NOTIFY SEQ=idle_alert_withgun TIME=0.52459 FUNCTION=PlaySound_N ARG="VExhale PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=idle_alert_withgun TIME=0.803279 FUNCTION=PlaySound_N ARG="VInhale CHANCE=0.7 PVar=0.2 V=0.3 VVar=0.2"
#exec MESH NOTIFY SEQ=maori_dance TIME=0.0212766 FUNCTION=PlaySound_N ARG="VCry CHANCE=0.2 PVar=0.2 V=0.9 VVar=0.1"
#exec MESH NOTIFY SEQ=maori_dance TIME=0.170213 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=maori_dance TIME=0.255319 FUNCTION=C_BackRight				//
#exec MESH NOTIFY SEQ=maori_dance TIME=0.255319 FUNCTION=PlaySound_N ARG="Spear PVar=0.2"
#exec MESH NOTIFY SEQ=maori_dance TIME=0.595745 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=maori_dance TIME=0.638298 FUNCTION=C_BackLeft					//
#exec MESH NOTIFY SEQ=maori_dance TIME=0.659574 FUNCTION=PlaySound_N ARG="Spear PVar=0.2"
#exec MESH NOTIFY SEQ=maori_dance TIME=0.93617 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=maori_dance TIME=1.0 FUNCTION=C_BackRight						//
#exec MESH NOTIFY SEQ=rock_surprise TIME=0.428571 FUNCTION=C_BackLeft				//
#exec MESH NOTIFY SEQ=rock_surprise TIME=0.428571 FUNCTION=PlaySound_N ARG="SpeakEmph PVar=0.1"
#exec MESH NOTIFY SEQ=rock_surprise TIME=0.585714 FUNCTION=C_BackRight				//
#exec MESH NOTIFY SEQ=rock_surprise TIME=0.685714 FUNCTION=C_BackLeft				//
#exec MESH NOTIFY SEQ=run TIME=0.451613 FUNCTION=C_BackLeft							//
#exec MESH NOTIFY SEQ=run TIME=0.451613 FUNCTION=PlaySound_N ARG="VExhale CHANCE=0.8 PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=run TIME=0.935484 FUNCTION=C_BackRight						//
#exec MESH NOTIFY SEQ=attack_speardraw TIME=0.173077 FUNCTION=PlaySound_N ARG="VGrunt PVar=0.2 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_speardraw TIME=0.5 FUNCTION=PlaySound_N ARG="Whoosh V=0.9 VVar=0.1"
#exec MESH NOTIFY SEQ=taunt_tusken TIME=0.083 FUNCTION=PlaySound_N ARG="VCry CHANCE=0.7 PVar=0.2 V=0.9 VVar=0.1"

// added manually
#exec MESH NOTIFY SEQ=maori_dance_cycle TIME=0.314 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=maori_dance_cycle TIME=0.457 FUNCTION=C_BackLeft				//
#exec MESH NOTIFY SEQ=maori_dance_cycle TIME=0.857 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=maori_dance_cycle TIME=0.914 FUNCTION=C_BackRight				//


//****************************************************************************
// Member vars.
//****************************************************************************
var HeldProp				SpearR;				//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	if ( FRand() < 0.5 )
		PlayAnim( 'attack_spear_jab' );
	else
		PlayAnim( 'attack_spear_jabswipe' );
}

function PlayTaunt()
{
	PlayAnim( 'taunt_tusken' );
}

function PlayWaiting()
{
	if ( InWater() )
		LoopAnim('swim_idle');
	else if ( InCrouch() )
		LoopAnim( 'crouch_idle',,,, 0.2 );
	else if ( IsAlert() )
	{
		if ( RangedWeapon != none )
			LoopAnim('idle_alert_withgun') || LoopAnim('idle');
		else
			LoopAnim('idle_alert') || LoopAnim('idle');
	}
	else
	{
		if ( RangedWeapon != none )
			LoopAnim('idle') || LoopAnim('idle_alert_withgun');
		else
			LoopAnim('idle') || LoopAnim('idle_alert');
	}
}


//****************************************************************************
// Animation/audio notification handlers [SFX].
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PlayRun()
{
	if ( FullSpeedScale <= WalkSpeedScale )
		PlayWalk();
	else
		super.PlayRun();
}

function bool IsAlert()
{
	return true;
}

function SetOpacity( float OValue )
{
	super.SetOpacity( OValue );
	if ( SpearR != none )
		SpearR.Opacity = OValue;
}

function Destroyed()
{
	RemoveSpearR();
	super.Destroyed();
}

function bool TriggerSwitchToMelee()
{
	if ( ( Enemy != none ) &&
		 !Enemy.bCanFly &&
		 ( FRand() < 0.25 ) &&
		 ( PathDistanceTo( Enemy ) > 0.0 ) )
		return super.TriggerSwitchToMelee();
	else
		return false;
}

function DamageInfo AdjustDamageByLocation ( DamageInfo DInfo )
{
	DInfo = super.AdjustDamageByLocation( DInfo );
	switch ( DInfo.JointName )
	{
		// Head shots
		case 'Neck':
		case 'Head':
		case 'Hair1':
		case 'Hair2':
		case 'Hair3':
		case 'Hair4':
		case 'Hair5':
		case 'L_Ear':
		case 'R_Ear':
		case 'Jaw':
		case 'Mouth':
			if ( DInfo.DamageType == 'spear' )
				DInfo.Damage = Health * 10;
			break;
	}
	return DInfo;
}


//****************************************************************************
// New class functions.
//****************************************************************************
function DrawSpearL()
{
	MyProp[1].SetBase( self, 'l_fist', 'root' );
}

function DrawSpearR()
{
	MyProp[0].SetBase( self, 'r_fist', 'root' );
}

function SpawnSpearR()
{
	RemoveSpearR();
	SpearR = Spawn( class'JemaasSpear', self,, JointPlace('r_fist').pos );
	if ( SpearR != none )
	{
		SpearR.SetPhysics( PHYS_None );
		SpearR.SetBase( self, 'r_fist', 'root' );
	}
}

function RemoveSpearR()
{
	if ( SpearR != none )
	{
		SpearR.Destroy();
		SpearR = none;
	}
}

// TODO: this should drop the spear
function DropSpearL()
{
	if ( MyProp[1] != none )
	{
		MyProp[1].Destroy();
		MyProp[1] = none;
	}
}

// TODO: this should drop the spear
function DropSpearR()
{
	if ( MyProp[0] != none )
	{
		MyProp[0].Destroy();
		MyProp[0] = none;
	}
}

//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AISwitchToMelee
// Switch to melee weapon, return via state stack.
//****************************************************************************
state AISwitchToMelee
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool PlayHolsterWeapon()
	{
		// Can't holster the weapon, so drop it.
		if ( RangedWeapon != none )
		{
			RangedWeapon.Drop();
			RangedWeapon = none;
		}
		return false;
	}

	function bool PlaySwitchToMelee()
	{
		return PlayAnim( 'attack_speardraw' );
	}

	// *** new (state only) functions ***

} // state AISwitchToMelee

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
		GotoState( , 'JEMAASSTART' );
	}

	// *** new (state only) functions ***

JEMAASSTART:
	if ( Abs( ( Location.Z - CollisionHeight ) - ( SK_TargetPawn.Location.Z - SK_TargetPawn.CollisionHeight ) ) >= 10.0 )
	{
		Timer();
	}
	else
	{
		DebugDistance( "before anim" );
		SK_TargetPawn.PlayAnim( 'jemaas_death', [TweenTime] 0.0 );
		PlayAnim( 'specialkill', [TweenTime] 0.0 );
		FinishAnim();
		goto 'LOST';
	}

} // state AISpecialKill


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     MyPropInfo(0)=(Prop=Class'Aeons.JemaasSpear',PawnAttachJointName=spearback_R,AttachJointName=root)
     MyPropInfo(1)=(Prop=Class'Aeons.JemaasSpear',PawnAttachJointName=spearback_L,AttachJointName=root)
     LongRangeDistance=1000
     Aggressiveness=1
     bHasNearAttack=False
     bHasFarAttack=True
     bUseCoverPoints=True
     MeleeInfo(0)=(Damage=20,Method=Blunt)
     MeleeInfo(1)=(Damage=20,Method=RipSlice)
     WeaponClass=Class'Aeons.SPSpeargun'
     WeaponJoint=Left_Fist2
     WeaponAccuracy=0.9
     bCanSwitchToMelee=True
     MeleeSwitchDistance=400
     DamageRadius=85
     SK_PlayerOffset=(X=70)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.6
     bCanCrouch=False
     WalkSpeedScale=0.55
     bGiveScytheHealth=True
     FireScalar=0.5
     ConcussiveScalar=0.5
     AttackVocalDelay=7.5
     MeleeRange=60
     GroundSpeed=325
     AccelRate=1600
     Alertness=1
     SightRadius=900
     BaseEyeHeight=52
     Health=150
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.JemaasSoundSet'
     FootSoundClass=Class'Aeons.BareFootSoundSet'
     GibDamageThresh=100
     Mesh=SkelMesh'Aeons.Meshes.Jemaas_m'
     DrawScale=1.1
     CollisionRadius=22
     CollisionHeight=57
}
