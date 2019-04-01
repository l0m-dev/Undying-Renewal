//=============================================================================
// deadjemas_amputa.
//=============================================================================
class deadjemas_amputa expands Corpses;
#exec MESH IMPORT MESH=deadjemas_amputa_m SKELFILE=deadjemas_amputa.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_amputa_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
