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
	Velocity = 0.25*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	Speed = VSize(Velocity);

	bFixedRotationDir = false;
	RandSpin(12500);

	if ( (Velocity.Z < 50) && (HitNormal.Z > 0.7) )
	{
		SetPhysics(PHYS_none);
		bBounce = false;
	}
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
