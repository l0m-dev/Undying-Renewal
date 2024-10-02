//=============================================================================
// SkyZoneInfo.
//=============================================================================
class SkyZoneInfo extends ZoneInfo
	native;

//#exec Texture Import File=Textures\S_SkyZone.pcx Name=S_SkyZone Mips=On Flags=4194432

var() bool bRotating;
var() float DegreesPerSec;
var int DeltaRot;

simulated function PreBeginPlay()
{
	if ( bRotating )
	{
		Enable('Tick');
		DeltaRot = DegreesPerSec * 182.04;
	} else {
		Disable('Tick');
	}
}

simulated function Tick(float DeltaTime)
{
	local rotator r;

	r = Rotation;
	r.Yaw += (DeltaRot * DeltaTime);
	SetRotation(r);
}

defaultproperties
{
     bSkyZone=True
     bStatic=False
     RemoteRole=ROLE_SimulatedProxy
}
