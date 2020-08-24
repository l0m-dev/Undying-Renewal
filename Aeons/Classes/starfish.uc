//=============================================================================
// starfish.
//=============================================================================
class starfish expands Decoration;
//#exec MESH IMPORT MESH=starfish_m SKELFILE=starfish.ngf

defaultproperties
{
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.starfish_m'
     DrawScale=0.5
     CollisionRadius=24
     CollisionHeight=4
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
}
