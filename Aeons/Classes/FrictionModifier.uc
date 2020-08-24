//=============================================================================
// FrictionModifier.
//=============================================================================
class FrictionModifier expands PlayerModifier;

var float OverRideFriction;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	OverRideFriction = 8.0;
	if (Owner == none)
		Destroy();
	else {
		SetTimer(0.1, true);
	}
}

function Timer()
{
	local vector HitLocation, HitNormal;
	local int Flags;
	local Texture HitTexture;
	local float dif;

	if (Owner == none)
	{
		SetTimer(0.0, false);
		Destroy();
		return;
	}

	Pawn(Owner).GroundFriction = OverRideFriction;
}

defaultproperties
{
}
