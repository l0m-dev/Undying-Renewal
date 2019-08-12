//=============================================================================
// Bot.
//=============================================================================
class Bot expands ScriptedBiped;

#exec MESH IMPORT MESH=Trsanti_Dead_Hanging_m SKELFILE=Poses\Dead_Hanging.ngf
#exec MESH IMPORT MESH=Trsanti_Dead_Floating_m SKELFILE=Poses\Dead_Floating.ngf
#exec MESH IMPORT MESH=TrsantiGrunt_m SKELFILE=Trsanti_Grunt.ngf INHERIT=TrsantiBase_m
#exec MESH JOINTNAME Head=Hair Neck=Head

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
#exec MESH NOTIFY SEQ=attack_sword1 TIME=0.275 FUNCTION=DoNearDamage	//
#exec MESH NOTIFY SEQ=attack_sword1 TIME=0.300 FUNCTION=DoNearDamage	//
#exec MESH NOTIFY SEQ=attack_sword1 TIME=0.325 FUNCTION=DoNearDamage	//
#exec MESH NOTIFY SEQ=attack_sword1 TIME=0.350 FUNCTION=DoNearDamage	//
#exec MESH NOTIFY SEQ=attack_sword1 TIME=0.375 FUNCTION=DoNearDamage	//
#exec MESH NOTIFY SEQ=attack_sword2 TIME=0.475 FUNCTION=DoNearDamage	//
#exec MESH NOTIFY SEQ=attack_sword2 TIME=0.500 FUNCTION=DoNearDamage	//
#exec MESH NOTIFY SEQ=attack_sword2 TIME=0.525 FUNCTION=DoNearDamage	//
#exec MESH NOTIFY SEQ=attack_sword2 TIME=0.550 FUNCTION=DoNearDamage	//
#exec MESH NOTIFY SEQ=invoke_death TIME=0.400 FUNCTION=PopACap			//
#exec MESH NOTIFY SEQ=invoke_death TIME=0.990 FUNCTION=BleedOut			//
#exec MESH NOTIFY SEQ=taunt_sword_start TIME=1.000 FUNCTION=taunt_sword_cycle	//
#exec MESH NOTIFY SEQ=taunt_sword_cycle TIME=1.000 FUNCTION=taunt_sword_cycle	//
#exec MESH NOTIFY SEQ=special_kill TIME=0.059 FUNCTION=StickPlayer		//
#exec MESH NOTIFY SEQ=special_kill TIME=0.197 FUNCTION=StickPlayer		//
#exec MESH NOTIFY SEQ=special_kill TIME=0.430 FUNCTION=OJDidItAgain		//

#exec MESH NOTIFY SEQ=attack_sword1 TIME=0.275 FUNCTION=PlaySound_N ARG="SwordWhsh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=attack_sword2 TIME=0.439024 FUNCTION=PlaySound_N ARG="SwordWhsh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=taunt_sword_cycle TIME=0.0625 FUNCTION=PlaySound_N ARG="Taunt PVar=0.1 VVar=0.1"
#exec MESH NOTIFY SEQ=taunt_sword_end TIME=0.212121 FUNCTION=C_BackRight			//
#exec MESH NOTIFY SEQ=taunt_sword_end TIME=0.121212 FUNCTION=PlaySound_N ARG="SwordWhsh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=taunt_sword_start TIME=0.761905 FUNCTION=PlaySound_N ARG="SwordWhsh PVar=0.2 V=0.8 VVar=0.2"
#exec MESH NOTIFY SEQ=taunt_sword_start TIME=0.857143 FUNCTION=C_BackRight			//
#exec MESH NOTIFY SEQ=special_kill TIME=0.000 FUNCTION=PlaySound_N ARG="SpKill"
#exec MESH NOTIFY SEQ=special_kill TIME=0.203 FUNCTION=PlaySound_N ARG="PatDeath"
#exec MESH NOTIFY SEQ=special_kill TIME=0.477 FUNCTION=PlaySound_N ARG="SpKillTaunt"
#exec MESH NOTIFY SEQ=invoke_death TIME=0.473 FUNCTION=PlaySound_N ARG="WpnImpact"
#exec MESH NOTIFY SEQ=invoke_death TIME=0.473 FUNCTION=PlaySound_N ARG="GoreImpact"
#exec MESH NOTIFY SEQ=invoke_death TIME=0.780 FUNCTION=BFallBig

//****************************************************************************
// Member vars.
//****************************************************************************
var PersistentWound Wound;
var SPShield				Shield;
var() vector				ShieldOffset;
var() float					MinRangedDistance;
var() int					ShieldDispelLevel;

var SPSkullStorm skulls;
var SPEctoplasm ectoplasm;

function PreBeginPlay()
{
	super.PreBeginPlay();
	
	skulls = Spawn( Class'Aeons.SPSkullStorm', self,, JointPlace('L_Palm').Pos, ConvertQuat(JointPlace('L_Palm').rot) );
	if ( skulls != none )
	{
		skulls.SetBase( self, 'L_Palm', WeaponAttachJoint );
	}
	
	ectoplasm = Spawn( Class'Aeons.SPEctoplasm', self,, JointPlace('L_Palm').Pos, ConvertQuat(JointPlace('L_Palm').rot) );
	if ( ectoplasm != none )
	{
		ectoplasm.SetBase( self, 'L_Palm', WeaponAttachJoint );
	}
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	
	GotoState( 'AIFollowOwner' );
}

//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	if ( Rand(2) == 0 )
		PlayAnim( 'attack_sword1', 1.25 );
	else
		PlayAnim( 'attack_sword2', 1.25 );
}

function PlayTaunt()
{
	PlaySoundTaunt();
	PlayAnim( 'idle_laugh' );
}

function PlayVictoryDance()
{
	if ( FRand() < 0.25 )
		PlayAnim( 'idle_laugh' );
	else
		PlayWait();
}

//****************************************************************************
// Inherited functions.
//****************************************************************************#
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

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	return JointStrikeValid( Victim, 'l_wrist', DamageRadius );
}

function bool UseSpecialNavigation( NavigationPoint navPoint )
{
	local float		Dist;
	local name		SName;

	Dist = DistanceToPoint( navPoint.Location );
	SName = GetStateName();

	if ( ( AeonsCoverPoint(navPoint) != none ) &&
		 ( AeonsCoverPoint(navPoint) == CoverPoint ) &&
		 ( AeonsCoverPoint(navPoint).CrouchChance > 0.0 ) &&
		 ( Dist > 450.0 ) )
	{
		if ( ( ( SName == 'AIChargeCovered' ) && ( FRand() < 0.80 ) ) ||
			 ( ( SName == 'AIRetreat' ) && ( FRand() < 0.75 ) ) )
			return true;
	}

	if ( ( navPoint != none ) && ( Dist > 400.0 ) )
	{
		if ( ( ( SName == 'AIAvoidHazard' ) && ( FRand() < 0.80 ) ) ||
			 ( ( SName == 'AIChargeCovered' ) && ( FRand() < 0.20 ) ) ||
			 ( ( SName == 'AIRetreat' ) && ( FRand() < 0.75 ) ) )
			return true;
	}
	return false;
}

function bool AcknowledgeDamageFrom( pawn Damager )
{
	if ( Damager.IsA('PlayerPawn') )
		return false;
		
	if ( Damager != none )
		return !Damager.IsA(class.name);
	else
		return true;
}

function PreSetMovement()
{
	super.PreSetMovement();
	bCanSwim = true;
}

function bool CanBeInvoked()
{
	return false;
}

function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo )
{
	bSpecialInvoke = false;
	super.Died( Killer, damageType, HitLocation, DInfo );
}

function bool DoFarAttack()
{
	if ( Region.Zone.bWaterZone )
		return false;
	else
		return super.DoFarAttack();
}

function bool TriggerSwitchToRanged()
{
	if ( Region.Zone.bWaterZone )
		return false;
	else
		return super.TriggerSwitchToRanged();
}

function bool TriggerSwitchToMelee()
{
	if ( !bHasNearAttack && !bHasFarAttack )
		return true;
	return super.TriggerSwitchToMelee();
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
		local float dist;
		
		if ( NeedShieldCast() )
		{
			PushState( GetStateName(), 'RESUME' );
			StopMovement();
			GotoState( 'AICastShield' );
			return;
		}
		else
			super.Dispatch();
		
		dist = DistanceTo( Enemy );

		if ( dist > RangedSwitchDistance )
		{
			if ( abs( dist - DistanceTo(FindPlayer()) ) > 100.0 )
			{
				// player isn't close to the enemy
				skulls.FireProjectile();
				skulls.GenerateEffects();
				skulls.PlaySoundFiring();
				//ClipCount -= 1;
				ScriptedPawn(skulls.Owner).WeaponFired( skulls );
				//WeaponClass = Class'Aeons.SPRevolver';
			}
		}
		else
		{			
			ectoplasm.FireProjectile();
			//ectoplasm.GenerateEffects();
			ectoplasm.PlaySoundFiring();
			ScriptedPawn(ectoplasm.Owner).WeaponFired( ectoplasm );
			//WeaponClass = Class'Aeons.SPShotgun';
		}
		
		//RangedWeapon = Spawn( WeaponClass, self,, JointPlace(WeaponJoint).Pos, ConvertQuat(JointPlace(WeaponJoint).rot) );
		//RangedWeapon.SetBase( self, WeaponJoint, WeaponAttachJoint );
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

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	if ( Enemy != none )
		TurnToward( Enemy, 60 * DEGREES );
	//PlayAnim( 'defense_spell',, MOVE_None );
	CastShield();
	//FinishAnim();
	PopState();
} // state AICastShield

//****************************************************************************
// AISpecialNavigation
// Handle special navigation to SpecialNavPoint.
//****************************************************************************
state AISpecialNavigation
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function WarnAvoidActor( actor Other, float Duration, float Distance, float threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

	// *** new (state only) functions ***

BEGIN:
	if ( ( SpecialNavPoint == CoverPoint ) &&
		 ( CoverPoint.CrouchChance > 0.0 ) &&
		 ( DistanceToPoint( CoverPoint.Location ) > 450.0 ) )
		GotoState( 'AISpecialNavRoll' );
	else
		GotoState( 'AISpecialNavTrip' );
} // state AISpecialNavigation


//****************************************************************************
// AISpecialNavTrip
// Handle special navigation to SpecialNavPoint, using trip.
//****************************************************************************
state AISpecialNavTrip extends AISpecialNavigation
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	//
	function TripLanded()
	{
		StopMovement();
		GotoState( , 'TRIPPED' );
	}

	// *** new (state only) functions ***


RESUME:
	PopState();

BEGIN:
	TurnToward( SpecialNavPoint );
	TargetPoint = SpecialNavPoint.Location + Normal(Location - SpecialNavPoint.Location) * 350.0;
	PlayRun();
	MoveTo( TargetPoint, 1.0 );
	PlayAnim( 'trip' );
	MoveToward( SpecialNavPoint, 0.75 );
TRIPPED:
	FinishAnim();
	PlayAnim( 'get_up' );
	FinishAnim();
	PlayRun();
	MoveToward( SpecialNavPoint, 1.0 );
	PopState();
} // state AISpecialNavTrip


//****************************************************************************
// AISpecialNavRoll
// Handle special navigation to SpecialNavPoint, using tuck-roll.
//****************************************************************************
state AISpecialNavRoll extends AISpecialNavigation
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	//
	function RollLeaped()
	{
		GotoState( , 'LEAPED' );
	}

	function RollLanded()
	{
		StopMovement();
		GotoState( , 'LANDED' );
	}

	// *** new (state only) functions ***


RESUME:
	PopState();

BEGIN:
	TurnToward( SpecialNavPoint );
	TargetPoint = SpecialNavPoint.Location + Normal(Location - SpecialNavPoint.Location) * 450.0;
	PlayRun();
	MoveTo( TargetPoint, 1.0 );
	StopMovement();
	PlayWait();
	PlayAnim( 'tuck_roll' );

LEAPED:
	MoveToward( SpecialNavPoint, 0.60 );

LANDED:
	FinishAnim();
	SetCrouch();
	PlayWalk();
	MoveToward( SpecialNavPoint, WalkSpeedScale * 0.5 );
	PopState();
} // state AISpecialNavRoll


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
		return PlayAnim( 'draw_left', 1.50, MOVE_None );
	}

	function bool PlaySwitchToMelee()
	{
		return PlayAnim( 'draw_back', 1.50, MOVE_None );
	}

	// *** new (state only) functions ***
	function DrawWeaponLeft()
	{
		DebugInfoMessage( " revolver to hip" );
		RangedWeapon.SetBase( self, 'revolver_hip', 'revolveratt' );
	}

	function DrawWeaponBack()
	{
		DebugInfoMessage( " sword to hand" );
		MyProp[0].SetBase( self, 'swordhand', 'swordcontact' );
		PlaySound_P( "SwordWhsh PVar=0.2 V=0.8 VVar=0.2" );
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
		PlaySound_P( "SwordWhsh PVar=0.2 V=0.8 VVar=0.2" );
		return PlayAnim( 'draw_back', 1.50, MOVE_None );
	}

	function bool PlaySwitchToRanged()
	{
		return PlayAnim( 'draw_left', 1.50, MOVE_None );
	}

	// *** new (state only) functions ***
	function DrawWeaponLeft()
	{
		DebugInfoMessage( " revolver to hand" );
		RangedWeapon.SetBase( self, 'l_palm', 'revolveratt' );
	}

	function DrawWeaponBack()
	{
		DebugInfoMessage( " sword to back" );
		MyProp[0].SetBase( self, 'sword_back', 'swordcontact' );
	}

} // state AISwitchToRanged


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool TriggerSwitchToMelee()
	{
		return ( bHasFarAttack && bCanSwitchToMelee );
	}

	function PostSpecialKill()
	{
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
		GotoState( , 'SPECIALANIM' );
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

		DVect = AActor.Location - Location;
		DVect.Z = Location.Z;
		return Location - DVect;
	}

	function SetOrientation()
	{
		local vector	DVect;

		SetLocation( SK_WorldLoc );
		DVect = SK_WorldLoc - SK_TargetPawn.Location;
		DVect.Z = 0;
		DesiredRotation = rotator(DVect);
		SetRotation( DesiredRotation );
	}

	function StartSequence()
	{
		GotoState( , 'TRSANTISTART' );
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
		Blood.SetBase( SK_TargetPawn, 'pelvis', 'root' );
	}

	function OJDidItAgain()
	{
		PlayerBleedOutFromJoint( 'pelvis' );
	}


TRSANTISTART:
	NoLook();
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'trsanti_grunt_death', [TweenTime] 0.0  );
	PlayAnim( 'special_kill', [TweenTime] 0.0  );
	FinishAnim();
	goto 'LOST';

SPECIALANIM:
	if ( TriggerSwitchToMelee() )
	{
		PushState( GetStateName(), 'DOTAUNT' );
		GotoState( 'AISwitchToMelee' );
	}

DOTAUNT:
	PlayAnim( 'taunt_sword_start' );
	Sleep( 2.25 );
	PlayAnim( 'taunt_sword_end' );
	FinishAnim();
	PlayWait();

} // state AISpecialKill


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***
	function Invoke( actor Other );
	
	// *** overridden functions ***

	// *** new (state only) functions ***
	function BleedOut()
	{
		local vector	DVect;
		local vector	HitLocation, HitNormal;
		local int		HitJoint;
		local Actor		A;

		DVect = JointPlace('head').pos;
		A = Trace( HitLocation, HitNormal, HitJoint, DVect + vect(0,0,-256), DVect, true );
		if ( A != none )
			Spawn( class'BloodDripDecal',,, HitLocation, rotator(HitNormal) );
	}

} // state Dying

//****************************************************************************
// def props
//****************************************************************************

defaultproperties
{
     MyPropInfo(0)=(Prop=Class'Aeons.TrsantiSword',PawnAttachJointName=Sword_Back,AttachJointName=ScytheContact)
     LongRangeDistance=1500
     Aggressiveness=1
     bHasNearAttack=False
     bHasFarAttack=True
     bUseCoverPoints=True
     MeleeInfo(0)=(Damage=35,EffectStrength=0.25,Method=RipSlice)
     WeaponClass=Class'Aeons.SPRevolver'
     WeaponAttachJoint=RevolverAtt
     WeaponAccuracy=1.0
     bCanSwitchToMelee=True
     bCanSwitchToRanged=True
     MeleeSwitchDistance=150
     RangedSwitchDistance=300
	 bIllumCrosshair=False
	 FollowDistance=150
     DamageRadius=95
     SK_PlayerOffset=(X=60)
     bHasSpecialKill=False
     SK_WalkDelay=8
     HearingEffectorThreshold=0.2
     VisionEffectorThreshold=0.2
     WalkSpeedScale=0.75
     bGiveScytheHealth=False
     bSpecialInvoke=False
     MeleeRange=70
     GroundSpeed=440
     AccelRate=2048
     Alertness=1
     SightRadius=1500
     PeripheralVision=0.5
     BaseEyeHeight=54
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.BotSoundSet'
     FootSoundClass=Class'Aeons.DefaultFootSoundSet'
     Buoyancy=100
     RotationRate=(Pitch=8000)
     Mesh=SkelMesh'Aeons.Meshes.TrsantiGrunt_m'
     CollisionRadius=32
     CollisionHeight=64
	 AttitudeToPlayer=ATTITUDE_Follow
	 bIsPlayer=True
	 PlayerReplicationInfoClass=Class'PlayerReplicationInfo'
	 ShieldOffset=(X=30)
     MinRangedDistance=400
     ShieldDispelLevel=3
	 Mass=1000
}