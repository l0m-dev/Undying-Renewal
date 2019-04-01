//=============================================================================
// HeldScroll.
//=============================================================================
class HeldScroll expands HeldProp;
#exec MESH IMPORT MESH=HeldScroll_m SKELFILE=HeldScroll.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.HeldScroll_m'
}
