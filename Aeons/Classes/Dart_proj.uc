//=============================================================================
// Dart_proj.
//=============================================================================
class Dart_proj expands WeaponProjectile;

var ParticleFX Trail;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
	{
		Trail = spawn(class 'DartTrailFX',self,,Location);
		Trail.SetBase(self);
	}
	
	Velocity = Vector(Rotation) * speed;
}

simulated function Destroyed()
{
	if ( Trail != none )
		Trail.Shutdown();
	
	Trail = None;
}

defaultproperties
{
     Speed=1000
     MaxSpeed=1500
     Damage=50
     MyDamageType=Dart
     Mesh=SkelMesh'Aeons.Meshes.spear_m'
     DrawScale=0.5
     CollisionRadius=1
     CollisionHeight=1
}
