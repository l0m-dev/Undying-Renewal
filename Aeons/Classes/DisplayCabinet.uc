//=============================================================================
// DisplayCabinet.
//=============================================================================
class DisplayCabinet expands Furniture;
//#exec MESH IMPORT MESH=DisplayCabinet_m SKELFILE=DisplayCabinet.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.DisplayCabinet_m'
     CollisionRadius=48
     CollisionHeight=96
}
