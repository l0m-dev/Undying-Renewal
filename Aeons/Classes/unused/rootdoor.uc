//=============================================================================
// rootdoor.
//=============================================================================
class rootdoor expands Decoration;
#exec MESH IMPORT MESH=rootdoor_m SKELFILE=rootdoor.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.rootdoor_m'
}
