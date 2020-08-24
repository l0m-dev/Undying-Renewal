//=============================================================================
// Idiot_Savant.
//=============================================================================
class Idiot_Savant expands ScriptedPawn;

function Tick(float DeltaTime)
{
	// SetDebugInfo("Health: " $health, true );

}

defaultproperties
{
     GroundSpeed=150
     AirSpeed=100
     Visibility=10
     AttitudeToPlayer=ATTITUDE_Ignore
     DrawScale=1.65
     CollisionHeight=64
}
