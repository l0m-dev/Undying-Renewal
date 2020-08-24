//=============================================================================
// PulseLight.
//=============================================================================
class PulseLight expands Light;

var   float InitialBrightness; // Initial brightness.
var   float Alpha;
var() float ChangeTime;        // Time light takes to change from on to off.

simulated function BeginPlay()
{
	InitialBrightness = LightBrightness;
	Alpha = 1.0;
	DrawType = DT_None;
	setTimer(ChangeTime, false);
}

simulated function Timer()
{
	Destroy();
}

simulated function Tick( float DeltaTime )
{
	Alpha += -1 * DeltaTime / ChangeTime;
	LightBrightness = Alpha * InitialBrightness;
}

defaultproperties
{
     ChangeTime=5
     DrawType=DT_None
     LightBrightness=166
}
