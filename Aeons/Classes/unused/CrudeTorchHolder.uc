//=============================================================================
// CrudeTorchHolder.
//=============================================================================
class CrudeTorchHolder expands Fixtures;
#exec MESH IMPORT MESH=CrudeTorchHolder_m SKELFILE=CrudeTorchHolder.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.CrudeTorchHolder_m'
}
