//=============================================================================
// DeadSheep.
//=============================================================================
class DeadSheep expands Corpses;
 
//#exec MESH IMPORT MESH=SheepBloody_m SKELFILE=SheepBloody.ngf INHERIT=Sheep_m
//#exec MESH ORIGIN MESH=SheepBloody_m X=10
//#exec MESH JOINTNAME Head=Neck Head1=Head

function PostBeginPlay()
{
	PlayAnim('Death', 10);
}

defaultproperties
{
     bStatic=False
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.SheepBloody_m'
     CollisionRadius=32
     CollisionHeight=32
     bCollideWorld=True
}
