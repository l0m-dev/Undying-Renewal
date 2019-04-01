//=============================================================================
// WoodStove.
//=============================================================================
class WoodStove expands Furniture;

#exec MESH IMPORT MESH=WoodStove_m SKELFILE=WoodStove.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.WoodStove_m'
     CollisionRadius=32
     CollisionHeight=96
}
