//=============================================================================
// TreeA.
//=============================================================================
class TreeA expands Plants;
#exec MESH IMPORT MESH=TreeA_m SKELFILE=TreeA.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.TreeA_m'
}
