//=============================================================================
// MercuryStatue.
//=============================================================================
class MercuryStatue expands Ornaments;
//#exec MESH IMPORT MESH=MercuryStatue_m SKELFILE=MercuryStatue.ngf

defaultproperties
{
     Tag=MercuryStatue
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.MercuryStatue_m'
     CollisionRadius=32
     CollisionHeight=122
     bCollideActors=True
     bCollideWorld=True
     bGroundMesh=False
     bBlockActors=True
     bBlockPlayers=True
}
