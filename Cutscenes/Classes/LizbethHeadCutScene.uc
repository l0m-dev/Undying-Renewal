//=============================================================================
// LizbethHeadCutScene.
//=============================================================================
class LizbethHeadCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=LizbethHeadCS_m SKELFILE=LizbethHeadCS.ngf
//#exec MESH NOTIFY SEQ=0606 TIME=0.382 FUNCTION=HeadOnFire

function HeadOnFire()
{
	local Actor A;

	A = spawn (class 'FireFX', self,,Location);
	A.SetBase(self,'Head', 'root');
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.LizbethHeadCS_m'
     ShadowImportance=0
}
