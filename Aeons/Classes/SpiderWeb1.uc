//=============================================================================
// SpiderWeb1.
//=============================================================================
class SpiderWeb1 expands SpiderWeb;
//#exec MESH IMPORT MESH=SpiderWeb1_m SKELFILE=SpiderWeb1.ngf 
//#exec MESH MODIFIERS Cloth:ClothCollide

defaultproperties
{
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.SpiderWeb1_m'
}
