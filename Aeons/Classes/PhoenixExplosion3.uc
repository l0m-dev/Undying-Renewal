//=============================================================================
// PhoenixExplosion3.
//=============================================================================
class PhoenixExplosion3 expands PhoenixExplosions;

simulated function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);

	// Damage
	if (bCausesDamage)
	{
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo(DamageType) );
		GibRadius(DamageRadius, Location, getDamageInfo(DamageType), Instigator);
	}

	// Visual Effects
	spawn (class 'PhoenixHotBigExplosionFX'    ,,,Location);
	spawn (class 'SmokyExplosionFX'  ,,,Location);
	spawn (class 'MolotovExplosion',,,Location);

	// Wind
	Spawn(class 'ExplosionWind',,,Location);

	// Sound
	PlayEffectSound();
}

defaultproperties
{
     DamageRadius=512
     Damage=250
     MomentumTransfer=500
     Sounds(0)=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     Sounds(1)=Sound'Aeons.Weapons.E_Wpn_DynaExpl02'
     Sounds(2)=Sound'Aeons.Weapons.E_Wpn_DynaExpl03'
}
