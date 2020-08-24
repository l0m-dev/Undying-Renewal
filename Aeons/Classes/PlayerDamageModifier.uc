//=============================================================================
// PlayerDamageModifier.
//=============================================================================
class PlayerDamageModifier expands PlayerModifier;

var float Str;
var float Damping;
var float RotStrength;
var Vector TotalVec;
var int y, p, r;

function PreBeginPlay()
{
	super.PreBeginPlay();
	Damping = 0.800;
	RotStrength = 4096;
}

function TakeHit(float Strength)
{
	str = 100;
	if (FRand() > 0.5)
		y = RotStrength * Strength;
	else
		y = RotStrength * Strength * -1;

	if (FRand() > 0.5)
		p = RotStrength * Strength;
	else
		p = RotStrength * Strength * -1;

	if (FRand() > 0.5)
		r = RotStrength * Strength;
	else
		r = RotStrength * Strength * -1;
}

function Tick(float DeltaTime)
{
	local rotator rot;

	if (str > 1.0)
	{
		str *= Damping;
		y *= Damping;
		p *= Damping;
		r *= Damping;
		
		rot.yaw = y;
		rot.pitch = p;
		rot.roll = r;
		
		PlayerPawn(Owner).ViewRotation += rot;
	}
}

defaultproperties
{
}
