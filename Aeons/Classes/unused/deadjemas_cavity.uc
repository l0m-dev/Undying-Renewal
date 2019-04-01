//=============================================================================
// deadjemas_cavity.
//=============================================================================
class deadjemas_cavity expands Corpses;
#exec MESH IMPORT MESH=deadjemas_cavity_m SKELFILE=deadjemas_cavity.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_cavity_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
