//=============================================================================
// PhoenixExplosion1.
//=============================================================================
class PhoenixExplosion1 expands PhoenixExplosions;

function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);

	// Damage
	if (bCausesDamage)
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo() );

	// Visual Effects
	spawn (class 'HotExplosionFX'    ,,,Location);
	spawn (class 'SmokyExplosionFX'  ,,,Location);

	// Wind
	Spawn(class 'ExplosionWind',,,Location);

	// Sound
	PlayEffectSound();
}

defaultproperties
{
     DamageRadius=512
     Damage=150
     MomentumTransfer=500
     Sounds(0)=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     Sounds(1)=Sound'Aeons.Weapons.E_Wpn_DynaExpl02'
     Sounds(2)=Sound'Aeons.Weapons.E_Wpn_DynaExpl03'
}
