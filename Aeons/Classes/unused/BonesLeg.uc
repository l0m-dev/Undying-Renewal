//=============================================================================
// BonesLeg.
//=============================================================================
class BonesLeg expands Carcass;
#exec MESH IMPORT MESH=BonesLeg_m SKELFILE=BonesLeg.ngf

defaultproperties
{
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.BonesLeg_m'
}
