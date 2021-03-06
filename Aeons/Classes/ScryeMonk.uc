//=============================================================================
// ScryeMonk.
//=============================================================================
class ScryeMonk expands MonkSoldier;


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool IsAlert()
{
	return false;
}

function SnapToIdle()
{
	LoopAnim( 'idle', [TweenTime] 0.0 );
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
// Def props.
//****************************************************************************

defaultproperties
{
     MyPropInfo(0)=(Prop=None)
     WalkSpeedScale=0.5
     bGiveScytheHealth=False
     bNoScytheTarget=True
     GroundSpeed=160
     AttitudeToPlayer=ATTITUDE_Ignore
     bScryeOnly=True
     bCollideActors=False
     bBlockActors=False
     bBlockPlayers=False
}
