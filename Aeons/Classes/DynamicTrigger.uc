//=============================================================================
// DynamicTrigger.
//=============================================================================
class DynamicTrigger expands Trigger;

var() float lifeTime;

var actor A;

// This Trigger Times out
state() TriggerTimesOut
{
	
	function Tick(float DeltaTime)
	{
		// log("Tick");
	}

	Begin:
		Sleep(lifeTime);
		foreach AllActors( class 'Actor', A, Event )
			UnTouch(A);
		Destroy();
}

defaultproperties
{
}
