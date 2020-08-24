//=============================================================================
// CrudeTorch.
//=============================================================================
class CrudeTorch expands Fixtures;

//#exec MESH IMPORT MESH=CrudeTorch_m SKELFILE=CrudeTorch.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.CrudeTorch_m'
}
