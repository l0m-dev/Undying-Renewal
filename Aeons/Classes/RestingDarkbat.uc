//=============================================================================
// RestingDarkbat.
//=============================================================================
class RestingDarkbat expands Darkbat;


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function SnapToIdle()
{
	LoopAnim( 'idle_hang',,,, 0.0 );
}

function PlayTaunt()
{
	PlayAnim( 'idle_wake' );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool DoEncounterAnim()
{
	return ( DefCon < 2 );
}

function PlayWait()
{
	if ( DefCon < 2 )
		LoopAnim( 'idle_hang' );
	else
		super.PlayWait();
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
// AIHangout
// wait for encounter at current location
//****************************************************************************
state AIHangout
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}

	// *** overridden functions ***
	function DefConChanged( int OldValue, int NewValue )
	{
//		PlayWait();
	}

	// *** new (state only) functions ***


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
} // state AIHangout


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     OrderState=AIHangout
}
