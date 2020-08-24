//=============================================================================
// PlayerWind.
//=============================================================================
class PlayerWind expands Wind;

// Travels with an actor, matching its current velocity.

function PreBeginPlay()
{
	super.PreBeginPlay();

	if (Owner == none)
		Destroy();
}

simulated function Tick(float deltaTime)
{
	if ( Owner == none )
	{
		Destroy();
		return;
	}

	setRotation(rotator(Owner.Velocity));

	WindSpeed  = VSize(Owner.Velocity) * 0.75;
}

defaultproperties
{
     WindRadius=20
     WindRadiusInner=128
     bTimedTick=True
     MinTickTime=0.2
}
