//=============================================================================
// deadjemas_wound.
//=============================================================================
class deadjemas_wound expands Corpses;

//#exec MESH IMPORT MESH=deadjemas_wound_m SKELFILE=deadjemas_wound.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_wound_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
