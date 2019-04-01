//=============================================================================
// BloodScryeWords.
//=============================================================================
class BloodScryeWords expands Decoration;
#exec MESH IMPORT MESH=BloodScryeWords_m SKELFILE=BloodScryeWords.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.BloodScryeWords_m'
     ShadowImportance=0
}
