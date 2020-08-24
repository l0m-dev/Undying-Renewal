//=============================================================================
// deadjemas_drool.
//=============================================================================
class deadjemas_drool expands Corpses;
//#exec MESH IMPORT MESH=deadjemas_drool_m SKELFILE=deadjemas_drool.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_drool_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
