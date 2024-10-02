//=============================================================================
// Gargoyle.
//=============================================================================
class Gargoyle expands Ornaments;
//#exec MESH IMPORT MESH=Gargoyle_m SKELFILE=Gargoyle.ngf

// InnerCourtyard changes bStatic to false and the mismatch causes the actor to not spawn
// either add bNoDelete=True or bStatic=False here

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Gargoyle_m'
     CollisionRadius=32
     CollisionHeight=40
     bBlockActors=True
     bBlockPlayers=True
     bNoDelete=True
}
