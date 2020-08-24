//=============================================================================
// TreeB.
//=============================================================================
class TreeB expands Plants;

//#exec MESH IMPORT MESH=TREE_m SKELFILE=TREER.ngf 


function PreBeginPlay()
{
	super.PreBeginPlay();
	Spawn(class 'TreeCollisionHack',,,Location);
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.TREE_m'
     CollisionHeight=372
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
