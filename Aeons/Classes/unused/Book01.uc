//=============================================================================
// Book01.
//=============================================================================
class Book01 expands Decoration;
#exec MESH IMPORT MESH=Book01_m SKELFILE=Book01.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Book01_m'
}
