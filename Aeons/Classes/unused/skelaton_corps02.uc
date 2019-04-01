//=============================================================================
// skelaton_corps02.
//=============================================================================
class skelaton_corps02 expands Corpses;

#exec MESH IMPORT MESH=skelaton_corps02_m SKELFILE=skelaton_corps02.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.skelaton_corps02_m'
}
