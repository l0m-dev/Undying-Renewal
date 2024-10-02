//=============================================================================
// PlayerWind.
//=============================================================================
class PlayerWind expands Wind;

// Travels with an actor, matching its current velocity.

// set bHidden to False to allow replication
// set DrawType to DT_None to hide sprite

simulated function PreBeginPlay()
{
	super.PreBeginPlay();

	if ( Level.NetMode == NM_Client )
		Disable('Tick');
}

simulated function PostNetBeginPlay()
{
	Enable('Tick');
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
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     bHidden=False
     DrawType=DT_None
     NetUpdateFrequency=4
}
