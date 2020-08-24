//=============================================================================
// Glasses.
//=============================================================================
class Glasses expands Heldprop;
//#exec MESH IMPORT MESH=Glasses_m SKELFILE=Glasses.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Glasses_m'
}
