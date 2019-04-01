//=============================================================================
// Gargoyle.
//=============================================================================
class Gargoyle expands Ornaments;
#exec MESH IMPORT MESH=Gargoyle_m SKELFILE=Gargoyle.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Gargoyle_m'
     CollisionRadius=32
     CollisionHeight=40
     bBlockActors=True
     bBlockPlayers=True
}
