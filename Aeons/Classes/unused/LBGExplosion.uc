//=============================================================================
// LBGExplosion.
//=============================================================================
class LBGExplosion expands Explosion;


function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);

	// Damage
	if ( bCausesDamage )
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo('LBG_Concussive') );

	// Visual Effects
	// spawn (class 'HotExplosionFX'    ,,,Location);
	spawn (class 'LBGSmokyExplosionFX'  ,,,Location);

	// Decals
	GenerateDecal();
	
	// Wind
	Spawn(class 'ExplosionWind',,,Location);

	// Light
	Spawn(class 'Aeons.LBGExplosionLight',,,Location);
	Spawn(class 'Aeons.LBGExplosionLight',,,Location);
	Spawn(class 'Aeons.LBGExplosionLight',,,Location);

	// Sound
	PlayEffectSound(5.0);
}

defaultproperties
{
     DamageRadius=384
     Damage=200
     DamageType=lbg_concussive
     bMagical=True
     MomentumTransfer=10000
     Sounds(0)=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_SpearLightning01'
     Sounds(1)=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_SpearLightning01'
     Sounds(2)=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_SpearLightning01'
     DecalClass=Class'Aeons.ExplosionDecal'
}
