//=============================================================================
// HowlerHanging.
//=============================================================================
class HowlerHanging expands Howler;


//****************************************************************************
// Member vars.
//****************************************************************************
var() name					HuntState;			//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function SnapToIdle()
{
	LoopAnim( 'idle_alert_hang',,,, 0.0 );
}


//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function PreBeginPlay()
{
	local rotator	XRot;

	super.PreBeginPlay();

	// If the Howler wasn't flipped in the editor, do it now.
	if ( Rotation.Roll == 0 )
	{
		XRot = Rotation;
		XRot.Roll = default.Rotation.Roll;
		SetRotation( XRot );
	}
}

function SetInitialState()
{
	super.SetInitialState();
	SetPhysics( PHYS_None );
}

// Determine if this encounter should be handled specially.
function bool HandleSpecialEncounter( actor Other )
{
	if ( ( Physics == PHYS_None ) && ( PlayerPawn(Other) != none ) )
	{
		SetFall();
		PlayInAir();
		GotoState( 'AIFall' );
		return true;
	}
	return false;
}

function PlayWait()
{
	DebugInfoMessage( ".PlayWait(), PH=" $ Physics );
	if ( Physics == PHYS_None )
		LoopAnim( 'idle_alert_hang' );
	else
		super.PlayWait();
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************


//****************************************************************************
// AIFallToHunt
//****************************************************************************
state AIFallToHunt
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
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***

	// *** new (state only) functions ***

BEGIN:
	if ( Physics == PHYS_None )
	{
		SetFall();
		PlayInAir();
		GotoState( 'AIFall' );
	}

RESUME:
	if ( HuntState != '' )
		GotoState( HuntState );
	else
		GotoState( 'AIWait' );

} // state AIFallToHunt


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     HuntState=AIHuntPlayer
     OrderState=AIWait
     FallDamageScalar=0.05
     Rotation=(Roll=32768)
     RotationRate=(Roll=9000)
}
