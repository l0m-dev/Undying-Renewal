//=============================================================================
// SkullExplosion.
//=============================================================================
class SkullExplosion expands Explosion;

/*
function HurtRadius( float DamageRadius, name DamageName, float Momentum, vector HitLocation, DamageInfo DInfo )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir, HurtLocation, jointDir, v;
	local float jointDist;
	local int i;
	local name closestJointName;

	if( bHurtEntry )
		return;

	if( DInfo.DamageRadius == 0.0 )
		DInfo.DamageRadius = DamageRadius;

	if( DInfo.DamageLocation == vect(0,0,0) )
		DInfo.DamageLocation = HitLocation;

	bHurtEntry = true;
	
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		if( Victims != self )
		{
			v = Victims.Location - HitLocation;

			dist = vsize(v) - Victims.CollisionRadius;

			DamageScale = abs(1.0-(dist/DamageRadius));
			
			HurtLocation = Victims.Location - v;
			
			if( Victims.bCollideSkeleton )
			{
				HurtLocation = HitLocation;
				damageScale = 1.0;
			}


				log("", 'Misc');
				log(""$Self.name, 'Misc');
				log("Victim Speed = "$(VSize(Victims.velocity)), 'Misc');
				log("damageScale = "$damageScale, 'Misc');
				log("PreDamageScale = "$DInfo.Damage, 'Misc');

			
			DInfo.Damage = Damage * DamageScale;

				log("PostDamageScale = "$DInfo.Damage, 'Misc');
				log("Victim Health Before Damage = "$Pawn(Victims).Health, 'Misc');
			

			Victims.TakeDamage (Instigator, HurtLocation, (damageScale * Momentum * Normal(v)), DInfo);
				
				log("Victim Health After Damage = "$Pawn(Victims).Health, 'Misc');
		}  
	}
	bHurtEntry = false;
}
*/

function CreateExplosion(Pawn Instigator)
{
	Super.CreateExplosion(Instigator);

	// Damage
	if ( bCausesDamage )
		HurtRadius(DamageRadius, DamageType, MomentumTransfer, Location, getDamageInfo(DamageType) );

	// Visual Effects
	spawn (class 'HotExplosionFX'    ,,,Location);
	spawn (class 'SmokyExplosionFX'  ,,,Location);

	// Decals
	GenerateDecal();
	
	// Wind
	Spawn(class 'ExplosionWind',,,Location);

	// Sound
	PlayEffectSound();
}

defaultproperties
{
     DamageRadius=320
     Damage=40
     DamageType=skull_concussive
     MomentumTransfer=5000
     Sounds(0)=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     Sounds(1)=Sound'Aeons.Weapons.E_Wpn_DynaExpl02'
     Sounds(2)=Sound'Aeons.Weapons.E_Wpn_DynaExpl03'
     DecalClass=Class'Aeons.ExplosionDecal'
}
