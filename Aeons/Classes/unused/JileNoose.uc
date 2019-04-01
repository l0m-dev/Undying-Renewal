//=============================================================================
// JileNoose.
//=============================================================================
class JileNoose expands Jile_Tentacle;


//****************************************************************************
// Member vars.
//****************************************************************************

//****************************************************************************
// Inherited functions.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************


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
	SK_TargetPawn.PlayAnim( 'jile_death' );
	PlayAnim( 'special_kill',, MOVE_None,, 0.0 );
	FinishAnim();
	PlayWait();
	SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );

} // state AISpawn


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
}
