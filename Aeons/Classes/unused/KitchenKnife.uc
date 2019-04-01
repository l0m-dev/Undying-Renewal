//=============================================================================
// KitchenKnife.
//=============================================================================
class KitchenKnife expands Decoration;
#exec MESH IMPORT MESH=KitchenKnife_m SKELFILE=KitchenKnife.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.KitchenKnife_m'
}
