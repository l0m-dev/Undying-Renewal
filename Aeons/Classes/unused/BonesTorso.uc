//=============================================================================
// BonesTorso.
//=============================================================================
class BonesTorso expands Carcass;
#exec MESH IMPORT MESH=BonesTorso_m SKELFILE=BonesTorso.ngf

defaultproperties
{
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.BonesTorso_m'
}
