//=============================================================================
// SideTable.
//=============================================================================
class SideTable expands Furniture;

#exec MESH IMPORT MESH=SideTable_m SKELFILE=SideTable.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.SideTable_m'
     DrawScale=0.35
     CollisionRadius=40
     CollisionHeight=38
}
