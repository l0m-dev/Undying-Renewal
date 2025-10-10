//=============================================================================
// StandingStone.
//=============================================================================
class SPStandingStone expands ScriptedPawn;

////#exec MESH IMPORT MESH=StandingStone_m SKELFILE=StandingStone.ngf

defaultproperties
{
     OrderState=AIDoNothing
     Mesh=SkelMesh'Aeons.Meshes.StandingStone_m'
     CollisionRadius=32
     CollisionHeight=64
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
}
