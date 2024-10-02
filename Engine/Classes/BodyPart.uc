//=============================================================================
// BodyPart.
//=============================================================================
class BodyPart expands Projectile;

simulated function PostBeginPlay()
{
	// bugged currently so destroy it
	// not needed anymore with RemoteRole=ROLE_None
	//if (Role < ROLE_Authority)
	//	Destroy();
}

simulated singular function Touch(Actor Other){}
simulated function ProcessTouch(Actor Other, Vector HitLocation){}

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	local vector HitLocation, HitNormal2, start, end;
	local int HitJoint;
	
	if (Physics == PHYS_None)
		return;
	
	Start = Location;
	End = Location + (vect(0,0,-1) * (CollisionHeight + 32));
	
	Trace(HitLocation, HitNormal2, HitJoint, end, start);
	if (HitLocation != vect(0,0,0) && Velocity.Z < 2)
	{
		setPhysics(PHYS_None);
	}
	
	Velocity = reflect(-Normal(Velocity), HitNormal);
	Speed = VSize(Velocity);
	bFixedRotationDir = false;
	RandSpin(12500);
}

simulated function Tick(float DeltaTime)
{
	if ( Owner == None )
		Destroy();
	else
		Opacity = Owner.Opacity;
}

defaultproperties
{
     Physics=PHYS_Falling
     RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
     CollisionRadius=8
     CollisionHeight=16
     bCollideActors=False
     bBounce=True
     bFixedRotationDir=True
     bRotateToDesired=True
     RemoteRole=ROLE_None
}
