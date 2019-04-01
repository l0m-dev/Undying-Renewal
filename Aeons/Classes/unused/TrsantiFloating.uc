//=============================================================================
// TrsantiFloating.
//=============================================================================
class TrsantiFloating expands Corpses;

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
	
	inc  += 	DeltaTime * 0.25;
	inc2 += 	DeltaTime * 0.55;
	inc3 += 	DeltaTime * 0.15;

	
	r.yaw 	= cos(inc) 	* 2048;
	r.pitch = cos(inc2) * 2048;
	r.roll 	= cos(inc3) * 2048;
	
	setRotation(InitialRot + r);
}

defaultproperties
{
     bStatic=False
     bTimedTick=True
     MinTickTime=0.05
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Trsanti_Dead_Floating_m'
}
