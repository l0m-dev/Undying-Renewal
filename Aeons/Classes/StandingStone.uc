//=============================================================================
// StandingStone.
//=============================================================================
class StandingStone expands Ornaments;

//#exec MESH IMPORT MESH=StandingStone_m SKELFILE=StandingStone.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.StandingStone_m'
     CollisionRadius=32
     CollisionHeight=64
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
