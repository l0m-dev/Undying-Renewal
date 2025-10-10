//=============================================================================
// VeragoProjectileExplosion.
//=============================================================================
class VeragoProjectileExplosion expands Explosion;

simulated function CreateExplosion( pawn Instigator )
{
	super.CreateExplosion( Instigator );

	// Damage
	if ( bCausesDamage )
		HurtRadius( DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo() );

	// Visual Effects
	Spawn( class'HotExplosionFX',,, Location );
	Spawn( class'SmokyExplosionFX',,, Location );

	// Decals
	GenerateDecal();
	
	// Wind
	Spawn( class'ExplosionWind',,, Location );

	// Sound
	PlayEffectSound();
}

defaultproperties
{
     Damage=50
     DamageType=gen_concussive
     MomentumTransfer=5000
     Sounds(0)=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     Sounds(1)=Sound'Aeons.Weapons.E_Wpn_DynaExpl02'
     Sounds(2)=Sound'Aeons.Weapons.E_Wpn_DynaExpl03'
     DecalClass=Class'Aeons.ExplosionDecal'
}
