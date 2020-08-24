//=============================================================================
// SPWarnCrouchEffector.
//=============================================================================
class SPWarnCrouchEffector expands SPEffector;

//****************************************************************************
// Takes information about a ScriptedPawn WarnPlayerCrouching event and
// "buffers" it until the effector expires
// When expiring, the effector checks to see if the ScriptedPawn should still
// be notified and, if so, passes the information back to the ScriptedPawn
//****************************************************************************


//****************************************************************************
// member vars
//****************************************************************************

var pawn					TrackingPawn;		// the pawn that generated the warning


//****************************************************************************
// new member funcs
//****************************************************************************

//
function Init( pawn tPawn )
{
	TrackingPawn = tPawn;
}


//****************************************************************************
// inherited member funcs
//****************************************************************************

// called immediately before removing from host
function Removing( pawn host )
{
	if ( ( TrackingPawn == host.Enemy ) &&
		 ( TrackingPawn.Health > 0 ) &&
		 ( AeonsPlayer(TrackingPawn) != none ) &&
		 AeonsPlayer(TrackingPawn).InCrouch() &&
		 ( ScriptedPawn(host) != none ) )
		ScriptedPawn(host).EffectorWarnPlayerCrouching( TrackingPawn );
}

//****************************************************************************
// def props
//****************************************************************************

defaultproperties
{
     EffectDuration=0.1
}
