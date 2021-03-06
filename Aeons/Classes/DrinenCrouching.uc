//=============================================================================
// DrinenCrouching.
//=============================================================================
class DrinenCrouching expands Drinen;


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Inherited member funcs.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIWait
// Wait for encounter at current location.
//****************************************************************************
state AIWait
{
	// *** ignored functions ***

	// *** *** overridden functions *** ***
	//
	function TriggerEvent()
	{
		if ( DefCon == 0 )
			PlayAnim( 'idle_search',, MOVE_None );
		else
			super.TriggerEvent();
	}

	//
	function CueNextEvent()
	{
		SetTimer( FVariant( 5.0, 2.0 ), false );
	}

	function PlayWaitAnim()
	{
		if ( DefCon == 0 )
			LoopAnim( 'idle_inquisitive' );
		else
			PlayWait();
	}

	// *** new (state only) functions ***

} // state AIWait


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     OrderState=AIWait
}
