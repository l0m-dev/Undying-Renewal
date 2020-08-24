//=============================================================================
// deadjemas_armhang.
//=============================================================================
class deadjemas_armhang expands Corpses;
//#exec MESH IMPORT MESH=deadjemas_armhang_m SKELFILE=deadjemas_armhang.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.deadjemas_armhang_m'
     CollisionRadius=32
     CollisionHeight=48
     bCollideActors=True
     bBlockPlayers=True
}
