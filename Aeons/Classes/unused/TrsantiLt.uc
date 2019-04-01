//=============================================================================
// TrsantiLt.
//=============================================================================
class TrsantiLt expands Trsanti;

#exec MESH IMPORT MESH=TrsantiLt_m SKELFILE=Trsanti_Lt.ngf INHERIT=TrsantiBase_m
#exec MESH MODIFIERS Cloth1:Cloth

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
#exec MESH NOTIFY SEQ=draw_daggers TIME=0.167 FUNCTION=DrawDaggerLeft
#exec MESH NOTIFY SEQ=draw_daggers TIME=0.467 FUNCTION=DrawDaggerRight
#exec MESH NOTIFY SEQ=attack_dagger TIME=0.325 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=attack_dagger TIME=0.350 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=attack_dagger TIME=0.375 FUNCTION=DoNearDamage
#exec MESH NOTIFY SEQ=attack_dagger TIME=0.550 FUNCTION=DoNearDamage2Reset
#exec MESH NOTIFY SEQ=attack_dagger TIME=0.575 FUNCTION=DoNearDamage2
#exec MESH NOTIFY SEQ=attack_dagger TIME=0.600 FUNCTION=DoNearDamage2
#exec MESH NOTIFY SEQ=special_kill TIME=0.197 FUNCTION=StickPlayer
#exec MESH NOTIFY SEQ=special_kill TIME=0.525 FUNCTION=DropPlayer
#exec MESH NOTIFY SEQ=gun_reload TIME=0.923 FUNCTION=Reloaded
#exec MESH NOTIFY SEQ=draw_shotgun TIME=0.387 FUNCTION=DrawWeaponShotgun
#exec MESH NOTIFY SEQ=invoke_death TIME=0.750 FUNCTION=OJDidIt

#exec MESH NOTIFY SEQ=attack_dagger TIME=0.261905 FUNCTION=PlaySound_N ARG="DaggerWhsh PVar=0.2 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=attack_dagger TIME=0.5 FUNCTION=PlaySound_N ARG="DaggerWhsh PVar=0.2 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=draw_daggers TIME=0.193548 FUNCTION=PlaySound_N ARG="DaggerDraw PVar=0.1 V=0.7 VVar=0.1"
#exec MESH NOTIFY SEQ=give_orders TIME=0.0384615 FUNCTION=PlaySound_N ARG="SpeakEmph"
#exec MESH NOTIFY SEQ=special_kill TIME=0.000 FUNCTION=PlaySound_N ARG="SPKill"
#exec MESH NOTIFY SEQ=special_kill TIME=0.525 FUNCTION=PlaySound_N ARG="PatDeath"
#exec MESH NOTIFY SEQ=special_kill TIME=0.895 FUNCTION=PlaySound_N ARG="SPKillTaunt"
#exec MESH NOTIFY SEQ=gun_reload TIME=0.108 FUNCTION=PlaySound_N ARG="Reload1"
#exec MESH NOTIFY SEQ=gun_reload TIME=0.462 FUNCTION=PlaySound_N ARG="Reload2"
#exec MESH NOTIFY SEQ=gun_reload TIME=0.677 FUNCTION=PlaySound_N ARG="Reload2"
#exec MESH NOTIFY SEQ=gun_reload TIME=0.938 FUNCTION=PlaySound_N ARG="Reload3"
#exec MESH NOTIFY SEQ=draw_shotgun TIME=0.548 FUNCTION=PlaySound_N ARG="DrawShotgun"
#exec MESH NOTIFY SEQ=invoke_death TIME=0.833 FUNCTION=PlaySound_N ARG="WpnImpact"
#exec MESH NOTIFY SEQ=invoke_death TIME=0.833 FUNCTION=PlaySound_N ARG="GoreImpact"


//****************************************************************************
// Structure defs.
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************
var PersistentWound Wound;

//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	PlayAnim( 'attack_dagger', 1.50, MOVE_None );
}

function PlayTaunt()
{
	PlaySoundTaunt();
	PlayAnim( 'give_orders' );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool NearStrikeValid( actor Victim, int DamageNum )
{
	switch ( DamageNum )
	{
		case 1:
			return JointStrikeValid( Victim, 'l_wrist', DamageRadius );
			break;
		default:
			return JointStrikeValid( Victim, 'r_wrist', DamageRadius );
			break;
	}
}

function bool CanPerformSK( pawn P )
{
	local bool	B;

	B = super.CanPerformSK( P );
	DebugInfoMessage( ".CanPerformSK() is " $ B );
	return B;
}

function bool CanBeInvoked()
{
	DebugInfoMessage( ".CanBeInvoked(), class.name is " $ class.name $ ", Health is " $ Health $ ", bSpecialInvoke is " $ bSpecialInvoke );
	if ( Health > 0 )
		return bSpecialInvoke;
	else
		return super.CanBeInvoked();
}

function Invoke( actor Other )
{
	DebugInfoMessage( ".Invoke(), Health is " $ Health );
	if ( ( class.name == 'trsantilt' ) && ( Health > 0 ) )
	{
		bIsInvoked = true;
		GotoState( 'AIInvokeDeath' );
	}
	else
		super.Invoke( Other );
}

function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo )
{
	bSpecialInvoke = false;
	super.Died( Killer, damageType, HitLocation, DInfo );
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
// AIFireWeapon
// Fire ranged weapon and return via state stack.
//****************************************************************************
state AIFireWeapon
{
	// *** ignored functions ***

	// *** overridden functions ***
	function EndState()
	{
		super.EndState();
		RangedWeapon.PlayReloadEnd();
	}

	function WeaponReload( SPWeapon ThisWeapon )
	{
		GotoState( , 'RELOAD' );
	}

	function Reloaded()
	{
		RangedWeapon.PlayReloadEnd();
	}


RELOAD:
	StopTimer();
	FinishAnim();		// finish recoil
	RangedWeapon.PlayReloadStart();
	PlayAnim( 'gun_reload' );
	FinishAnim();
	PlayAnim( RangedWeapon.AimAnim );
	super.WeaponReload( none );
	
} // state AIFireWeapon


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
		return PlayAnim( 'draw_back', 1.50, MOVE_None );
	}

	function bool PlaySwitchToMelee()
	{
		return PlayAnim( 'draw_daggers', 1.25, MOVE_None );
	}

	// *** new (state only) functions ***
	function DrawDaggerLeft()
	{
		DebugInfoMessage( " left dagger to left hand" );
		MyProp[1].SetBase( self, 'knife1att', 'knife2att' );
	}

	function DrawDaggerRight()
	{
		DebugInfoMessage( " right dagger to right hand" );
		MyProp[0].SetBase( self, 'knife2att', 'knife1att' );
	}

	function DrawWeaponBack()
	{
		DebugInfoMessage( " shotgun to back" );
		RangedWeapon.SetBase( self, 'shotgun_back', 'shotgunatt' );
	}

} // state AISwitchToMelee


//****************************************************************************
// AISwitchToRanged
// Switch to ranged weapon, return via state stack.
//****************************************************************************
state AISwitchToRanged
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool PlayHolsterMelee()
	{
		return PlayAnim( 'draw_daggers', 1.25, MOVE_None );
	}

	function bool PlaySwitchToRanged()
	{
		return PlayAnim( 'draw_shotgun', 1.50, MOVE_None );
	}

	// *** new (state only) functions ***
	function DrawDaggerLeft()
	{
		DebugInfoMessage( " left dagger to holster" );
		MyProp[1].SetBase( self, 'knife2_sheath', 'knife2att' );
	}

	function DrawDaggerRight()
	{
		DebugInfoMessage( " right dagger to holster" );
		MyProp[0].SetBase( self, 'knife1_sheath', 'knife1att' );
	}

	function DrawWeaponShotgun()
	{
		DebugInfoMessage( " shotgun to hand" );
		RangedWeapon.SetBase( self, 'shotgunatt', 'shotgunatt' );
	}

} // state AISwitchToRanged


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***
	function bool TriggerSwitchToMelee()
	{
		return ( bHasFarAttack && bCanSwitchToMelee );
	}

	function PostSpecialKill()
	{
		SK_TargetPawn.GotoState('SpecialKill', 'SpecialKillComplete');
	}

	function AtPoint()
	{
		if ( TriggerSwitchToMelee() )
		{
			PushState( GetStateName(), 'ATPOINT' );
			GotoState( 'AISwitchToMelee' );
		}
	}

	function vector TurnToPoint( actor AActor )
	{
		local vector	DVect;

		DVect = AActor.Location;
		DVect.Z = Location.Z;
		return DVect;
	}

	function SetOrientation()
	{
		local vector	DVect;

		SetLocation( SK_WorldLoc );
		DVect = SK_TargetPawn.Location - SK_WorldLoc;
		DVect.Z = 0;
		DesiredRotation = rotator(DVect);
		SetRotation( DesiredRotation );
	}

	function StartSequence()
	{
		GotoState( , 'TRSANTILTSTART' );
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

	function DropPlayer()
	{
		SK_TargetPawn.PlayAnim( 'death_revolver' );
	}


TRSANTILTSTART:
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'trsanti_lt_death', [TweenTime] 0.0  );
	PlayAnim( 'special_kill', [TweenTime] 0.0  );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// AIInvokeDeath
// 
//****************************************************************************
state AIInvokeDeath
{
	// *** ignored functions ***
	function PlayDying( name damage, vector HitLocation, DamageInfo DInfo ){}

	// *** overridden functions ***
	function bool CanBeInvoked()
	{
		return false;
	}

	function bool TriggerSwitchToMelee()
	{
		return ( !bHasNearAttack && bCanSwitchToMelee );
	}

	// *** new (state only) functions ***
	function OJDidIt()
	{
		local vector	DVect, RVect;
		local actor		Blood;
		local int		lp;

		DVect = JointPlace('spine3').pos;
		for ( lp=0; lp<2; lp++ )
		{
			Blood = Spawn( class'Aeons.WeakGibBits',,, DVect, Rotation );
			Blood.Velocity = -RVect * ( 100 + FRand() * 150 );
		}

		Wound = Spawn(class 'DecapitateWound',self,,DVect, Rotator(RVect));
		if ( Wound != None )
		{
			Wound.AttachJoint = 'spine3';
			Wound.setup();
		}

		bNoBloodPool = true;
//		super(pawn).Died( self, '', Location, GetDamageInfo( 'suicide' ) );
	}


BEGIN:
	bSpecialInvoke = false;
	Health = 0.0;
	StopMovement();
	if ( TriggerSwitchToMelee() )
	{
		PushState( GetStateName(), 'BEGIN' );
		GotoState( 'AISwitchToMelee' );
	}
	PlaySoundInvoked();
	PlayAnim( 'invoke_death' );
	FinishAnim();
	PlayAnim( 'death_gun_backhead' );
	super(pawn).Died( self, '', Location, GetDamageInfo( 'suicide' ) );
//	GotoState( 'Dying' );

} // state AIInvokeDeath


//****************************************************************************
// Def props.
//****************************************************************************
//	MyPropInfo(2)=(Prop=Class'Aeons.SPShotgun',PawnAttachJointName=shotgun_back,AttachJointName=shotgunatt)

defaultproperties
{
     MyPropInfo(0)=(Prop=Class'Aeons.TrsantiDagger1',PawnAttachJointName=Knife1_Sheath,AttachJointName=Knife1Att)
     MyPropInfo(1)=(Prop=Class'Aeons.TrsantiDagger2',PawnAttachJointName=Knife2_Sheath,AttachJointName=Knife2Att)
     MeleeInfo(0)=(Damage=25)
     MeleeInfo(1)=(Damage=20,EffectStrength=0.25,Method=RipSlice)
     WeaponClass=Class'Aeons.SPShotgun'
     WeaponJoint=ShotgunAtt
     WeaponAttachJoint=ShotgunAtt
     DamageRadius=100
     MeleeRange=75
     Health=120
     SoundSet=Class'Aeons.TrsantiLtSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.TrsantiLt_m'
}
