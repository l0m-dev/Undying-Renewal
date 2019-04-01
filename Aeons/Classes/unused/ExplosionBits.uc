//=============================================================================
// ExplosionBits.
//=============================================================================
class ExplosionBits expands FallingProjectile;

simulated function PostNetBeginPlay()
{
	Log("TrailClass=" $ TrailClass);
	Super.PostNetBeginPlay();
}

/*
function PreBeginPlay()
{	
	super.PreBeginPlay();
	speed = speed + (FRand() * 1000);
	Velocity = vector(rotation) * speed;
}
*/

defaultproperties
{
     CollisionMethod=COL_Method_4
     Elasticity=0.35
     TrailClass=Class'Aeons.SmokeTrailFX'
     bDestroyInWater=True
     bScaleDownWhenStopped=True
     Speed=1200
     Damage=7
     ExplosionDecal=Class'Aeons.EmberDecal'
     Style=STY_Translucent
     Texture=Texture'Aeons.Particles.Ember00'
     DrawScale=0.35
     CollisionRadius=0
     CollisionHeight=0
     LightBrightness=153
     LightHue=19
     LightSaturation=97
     LightRadius=8
     Mass=1000
}
