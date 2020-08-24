//=============================================================================
// CreepingRot_proj.
//=============================================================================
class CreepingRot_proj expands SpellProjectile;

var WardProj_particles Trail;

simulated function PreBeginPlay()
{
	super.PreBeginPlay();

	if ( Level.NetMode == NM_DedicatedServer )
		return;

	// Create the trail effect and attach it to the projectile
	trail = Spawn(class 'WardProj_particles',,, Location, Rotation);
	trail.setBase(self);
}


simulated function Destroyed()
{
	if ( Trail != None )
		Trail.bShuttingDown = true;
}

auto state flying
{
	simulated function Destroyed()
	{
		if ( Trail != None )
			Trail.bShuttingDown = true;
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		log("CreepingRot_proj: ProcessTouch "$Other,'Misc');

		if (Other != Owner)
		{
			PlaySound(MiscSound, SLOT_Misc, 2.0);
			Destroy();
		}
	}

	simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
	{
		local CreepTest c;

		c = spawn(class 'CreepTest', Pawn(Owner), , Location, rot(0,0,0));
		c.castingLevel = CastingLevel;
		c.Init();

		// hit effect
		spawn(class 'SigilHitFX',,,Location + HitNormal * 8);

		Destroy();
	}

	Begin:
		velocity = Vector(Rotation) * speed;
}

defaultproperties
{
     Speed=800
     LifeSpan=0
     bGameRelevant=False
     CollisionRadius=4
     CollisionHeight=8
}
