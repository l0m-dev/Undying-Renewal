//=============================================================================
// DebugArrow.
//=============================================================================
class DebugArrow expands Actor;
#exec MESH IMPORT MESH=DebugArrow_m SKELFILE=DebugArrow.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.DebugArrow_m'
     bUnlit=True
}
