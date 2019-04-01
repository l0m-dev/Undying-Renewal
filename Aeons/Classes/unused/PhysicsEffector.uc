//=============================================================================
// PhysicsEffector.
//=============================================================================
class PhysicsEffector expands Invisible
	abstract;


//****************************************************************************
// Member vars.
//****************************************************************************
var() savable bool			bIsActive;			// On/Off state.
var() bool					bAffectLockedPlayer;// Set if OK to affect locked player.
var() bool					bAffectAI;			// Set if affects AI also


//****************************************************************************
// Inherited functions.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************
// Return the effect of this effector on the location passed.
function vector EffectOn( vector ThisLoc )
{
	return vect(0,0,0);
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     bHidden=True
     bSavable=True
}
