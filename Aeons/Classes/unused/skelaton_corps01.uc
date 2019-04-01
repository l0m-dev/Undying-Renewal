//=============================================================================
// skelaton_corps01.
//=============================================================================
class skelaton_corps01 expands Corpses;

#exec MESH IMPORT MESH=skelaton_corps01_m SKELFILE=skelaton_corps01.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.skelaton_corps01_m'
}
