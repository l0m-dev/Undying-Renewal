//=============================================================================
// DeadTree.
//=============================================================================
class DeadTree expands Plants;
//#exec MESH IMPORT MESH=DeadTree_m SKELFILE=DeadTree.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.DeadTree_m'
}
