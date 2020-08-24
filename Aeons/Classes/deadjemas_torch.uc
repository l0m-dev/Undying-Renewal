//=============================================================================
// deadjemas_torch.
//=============================================================================
class deadjemas_torch expands Corpses;

//#exec MESH IMPORT MESH=deadjemas_torch_m SKELFILE=deadjemas_torch.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_torch_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
