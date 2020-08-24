//=============================================================================
// LanternHanging3.
//=============================================================================
class LanternHanging3 expands Fixtures;
//#exec MESH IMPORT MESH=LanternHanging3_m SKELFILE=LanternHanging3.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.LanternHanging3_m'
     CollisionRadius=8
     CollisionHeight=128
     bCollideActors=True
     bGroundMesh=False
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
