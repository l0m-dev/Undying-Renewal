//=============================================================================
// LanternHanging2.
//=============================================================================
class LanternHanging2 expands Fixtures;
#exec MESH IMPORT MESH=LanternHanging2_m SKELFILE=LanternHanging2.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.LanternHanging2_m'
}
