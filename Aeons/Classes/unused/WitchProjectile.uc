//=============================================================================
// WitchProjectile.
//=============================================================================
class WitchProjectile expands SPThrownProjectile;

#exec MESH IMPORT MESH=WitchProjectile_m SKELFILE=WitchProjectile.ngf

defaultproperties
{
     Mesh=SkelMesh'Aeons.Meshes.WitchProjectile_m'
     DrawScale=1
     CollisionRadius=4
     CollisionHeight=4
}
