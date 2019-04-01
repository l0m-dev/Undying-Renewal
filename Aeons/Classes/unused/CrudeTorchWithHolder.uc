//=============================================================================
// CrudeTorchWithHolder.
//=============================================================================
class CrudeTorchWithHolder expands Fixtures;
#exec MESH IMPORT MESH=CrudeTorchWithHolder_m SKELFILE=CrudeTorchWithHolder.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.CrudeTorchWithHolder_m'
}
