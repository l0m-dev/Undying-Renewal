//=============================================================================
// Candleabra_standing.
//=============================================================================
class Candleabra_standing expands Fixtures;

#exec MESH IMPORT MESH=Candleabra_standing01_m SKELFILE=Candleabra_standing01.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Candleabra_standing01_m'
     CollisionRadius=16
     CollisionHeight=57
     bCollideActors=True
     bCollideWorld=True
     bGroundMesh=False
     bBlockActors=True
     bBlockPlayers=True
}
