//=============================================================================
// SearchLight.
//=============================================================================
class SearchLight expands Light;

var() float Rate;	// how long it takes to revolve once
var	  float InvRate;

function BeginPlay()
{
	Super.BeginPlay();

	InvRate = 1.0 / Rate;
}

function Tick(float DeltaTime)
{
	local rotator r;
	local vector HitLocation, HitNormal, Start, End;
	local int HitJoint;
	local float str;
	
	r = Rotation;
	r.Yaw += (65536 * DeltaTime * InvRate);
	while (r.Yaw >= 65536)
		r.Yaw -= 65536;
	while (r.Yaw < 0)
		r.Yaw += 65536;

	SetRotation(r);

}

defaultproperties
{
     Rate=10
     bStatic=False
     bHidden=False
     bNoDelete=False
     bDirectional=True
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.camera_m'
     bMovable=True
     LightEffect=LE_Spotlight
     LightBrightness=255
     LightHue=32
     LightSaturation=40
     LightRadius=14
     LightPeriod=0
}
