//=============================================================================
// EnvironmentModifier.
//=============================================================================
class EnvironmentModifier expands Actor;

var() Enum EModType
{
	EMod_LightsOn,
	EMod_LightsOff,
	EMod_ParticleDensity,
	EMod_ActorOpacity
} ModType;

var() float EffectRadius;
var() bool bMustSee;
var() class<Actor> TargetClass;

function Tick(float DeltaTime)
{
	local Actor A;
	
	ForEach RadiusActors(TargetClass, A, EffectRadius)
	{
		if ( (bMustSee && fastTrace(Location, A.Location)) || !bMustSee )
		{
			
		}
	}
}

defaultproperties
{
     EffectRadius=1024
     bMustSee=True
     bHidden=True
}
