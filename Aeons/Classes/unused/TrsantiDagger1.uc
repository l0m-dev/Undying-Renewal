//=============================================================================
// TrsantiDagger1.
//=============================================================================
class TrsantiDagger1 expands HeldProp;

#exec MESH IMPORT MESH=TrsantiDagger1_m SKELFILE=Trsanti_Knife1.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.TrsantiDagger1_m'
     CollisionRadius=2
     CollisionHeight=2
}
