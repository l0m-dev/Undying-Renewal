//=============================================================================
// FireFly_proj. 
//=============================================================================
class FireFly_proj expands SpellProjectile;

// user exposed variables
var() 	int 		numFlies;
var() 	float 		effectLen[6];
var() 	float 		seekSpeed[6];

// internal variables
var		int			i;
var 	Vector		SeekLoc, sd;
var 	float 		seekWeight;
var 	Pawn 		seekingPawn;
var 	float 		seekVel;
var		vector directions[6];
var		FireFlyTrail_particles ft;
var		ParticleFX pFX;
var		bool 		bSeeking;

var		vector ServerVel, ServerLoc;

//----------------------------------------------------------------------------
//	Replication
//----------------------------------------------------------------------------
replication
{
	reliable if ( Role == ROLE_Authority )
		//seekLoc, bSeeking, seekVel, seekingPawn, 
		ServerVel, ServerLoc;
}

//----------------------------------------------------------------------------

simulated function PostNetBeginPlay()
{
	//logactorstate("postnetbeginplay");
	SpawnEffects();
}

//----------------------------------------------------------------------------

simulated function SpawnEffects()
{
	Log("SpawnEffects");
	pFX = spawn(class 'FireFlyTrailFliesFX',,,Location);
	pFX.setBase(self);

	for (i=0; i<5; i++)
	{
		spawn(class 'FireFlyParticle_proj', self,,Location + (VRand() * 32));
	}
}

//----------------------------------------------------------------------------

simulated function PreBeginPlay()
{
	local ScriptedPawn		GPawn;

	super.PreBeginPlay();
/*
	pFX = spawn(class 'FireFlyTrailFliesFX',,,Location);
	pFX.setBase(self);

	for (i=0; i<5; i++)
	{
		spawn(class 'FireFlyParticle_proj', self,,Location + (VRand() * 32));
	}
*/
	// only server version should notify Pawns
	if ( Level.NetMode < NM_Client )
	{
		foreach RadiusActors( class'ScriptedPawn', GPawn, 4096 )
			GPawn.LookTargetNotify( self, 5.0 );

		// Dedicated Server doesn't spawn effects, those are done clientside
		if ( Level.NetMode != NM_DedicatedServer )
			SpawnEffects();

	}
}
 
//----------------------------------------------------------------------------

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// owner check
	if (Owner == none)
	{
		//logactor("PostBeginPlay: Owner is none, destroying...");
		//Destroy();
	}

	Velocity = Vector(Rotation)*speed;
	directions[0] = vect(0,0,1);
	directions[1] = vect(0,0,-1);
	directions[2] = vect(0,1,0);
	directions[3] = vect(0,-1,0);
	directions[4] = vect(1,0,0);
	directions[5] = vect(-1,0,0);

	PlaySound(SpawnSound,SLOT_Misc,1,,1024);
	setTimer(0.50, true);
}

//----------------------------------------------------------------------------

// projectile is automaticly put in this state when fired
// it periodically check through pawn class actors for line
// of sight tests and if it finds any, it sets itself to seek
function Timer()
{
	local int i, foo, axis;
	local float d, td;
	local vector HitLocation, HitNormal, te;
	local actor Other;

	local vector seekDir;

	if ( bSeeking )
	{
		seekDir = normal(seekingPawn.location - Location);
		Velocity = seekDir * seekVel;
		setRotation(rotator(Velocity));
	} 
	else 
	{
		te = location + (VRand() * 8192);
		Trace(HitLocation, HitNormal, foo, te, Location, false, true);
		SeekLoc = HitLocation;
	}
}

//----------------------------------------------------------------------------

function SetRoll(vector NewVelocity) 
{
	local rotator newRot;	

	newRot = rotator(NewVelocity);	
	SetRotation(newRot);	
}

//----------------------------------------------------------------------------

function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	// Velocity -= 2 * ( Velocity dot HitNormal) * HitNormal;  
	Velocity -= 2 * ( Velocity dot HitNormal) * HitNormal;  
	SetRoll(Velocity);
/*
	if ( Role == ROLE_Authority ) 
	{
		Log("Server: HitWall: Velocity=" $ Velocity);
	}
	else
	{
		Log("Client: HitWall: Velocity=" $ Velocity);
	}
*/

}

//----------------------------------------------------------------------------

simulated function Tick(float deltaTime)
{
	local vector 	SeekingDir, currentDir;

	local vector 	sd;						// weighted var for seeking direction
	local vector 	cd;						// weighted var for current direction
	local vector 	rd;						// weighted var for random direction

	if ( Level.NetMode == NM_Client ) 
	{
		Velocity = ServerVel;
		SetLocation(ServerLoc);
	}
	else
	{
		if (!bSeeking)
		{
			currentDir = Normal( Vector(Rotation) );
		
	//		if (Level.NetMode < NM_Client)
			seekingPawn = getClosePawn(seekingPawn, 4096, Location);
		
			if ( (seekingPawn != None) && (seekingPawn != Owner) )
				Seek();
			else 
			{
				sd = Normal(seekLoc - Location) * 0.5;
				rd = VRand() * 0.2;
				cd = currentDir * 0.5;
			}
		
			Velocity = Normal(sd + rd + cd) * speed;
		}

		ServerVel = Velocity;
		ServerLoc = Location;
	}
}

//----------------------------------------------------------------------------

simulated function Seek()
{
	ft.Elasticity = 0;
	ft.SizeLength.Base = 64;
	ft.SizeWidth.Base = 64;
	ft.ParticlesPerSec.Base *= 2;
	setTimer(0.2, true);
	seekVel = seekSpeed[castingLevel];
	bSeeking = true;
}

//----------------------------------------------------------------------------

simulated function Destroyed()
{

	log("firefly_proj: destroyed");
	if ( pFX != None ) 
		pFX.Shutdown();
	// spawn(class 'DefaultParticleExplosionFX',,,Location);
	
	if ( ft != None )
		ft.gotostate('dissipate');
}

//----------------------------------------------------------------------------

function ProcessTouch(Actor Other, Vector HitLocation)
{
	local Pawn p;
	local FireFlyParticle_proj f;
	local bool bFound;

	if ( Other.IsA('Pawn') && (Other != Owner))
	{
		PlaySound(PawnImpactSound,,4,,1024);
		if ( (Other != Owner) && Other.IsA('AeonsPlayer') )
		{
			AeonsPlayer(Other).FireFlyMod.castingLevel = castingLevel;
			AeonsPlayer(Other).FireFlyMod.gotoState('Activated');
			bFound = True;
		}

		if ( Other.IsA('ScriptedPawn') )
		{
			// log("FireFly_proj:ProcessTouch: ScriptedPawn    "$Other.name);
			ScriptedPawn(Other).FireFlyMod.castingLevel = castingLevel;
			ScriptedPawn(Other).FireFlyMod.gotoState('Activated');
			bFound = True;
		}

		if ( bFound ) 
		{
			ForEach AllActors(class 'FireFlyParticle_proj', f)
			{
				if ( f.Owner == self )
				{
					switch( ScriptedPawn(Other).FireFlyMod.castingLevel )
					{
						case 0:
							f.SetLifeSpan(10);
							break;

						case 1:
							f.SetLifeSpan(10);
							break;

						case 2:
							f.SetLifeSpan(10);
							break;
						
						case 3:
							f.SetLifeSpan(10);
							break;
						
						case 4:
							f.SetLifeSpan(20);
							break;
						
						case 5:
							f.SetLifeSpan(30);
							break;
					}
					f.SetOwner(Other);
				}
			}
		}
		Destroy(); // destroy self
	}
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     EffectLen(0)=5
     EffectLen(1)=5
     EffectLen(2)=5
     EffectLen(3)=10
     EffectLen(4)=10
     EffectLen(5)=15
     seekSpeed(0)=1500
     seekSpeed(1)=1500
     seekSpeed(2)=1500
     seekSpeed(3)=1500
     seekSpeed(4)=1500
     seekSpeed(5)=1500
     Speed=1000
     PawnImpactSound=Sound'Aeons.Spells.E_Spl_FireFlyHit01'
     bNetTemporary=False
     LifeSpan=10
     AmbientSound=Sound'Aeons.Spells.E_Spl_FireFlyLoop01'
     DrawType=DT_None
     Style=STY_Masked
     Texture=None
     SoundRadius=64
     SoundVolume=64
     TransientSoundRadius=32
     LightType=LT_Steady
     LightBrightness=115
     LightHue=33
     LightSaturation=153
     LightRadius=24
}
