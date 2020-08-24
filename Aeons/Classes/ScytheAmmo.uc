//=============================================================================
// ScytheAmmo.
//=============================================================================
class ScytheAmmo expands Ammo;

function Tick(float DeltaTime)
{
	AmmoAmount = 20;
}

function bool UseAmmo(int AmountNeeded)
{
	return True;
}

defaultproperties
{
}
