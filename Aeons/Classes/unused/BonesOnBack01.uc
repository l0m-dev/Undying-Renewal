//=============================================================================
// BonesOnBack01.
//=============================================================================
class BonesOnBack01 expands Carcass;
#exec MESH IMPORT MESH=BonesOnBack01_m SKELFILE=BonesOnBack01.ngf

defaultproperties
{
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.BonesOnBack01_m'
     ShadowImportance=0
     ShadowRange=0
}
