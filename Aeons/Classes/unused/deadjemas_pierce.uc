//=============================================================================
// deadjemas_pierce.
//=============================================================================
class deadjemas_pierce expands Corpses;

#exec MESH IMPORT MESH=deadjemas_pierce_m SKELFILE=deadjemas_pierce.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_pierce_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
