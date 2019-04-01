//=============================================================================
// TeaTable.
//=============================================================================
class TeaTable expands Furniture;

#exec MESH IMPORT MESH=TeaTable_m SKELFILE=TeaTable.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.TeaTable_m'
     CollisionHeight=32
}
