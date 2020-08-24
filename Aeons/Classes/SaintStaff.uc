//=============================================================================
// SaintStaff.
//=============================================================================
class SaintStaff expands HeldProp;
//#exec MESH IMPORT MESH=SaintStaff_m SKELFILE=SaintStaff.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.SaintStaff_m'
}
