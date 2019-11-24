//=============================================================================
// DynamiteExplosion.
//=============================================================================
class DynamiteExplosion expands Explosion;

/*
function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);

	// Damage
	if (bCausesDamage)
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo() );

	// Visual Effects
	spawn (class 'HotExplosionFX'    ,,,Location);
	spawn (class 'SmokyExplosionFX'  ,,,Location);
	spawn (class 'ParticleExplosion' ,,,Location);

	// Decals
	GenerateDecal();

	// Make Noise
	// MakeNoise(3.0);

	// Wind
	Spawn(class 'ExplosionWind',,,Location);

	// Sound
	PlayEffectSound();
}
*/

function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);

	// Damage
	if (bCausesDamage)
	{
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo(DamageType) );
		GibRadius(DamageRadius, Location, getDamageInfo(DamageType), Instigator);
	}
	
	// Visual Effects
	spawn (class 'HotDynamiteExplosionFX'    ,,,Location);
	spawn (class 'SmokyDynamiteExplosionFX'  ,,,Location);
	spawn (class 'ParticleDynamiteExplosion' ,,,Location);

	// Decals
	GenerateDecal();
	
	// Wind
	Spawn(class 'ExplosionWind',,,Location);

	// Sound
	PlayEffectSound();
}

defaultproperties
{
     DamageRadius=400
     Damage=150
     DamageType=dyn_concussive
     MomentumTransfer=5000
     Sounds(0)=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     Sounds(1)=Sound'Aeons.Weapons.E_Wpn_DynaExpl02'
     DecalClass=Class'Aeons.ExplosionDecal'
     DrawScale=2
}
