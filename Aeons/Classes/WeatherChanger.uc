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

function Trigger(Actor Other, Pawn Instigator)
{
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
	
	ForEach AllActors(class 'AeonsPlayer', Player)
	{
		Player.ClientUpdateForecast();
	}
}

defaultproperties
{
     WeatherStrength=1
     Texture=Texture'Aeons.System.WeatherChanger'
     bCollideActors=True
}
