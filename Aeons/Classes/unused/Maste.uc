//=============================================================================
// Maste.
//=============================================================================
class Maste expands Decoration;
#exec MESH IMPORT MESH=Maste_m SKELFILE=Maste.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Maste_m'
}
