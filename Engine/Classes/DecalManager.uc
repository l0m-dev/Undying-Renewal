//=============================================================================
// DecalManager.
//=============================================================================
class DecalManager expands Info;

var() int SoftDecalLimit;			// number of decals we don't want to go over
var() int HardDecalLimit;			// number of decals we will never go over
var int NumDecals;					// num decals in the level right now.

function Tick(float DeltaTime)
{
	local Decal D;
	
	if ( NumDecals > HardDecalLimit )
	{
		// above our hard limit... force Destroy Decals;
		ForEach AllActors(class 'Decal', D)
		{
			if ( D.Age > 1.0 )
				D.HardLimitReached();
		}
	} else if ( NumDecals > SoftDecalLimit ) {
		// above our soft limit... force Destroy Decals;
		ForEach AllActors(class 'Decal', D)
		{
			if (D.Age > 3)
				D.SoftLimitReached();
		}
	}
}

defaultproperties
{
     SoftDecalLimit=100
     HardDecalLimit=200
     bTimedTick=True
     MinTickTime=0.25
}
