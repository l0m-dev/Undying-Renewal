//=============================================================================
// ScriptedBethany.
//=============================================================================
class ScriptedBethany expands ScriptedNarrator;

#exec MESH IMPORT MESH=ScriptedBeth_m SKELFILE=ScriptedBeth.ngf INHERIT=ScriptedBiped_m

//****************************************************************************
// Member vars.
//****************************************************************************
var() float					MirrorFadeRate;		//
var bool					bIgnoreUp;			//
var bool					bIgnoreDn;			//


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

function RampOpacity( bool bUp )
{
	if ( bUp )
	{
		if ( !bIgnoreUp )
		{
			OpacityEffector.SetFade( 1.0, MirrorFadeRate );
			bHidden = false;
			bIgnoreUp = true;
		}
		bIgnoreDn = false;
	}
	else
	{
		if ( !bIgnoreDn )
		{
			OpacityEffector.SetFade( 0.0, MirrorFadeRate );
			bIgnoreDn = true;
		}
		bIgnoreUp = false;
	}
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
     MirrorFadeRate=0.25
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.ScriptedBeth_m'
     bCollideActors=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
}
