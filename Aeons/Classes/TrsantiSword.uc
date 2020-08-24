//=============================================================================
// TrsantiSword.
//=============================================================================
class TrsantiSword expands HeldProp;

//#exec MESH IMPORT MESH=Trsanti_Sword_m SKELFILE=Trsanti_Sword.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Trsanti_Sword_m'
     CollisionRadius=2
     CollisionHeight=2
}
