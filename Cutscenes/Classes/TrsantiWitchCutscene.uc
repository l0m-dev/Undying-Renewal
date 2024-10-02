//=============================================================================
// TrsantiWitchCutscene.
//=============================================================================
class TrsantiWitchCutscene expands CutSceneChar;

//#exec MESH IMPORT MESH=TrsantiWitchCS_m SKELFILE=TrsantiWitchCS.ngf
//#exec MESH NOTIFY SEQ=0916 TIME=1.0 FUNCTION=Play0916

function Play0916()
{
	PlayAnim('0916',,MOVE_AnimAbs,,0.25);
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.TrsantiWitchCS_m'
}
