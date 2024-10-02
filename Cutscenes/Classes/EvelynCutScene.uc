//=============================================================================
// EvelynCutScene.
//=============================================================================
class EvelynCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=EvelynCutScene_m SKELFILE=Evelyn.ngf

function Tick(float DeltaTime)
{
	bHidden = false;
}

defaultproperties
{
     DrawType=DT_Sprite
     Mesh=SkelMesh'Cutscenes.Meshes.EvelynCutScene_m'
     CollisionHeight=64
}
