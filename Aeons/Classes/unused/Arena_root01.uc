//=============================================================================
// Arena_root01.
//=============================================================================
class Arena_root01 expands Plants;
#exec MESH IMPORT MESH=Arena_Root01_m SKELFILE=Arena_Root01.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Arena_Root01_m'
}
