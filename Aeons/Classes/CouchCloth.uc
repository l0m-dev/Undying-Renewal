//=============================================================================
// CouchCloth.
//=============================================================================
class CouchCloth expands Furniture;
//#exec MESH IMPORT MESH=CouchCloth_m SKELFILE=CouchCloth.ngf SMOOTHING=150

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.CouchCloth_m'
}
