//=============================================================================
// WeatherFXManager.
//=============================================================================
class WeatherFXManager expands Info;

var PlayerPawn Player;
var bool bPlayerInMyZone;

function FindPlayer()
{
	if (Player != none)
		return;
	ForEach AllActors (class 'PlayerPawn', Player)
	{
		break;
	}
}

function Tick(float DeltaTime)
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
					P.ParticlesPerSec.Base = P.default.ParticlesPerSec.Base;
				}
				bPlayerInMyZone = true;
			}
		} else {
			if ( bPlayerInMyZone )
			{
				ForEach AllActors(class 'ParticleFX', P, Event)
				{
					P.ParticlesPerSec.Base = 0;
				}
				bPlayerInMyZone = false;
			}
		}
	}
}

defaultproperties
{
}
