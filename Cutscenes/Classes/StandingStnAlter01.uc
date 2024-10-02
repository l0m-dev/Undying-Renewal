//=============================================================================
// StandingStnAlter01.
//=============================================================================
class StandingStnAlter01 expands cutscenechar;

//#exec MESH IMPORT MESH=StandingStnAlter01_m SKELFILE=StandingStnAlter01.ngf 

function Hide()
{
	bHidden = true;
}

function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_07
	// ====================================================
	if ( Cutscene == 7 )
	{
		switch( Take )
		{
			case 43:
				Hide();
				break;

		}
	}	// 07
}

defaultproperties
{
     Style=STY_Masked
     Mesh=SkelMesh'Cutscenes.Meshes.StandingStnAlter01_m'
}
