//=============================================================================
// DynamiteExplosion.
//=============================================================================
class DynamiteExplosion expands Explosion;

/*
simulated function CreateExplosion(Pawn Instigator)
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

simulated function CreateExplosion(Pawn Instigator)
{
	local Texture HitTexture;
	local int flags;
	
	Super.CreateExplosion(Instigator);

	// Damage
	if (bCausesDamage)
	{
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo(DamageType) );
		GibRadius(DamageRadius, Location, getDamageInfo(DamageType), Instigator);
	}
	
	// Visual Effects
	TearOff(spawn (class 'HotDynamiteExplosionFX'    ,,,Location));
	TearOff(spawn (class 'SmokyDynamiteExplosionFX'  ,,,Location));
	TearOff(spawn (class 'ParticleDynamiteExplosion' ,,,Location));

	// Decals
	GenerateDecal();

	// Sound
	HitTexture = TraceTexture( location + vect(0,0,-1)*48*2, location, flags );
	if ( HitTexture != none )
	{
		if (HitTexture.ImpactID == TID_Water)
		{
			PlaySound(Sound'Aeons.Weapons.E_Wpn_DynaExplWater01',SLOT_Interact, 3.0 ,,4096, 1.0);
			Spawn (class 'UnderwaterExplosionFX',,,Location);
			return;
		}
	}
	
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
     Sounds(2)=Sound'Aeons.Weapons.E_Wpn_DynaExpl03'
     DecalClass=Class'Aeons.ExplosionDecal'
     DrawScale=2
}
