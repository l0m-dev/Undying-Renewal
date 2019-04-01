//=============================================================================
// BarrelNormal.
//=============================================================================
class BarrelNormal expands Container;

#exec MESH IMPORT MESH=BarrelNormal_m SKELFILE=BarrelNormal.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.BarrelNormal_m'
     CollisionRadius=32
     CollisionHeight=42
}
