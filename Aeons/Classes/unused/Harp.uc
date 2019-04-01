//=============================================================================
// Harp.
//=============================================================================
class Harp expands Ornaments;
#exec MESH IMPORT MESH=Harp_m SKELFILE=Harp.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.Harp_m'
     CollisionRadius=32
     CollisionHeight=64
     bCollideActors=True
     bCollideWorld=True
     bGroundMesh=False
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
