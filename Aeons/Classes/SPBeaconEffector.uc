//=============================================================================
// SPBeaconEffector.
//=============================================================================
class SPBeaconEffector expands SPEffector;

//****************************************************************************
// This effector class is used to mark an actor that the ScriptedPawn needs
// to keep track of and attempt to reach
//****************************************************************************


//****************************************************************************
// member vars
//****************************************************************************

var actor					TrackingActor;		// the actor this effector is tracking

//****************************************************************************
// new member funcs
//****************************************************************************

//
function Init( actor tActor, float Duration )
{
	TrackingActor = tActor;
	SetDuration( Duration );
}

function actor GetTrackingActor()
{
	return TrackingActor;
}

//****************************************************************************
// def props
//****************************************************************************

defaultproperties
{
}
