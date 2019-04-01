//=============================================================================
// sleedskin.
//=============================================================================
class sleedskin expands Decoration;
#exec MESH IMPORT MESH=sleedskin_m SKELFILE=sleedskin.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.sleedskin_m'
}
