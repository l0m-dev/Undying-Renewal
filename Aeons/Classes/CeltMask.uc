//=============================================================================
// CeltMask.
//=============================================================================
class CeltMask expands HeldProp;
//#exec MESH IMPORT MESH=CeltMask_m SKELFILE=CeltMask.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.CeltMask_m'
}
