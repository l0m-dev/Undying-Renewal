//=============================================================================
// deadjemas_strapped02.
//=============================================================================
class deadjemas_strapped02 expands Corpses;

#exec MESH IMPORT MESH=deadjemas_strapped02_m SKELFILE=deadjemas_strapped02.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_strapped02_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
