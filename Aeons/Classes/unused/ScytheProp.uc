//=============================================================================
// ScytheProp.
//=============================================================================
class ScytheProp expands Decoration;
#exec MESH IMPORT MESH=ScytheProp_m SKELFILE=ScytheProp.ngf 

var vector InitialLocation;
var float inc;

var() float BobAmount;
var() float Period;

function PreBeginPlay()
{
	super.PreBeginPlay();
	InitialLocation = Location;
	Period = (1.0 / FClamp(Period, 0.25, 9999));
}

function Tick(float DeltaTime)
{
	local vector Loc;
	local rotator r;
	
	SetPhysics(PHYS_None);
	
	inc += DeltaTime * Period;
	
	Loc.z = cos(inc) * BobAmount;

	SetLocation(InitialLocation + Loc);
}

defaultproperties
{
     BobAmount=16
     Period=0.5
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.ScytheProp_m'
}
