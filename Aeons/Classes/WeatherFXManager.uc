//=============================================================================
// WeatherFXManager.
//=============================================================================
class WeatherFXManager expands Info;

var PlayerPawn Player;
var bool bPlayerInMyZone;

simulated function FindPlayer()
{
	local PlayerPawn P;

	foreach AllActors(class'PlayerPawn', P)
		if(Viewport(P.Player) != None)
			Player = P;
}

simulated function Tick(float DeltaTime)
{
	local ParticleFX P;

	if ( Event == 'none' )
		return;

	if ( Player == none )
		FindPlayer();

	if ( Player != none )
	{

		if ( Player.Region.zoneNumber == self.Region.zoneNumber )
		{
			if ( !bPlayerInMyZone )
			{
				ForEach AllActors(class 'ParticleFX', P, Event)
				{
					P.bSteadyState = P.default.bSteadyState;
					P.ParticlesPerSec.Base = P.default.ParticlesPerSec.Base;
				}
				bPlayerInMyZone = true;
			}
		} else {
			if ( bPlayerInMyZone )
			{
				ForEach AllActors(class 'ParticleFX', P, Event)
				{
					P.bSteadyState = false; // allow particles to age initially
					P.ParticlesPerSec.Base = 0;
					P.Age += P.Lifetime.Base; // age particles
				}
				bPlayerInMyZone = false;
			}
		}
	}
}

defaultproperties
{
     bNoDelete=True
     RemoteRole=ROLE_SimulatedProxy
}
