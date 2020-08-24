//=============================================================================
// deadfish.
//=============================================================================
class deadfish expands Corpses;

//#exec MESH IMPORT MESH=deadfish_m SKELFILE=deadfish.ngf

defaultproperties
{
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.deadfish_m'
     DrawScale=2
     CollisionRadius=20
     CollisionHeight=10
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
}
