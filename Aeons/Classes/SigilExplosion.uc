//=============================================================================
// SigilExplosion.
//=============================================================================
class SigilExplosion expands Explosion;

function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);

	// Damage
	if (bCausesDamage)
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo() );

	// Visual Effects
	spawn (class 'SigilExplosionFX'    ,,,Location);
	spawn (class 'SigilSmokyExplosionFX'  ,,,Location);
	// spawn (class 'ParticleExplosion' ,,,Location);

	// Wind
	Spawn(class 'ExplosionWind',,,Location);

	// Sound
	PlayEffectSound();
}

defaultproperties
{
     DamageRadius=384
     Damage=50
     DamageType=sigil_concussive
     MomentumTransfer=500
     Sounds(0)=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardBoilPop01'
     Sounds(1)=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardBoilPop01'
     Sounds(2)=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardBoilPop01'
}
