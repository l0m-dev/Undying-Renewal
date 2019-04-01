//=============================================================================
// SpiderWeb0.
//=============================================================================
class SpiderWeb0 expands SpiderWeb;
#exec MESH IMPORT MESH=SpiderWeb0_m SKELFILE=SpiderWeb0.ngf 
#exec MESH MODIFIERS Cloth:ClothCollide

defaultproperties
{
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.SpiderWeb0_m'
}
