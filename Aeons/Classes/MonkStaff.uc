//=============================================================================
// MonkStaff.
//=============================================================================
class MonkStaff expands HeldProp;

//#exec MESH IMPORT MESH=MonkStaff_m SKELFILE=MonkStaff.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.MonkStaff_m'
}
