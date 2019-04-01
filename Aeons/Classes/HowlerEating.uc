//=============================================================================
// HowlerEating.
//=============================================================================
class HowlerEating expands Howler;


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
	function Timer()
	{
		if ( DefCon <= 1 )
		{
			TriggerEvent();
			GotoState( , 'ANIMWAIT' );
		}
		else
			GotoState( , 'ALERT' );
	}

	function TriggerEvent()
	{
		DebugInfoMessage( ".HowlerEating.TriggerEvent(), DefCon is " $ DefCon );
		if ( DefCon > 1 )
			super.TriggerEvent();
		else
		{
			if ( FRand() < 0.70 )
				PlayAnim( 'eat_at_corpse', [Rate] FVariant( 0.9, 0.1 ) );
			else
				PlayAnim( 'idle_alert' );
		}
	}

	//
	function CueNextEvent()
	{
//		DebugInfoMessage( ".HowlerEating.AIWait.CueNextEvent()" );
		SetTimer( FVariant( 0.15, 0.05 ), false );
	}

	// *** new (state only) functions ***

WAIT:
} // state AIWait


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     OrderState=AIWait
}
