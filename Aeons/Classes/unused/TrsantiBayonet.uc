//=============================================================================
// TrsantiBayonet.
//=============================================================================
class TrsantiBayonet expands HeldProp;
#exec MESH IMPORT MESH=TrsantiBayonet_m SKELFILE=TrsantiBayonet.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.TrsantiBayonet_m'
}
