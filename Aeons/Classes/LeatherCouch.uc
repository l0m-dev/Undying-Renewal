//=============================================================================
// LeatherCouch.
//=============================================================================
class LeatherCouch expands Furniture;
//#exec MESH IMPORT MESH=LeatherCouch_m SKELFILE=LeatherCouch.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.LeatherCouch_m'
}
