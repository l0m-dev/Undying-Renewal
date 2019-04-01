//=============================================================================
// HangingChain1.
//=============================================================================
class HangingChain1 expands Ornaments;
#exec MESH IMPORT MESH=HangingChain1_m SKELFILE=HangingChain1.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.HangingChain1_m'
}
