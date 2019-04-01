//=============================================================================
// Book2.
//=============================================================================
class Book2 expands Decoration;
#exec MESH IMPORT MESH=Book2_m SKELFILE=Book2.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Book2_m'
}
