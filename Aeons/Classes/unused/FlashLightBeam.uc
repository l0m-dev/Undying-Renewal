//=============================================================================
// FlashLightBeam.
//=============================================================================
class FlashLightBeam expands Light;

function BeginPlay()
{
	DrawType = DT_None;
	SetTimer(1.0,True);
}

function Timer()
{
	MakeNoise(0.3);
}

defaultproperties
{
     bStatic=False
     bHidden=False
     bNoDelete=False
     bMovable=True
     LightBrightness=255
     LightHue=32
     LightSaturation=40
     LightRadius=14
     LightPeriod=0
     LightSource=LD_Ambient
}
