//=============================================================================
// BayCurtains.
//=============================================================================
class BayCurtains expands Ornaments;
#exec MESH IMPORT MESH=BayCurtains_m SKELFILE=BayCurtains.ngf
#exec MESH MODIFIERS Spacer:ClothingFront

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.BayCurtains_m'
}
