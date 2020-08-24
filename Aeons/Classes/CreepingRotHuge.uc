//=============================================================================
// CreepingRotHuge.
//=============================================================================
class CreepingRotHuge expands CreepingRot;

function PreBeginPlay()
{
	bHuge = true;
	super.PreBeginPlay();
}

defaultproperties
{
     Decal=None
     DrawType=DT_Mesh
     DrawScale=3
     CollisionRadius=192
     CollisionHeight=8
}
