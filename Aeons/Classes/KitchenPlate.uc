//=============================================================================
// KitchenPlate.
//=============================================================================
class KitchenPlate expands Decoration;
//#exec MESH IMPORT MESH=KitchenPlate_m SKELFILE=KitchenPlate.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.KitchenPlate_m'
}
