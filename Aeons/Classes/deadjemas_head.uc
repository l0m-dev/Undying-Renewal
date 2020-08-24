//=============================================================================
// deadjemas_head.
//=============================================================================
class deadjemas_head expands Corpses;
//#exec MESH IMPORT MESH=deadjemas_head_m SKELFILE=deadjemas_head.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_head_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
