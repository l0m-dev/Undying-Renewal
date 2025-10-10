//=============================================================================
// FallingBloodDrip.
//=============================================================================
class FallingBloodDrip expands FallingProjectile;

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	Velocity = Vector(rotation) * (Speed * (0.75 + FRand()));
}

simulated function ProcessBounce(vector HitNormal, optional vector vel)
{
	local vector HitLocation;
	local int HitJoint;
	
	Trace(HitLocation, HitNormal, HitJoint, Location + vect(0,0,-32), Location, true);
	spawn (class 'BigBloodDripDecal',,,HitLocation, rotator(HitNormal));

	Destroy();
}

defaultproperties
{
     Speed=50
     DrawType=DT_None
     CollisionRadius=2
     CollisionHeight=2
     bCollideActors=False
     bProjTarget=False
}
