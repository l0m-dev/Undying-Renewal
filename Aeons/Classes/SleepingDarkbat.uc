//=============================================================================
// SleepingDarkbat.
//=============================================================================
class SleepingDarkbat expands RestingDarkbat;


//****************************************************************************
// Member vars.
//****************************************************************************
var() float					InitHearingEffectorThreshold;	//
var() float					InitVisionEffectorThreshold;	//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	HearingEffectorThreshold = InitHearingEffectorThreshold;
	VisionEffectorThreshold = InitVisionEffectorThreshold;
	super.PreBeginPlay();
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

	// *** overridden functions ***
	function EndState()
	{
		super.EndState();
		HearingEffectorThreshold = default.HearingEffectorThreshold;
		VisionEffectorThreshold = default.VisionEffectorThreshold;
		SetAlertness( Alertness );
	}

	// *** new (state only) functions ***

} // state AIHangout


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     InitHearingEffectorThreshold=3.5
     InitVisionEffectorThreshold=4
}
