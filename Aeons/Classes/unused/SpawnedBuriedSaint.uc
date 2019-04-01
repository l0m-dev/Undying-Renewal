//=============================================================================
// SpawnedBuriedSaint.
//=============================================================================
class SpawnedBuriedSaint expands BuriedSaint;


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function Generated()
{
	super.Generated();
	GotoState( 'AIEmerge' );
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
// AIEmerge
// Emerge, then attack.
//****************************************************************************
state AIEmerge
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
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		if ( !bHasAwakened )
		{
			if ( !bInitialShadow )
				ShadowImportance = -1.0;
			PlayAnim( InitialAnim, 20.0, MOVE_None,, 0.0 );
		}
	}

	// *** new (state only) functions ***

BEGIN:
	Sleep( 0.25 );
	PlayAnim( AwakenAnim,, MOVE_None );
	FinishAnim();
	GotoState( 'AIHuntPlayer' );

} // state AIEmerge



//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
}
