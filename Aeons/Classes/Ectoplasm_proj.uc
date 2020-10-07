//=============================================================================
// Ectoplasm_proj. 
//=============================================================================
class Ectoplasm_proj expands SpellProjectile;

// User exposed variables
var() 	bool 	bSpawnClones; 					// spawn a cloned particle
var() 	float 	spawnClonesProbability;			// probability to spawn a cloned projectile at the time of re-evaluation
var() 	float 	majorDeviationProbability[6]; 	// probability for the projectile to assume a major deviation in direction when it is re-evaluated, rather than taking the standard deviation
var() 	int 	speedPerLevel[6];
var() 	float 	stdDev[6];
var() 	float 	majDev[6];
var()	sound	EnterWallSound;

// Internal vars
var		int			maxClones, numClones, i;
var		float		fDelay;
var 	pawn 		seekPawn; 						// location to seek if above var is true
// var 	vector 		seekLocation; 					// location to seek if bSeekActor is false
var		vector 		InitialDir;
var 	Ectoplasm_proj 				ecto;
var 	EctoplasmTrail_particles 	ectoTrail;
//var ParticleFX ectoTrail;
var		vector		SeekingDir;
var 	ScriptedFX  Shaft;
var		float 		SeekWt;

// ==============================================================================
function PreBeginPlay()
{
	// Create the trail effect and attach it to the projectile
//	ectoTrail = Spawn(class 'EctoplasmTrail_particles',,, Location, Rotation);
//	ectoTrail.setBase(self);

	//if ( seekLocation == vect(0,0,0) )
	//	seekLocation = Location + Vector(Rotation) * 4096;
	maxClones = 2;
	
	ManaCost = 10;

	Velocity = Vector(Rotation) * speedPerLevel[castingLevel];
	super.PreBeginPlay();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	ectoTrail = Spawn(class 'EctoplasmTrail_particles',self);
	//ectoTrail = Spawn(class 'AeonsParticleFX',self);
	//ectoTrail.SetPhysics(PHYS_Trailer);
}


simulated function Destroyed()
{
	if ( ectoTrail != None )
		ectoTrail.bShuttingDown = true;
}

simulated function ParticleHitFX(vector HitLocation, vector HitNormal)
{
	if ( Level.NetMode != NM_DedicatedServer )
		Spawn(class'EctoplasmHitFX', , , HitLocation, rotator(HitNormal));
}

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	local bool bCanSpawn;
	local vector Vel, deathLocation, spawnLocation, endTrace, HitLocation, tempLoc;
	local float distanceToTravel, totalDistanceToTravel, insideWallDistance;
	local int iJoint, zoneID, i;
	local ectoplasm_proj ecto;
	local DamageInfo DInfo;
	
	HitLocation = Location;
	if (castingLevel >= 4)
	{
		WallDecal(Location, HitNormal);
		if ( Role == ROLE_Authority )
		{
			DInfo = GetDamageInfo();
			if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
			{
				if ( Wall.AcceptDamage(DInfo) )
					Wall.TakeDamage(instigator, Location, MomentumTransfer * Normal(Velocity), getDamageInfo());
			}
			MakeNoise(1.0);
		}
		
		vel = Normal(Velocity);
		totalDistanceToTravel = Speed/LifeSpan;
		bCanSpawn = false;
		for (i=0; i<24; i++)
		{
			distanceToTravel = (totalDistanceToTravel / 24) * (i+1);
			deathLocation = HitLocation + (initialDir * distanceToTravel);
			if ( Level.GetZone(deathLocation) > 0 )
			{
				bCanSpawn = true;
				break;
			}
		}

		log ("Ecto Iterations: " $ i);

		if ( bCanSpawn )
		{
			endTrace = deathLocation + (-InitialDir * 256);
			Trace(spawnLocation, HitNormal, iJoint, endTrace, deathLocation, false, true);
			
			if (spawnLocation != vect(0,0,0))
			{
				WallDecal(spawnLocation, HitNormal);
				playSound(EnterWallSound);				

				insideWallDistance = VSize(spawnLocation - HitLocation);

				log ("Success! Inside Distance- " $ insideWallDistance);
				ecto = Spawn(class 'Ectoplasm_proj',,, (spawnLocation + (Normal(InitialDir) * 16)), rotator(InitialDir));
				ecto.InitialDir = InitialDir;


				ecto.castingLevel = castingLevel;
				ecto.speed = speed;
				ecto.velocity = InitialDir * speed;
				ecto.manaCost = manaCost;
				ecto.lifeSpan = (Lifespan - (insideWallDistance / speed));
				// ecto.seekLocation = Location + (initialSeekDir * 2048);
				ecto.ectoTrail.ColorEnd.Base.r = ectoTrail.ColorEnd.Base.r;
				ecto.ectoTrail.ColorEnd.Base.g = ectoTrail.ColorEnd.Base.g;
				ecto.ectoTrail.ColorEnd.Base.b = ectoTrail.ColorEnd.Base.b;
				
				Destroy();
				
			} else {
				log ("Ectoplasm: Spawn Location Failed");
				super.HitWall(HitNormal, Wall,TextureID);
			}
		} else {
			log ("Ectoplasm: Spawn Ability Failed");
			super.HitWall(HitNormal, Wall,TextureID);
		}
	} else {
		log ("Ectoplasm: Casting Level Failed");
		super.HitWall(HitNormal, Wall,TextureID);
	}
}

auto state Flying
{
	function BeginState()
	{
		SetTimer(0.05,True);
		i = 0;
		Super.BeginState();
	}

	/*
	function ZoneChange( ZoneInfo NewZone )
	{
		// seekLocation = SeekLocation + initialSeekDir * 4096;
	}*/

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		ParticleHitFX(HitLocation, HitNormal);
		Destroy();
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		// Make sure that you can't shoot yourself with this
		if (Other != Pawn(Owner))
			super.ProcessTouch (Other, HitLocation);
	}

	function Timer()
	{
		local rotator RandRot;
		local float deviation, MagnitudeVel;
		local vector currentDir, randomDir;
		
		if (FRand() < majorDeviationProbability[CastingLevel])
			deviation = majDev[CastingLevel];
		else
			deviation = stdDev[CastingLevel];
	
		if ( SeekPawn == none )
		{
			seekPawn = getLitPawn(seekPawn, 4096, Location);
			SeekingDir = Vector(Rotation); //Normal(seekLocation - Location); // seeking a fixed location in world space
		} else {
			currentDir = Normal(Vector(Rotation));
			SeekingDir = Normal(seekPawn.location - Location);
			SeekWt = seekWeight[SeekPawn.LitAmplitude];
			SeekingDir = Normal( (SeekingDir * SeekWt) + (currentDir * (1.0 - SeekWt)) );
			deviation *= 0.5;
		}
	
		randomDir = (VRand() * (FRand() * deviation)) * 0.25;
		Velocity = Normal(seekingDir + randomDir) * speedPerLevel[CastingLevel];
		SetRotation(rotator(Velocity));

		// spawning clones of itself
		if ( (FRand() < 0.025) && (numClones < MaxClones) )
		{
			ecto = Spawn(class 'Ectoplasm_proj',,,Location, Rotation);
			ecto.seekPawn = seekPawn;		// mjg: clones should get this info, right?
			// ecto.seekLocation = Location + (Normal(Velocity) * 2048);
			ecto.castingLevel = castingLevel;
			ecto.Lifespan = LifeSpan * randRange(0.5,1.5);
			numClones ++;
		}
	}

	Begin:
		sleep(fDelay);
}	

function int Dispel(optional bool bCheck)
{
	if ( bCheck )
		return CastingLevel;
	
	ectoTrail.bShuttingDown = true;
	Destroy();
}

defaultproperties
{
     spawnClonesProbability=0.05
     majorDeviationProbability(0)=0.05
     majorDeviationProbability(1)=0.05
     majorDeviationProbability(2)=0.05
     majorDeviationProbability(3)=0.05
     majorDeviationProbability(4)=0.05
     majorDeviationProbability(5)=0.05
     speedPerLevel(0)=800
     speedPerLevel(1)=800
     speedPerLevel(2)=1200
     speedPerLevel(3)=1200
     speedPerLevel(4)=1200
     speedPerLevel(5)=1600
     stdDev(0)=0.5
     stdDev(1)=0.5
     stdDev(2)=0.5
     stdDev(3)=0.5
     stdDev(4)=0.5
     stdDev(5)=0.5
     majDev(0)=0.5
     majDev(1)=0.5
     majDev(2)=0.5
     majDev(3)=0.5
     majDev(4)=0.5
     majDev(5)=0.5
     EnterWallSound=Sound'Aeons.Spells.E_Spl_EctoThruWall01'
     damagePerLevel(0)=10
     damagePerLevel(1)=10
     damagePerLevel(2)=10
     damagePerLevel(3)=10
     damagePerLevel(4)=10
     damagePerLevel(5)=10
     Speed=800
     MaxSpeed=1200
     Damage=10
     MomentumTransfer=10
     MyDamageType=Ectoplasm
     MyDamageString="splatted"
     bMagical=True
     ProjImpactSound=Sound'Aeons.Spells.E_Spl_EctoHitGen01'
     PawnImpactSound=Sound'Aeons.Spells.E_Spl_EctoHitFlesh01'
     ExploWallOut=8
     ExplosionDecal=Class'Aeons.EctoDecal'
     LifeSpan=1
     DrawType=DT_None
     Style=STY_None
     Texture=None
     DrawScale=0.3
     CollisionRadius=8
     CollisionHeight=16
     LightType=LT_Steady
     LightBrightness=200
     LightHue=150
     LightSaturation=128
     LightRadius=6
}
