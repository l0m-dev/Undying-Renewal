//=============================================================================
// OldPot01.
//=============================================================================
class OldPot01 expands OldPots;

#exec MESH IMPORT MESH=OldPot01_m SKELFILE=OldPot01.ngf

defaultproperties
{
     Mesh=SkelMesh'Aeons.Meshes.OldPot01_m'
     CollisionHeight=64
     bCollideActors=True
}
