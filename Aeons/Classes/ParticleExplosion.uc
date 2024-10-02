//=============================================================================
// ParticleExplosion.
//=============================================================================
class ParticleExplosion expands Effects;

var() class<Projectile> ProjClass;
var() int maxBits;
var() int minBits;
var() class<Actor> MiscSpawnClass1;
var() class<Actor> MiscSpawnClass2;

var int NumBits;

simulated function PreBeginPlay()
{
	local int i;
	local vector dir;
	
	super.PreBeginPlay();
	
	if (MiscSpawnClass1 != none)
		TearOff(Spawn(MiscSpawnClass1,,,Location));

	if (MiscSpawnClass2 != none)
		TearOff(Spawn(MiscSpawnClass2,,,Location));

	numBits = RandRange(MaxBits, MinBits);
	
	TearOff(spawn(class 'WeaponLight',,,Location));
	for (i=0; i<numBits; i++)
	{
		dir = Normal(vect(0,0,1) + (VRand() * 0.5));
		dir.z *= 0.35;
		TearOff(spawn( ProjClass,,,Location, Rotator(Dir) ));
	}
}

defaultproperties
{
     ProjClass=Class'Aeons.ExplosionBits'
     maxBits=8
     minBits=4
     NumBits=6
}
