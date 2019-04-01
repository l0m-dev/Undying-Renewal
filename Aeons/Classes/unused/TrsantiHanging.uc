//=============================================================================
// TrsantiHanging.
//=============================================================================
class TrsantiHanging expands Corpses;

var float inc, inc2, inc3;
var rotator InitialRot;

function PreBeginPlay()
{
	Super.PrebeginPlay();
	
	InitialRot = Rotation;
}

function Tick(float DeltaTime)
{
	local rotator r;
	
	inc += DeltaTime * 0.35;
	r.yaw = cos(inc) * 1536;
	setRotation(InitialRot + r);
}

defaultproperties
{
     bStatic=False
     bTimedTick=True
     MinTickTime=0.05
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Trsanti_Dead_Hanging_m'
}
