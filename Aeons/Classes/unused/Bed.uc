//=============================================================================
// Bed.
//=============================================================================
class Bed expands Furniture;
#exec MESH IMPORT MESH=Bed_m SKELFILE=Bed.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Bed_m'
}
