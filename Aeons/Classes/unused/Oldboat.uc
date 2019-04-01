//=============================================================================
// Oldboat.
//=============================================================================
class Oldboat expands Decoration;
#exec MESH IMPORT MESH=Oldboat_m SKELFILE=Oldboat.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Oldboat_m'
}
