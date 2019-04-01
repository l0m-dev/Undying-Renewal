//=============================================================================
// OldCannon.
//=============================================================================
class OldCannon expands Decoration;
#exec MESH IMPORT MESH=OldCannon_m SKELFILE=OldCannon.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.OldCannon_m'
}
