//=============================================================================
// skelaton_corpse_sit.
//=============================================================================
class skelaton_corpse_sit expands Corpses;

#exec MESH IMPORT MESH=skelaton_corpse_sit_m SKELFILE=skelaton_corpse_sit.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.skelaton_corpse_sit_m'
}
