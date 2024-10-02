//=============================================================================
// TriggeredSaint.
//=============================================================================
class TriggeredSaint expands DecayedSaint
	abstract;


//****************************************************************************
// Member vars.
//****************************************************************************
var() name					InitialAnim;		//
var() name					AwakenAnim;			//
var() bool					bInitialShadow;		//
var bool					bHasAwakened;		//
var actor					TriggerActor;		//
var pawn					TriggerPawn;		//


//****************************************************************************
// Inherited functions.
//****************************************************************************
function GenSpawnFX()
{
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
// AIWaitForTrigger
// wait for encounter at current location
//****************************************************************************
state AIWaitForTrigger
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
	function Falling(){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function LongFall(){}
	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo ){}
	function Killed( pawn Killer, pawn Other, name damageType ){}
	function KilledBy( pawn EventInstigator ){}
	function PainTimer(){}
	function HeadZoneChange( ZoneInfo newHeadZone ){}
	function FootZoneChange( ZoneInfo newFootZone ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat ){}
	function Ignited(){}
	function DelayedOrder( name OState, name OTag ){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		if ( !bHasAwakened )
		{
			SetCollision( false, false, false );
			if ( !bInitialShadow )
				ShadowImportance = -1.0;
			PlayAnim( InitialAnim, 20.0, MOVE_None,, 0.0 );
			NetUpdateFrequency = 8; // hack: since all anims loop in multiplayer, reduce NetUpdateFrequency to stop flickering
		}
	}

	function Trigger( actor Other, pawn EventInstigator )
	{
		TriggerActor = Other;
		TriggerPawn = EventInstigator;

		bHasAwakened = true;
		SetCollision( InitCollideActors, InitBlockActors, InitBlockPlayers );
		PushState( GetStateName(), 'AWAKENED' );
		GotoState( 'AIAwaken' );
		NetUpdateFrequency = default.NetUpdateFrequency;
	}

	// *** new (state only) functions ***

AWAKENED:
	ShadowImportance = default.ShadowImportance;
	super.Trigger( TriggerActor, TriggerPawn );

BEGIN:

} // state AIWaitForTrigger


//****************************************************************************
// AIAwaken
// Awaken and rise from ground.
//****************************************************************************
state AIAwaken
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorHearNoise( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function LookTargetNotify( actor Sender, float Duration ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Stoned( pawn Stoner ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		PushLookAt( none );
	}

	function EndState()
	{
		DebugEndState();
		PopLookAt();
	}

	// *** new (state only) functions ***

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	PlayAnim( AwakenAnim,, MOVE_None );
	FinishAnim();
	PopState();

} // state AIAwaken


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     InitialAnim=Death_Gun_Left
     AwakenAnim=get_up
     OrderState=AIWaitForTrigger
}
