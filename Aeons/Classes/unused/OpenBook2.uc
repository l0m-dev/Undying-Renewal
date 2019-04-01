//=============================================================================
// OpenBook2.
//=============================================================================
class OpenBook2 expands Decoration;
#exec MESH IMPORT MESH=OpenBook2_m SKELFILE=OpenBook2.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.OpenBook2_m'
}
