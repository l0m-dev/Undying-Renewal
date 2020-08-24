//=============================================================================
// JemasDrum.
//=============================================================================
class JemasDrum expands Decoration;
//#exec MESH IMPORT MESH=JemasDrum_m SKELFILE=JemasDrum.ngf

defaultproperties
{
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.JemasDrum_m'
     CollisionHeight=64
     bCollideActors=True
     bCollideWorld=True
     bGroundMesh=False
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
