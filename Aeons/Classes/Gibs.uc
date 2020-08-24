//=============================================================================
// Gibs.
//=============================================================================
class Gibs expands ParticleExplosion;

function PreBeginPlay()
{
	local int i;
	local vector dir;

	if (MiscSpawnClass1 != none)
		Spawn(MiscSpawnClass1,,,Location);

	if (MiscSpawnClass2 != none)
		Spawn(MiscSpawnClass2,,,Location);

	NumBits = RandRange(4,8);

	for (i=0; i<numBits; i++)
	{
		dir = Vector(Rotation) + (VRand() * 0.85);
		dir.z *= 0.75;
		spawn( ProjClass,,,Location, Rotator(Dir) );
	}
}

defaultproperties
{
     ProjClass=Class'Aeons.GibBits'
     MiscSpawnClass1=Class'Aeons.SmokyBloodFX'
}
