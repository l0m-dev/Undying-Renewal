//=============================================================================
// HangingChain2.
//=============================================================================
class HangingChain2 expands Ornaments;

#exec MESH IMPORT MESH=HangingChain2_m SKELFILE=HangingChain2.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.HangingChain2_m'
}
