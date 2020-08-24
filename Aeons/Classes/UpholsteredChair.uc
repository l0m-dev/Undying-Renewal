//=============================================================================
// UpholsteredChair.
//=============================================================================
class UpholsteredChair expands Furniture;

//#exec MESH IMPORT MESH=UpholsteredChair_m SKELFILE=UpholsteredChair.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.UpholsteredChair_m'
     CollisionRadius=32
     CollisionHeight=48
}
