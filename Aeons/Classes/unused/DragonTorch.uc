//=============================================================================
// DragonTorch.
//=============================================================================
class DragonTorch expands Fixtures;

#exec MESH IMPORT MESH=DragonTorch_m SKELFILE=DragonTorch.ngf

defaultproperties
{
     LODBias=6
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.DragonTorch_m'
}
