//=============================================================================
// FireGrillWithLogs.
//=============================================================================
class FireGrillWithLogs expands Decoration;
#exec MESH IMPORT MESH=FireGrillWithLogs_m SKELFILE=FireGrillWithLogs.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.FireGrillWithLogs_m'
}
