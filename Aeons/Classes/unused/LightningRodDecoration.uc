//=============================================================================
// LightningRodDecoration.
//=============================================================================
class LightningRodDecoration expands Decoration;

defaultproperties
{
     bStatic=False
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.LightningRod_m'
     CollisionRadius=3
     CollisionHeight=85
     bCollideActors=True
     bCollideWorld=True
     bGroundMesh=False
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
