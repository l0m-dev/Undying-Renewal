//=============================================================================
// Phosphorus_proj.
//=============================================================================
class Phosphorus_proj expands WeaponProjectile;

var ParticleFX ps, ps_Smoke;

function Destroyed()
{
	ps.bShuttingDown = true;
	ps_Smoke.bShuttingDown = true;
}

auto state Flying
{

	function BeginState()
	{
		Velocity = Vector(Rotation) * speed;
		ps = spawn(class 'Phosphorus_particles',,,Location, Rotation);
		ps.SetBase(self);
		ps_Smoke = spawn(class 'PhosphorusSmoke_particles',,,Location, Rotation);
		ps_Smoke.SetBase(self);
	}

	simulated function ZoneChange( Zoneinfo NewZone )
	{
	}

	simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
	{
		// local vector reflectVector;
		//bCanHitInstigator = true;
		PlaySound(ProjImpactSound, SLOT_Misc, 2.0);

		if ( Role == ROLE_Authority )
		{
			if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
				if ( Wall.AcceptDamage(GetDamageInfo()) )
					Wall.TakeDamage( instigator, Location, MomentumTransfer * Normal(Velocity), getDamageInfo());
	
			MakeNoise(1.0);
		}

		Explode(Location + ExploWallOut * HitNormal, HitNormal);
		WallDecal(Location, HitNormal);
	}


	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ( (Other != instigator) || (bCanHitInstigator) )
		{
			if ( Role == ROLE_Authority )
			{
				if ( Other.IsA('Pawn') && Other.AcceptDamage(GetDamageInfo()) ) {
					Other.TakeDamage(instigator,HitLocation, (MomentumTransfer * Normal(Velocity)), getDamageInfo());
					Pawn(Other).OnFire(true);
				} else if ( Other.AcceptDamage(GetDamageInfo()) ) {
					Other.TakeDamage(instigator,HitLocation, (MomentumTransfer * Normal(Velocity)), getDamageInfo() );
				}
			}
			PlaySound(MiscSound, SLOT_Misc, 2.0);
			destroy();
		}
	}


}

defaultproperties
{
     HeadShotMult=1
     Speed=7000
     MaxSpeed=10000
     Damage=20
     MyDamageType=Fire
     MyDamageString="torched"
     Physics=PHYS_Falling
     LifeSpan=1
     DrawType=DT_None
     Mass=500
}
