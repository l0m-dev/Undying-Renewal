//=============================================================================
// ProjectileWind.
//=============================================================================
class ProjectileWind expands Wind;

function Tick(float deltaTime)
{
	if (Owner == none)
		Destroy();
}

defaultproperties
{
     WindSpeed=520
     WindRadius=16
     WindSource=LD_Point
}
