//=============================================================================
// TunaClipper.
//=============================================================================
class TunaClipper expands Decoration;

#exec MESH IMPORT MESH=TunaClipper_m SKELFILE=TunaClipper.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.TunaClipper_m'
}
