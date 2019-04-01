//=============================================================================
// TreeBare.
//=============================================================================
class TreeBare expands Plants;
#exec MESH IMPORT MESH=TreeBare_m SKELFILE=TreeBare.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.TreeBare_m'
}
