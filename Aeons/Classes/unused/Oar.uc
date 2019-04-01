//=============================================================================
// Oar.
//=============================================================================
class Oar expands HeldProp;
#exec MESH IMPORT MESH=Oar_m SKELFILE=Oar.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Oar_m'
}
