//=============================================================================
// OpenBook1.
//=============================================================================
class OpenBook1 expands Decoration;
#exec MESH IMPORT MESH=OpenBook1_m SKELFILE=OpenBook1.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.OpenBook1_m'
}
