//=============================================================================
// CreepingRotBig.
//=============================================================================
class CreepingRotBig expands CreepingRot;

function PreBeginPlay()
{
	bBig = true;
	super.PreBeginPlay();
}

defaultproperties
{
     Decal=None
     DrawType=DT_Mesh
     DrawScale=2
     CollisionRadius=128
     CollisionHeight=8
}
