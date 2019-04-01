//=============================================================================
// ArmChairWood.
//=============================================================================
class ArmChairWood expands Furniture;
#exec MESH IMPORT MESH=ArmChairWood_m SKELFILE=ArmChairWood.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.ArmChairWood_m'
     CollisionRadius=32
     CollisionHeight=46
}
