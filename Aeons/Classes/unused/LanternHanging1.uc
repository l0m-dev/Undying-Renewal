//=============================================================================
// LanternHanging1.
//=============================================================================
class LanternHanging1 expands Fixtures;
#exec MESH IMPORT MESH=LanternHanging1_m SKELFILE=LanternHanging1.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.LanternHanging1_m'
     CollisionRadius=24
     CollisionHeight=92
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
