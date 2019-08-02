//=============================================================================
// BodyPart.
//=============================================================================
class BodyPart expands Projectile;

simulated singular function Touch(Actor Other){}
simulated function ProcessTouch(Actor Other, Vector HitLocation){}
simulated function HitWall (vector HitNormal, actor Wall, byte TextureID){}


function Tick(float DeltaTime)
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
}
