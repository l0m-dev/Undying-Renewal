//=============================================================================
// SPWarnTargetEffector.
//=============================================================================
class SPWarnTargetEffector expands SPEffector;

//****************************************************************************
// Takes information about a ScriptedPawn WarnTarget event and "buffers" it
// until the effector expires.
// When expiring, the effector passes the information back to the ScriptedPawn.
//****************************************************************************


//****************************************************************************
// member vars
//****************************************************************************

var vector					PawnLocation;		// Location of pawn that shot the projectile.
var float					ProjectileSpeed;	// Speed of the projectile.
var vector					FireDirection;		// Direction of projectile when fired.

//****************************************************************************
// New member funcs.
//****************************************************************************

//
function Init( vector pawnLoc, float speed, vector direction )
{
	PawnLocation = pawnLoc;
	ProjectileSpeed = speed;
	FireDirection = direction;
}

//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Called immediately before removing from host.
function Removing( pawn host )
{
	if ( ScriptedPawn(host) != none )
		ScriptedPawn(host).EffectorWarnTarget( PawnLocation, ProjectileSpeed, FireDirection );
}

//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     EffectDuration=0.1
}
