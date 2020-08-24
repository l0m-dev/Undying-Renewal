//=============================================================================
// WeatherChanger.
//=============================================================================
class WeatherChanger expands Info;

//#exec Texture Import File=WeatherChanger.pcx Name=WeatherChanger Group=System Flags=2

var() float WeatherStrength;
var() enum EWeather
{
	Weather_Clear,
	Weather_Rain,
	Weather_Snow
} Weather;

var AeonsPlayer Player;

function FindPlayer()
{
	ForEach AllActors(class 'AeonsPlayer', Player)
	{
		break;
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	FindPlayer();

	Region.Zone.WeatherStrength = WeatherStrength;

	switch ( Weather )
	{
		case Weather_Clear:
			Region.Zone.Weather = Weather_Clear;
			break;

		case Weather_Rain:
			Region.Zone.Weather = Weather_Rain;
			break;

		case Weather_Snow:
			Region.Zone.Weather = Weather_Snow;
			break;
	}
	
	if ( Player != none )
		RainModifier(Player.RainMod).UpdateForecast();
}

defaultproperties
{
     WeatherStrength=1
     Texture=Texture'Aeons.System.WeatherChanger'
     bCollideActors=True
}
