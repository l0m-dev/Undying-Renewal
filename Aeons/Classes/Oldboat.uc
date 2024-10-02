//=============================================================================
// Oldboat.
//=============================================================================
class Oldboat expands Decoration;
//#exec MESH IMPORT MESH=Oldboat_m SKELFILE=Oldboat.ngf

// either add bNoDelete=True or bStatic=False here

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Oldboat_m'
     bNoDelete=True
}
