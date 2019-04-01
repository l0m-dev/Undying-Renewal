//=============================================================================
// deadjemas_strapped.
//=============================================================================
class deadjemas_strapped expands Corpses;

#exec MESH IMPORT MESH=deadjemas_strapped_m SKELFILE=deadjemas_strapped.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_strapped_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
