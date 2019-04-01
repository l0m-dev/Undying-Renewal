//=============================================================================
// skinlamp.
//=============================================================================
class skinlamp expands Fixtures;
#exec MESH IMPORT MESH=skinlamp_m SKELFILE=skinlamp.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.skinlamp_m'
}
