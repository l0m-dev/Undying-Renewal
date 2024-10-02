//=============================================================================
// Inhabitant.
//=============================================================================
class Inhabitant expands ScriptedPawn;

//#exec MESH IMPORT MESH=Inhabitant_m SKELFILE=Inhabitant.ngf
//#exec MESH MODIFIERS R_Pelvis_Cloth1:Cloth L_Leg_Cloth1:Cloth R_Chest_Cloth1:Cloth L_Arm_Cloth1:Cloth

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=attack2 TIME=0.500 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=death1 TIME=1.000 FUNCTION=death2
//#exec MESH NOTIFY SEQ=death2 TIME=1.000 FUNCTION=death2
//#exec MESH NOTIFY SEQ=mindshatter TIME=0.875 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=jumpstart TIME=1.000 FUNCTION=jumpcycle
//#exec MESH NOTIFY SEQ=jumpcycle TIME=1.000 FUNCTION=jumpcycle
//#exec MESH NOTIFY SEQ=jumpstart TIME=0.500 FUNCTION=TriggerJump
//#exec MESH NOTIFY SEQ=specialkill TIME=0.100 FUNCTION=OJDidIt

//#exec MESH NOTIFY SEQ=Attack1 TIME=0.0384615 FUNCTION=PlaySound_N ARG="AttackClaw PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack1 TIME=0.461538 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Attack1 TIME=0.576923 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.0789474 FUNCTION=PlaySound_N ARG="AttackClaw PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.631579 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Attack2 TIME=0.684211 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Death1 TIME=0.0625 FUNCTION=PlaySound_N ARG="Stun PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death1 TIME=0.375 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death1 TIME=0.75 FUNCTION=C_Bodyfall
//#exec MESH NOTIFY SEQ=Death2 TIME=0.0222222 FUNCTION=PlaySound_N ARG="DeathStruggle PVar=0.25 V=1.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death2 TIME=0.0222222 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death2 TIME=0.288889 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death2 TIME=0.488889 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death3 TIME=0.0172414 FUNCTION=PlaySound_N ARG="Death PVar=0.25 V=1.4 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death3 TIME=0.689655 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.185185 FUNCTION=C_BackLeft	//
//#exec MESH NOTIFY SEQ=Hunt TIME=0.740741 FUNCTION=C_BackRight	//
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.855556 FUNCTION=PlaySound_N ARG="ShortVocal CHANCE=0.4 PVar=0.25 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=idle_alert TIME=0.0111111 FUNCTION=PlaySound_N ARG="Sleep CHANCE=0.4 PVar=0.25 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle4 TIME=0.0111111 FUNCTION=PlaySound_N ARG="Sleep CHANCE=0.4 PVar=0.25 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle5 TIME=0.0111111 FUNCTION=PlaySound_N ARG="ShortVocal CHANCE=0.4 PVar=0.25 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle5 TIME=0.0111111 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle5 TIME=0.277778 FUNCTION=PlaySound_N ARG="ShortVocal CHANCE=0.4 PVar=0.25 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle5 TIME=0.277778 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle5 TIME=0.533333 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle5 TIME=0.777778 FUNCTION=PlaySound_N ARG="ShortVocal CHANCE=0.4 PVar=0.25 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle5 TIME=0.777778 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=JumpEnd TIME=0.0625 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=JumpEnd TIME=0.25 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=JumpEnd TIME=0.4375 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=JumpStart TIME=0.1875 FUNCTION=PlaySound_N ARG="ShortVocal CHANCE=0.4 PVar=0.25 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=JumpStart TIME=0.25 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Mindshatter TIME=0.0151515 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Mindshatter TIME=0.0909091 FUNCTION=PlaySound_N ARG="MindShatter PVar=0.25 V=1.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Mindshatter TIME=0.106061 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Mindshatter TIME=0.863636 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.010101 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.10101 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.121212 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.131313 FUNCTION=PlaySound_N ARG="Bite PVar=0.25 V=1.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.191919 FUNCTION=PlaySound_N ARG="Bite PVar=0.25 V=1.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.30303 FUNCTION=PlaySound_N ARG="Bite PVar=0.25 V=1.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.383838 FUNCTION=PlaySound_N ARG="Bite PVar=0.25 V=1.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.424242 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.436 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.636364 FUNCTION=PlaySound_N ARG="Bite PVar=0.25 V=1.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=SpecialKill TIME=0.767677 FUNCTION=PlaySound_N ARG="Bite PVar=0.25 V=1.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Stun TIME=0.0166667 FUNCTION=PlaySound_N ARG="Stun PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Stun TIME=0.383333 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Stun TIME=0.45 FUNCTION=PlaySound_N ARG="ShortVocal PVar=0.25 V=0.75 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt1 TIME=0.166667 FUNCTION=PlaySound_N ARG="Taunt PVar=0.2 V=2.0 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt2 TIME=0.0833333 FUNCTION=PlaySound_N ARG="ShortVocal PVar=0.25 V=1.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt2 TIME=0.0833333 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt2 TIME=0.308333 FUNCTION=PlaySound_N ARG="ShortVocal CHANCE=0.4 PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Taunt2 TIME=0.541667 FUNCTION=PlaySound_N ARG="ShortVocal CHANCE=0.4 PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn TIME=0.5 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Turn TIME=0.55 FUNCTION=C_BareFS
//#exec MESH NOTIFY SEQ=Wake TIME=0.0333333 FUNCTION=PlaySound_N ARG="ShortVocal PVar=0.25 V=1.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=Wake TIME=0.0333333 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Wake TIME=0.366667 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=search1 TIME=0.026 FUNCTION=PlaySound_N ARG="ShortVocal PVar=0.25 V=1.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=search1 TIME=0.256 FUNCTION=C_BackLeft	//
//#exec MESH NOTIFY SEQ=search1 TIME=0.436 FUNCTION=C_BackLeft	//


//****************************************************************************
// Member vars.
//****************************************************************************
var float					DyingAnimDelay;		//
var float					IdleDelay;			//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	if (RGC())
		PlayAnim( 'attack2', 2.0 );
	else
		PlayAnim( 'attack2' );
}

function PlayFarAttack()
{
	PlayAnim( 'mindshatter' );
}

function PlayStunDamage()
{
	PlayAnim( 'stun' );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'death1',, MOVE_None );
}

function PlayTaunt()
{
	if ( Rand(2) == 0 )
		PlayAnim( 'taunt1' );
	else
		PlayAnim( 'taunt2' );
}

function PlayGreeting()
{
	PlayAnim( 'idle5' );
}

function PlayAwaken()
{
	PlayAnim( 'wake' );
}

function PlayJump()
{
	PlayAnim( 'jumpstart',, MOVE_None );
}

function bool PlayLanding()
{
	return PlayAnim( 'jumpend',, MOVE_None );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	if (RGC())
	{
		FollowDistance = 310;
		GreetDistance = 80;
		MeleeInfo[0].Damage = 25;
		DamageRadius = 95;
		MeleeRange = 70;
		WeaponAccuracy = 1.0;
	}
	super.PreBeginPlay();
	if ( SPMindshatter(RangedWeapon) != none )
		SPMindshatter(RangedWeapon).ProjAmplitude = 3;
}

function bool DoEncounterAnim()
{
	return true;
}

function bool DoAwakenAnim()
{
	return true;
}

function bool DoWeaponAttack()
{
	if ( ( Enemy != none ) &&
		 ( AeonsPlayer(Enemy) != none ) &&
		 ( AeonsPlayer(Enemy).MindshatterMod != none ) &&
		 AeonsPlayer(Enemy).MindshatterMod.bActive )
	{
		DebugInfoMessage( ".DoWeaponAttack() not attacking as player is mindshattered" );
		return false;
	}
	else
		return super.DoWeaponAttack();
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	return JointStrikeValid( Victim, 'l_ankle', DamageRadius );
}

function ReactToDamage( pawn Instigator, DamageInfo DInfo )
{
	super.ReactToDamage( Instigator, DInfo );
	SendClassComm( class'Inhabitant', "ATTACKED" );
}

function CommMessage( actor sender, string message, int param )
{
	DebugInfoMessage( ".CommMessage() '" $ message $ "' from " $ sender.name $ ", DefCon is " $ DefCon );
	if ( ( sender != self ) &&
		 ( Health > 0.0 ) &&
		 ( message == "ATTACKED" ) &&
		 ( DefCon < 5 ) )
	{
		SensedActor = ScriptedPawn(sender).SensedActor;
		SensedSense = 'CommMessage';
		CheckHatedEnemy( pawn(SensedActor) );
		GotoState( 'AIEncounter' );
	}
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
// AIFollow
// follow the TargetActor actor
//****************************************************************************
state AIFollow
{
	// *** ignored functions ***

	// *** overridden functions ***
	function AtPoint()
	{
		if ( FRand() < 0.25 )
			GotoState( 'AIGreet' );
	}

	function WaitPoint()
	{
		if ( IdleDelay <= 0.0 )
		{
			IdleDelay = FVariant( 4.0, 1.0 );
			if ( FRand() < 0.25 )
				GotoState( , 'PLAYIDLE' );
		}
	}

	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		if ( IdleDelay > 0.0 )
			IdleDelay -= DeltaTime;
	}

	// *** new (state only) functions ***

PLAYIDLE:
	PlayAnim( 'search1' );
	FinishAnim();
	goto 'ATPOINT';
} // state AIFollow


//****************************************************************************
// AIFireSpell
// Fire spell weapon and return via state stack.
//****************************************************************************
state AIFireSpell
{
	// *** ignored functions ***
	function TakeMindshatter( pawn Instigator, int castingLevel ){}

	// *** overridden functions ***
	function WeaponFired( SPWeapon ThisWeapon )
	{
		StopFiring();
		GotoState( , 'FIRED' );
	}

	// *** new (state only) functions ***
	function FireSpell()
	{
		GotoState( , 'FIRESPELL' );
	}


// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	TurnTo( EnemyAimSpot(), 10 * DEGREES );
	PlayFarAttack();

TURRET:
	TurnTo( EnemyAimSpot(), 10 * DEGREES );
	Sleep( 0.1 );
	goto 'TURRET';

FIRESPELL:
	FireWeapon();
	goto 'END';

FIRED:
	FinishAnim();
	PopState();

END:
} // state AIFireSpell


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Tick( float DeltaTime )
	{
		if ( DyingAnimDelay > 0.0 )
		{
			DyingAnimDelay -= DeltaTime;
			if ( DyingAnimDelay <= 0.0 )
				PlayAnim( 'death3' );
		}
		super.Tick( DeltaTime );
	}

	function PostAnim()
	{
		DyingAnimDelay = FVariant( 1.75, 0.25 );
	}

	// *** new (state only) functions ***

} // state Dying


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** ignored functions ***

	// *** overridden functions ***
	function PostSpecialKill()
	{
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
		GotoState( 'AIWait' );
	}

	function StartSequence()
	{
		GotoState( , 'INHABSTART' );
	}

	// *** new (state only) functions ***
	function OJDidIt()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('head').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect + vect(0,0,20), rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'head', 'root');
	}


INHABSTART:
	DebugDistance( "before anim" );
	PlayAnim( 'taunt1' );
	Sleep( 1.5 );
	SK_TargetPawn.PlayAnim( 'death_gun_back' );
	FinishAnim();
	PlayAnim( 'idle1' );
	Sleep( 0.5 );
	PlayAnim( 'specialkill' );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// AINearAttack
// attack near enemy (melee)
//****************************************************************************
state AINearAttack
{
	// *** overridden functions ***
	function bool MoveInAttack()
	{
		if (RGC())
			return true;
		return Super.MoveInAttack();
	}

	function PostAttack()
	{
		if (RGC() && bDidMeleeDamage)
		{
			PushState( 'AIAttack', 'BEGIN' );
			GotoState( 'AIQuickTaunt' );
		}
		else
		{
			super.PostAttack();
		}
	}

	// *** new (state only) functions ***

} // state AINearAttack


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     FollowDistance=300
     GreetDistance=60
     JumpDownDistance=350
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=25,EffectStrength=0.15,Method=RipSlice)
     WeaponClass=Class'Aeons.SPMindshatter'
     WeaponAccuracy=0.5
     DamageRadius=50
     SK_PlayerOffset=(X=250)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.85
     bGiveScytheHealth=True
     FallDamageScalar=0.2
     MeleeRange=60
     GroundSpeed=500
     AirSpeed=700
     AccelRate=2000
     MaxStepHeight=30
     SightRadius=1500
     BaseEyeHeight=34
     AttitudeToPlayer=ATTITUDE_Friendly
     SoundSet=Class'Aeons.InhabitantSoundSet'
     FootSoundClass=Class'Aeons.BareFootSoundSet'
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.Inhabitant_m'
     CollisionRadius=20
     CollisionHeight=38
     MenuName="Inhabitant"
     CreatureDeathVerb="warped"
}
