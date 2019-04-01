//=============================================================================
// SPHazardEffector.
//=============================================================================
class SPHazardEffector expands SPEffector;

//****************************************************************************
// This effector class is used to mark an actor that the ScriptedPawn needs
// to keep track of and attempt to avoid
//****************************************************************************


//****************************************************************************
// member vars
//****************************************************************************

var actor					TrackingActor;		// the actor this effector is tracking
var float					AvoidDistance;		// try to stay at least this far away
var bool					bAutoExpire;		// expire when the TrackingActor expires


//****************************************************************************
// inherited member funcs
//****************************************************************************

// handle per-frame tick
function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	if ( bAutoExpire && ( ( TrackingActor == none ) || ( TrackingActor.bDeleteMe ) ) )
		Lifespan = 0.0001;	// if the hazard has been removed, the effector should expire
}


//****************************************************************************
// new member funcs
//****************************************************************************

//
function Init( actor tActor, float Duration, float Distance, optional bool Expire )
{
	TrackingActor = tActor;
	AvoidDistance = Distance;
	bAutoExpire = Expire;
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
