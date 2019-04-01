//=============================================================================
// TreeSmallP.
//=============================================================================
class TreeSmallP expands Decoration;
#exec MESH IMPORT MESH=TreeSmallP_m SKELFILE=TreeSmallP.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.TreeSmallP_m'
}
