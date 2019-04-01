//=============================================================================
// Chair_Jeremiah.
//=============================================================================
class Chair_Jeremiah expands Furniture;
#exec MESH IMPORT MESH=Chair_Jeremiah_m SKELFILE=Chair_Jeremiah.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Chair_Jeremiah_m'
     CollisionRadius=32
     CollisionHeight=62
}
