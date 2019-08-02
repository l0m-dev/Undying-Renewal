//=============================================================================
// Projectile.
//
// A delayed-hit projectile moves around for some time after it is created.
// An instant-hit projectile acts immediately. 
//=============================================================================
class Projectile extends Visible
	abstract
	native
	transient;

#exec Texture Import File=Textures\S_Camera.pcx Name=S_Camera Mips=On Flags=2

//-----------------------------------------------------------------------------
// Projectile variables.

var bool bCanHitInstigator;
var bool bHasBeenReflected;

// Motion information.
var() float    Speed;               // Initial speed of projectile.
var() float    MaxSpeed;            // Limit on speed of projectile (0 means no limit)

// Damage attributes.
var() float    Damage;         
var() int	   MomentumTransfer; // Momentum imparted by impacting projectile.
var() name	   MyDamageType;
var() string   MyDamageString;
var() bool	   bMagical;

// Projectile sound effects
var() sound    SpawnSound;		// Sound made when projectile is spawned.
var() sound	   ProjImpactSound;		// Sound made when projectile hits something.
var() sound	   PawnImpactSound;		// Sound made when projectile hits a Pawn
var() sound    MiscSound;		// Miscellaneous Sound.

var() float		ExploWallOut;	// distance to move explosions out from wall

// explosion decal
var() class<Decal> ExplosionDecal;		// normal decal
var() class<Decal> GlassStrikeDecal;	// decal you get when you hit a mirror

var vector spawnLoc;
var(Projectile) sound RicochetSounds[3];
var vector EnterWaterLocation;
var() float HeadShotMult;		// damage multiplier if I score a head shot.

//==============
// Encroachment
function bool EncroachingOn( actor Other )
{
	if ( (Other.Brush != None) || (Brush(Other) != None) )
		return true;
		
	return false;
}

function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	if (DamageType == 'none')
		DamageType = MyDamageType;
	DInfo.Damage = Damage;
	DInfo.DamageType = DamageType;
	DInfo.DamageString = MyDamageString;
	DInfo.bMagical = bMagical;
	DInfo.Deliverer = self;
	DInfo.DamageMultiplier = 1.0;

	return DInfo;

}

//==============
// Touching
simulated singular function Touch(Actor Other)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, TestLocation;
	local int HitJoint;
	
	if ( Other.IsA('BlockAll') )
	{
		HitWall( Normal(Location - Other.Location), Other, 0); //rb what is a blockall ? come back to this.  maybe pass CollideSoundID of Other if an Actor ?
		return;
	}
	if ( Other.bProjTarget || (Other.bBlockActors && Other.bBlockPlayers) )
	{
		//get exact hitlocation
	 	HitActor = Trace(HitLocation, HitNormal, HitJoint, Location, OldLocation, true);
		if (HitActor == Other)
		{
			ProcessTouch(Other, HitLocation); 
		}
		else 
			ProcessTouch(Other, Other.Location + Other.CollisionRadius * Normal(Location - Other.Location));
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other.IsA('Pawn') )
		PlaySound(PawnImpactSound);

	// log("Projectile:ProcessTouch:"$Other);
	Other.ProjectileHit(Instigator, HitLocation, (MomentumTransfer * Normal(Velocity)), self, getDamageInfo());
}

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	local DamageInfo DInfo;
	
	if ( Role == ROLE_Authority )
	{
		DInfo = GetDamageInfo();
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
		{
			if ( Wall.AcceptDamage(DInfo) )
				Wall.TakeDamage( instigator, Location, MomentumTransfer * Normal(Velocity), GetDamageInfo());
		}
		MakeNoise(1.0);
	}
	Explode(Location + ExploWallOut * HitNormal, HitNormal);

	// Paste a decal on the wall.
	WallDecal(Location, HitNormal);
}

simulated function WallDecal(Vector HitLocation, Vector HitNormal)
{
	// log("Projectile:WallDecal");
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
	{
		// log("Projectile:WallDecal:Spawning Decal");
		Spawn(ExplosionDecal,self,,Location, rotator(HitNormal));
	}
}

simulated function GlassDecal(Vector HitLocation, Vector HitNormal)
{
	// log("Projectile:WallDecal");
	if ( (GlassStrikeDecal != None) && (Level.NetMode != NM_DedicatedServer) )
	{
		// log("Projectile:WallDecal:Spawning Decal");
		Spawn(GlassStrikeDecal,self,,Location, rotator(HitNormal));
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

simulated function CallExplodeDecal(Vector HitLocation)
{
	//
	// This function should be called by the explode function in the case of grenades
	// and explosive packs.
	//
	local vector HitNormal;
	local vector FloorLocation;
	local vector BeginLocation;
	local vector EndLocation;
	local int HitJoint;
		
	FloorLocation = HitLocation;
	BeginLocation = HitLocation;
	EndLocation   = HitLocation;
	
	HitNormal.X = 0;
	HitNormal.Y = 0;
	HitNormal.Z = 1;
	
	// Find the floor under the explosion.
	BeginLocation.Z += 2;
	EndLocation.Z -= 100;
	Trace(FloorLocation,HitNormal,HitJoint,EndLocation,BeginLocation,False);

	ExplodeDecal(FloorLocation,HitNormal);

}

simulated function ExplodeDecal(vector HitLocation, vector HitNormal)
{
	// This function should be overriden to actually draw the decal.
}

simulated final function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;	
}

/*
*/

simulated function genBubbles(vector start, vector dir);
simulated function bool CheckGenBubbles();

defaultproperties
{
     MaxSpeed=2000
     bNetTemporary=True
     bReplicateInstigator=True
     Physics=PHYS_Projectile
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=140
     bSavable=True
     bDirectional=True
     DrawType=DT_Mesh
     Texture=Texture'Engine.S_Camera'
     bGameRelevant=True
     SoundVolume=0
     CollisionRadius=0
     CollisionHeight=0
     bCollideActors=True
     bCollideJoints=True
     bCollideWorld=True
     bGroundMesh=False
     NetPriority=2.5
}
