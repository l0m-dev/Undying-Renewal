//=============================================================================
// ProjectileWind.
//=============================================================================
class ProjectileWind expands Wind;

/* Force-Recompile */

simulated function Tick(float deltaTime)
{
	if (Owner == none)
		Destroy();
}

defaultproperties
{
     WindSpeed=520
     WindRadius=16
     WindSource=LD_Point
     bNoDelete=False
}
