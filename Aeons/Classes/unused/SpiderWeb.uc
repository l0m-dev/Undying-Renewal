//=============================================================================
// SpiderWeb.
//=============================================================================
class SpiderWeb expands Effects;
#exec MESH IMPORT MESH=SpiderWeb_m SKELFILE=SpiderWeb.ngf
#exec MESH MODIFIERS Cloth:ClothCollide

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.SpiderWeb_m'
     Lighting(0)=(Constant=(R=55,G=55,B=55),Diffuse=(R=154,G=154,B=154),TextureMask=-1)
}
