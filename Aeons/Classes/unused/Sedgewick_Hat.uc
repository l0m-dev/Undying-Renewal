//=============================================================================
// Sedgewick_Hat.
//=============================================================================
class Sedgewick_Hat expands HeldProp;

#exec MESH IMPORT MESH=Sedgewick_Hat_m SKELFILE=Sedgewick_Hat.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Sedgewick_Hat_m'
     CollisionRadius=10
     CollisionHeight=6
}
