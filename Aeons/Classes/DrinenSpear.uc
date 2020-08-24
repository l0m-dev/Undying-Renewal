//=============================================================================
// DrinenSpear.
//=============================================================================
class DrinenSpear expands HeldProp;

//#exec MESH IMPORT MESH=DrinenSpear_m SKELFILE=DrinenSpear.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.DrinenSpear_m'
     CollisionRadius=3
     CollisionHeight=110
}
