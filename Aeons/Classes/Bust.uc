//=============================================================================
// Bust.
//=============================================================================
class Bust expands Ornaments;
//#exec MESH IMPORT MESH=Bust_m SKELFILE=Bust.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Bust_m'
     CollisionRadius=18
     CollisionHeight=28
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
