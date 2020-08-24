//=============================================================================
// OldPot03.
//=============================================================================
class OldPot03 expands OldPots;

//#exec MESH IMPORT MESH=OldPot03_m SKELFILE=OldPot03.ngf

defaultproperties
{
     Mesh=SkelMesh'Aeons.Meshes.OldPot03_m'
     CollisionRadius=32
     CollisionHeight=32
     bCollideActors=True
}
