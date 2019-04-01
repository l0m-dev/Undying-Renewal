//=============================================================================
// Mermaid.
//=============================================================================
class Mermaid expands Decoration;
#exec MESH IMPORT MESH=Mermaid_m SKELFILE=Mermaid.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Mermaid_m'
}
