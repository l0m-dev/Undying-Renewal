//=============================================================================
// MolotovExplosion.
//=============================================================================
class MolotovExplosion expands Explosion;

var MolotovFire_proj fProj, clone;
var() int numExplosionBits;

function CreateExplosion(Pawn Instigator)
{
	local int i;
	local vector SpewDir;

	Super.CreateExplosion(Instigator);

	// Damage
	if (bCausesDamage)
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo() );

	// Visual Effects

	for (i = 0; i < numExplosionBits; i++)
	{
		spewDir = Normal(Vector(Rotation) + (VRand() * 0.5));
		spewDir.z *= 0.6;
		// spewDir = Normal(reflect(Normal(-Velocity), WallHitNormal) + (VRand() * 0.5));
		fProj = Spawn(class 'molotovFire_proj',,,Location ,rotator(SpewDir));
		
		if (i != 0)
			fProj.bMakesSound = false;
		
		fProj.gotoState('Flying');
		if (i > 0)
			fProj.AmbientSound = none;
	}

	spawn (class 'HotExplosionFX'    ,,,Location);
	spawn (class 'SmokyExplosionFX'  ,,,Location);

	// Wind
	Spawn(class 'ExplosionWind',,,Location);

	// Sound
	PlayEffectSound();
}

defaultproperties
{
     numExplosionBits=4
     DamageRadius=128
     Damage=20
     DamageType=Fire
     MomentumTransfer=0
     Sounds(0)=Sound'Aeons.Weapons.E_Wpn_MoltExpl01'
     Sounds(1)=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MoltExpl02'
}
