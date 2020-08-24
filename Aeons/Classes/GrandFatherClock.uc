//=============================================================================
// GrandFatherClock.
//=============================================================================
class GrandFatherClock expands Furniture;
//#exec MESH IMPORT MESH=GrandFatherClock_m SKELFILE=GrandFatherClock.ngf 


function PostBeginPlay()
{
	// PlayAnim('Idle');
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.GrandFatherClock_m'
     CollisionRadius=24
     CollisionHeight=75
}
