//=============================================================================
// InstantScytheWound.
//=============================================================================
class InstantScytheWound expands InstantWound;

function BeginPlay()
{
	spawn(class 'SmokyBloodSmallFX',,,Location);
	Destroy();
}

defaultproperties
{
}
