//=============================================================================
// LanternMounted.
//=============================================================================
class LanternMounted expands Fixtures;
#exec MESH IMPORT MESH=LanternMounted_m SKELFILE=LanternMounted.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.LanternMounted_m'
}
