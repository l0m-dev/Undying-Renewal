//=============================================================================
// DeadGuy02.
//=============================================================================
class DeadGuy02 expands Carcass;
#exec MESH IMPORT MESH=DeadGuy02_m SKELFILE=DeadGuy02.ngf

defaultproperties
{
     Mesh=SkelMesh'Aeons.Meshes.DeadGuy02_m'
     ShadowImportance=0
     ShadowRange=0
}
