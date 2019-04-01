//=============================================================================
// deadjemas_impale01.
//=============================================================================
class deadjemas_impale01 expands Corpses;
#exec MESH IMPORT MESH=deadjemas_impale01_m SKELFILE=deadjemas_impale01.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_impale01_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
