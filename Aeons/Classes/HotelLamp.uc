//=============================================================================
// HotelLamp.
//=============================================================================
class HotelLamp expands Furniture;
//#exec MESH IMPORT MESH=HotelLamp_m SKELFILE=HotelLamp.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.HotelLamp_m'
     CollisionRadius=16
     CollisionHeight=8
}
