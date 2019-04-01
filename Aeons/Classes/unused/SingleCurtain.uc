//=============================================================================
// SingleCurtain.
//=============================================================================
class SingleCurtain expands Ornaments;
#exec MESH IMPORT MESH=SingleCurtain_m SKELFILE=SingleCurtain.ngf 
#exec MESH MODIFIERS Spacer:ClothingFront

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.SingleCurtain_m'
}
