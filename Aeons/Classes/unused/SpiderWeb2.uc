//=============================================================================
// SpiderWeb2.
//=============================================================================
class SpiderWeb2 expands SpiderWeb;
#exec MESH IMPORT MESH=SpiderWeb2_m SKELFILE=SpiderWeb2.ngf 
#exec MESH MODIFIERS Cloth:ClothCollide

defaultproperties
{
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.SpiderWeb2_m'
}
