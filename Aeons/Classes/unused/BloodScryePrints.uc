//=============================================================================
// BloodScryePrints.
//=============================================================================
class BloodScryePrints expands Decoration;
#exec MESH IMPORT MESH=BloodScryePrints_m SKELFILE=BloodScryePrints.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.BloodScryePrints_m'
     ShadowImportance=0
}
