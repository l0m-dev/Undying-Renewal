//=============================================================================
// AmberTableLamp.
//=============================================================================
class AmberTableLamp expands Furniture;
#exec MESH IMPORT MESH=AmberTableLamp_m SKELFILE=AmberTableLamp.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.AmberTableLamp_m'
     DrawScale=0.7
     CollisionRadius=44
     CollisionHeight=24
}
