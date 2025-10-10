//=============================================================================
// SphereOfColdExplosion.
//=============================================================================
class SphereOfColdExplosion expands Explosion;

simulated function CreateExplosion(Pawn Instigator)
{
	local int i;
	
	Super.CreateExplosion(Instigator);

	// Damage
	if (bCausesDamage)
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo('SphereOfCold') );

	// Visual Effects
	spawn (class 'SmokyExplosionFX'  ,,,Location);
	
	for (i=0; i<4; i++)
	{
		Spawn(class 'IceChunk',,,Location, Rotation);
	}

	// Decals
	GenerateDecal();
	
	// Wind
	Spawn(class 'ExplosionWind',,,Location);

	// Sound
	PlayEffectSound();
}

defaultproperties
{
}
