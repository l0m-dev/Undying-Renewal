//=============================================================================
// LightningBlastExplosion.
//=============================================================================
class LightningBlastExplosion expands Explosion;

function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);

	// Damage
	//if (bCausesDamage)
	//	HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo(DamageType) );

	// Visual Effects
	//spawn (class 'HotDynamiteExplosionFX'    ,,,Location);
	spawn (class 'SmokyDynamiteExplosionFX'  ,,,Location);
	//spawn (class 'ParticleDynamiteExplosion' ,,,Location);

	// Decals
	//GenerateDecal();
	
	// Wind
	//Spawn(class 'ExplosionWind',,,Location);

	// Sound
	//PlayEffectSound();
}

defaultproperties
{
}
