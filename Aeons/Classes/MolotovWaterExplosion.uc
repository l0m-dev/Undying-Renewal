//=============================================================================
// MolotovWaterExplosion.
//=============================================================================
class MolotovWaterExplosion expands Explosion;

simulated function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);

	// Visual Effects
	spawn (class 'SmokyExplosionFX'  ,,,Location);

	// Sound
	PlayEffectSound(0.25);
}

defaultproperties
{
     DamageRadius=128
     Damage=0
     DamageType=Fire
     MomentumTransfer=0
     Sounds(0)=Sound'Aeons.Weapons.E_Wpn_MoltExpl01'
     Sounds(1)=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MoltExpl02'
}
