//=============================================================================
// Sigil_proj.
//=============================================================================
class Sigil_proj expands SpellProjectile;

var WardProj_particles trail;

simulated function PreBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		// Create the trail effect and attach it to the projectile
		trail = Spawn(class 'WardProj_particles',,, Location, Rotation);
		trail.castingLevel = castingLevel;
		trail.initSystem();
		trail.setBase(self);
	}
	super.PreBeginPlay();
}

simulated function Destroyed()
{
	if ( trail != None )
		trail.bShuttingDown = true;
}

auto state flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if (Other != Owner)
		{
			PlaySound(MiscSound, SLOT_Misc, 2.0);
			destroy();
		}
	}

	simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
	{
		local SigilTest s;
		
		if (Level.NetMode <  NM_Client )
		{
			s = spawn(class 'SigilTest',Owner,,Location, rotator(HitNormal));
			s.castingLevel = CastingLevel;
//			s.Init(); 
		}
		
		spawn(class 'SigilHitFX',,,Location);
		Destroy();
	}

	Begin:
		velocity = Vector(Rotation) * speed;
}

defaultproperties
{
     Speed=800
     CollisionRadius=2
     CollisionHeight=4
     bCollideJoints=False
     bProjTarget=True
}
