//=============================================================================
// King_BodyCutscene.
//=============================================================================
class King_BodyCutscene expands CutsceneChar;

//#exec MESH IMPORT MESH=King_BodyCS_m SKELFILE=King_BodyCS.ngf

function Hide()
{
	bHidden = true;
}

function UnHide()
{
	bHidden = false;
}

function SetupTake(int Cutscene, int Take)
{
	if ( Cutscene == 7 )
	{
		switch( Take )
		{
			case 0:
				Hide();
				break;
			case 49:
				UnHide();
				break;
			case 50:
				UnHide();
				break;
		}
	}
	if ( Cutscene == 13 )
	{
		switch( Take )
		{
			case 7:
				Destroy();
				break;
		}
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.King_BodyCS_m'
}
