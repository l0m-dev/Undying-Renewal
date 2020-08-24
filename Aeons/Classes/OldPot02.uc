//=============================================================================
// OldPot02.
//=============================================================================
class OldPot02 expands OldPots;

//#exec MESH IMPORT MESH=OldPot02_m SKELFILE=OldPot02.ngf

defaultproperties
{
     Mesh=SkelMesh'Aeons.Meshes.OldPot02_m'
     CollisionRadius=32
     CollisionHeight=50
     bCollideActors=True
}
