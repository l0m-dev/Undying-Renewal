//=============================================================================
// Evelyn.
//=============================================================================
class Evelyn expands ScriptedBiped;

//#exec MESH IMPORT MESH=Evelyn_m SKELFILE=Evelyn.ngf INHERIT=ScriptedBiped_m


//****************************************************************************
// Structure defs.
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function Bump( actor Other )
{
	local Lizbeth aPawn;

	if( PlayerPawn( Other ) != none )
	{
		// PlayAnim( 'Crumple',,,, 0.2 );
		foreach AllActors( class'Lizbeth', aPawn )
		{
			aPawn.GotoState( 'LizbethBossFightStart' );
		}
	}
}

function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ) { }

function bool IsAlert()
{
	return false;
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************
state AIStart
{
	function Bump( actor Other) { global.Bump( Other ); }

Begin:
	// PlayAnim( 'Singing',,,, 0.2 );
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     bIsBoss=True
     FadeOutDelay=600
     bNoBloodPool=True
     FootSoundClass=Class'Aeons.BareFootSoundSet'
     FootSoundRadius=1200
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Evelyn_m'
}
