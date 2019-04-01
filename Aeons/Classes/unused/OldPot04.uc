//=============================================================================
// OldPot04.
//=============================================================================
class OldPot04 expands OldPots;

#exec MESH IMPORT MESH=OldPot04_m SKELFILE=OldPot04.ngf

defaultproperties
{
     Mesh=SkelMesh'Aeons.Meshes.OldPot04_m'
     CollisionRadius=32
     CollisionHeight=68
     bCollideActors=True
}
