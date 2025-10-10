//=============================================================================
// LizbethCutScene.
//=============================================================================
class LizbethCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=LizbethCS_m SKELFILE=LizbethCS.ngf
//#exec MESH MODIFIERS Cloth:LizbethSkirt Hair:Hair Breast:Breast

//#exec MESH NOTIFY SEQ=0501 TIME=0.9375 FUNCTION=Scream

#exec OBJ LOAD FILE=..\Sounds\VoiceOver.uax PACKAGE=VoiceOver

var() Sound ScreamSound;

function Scream()
{
	local PlayerPawn Player;

	if (ScreamSound != none)
	{
		ForEach AllActors (class 'PlayerPawn', Player)
		{
			break;
		}
		
		if (Player != none)
		{
			if ( Player.ViewTarget != none )
			{
				Player.ViewTarget.PlaySound(ScreamSound,,2);
			}
		}
	} else {
		log ("Lizbeth trying to scream, but .... no", 'Cutscenes');
	}

}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.LizbethCS_m'
}
