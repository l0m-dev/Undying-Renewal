//=============================================================================
// Jile_Tentacle.
//=============================================================================
class Jile_Tentacle expands Jile;

//#exec MESH IMPORT MESH=Jile_Tentacle_m SKELFILE=Jile_Tentacle.ngf

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=tentacle_snap TIME=0.656 FUNCTION=DoNearDamage	//
//#exec MESH NOTIFY SEQ=tentacle_snap TIME=0.688 FUNCTION=DoNearDamage	//
//#exec MESH NOTIFY SEQ=tentacle_snap TIME=0.719 FUNCTION=DoNearDamage	//
//#exec MESH NOTIFY SEQ=tentacle_snap TIME=0.750 FUNCTION=DoNearDamage	//
//#exec MESH NOTIFY SEQ=tentacle_snap TIME=0.781 FUNCTION=DoNearDamage	//
//#exec MESH NOTIFY SEQ=tentacle_snap TIME=0.813 FUNCTION=DoNearDamage	//
//#exec MESH NOTIFY SEQ=tentacle_snap TIME=1.000 FUNCTION=PlaySnap		//

////#exec MESH NOTIFY SEQ=Tentacle_Die TIME=0.0 FUNCTION=PlaySound_N ARG="Die PVar=0.2"
//#exec MESH NOTIFY SEQ=Tentacle_Grow TIME=0.0 FUNCTION=PlaySound_N ARG="Grow PVar=0.2"
//#exec MESH NOTIFY SEQ=Tentacle_Idle TIME=0.0238095 FUNCTION=PlaySound_N ARG="Mvmt CHANCE=0.8 PVar=0.2 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=Tentacle_Snap TIME=0.125 FUNCTION=PlaySound_N ARG="Snap PVar=0.2"
//#exec MESH NOTIFY SEQ=Tentacle_Wild TIME=0.0769231 FUNCTION=PlaySound_N ARG="Mvmt CHANCE=0.7 PVar=0.2 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=Tentacle_Sink TIME=0.0 FUNCTION=PlaySound_N ARG="Grow PVar=0.2"
//#exec MESH NOTIFY SEQ=special_kill TIME=0.000 FUNCTION=PlaySound_N ARG="SPKill"
//#exec MESH NOTIFY SEQ=special_kill TIME=0.596 FUNCTION=PlaySound_N ARG="PatDeath"


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'tentacle_die',, MOVE_None );
}

function PlayWaiting()
{
	LoopAnim( 'tentacle_idle' );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool NearStrikeValid( actor Victim, int DamageNum )
{
	return JointStrikeValid( Victim, 'bone30', DamageRadius );
}

function bool CanTurnTo( vector OtherLoc )
{
	return true;
}

function bool CanTurnToward( actor Other )
{
	return true;
}

function CommMessage( actor sender, string message, int param )
{
	DebugInfoMessage( ".CommMessage( '" $ message $ "', " $ param $ " ) from " $ sender.name );
	if ( ( ( message == "DIED" ) && ( sender == Owner ) ) ||
		 ( message == "HALT" ) )
		Expire();
}

function FearThisSpot( actor ASpot )
{
}

//****************************************************************************
// New class functions.
//****************************************************************************
function Expire()
{
	TakeDamage( none, Location, vect(0,0,0), GetDamageInfo( 'suicide' ) );
}

function SlitherAway()
{
	GotoState( 'AISlitherAway' );
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AISpawn
// 
//****************************************************************************
auto state AISpawn
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function DelayedOrder( name OState, name OTag ){}

	// *** overridden functions ***

	// *** new (state only) functions ***


BEGIN:
	PlayAnim( 'tentacle_grow',, MOVE_None,, 0.0 );
	FinishAnim();
	GotoState( 'AIAttack' );
} // state AISpawn


//****************************************************************************
// AIAttack
// primary attack dispatch state
//****************************************************************************
state AIAttack
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Timer()
	{
		SlitherAway();
	}

	// *** new (state only) functions ***
	function PlaySnap()
	{
		PlayAnim( 'tentacle_snap', FVariant( 1.2, 0.2 ), MOVE_None );
	}


BEGIN:
	PlaySnap();
	SetTimer( 20.0, false );

RESUME:
TURRET:
	DebugInfoMessage( " distance to Enemy is " $ DistanceTo( Enemy ) );
	if ( ( Enemy == none ) || ( Enemy.Health <= 0.0 ) )
		goto 'WAIT';
	if ( DistanceTo( Enemy ) > 400.0 )
		SlitherAway();
	TurnToward( Enemy, 10 * DEGREES );
	Sleep( 0.1 );
	goto 'TURRET';

WAIT:
	PlayWait();
} // state AIAttack


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function bool CanBeInvoked()
	{
		return false;
	}

	function PostAnim()
	{
		SendCreatureComm( Owner, "DIED" );
	}

	function StartTimer()
	{
		SetTimer( FVariant( 5.0, 2.0 ), false );
	}

	// *** new (state only) functions ***

} // state Dying


//****************************************************************************
// AISlitherAway
// Slither into ground and disappear.
//****************************************************************************
state AISlitherAway
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function DelayedOrder( name OState, name OTag ){}

	// *** overridden functions ***

	// *** new (state only) functions ***

BEGIN:
	ShadowImportance = 0.0;
	PlayAnim( 'tentacle_sink',, MOVE_None );
	FinishAnim();
	SendCreatureComm( Owner, "DIED" );
	Destroy();

} // state AISlitherAway


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     OrderState=AISpawn
     FadeOutDelay=2
     FadeOutTime=1
     BaseEyeHeight=54
     Health=5
     RotationRate=(Yaw=60000)
     Mesh=SkelMesh'Aeons.Meshes.Jile_Tentacle_m'
     CollisionRadius=12
     CollisionHeight=40
}
