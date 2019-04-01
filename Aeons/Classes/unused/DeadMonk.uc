//=============================================================================
// DeadMonk.
//=============================================================================
class DeadMonk expands Corpses;

#exec MESH IMPORT MESH=DeadMonk_m SKELFILE=DeadMonk.ngf

defaultproperties
{
     bStatic=False
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.DeadMonk_m'
     ShadowImportance=0
}
