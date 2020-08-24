//=============================================================================
// deadjemas_impale02.
//=============================================================================
class deadjemas_impale02 expands Corpses;
//#exec MESH IMPORT MESH=deadjemas_impale02_m SKELFILE=deadjemas_impale02.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_impale02_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
