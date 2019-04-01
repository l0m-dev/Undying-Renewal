//=============================================================================
// BurialSceneRope.
//=============================================================================
class BurialSceneRope expands Decoration;
#exec MESH IMPORT MESH=BurialSceneRope_m SKELFILE=BurialSceneRope.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.BurialSceneRope_m'
}
