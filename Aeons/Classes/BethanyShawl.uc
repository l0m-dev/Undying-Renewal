//=============================================================================
// BethanyShawl.
//=============================================================================
class BethanyShawl expands HeldProp;

//#exec MESH IMPORT MESH=BethanyShawl_m SKELFILE=BethanyShawl.ngf
//#exec MESH MODIFIERS Shawl3:ClothCollide

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.BethanyShawl_m'
     CollisionRadius=11
     CollisionHeight=7
}
