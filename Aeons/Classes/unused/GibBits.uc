//=============================================================================
// GibBits.
//=============================================================================
class GibBits expands FallingProjectile;

function GenWallHitDecal(vector HitLocation, vector HitNormal)
{
	spawn (class 'BloodDripDecal',,,HitLocation, rotator(HitNormal));
}

function DripBlood()
{
	local vector HitLocation, HitNormal;
	local int HitJoint;
	
	local Actor A;
	
	A = Trace(HitLocation, HitNormal, HitJoint, Location + vect(0,0,256), Location, true);
	if (A == none)
		spawn (class 'BloodDripDecal',,,HitLocation, rotator(HitNormal));
}

function Timer()
{
	DripBlood();
	SetTimer(1 + FRand(),true);
}

function PreBeginPlay()
{
	// super.PreBeginPlay();
	Velocity = Vector(rotation) * (100 + FRand() * 500);
	SetTimer(1 + FRand(),true);
}

defaultproperties
{
     TrailClass=Class'Aeons.BloodTrailFX'
     DrawType=DT_None
     CollisionRadius=8
     CollisionHeight=16
     bCollideActors=False
     bProjTarget=False
}
