//=============================================================================
// Jile.
//=============================================================================
class Jile expands ScriptedPawn;

//#exec MESH IMPORT MESH=Jile_m SKELFILE=Jile.ngf
//#exec MESH ORIGIN MESH=Jile_m X=-10
//#exec MESH JOINTNAME Head2=Head

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=shoot TIME=0.615 FUNCTION=Spit
//#exec MESH NOTIFY SEQ=bite TIME=0.500 FUNCTION=DoNearDamage

//#exec MESH NOTIFY SEQ=Bite TIME=0.178571 FUNCTION=PlaySound_N ARG="Bite PVar=0.2"
//#exec MESH NOTIFY SEQ=Idle TIME=0.0196078 FUNCTION=PlaySound_N ARG="Mvmt CHANCE=0.8 PVar=0.2 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle TIME=0.0196078 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.3 PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Shoot TIME=0.0 FUNCTION=PlaySound_N ARG="Shoot PVar=0.2"
//#exec MESH NOTIFY SEQ=Taunt TIME=0.0454545 FUNCTION=PlaySound_N ARG="Taunt PVar=0.2"


//****************************************************************************
// Structure defs.
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************
var() vector				ProjOffset;			//
var() float					RootRadius;			//
var Jile_Tentacle			Tentacle[2];		//
var float					SpawnDelay;			//
var class<ScriptedPawn>		SKClass;			//
var() float					WeedBeGoneRadius;	//
var bool					bLobSpit;			//
var() float					LobScale;			//
var() float					LobAccuracy;		//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayStunDamage()
{
	PlayAnim( 'damage',, MOVE_None );
}

function PlayTaunt()
{
	PlayAnim( 'taunt',, MOVE_None );
}

function PlayNearAttack()
{
	PlayAnim( 'bite',, MOVE_None );
}

function PlayFarAttack()
{
	PlayAnim( 'shoot',, MOVE_None );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo)
{
	PlayAnim( 'death',, MOVE_None );
}


//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage PVar=0.2" );
}

function PlaySoundDeath()
{
	PlaySound_P( "VDeath PVar=0.2" );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool NearStrikeValid( actor Victim, int DamageNum )
{
	DebugInfoMessage( ".NearStrikeValid()" );
	return JointStrikeValid( Victim, 'head2', DamageRadius );
}

function bool CanTurnTo( vector OtherLoc )
{
	return false;
}

function bool CanTurnToward( actor Other )
{
	return false;
}

function Tick( float DeltaTime )
{
	Velocity = vect(0,0,0);
	super.Tick( DeltaTime );

	if ( SpawnDelay > 0.0 )
		SpawnDelay = FMax(SpawnDelay - DeltaTime, 0.0);
}

function CreatureBump( pawn Other )
{
	DebugInfoMessage( ".CreatureBump(), bumped by " $ Other.name );
}

function CommMessage( actor sender, string message, int param )
{
	local int	lp;

	DebugInfoMessage( ".CommMessage( '" $ message $ "', " $ param $ " ) from " $ sender.name );
	for ( lp=0; lp<ArrayCount(Tentacle); lp++ )
		if ( Jile_Tentacle(sender) == Tentacle[lp] )
			Tentacle[lp] = none;
}

function bool DoFarAttack()
{
	if ( FacingToward( Enemy.Location, 0.70 ) )
		return super.DoFarAttack();
	else
		return false;
}

function pawn ViewSKFrom()
{
	return SK_TargetPawn;
}

function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo )
{
	super.Died( Killer, damageType, HitLocation, DInfo );
	KillChildTentacles();
	KillAllTentacles();
}


//****************************************************************************
// New class functions.
//****************************************************************************
// Spawn long range projectile.
function Spit()
{
	local Projectile	SpitProj;
	local vector		TargetDirection;
	local rotator		LobRot;

	DebugInfoMessage( ".Spit() @" $ Level.TimeSeconds );
	SpitProj = Spawn( class'JileProjectile', self,, JointPlace('head2').pos + ProjOffset );
	if ( SpitProj != none )
	{
		if ( bLobSpit )
		{
			TargetDirection = vector(WeaponAimAt( Enemy, SpitProj.Location, LobAccuracy, true, SpitProj.Speed ));
			LobRot = rotator(TargetDirection);
			if ( ( LobRot.Pitch < 6300 ) || ( LobRot.Pitch > 49152 ) )
				LobRot.Pitch += 10000;
			SpitProj.Velocity = vector(LobRot) * SpitProj.Speed * LobScale;
		}
		else
		{
			TargetDirection = vector(WeaponAimAt( Enemy, SpitProj.Location, WeaponAccuracy, true, SpitProj.Speed ));
			SpitProj.Velocity = TargetDirection * SpitProj.Speed;
		}
		SpitProj.GotoState( 'FallingState' );
		SpitProj.SetPhysics( PHYS_Falling );
		SpitProj.Enable( 'Tick' );
		bLobSpit = !bLobSpit;
	}
}

function bool CanSpawnTentacle()
{
	local int	lp;

	if ( SpawnDelay <= 0.0 )
	{
		for ( lp=0; lp<ArrayCount(Tentacle); lp++ )
			if ( Tentacle[lp] == none )
				return true;
	}
	return false;
}

function KillChildTentacles()
{
	local int	lp;

	for ( lp=0; lp<ArrayCount(Tentacle); lp++ )
		if ( Tentacle[lp] != none )
			SendCreatureComm( Tentacle[lp], "DIED" );
}

function int GetAvailableTentacle()
{
	local int	lp;

	for ( lp=0; lp<ArrayCount(Tentacle); lp++ )
		if ( Tentacle[lp] == none )
			return lp;
	return -1;
}

function KillAllTentacles()
{
	local Jile_Tentacle		T;

	foreach AllActors( class'Jile_Tentacle', T )
		if ( ( T.Health > 0 ) &&
			 ( Jile(T.Owner) == none ) &&
			 ( DistanceTo( T ) < WeedBeGoneRadius ) )
			SendCreatureComm( T, "HALT" );
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIWait
// wait for encounter at current location
//****************************************************************************
state AIWait
{
	// *** ignored functions ***

	// *** overridden functions ***
	function TriggerEvent()
	{
		PlayTaunt();
	}

	function CueNextEvent()
	{
		SetTimer( FVariant( 20.0, 5.0 ), false );
	}

	// *** new (state only) functions ***

} // state AIWait


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
		local float		dist;
		local bool		bFarAttack;

		dist = DistanceTo( Enemy );
		bFarAttack = DoFarAttack();

		if ( dist <= ( MeleeRange * 1.35 ) )
		{
			if ( FastTrace( Location, Enemy.Location ) )
			{
				GotoState( 'AINearAttack' );
			}
		}
		else if ( ( dist < RootRadius ) && CanSpawnTentacle() )
			GotoState( 'AITentAttack' );
		else if ( bFarAttack )
			GotoState( 'AIFarAttack' );
		else
			GotoState( 'AIForfeit' );
	}

	// *** new (state only) functions ***

} // state AIAttack


//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function EnemyNotVisible(){}

	// *** overridden functions ***

	// *** new (state only) functions ***
	function AnimFinished()
	{
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Default entry point.
BEGIN:
	StopMovement();
	bLobSpit = true;
	PlayFarAttack();
	FinishAnim();
	PlayWait();
	Sleep( FVariant( 0.6, 0.2 ) );
	PlayFarAttack();
	FinishAnim();
	AnimFinished();

// Entry point when resuming this state.
RESUME:
	GotoState( 'AIAttack' );

} // state AIFarAttackAnim


//****************************************************************************
// AITentAttack
// Tentacle attack
//****************************************************************************
state AITentAttack expands AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***
	function SpawnAttack()
	{
		local vector			X, Y, Z;
		local int				TNum;
		local Jile_Tentacle		T;
		local vector			EVect;
		local rotator			ARot;
		local texture			HitTexture;
		local int				Flags;
		local int				Tries;

		TNum = GetAvailableTentacle();
		if ( ( TNum >= 0 ) && ( Enemy != none ) )
		{
			Tries = 5;
			GetAxes( Enemy.Rotation, X, Y, Z );
			while ( Tries >= 0 )
			{
				if ( Tries == 0 )
					ARot = rotator(X);
				else
					ARot = rotator(-X);
				ARot.Yaw += IVariant( 0, 4000 );
				ARot.Pitch = 0;
				EVect = Enemy.Location + vect(0,0,50) + vector(ARot) * FVariant( 175.0, 25.0 );
				EVect = GetTentacleSpawnPoint( EVect );
				HitTexture = TraceTexture( EVect - vect(0,0,100), EVect, Flags );
				if ( FastTrace( EVect, Enemy.Location ) &&
					 ( ( Flags & 131072 ) == 0 ) )
				{
					ARot.Yaw += 32768;
					T = Spawn( class'Jile_Tentacle', self,, EVect, ARot );
					if ( T != none )
					{
						T.SetEnemy( Enemy );
						Tentacle[TNum] = T;
						SpawnDelay = default.SpawnDelay;
						Tries = 0;
					}
				}
				Tries -= 1;
			}
		}
	}

	function vector GetTentacleSpawnPoint( vector ThisLoc )
	{
		local vector	HitLocation, HitNormal;
		local int		HitJoint;

		Trace( HitLocation, HitNormal, HitJoint, ThisLoc - vect(0,0,500), ThisLoc, false );
		return HitLocation + ( vect(0,0,1) * class'Jile_Tentacle'.default.CollisionHeight );
	}


BEGIN:
	if ( CanSpawnTentacle() )
		SpawnAttack();		// spawn a tentacle
	// wait for reply
	PlayWait();
	Sleep( 1.0 );
	GotoState( 'AIAttack' );
} // state AITentAttack


//****************************************************************************
// AIForfeit
// Forfeit attack
//****************************************************************************
state AIForfeit expands AIWait
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***

BEGIN:
	if ( FRand() < 0.20 )
	{
		PlayTaunt();
		FinishAnim();
	}
	SetEnemy( none );
	VisionEffector.SetSensorLevel( 0.0 );		// clear sensors
	HearingEffector.SetSensorLevel( 0.0 );
	GotoState( 'AIAmbush' );
} // state AIForfeit


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function PostAnim()
	{
		KillChildTentacles();
		KillAllTentacles();
	}

	// *** new (state only) functions ***

} // state Dying


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***

	// *** new (state only) functions ***
	function SpawnNoose()
	{
		local vector		X, Y, Z;
		local vector		DVect;
		local rotator		DRot;
		local ScriptedPawn	SP;

		GetAxes( SK_TargetPawn.Rotation, X, Y, Z );
		DVect = SK_TargetPawn.Location + ( SK_PlayerOffset.X * X ) + ( SK_PlayerOffset.Y * Y ) + ( SK_PlayerOffset.Z * Z );
		DVect = CalcGroundPoint( DVect, SKClass.default.CollisionHeight );
		DRot = rotator(SK_TargetPawn.Location - DVect);
		DRot.Pitch = 0;
		SP = Spawn( SKClass,,, DVect, DRot );
		if ( SP != none )
			SP.SK_TargetPawn = SK_TargetPawn;
		else
			DebugInfoMessage( " ********** couldn't spawn noose!!!" );
	}

	function vector CalcGroundPoint( vector thisLocation, float thisHeight )
	{
		local actor		HitActor;
		local vector	HitLocation, HitNormal;
		local int		HitJoint;

		HitActor = Trace( HitLocation, HitNormal, HitJoint, thisLocation + vect(0,0,-500), thisLocation, false );
		return HitLocation + ( vect(0,0,1) * thisHeight );
	}


BEGIN:
	KillChildTentacles();
	PlayWait();
	Sleep( 3.0 );
	SpawnNoose();
	Sleep( 3.0 );

} // state AISpecialKill


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     ProjOffset=(Z=15)
     RootRadius=1000
     SpawnDelay=1.5
     SKClass=Class'Aeons.JileNoose'
     WeedBeGoneRadius=1000
     LobScale=0.3
     LobAccuracy=0.5
     LongRangeDistance=1300
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=10,EffectStrength=0.1,Method=Bite)
     WeaponAccuracy=0.65
     DamageRadius=75
     SK_PlayerOffset=(X=-50,Y=-15)
     bHasSpecialKill=True
     bGiveScytheHealth=True
     PhysicalScalar=0.25
     MagicalScalar=0.25
     FireScalar=2
     bNoBloodPool=True
     bHackable=False
     MeleeRange=50
     SightRadius=3250
     BaseEyeHeight=30
     Health=50
     SoundSet=Class'Aeons.JileSoundSet'
     PE_StabEffect=Class'Aeons.JileBloodPuffFX'
     PE_BiteEffect=Class'Aeons.JileBloodPuffFX'
     PE_BluntEffect=Class'Aeons.JileBloodPuffFX'
     PE_BulletEffect=Class'Aeons.JileBloodPuffFX'
     PE_RipSliceEffect=Class'Aeons.JileBloodPuffFX'
     PE_GenLargeEffect=Class'Aeons.JileBloodPuffFX'
     PE_GenMediumEffect=Class'Aeons.JileBloodPuffFX'
     PE_GenSmallEffect=Class'Aeons.JileBloodPuffFX'
     RotationRate=(Yaw=0)
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Jile_m'
     CollisionRadius=26
     CollisionHeight=36
     Mass=2000
}
