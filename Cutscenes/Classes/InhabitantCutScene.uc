//=============================================================================
// InhabitantCutScene.
//=============================================================================
class InhabitantCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=InhabitantCS_m SKELFILE=InhabitantCS.ngf


function SetupTake(int Cutscene, int Take)
{

	// ====================================================
	// CU_11
	// ====================================================
	if ( Cutscene == 12)
	{
		log("SetupTake "$Cutscene, 'Misc');
		
		switch( Take )
		{
			case 0:
				break;
		}
	}
}

defaultproperties
{
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Cutscenes.Meshes.InhabitantCS_m'
}
