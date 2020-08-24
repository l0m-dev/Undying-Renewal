//=============================================================================
// jemas_firepot.
//=============================================================================
class jemas_firepot expands OldPots;

//#exec MESH IMPORT MESH=jemas_firepot_m SKELFILE=jemas_firepot.ngf

defaultproperties
{
     bPushable=False
     Mesh=SkelMesh'Aeons.Meshes.jemas_firepot_m'
     CollisionHeight=64
     bCollideActors=True
}
