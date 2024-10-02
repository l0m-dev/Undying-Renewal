//=============================================================================
// MolotovFire_proj. 
//=============================================================================
class MolotovFire_proj expands WeaponProjectile;

var bool 	genClones, isClone;
var bool bMakesSound;
var int		maxClones, numClones;
var float 	v, aliveLen;

var vector 	dir;
var vector 	tempDir, lastDir;

var MolotovFire_proj clone;

var FireFX Fire;
var FireSmokeFX Smoke;

simulated function PreBeginPlay()
{
	numClones = 0;
	maxClones = 1;
	super.PreBeginPlay();
}
  
simulated function Touch( actor Other )
{
	local actor A;
	
	if (Pawn(Other) != None)
		Pawn(Other).TakeDamage(Instigator, Location, vect(0,0,0), getDamageInfo());
}

simulated function Timer()
{
	local int i;
	
	for (i=0;i<8;i++)
		if ( Touching[i] != None )
			Touch(Touching[i]);
}

simulated function HitWall(vector HitNormal, actor Wall, byte TextureID)
{
	Destroy();
}

simulated function PasteBigWallDecal(Vector HitLocation, Vector HitNormal)
{
	local Actor bh;
	Spawn(class 'FireBurnDecal',self,,Location, rotator(HitNormal));
}

simulated function PasteSmallWallDecal(Vector HitLocation, Vector HitNormal)
{
	local Actor bh;
	Spawn(class 'SmallFireBurnDecal',self,,Location, rotator(HitNormal));
}

// ==================================================================================
// ==================            State Dripping            ==========================
// ==================================================================================
// used for small drips of fire
// ==================================================================================
state Dropping
{
	simulated function HitWall(vector HitNormal, actor Wall, byte TextureID)
	{
		PasteSmallWallDecal(Location, HitNormal);
		Destroy();
	}

	simulated function Landed(vector HitNormal)
	{
		setRotation(Rotator(HitNormal));
		PasteSmallWallDecal(Location, HitNormal);
		Destroy();
	}
	
	simulated function BeginState()
	{
		setPhysics(PHYS_Falling);
		Velocity = vect(0,0,-1);
		if (Level.NetMode != NM_DedicatedServer)
		{
			Fire = spawn(class 'FireDripFX',,,Location, Rotation);
			Fire.MakeDynamic();
			Fire.setBase(self);
			//Fire.Lifespan=10;
			Smoke = spawn(class 'FireSmokeFXDrip',Fire,,Location, Rotation);
			Smoke.setBase(self);
			//Smoke.Lifespan=10;
		}
	}

//	Begin:
}

// ==================================================================================
// ==================            State Flying            ============================
// ==================================================================================
// used as part of a molotov explosion
// ==================================================================================
state Flying
{
	simulated function splash()
	{
		if (Level.NetMode != NM_DedicatedServer)
		{
			Fire.SourceDepth.Base = Fire.default.SourceDepth.Base * 4;
			Fire.SourceWidth.Base = Fire.default.SourceWidth.Base * 4;
			Fire.SourceHeight.Base = Fire.default.SourceHeight.Base * 4;
		}
		Destroy();
	}

	simulated function Landed(vector HitNormal)
	{
		PasteBigWallDecal(Location, HitNormal);
		splash();
	}

	simulated function HitWall(vector HitNormal, actor Wall, byte TextureID)
	{
		PasteBigWallDecal(Location, HitNormal);
		splash();
	}

	simulated function Tick(float deltaTime)
	{
		aliveLen += deltaTime;
	}

	simulated function BeginState()
	{
		setPhysics(PHYS_Falling);
		Velocity = Vector(Rotation) * speed;

		// create and attach the particle system
		if (Level.NetMode != NM_DedicatedServer)
		{
			Fire = spawn(class 'FireFX',,,Location, Rotation);
			Fire.setBase(self);
			Fire.MakeDynamic();
			if (!bMakesSound)
				Fire.AmbientSound = none;
			
			Smoke = spawn(class 'FireSmokeFXMedium',Fire,,Location, Rotation);
			Smoke.setBase(self);

			Fire.SourceDepth.Base = Fire.default.SourceDepth.Base * 4;
			Fire.SourceWidth.Base = Fire.default.SourceWidth.Base * 4;
			Fire.SourceHeight.Base = Fire.default.SourceHeight.Base * 4;
		}
	}

//	Begin:
}

// ==================================================================================
// ==================            State Extinguish            ========================
// ==================================================================================
// used for putting the flame out
// ==================================================================================
state Extinguish
{
	simulated function BeginState()
	{
		SetPhysics(PHYS_None);
		if (Level.NetMode != NM_DedicatedServer)
			Fire.Shutdown();
		Destroy();
	}

//	Begin:
}

state Idle
{
	simulated function Timer()
	{
		Destroy();
	}

	simulated function Landed(vector HitNormal)
	{
		setRotation(Rotator(HitNormal));
		WallDecal(Location, HitNormal);
		Destroy();
	}

	simulated function HitWall(vector HitNormal, actor Wall, byte TextureID)
	{
		// setRotation(Rotator(HitNormal));
		WallDecal(Location, HitNormal);
		if (Level.NetMode != NM_DedicatedServer)
		{
			Fire.SourceDepth.Base = Fire.default.SourceDepth.Base * 4;
			Fire.SourceWidth.Base = Fire.default.SourceWidth.Base * 4;
			Fire.SourceHeight.Base = Fire.default.SourceHeight.Base * 4;
		}
		Destroy();
	}

	simulated function BeginState()
	{
		if (Level.NetMode != NM_DedicatedServer)
		{
			Fire = spawn(class 'FireFX',Pawn(Owner),,Location, Rotation);
			Fire.setBase(self);

			Fire.MakeDynamic();
			Smoke = spawn(class 'FireSmokeFXMedium',Fire,,Location, Rotation);
			Smoke.setBase(self);

			Fire.SourceDepth.Base = Fire.default.SourceDepth.Base * 4;
			Fire.SourceWidth.Base = Fire.default.SourceWidth.Base * 4;
			Fire.SourceHeight.Base = Fire.default.SourceHeight.Base * 4;
		}
	
		setTimer(3 + (FRand() * 2), false);
	}

	//Begin:
	//	setTimer(3 + (FRand() * 2), false);
}

defaultproperties
{
     bMakesSound=True
     HeadShotMult=1
     Speed=250
     Damage=5
     ExplosionDecal=Class'Aeons.FireBurnDecal'
     LifeSpan=6
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Aeons.Particles.Ember00'
     DrawScale=0.5
     CollisionRadius=1
     CollisionHeight=1
     LightType=LT_Steady
     LightEffect=LE_TorchWaver
     LightBrightness=211
     LightHue=34
     LightRadius=6
}
