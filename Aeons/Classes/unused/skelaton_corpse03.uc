//=============================================================================
// skelaton_corpse03.
//=============================================================================
class skelaton_corpse03 expands Corpses;

#exec MESH IMPORT MESH=skelaton_corpse03_m SKELFILE=skelaton_corpse03.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.skelaton_corpse03_m'
}
