//=============================================================================
// ChairArmWood.
//=============================================================================
class ChairArmWood expands Furniture;
//#exec MESH IMPORT MESH=ChairArmWood_m SKELFILE=ChairArmWood.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.ChairArmWood_m'
     CollisionRadius=32
     CollisionHeight=46
}
