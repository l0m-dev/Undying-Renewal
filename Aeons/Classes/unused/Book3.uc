//=============================================================================
// Book3.
//=============================================================================
class Book3 expands Decoration;
#exec MESH IMPORT MESH=Book3_m SKELFILE=Book3.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Book3_m'
}
