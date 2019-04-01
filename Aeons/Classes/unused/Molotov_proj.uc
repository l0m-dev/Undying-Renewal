//=============================================================================
// Molotov_proj.
//=============================================================================
class Molotov_proj expands WeaponProjectile;

#exec MESH IMPORT MESH=Molotov_m SKELFILE=Molotov.ngf

//=============================================================================
// Sounds =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-
//=============================================================================

// Explosion sound
#exec AUDIO IMPORT FILE="E_Wpn_MoltExpl01.wav" NAME="E_Wpn_MoltExpl01" GROUP="Weapons"
#exec AUDIO IMPORT FILE="E_Wpn_MoltBounce01.wav" NAME="E_Wpn_MoltBounce01" GROUP="Weapons"
#exec AUDIO IMPORT FILE="E_Wpn_MoltFireLoop01vL.wav" NAME="E_Wpn_MoltFireLoop01" GROUP="Weapons"

//=============================================================================

var bool bDropped;				// Molotov was dropped, not thrown

var int i;						// Counter
var int numExplosionBits;		// Number of molotovFire_proj bits to spawn
var int maxSkips, numSkips;		// Maximum number of skips a molotov can 

var float fuseLen;				// fuse time length
var float FlyLen;				// how long have I been flying???
var float dripTimer;			// how often do I drip?

var vector wallHitNormal;		// normal of the surface the projectile has just hit
var vector loc, dir;			//
var vector impactDirection;		// direction of molotov at impact to a wall or actor
var() sound ColHardSounds[3];
var() sound ColSoftSounds[3];

var MolotovFire_particles fPart;
var MolotovFire_proj fProj, clone;

var wind wind;

//----------------------------------------------------------------------------

simulated function PostBeginPlay()
{
	local vector X,Y,Z;
	local rotator RandRot;

	Super.PostBeginPlay();
	
	//if ( Owner.IsA('Pawn') )
	//	Velocity = vector(Pawn(Owner).ViewRotation) * speed;
	//else
	
	Velocity = vector(Rotation) * speed;
	
	LoopAnim('EndOverEnd');
	
	numExplosionBits = Rand(3) + 3;
	setPhysics(PHYS_Falling);

	// only the client should spawn the particles, if the server spawns them here, there will be
	// an extra one on the client that will linger
	if ( Level.Netmode != NM_DedicatedServer )
	{
		// spawn the particle effect and setup all initial params
		fPart = Spawn(class 'molotovFire_particles',self,,(Location) + vect(0,0,32), Rotation);
		
		if ( fPart != None )
		{
			fPart.setPhysics(PHYS_None);
			fPart.setBase(self, 'Molotov_5');
			fPart.AlphaStart.Base = 1;
			fPart.ParticlesPerSec.Base = 128;
			fPart.LifeTime.Base = 0.15;
			fPart.LifeTime.Rand = 0.15;
			fPart.GravityModifier = -1;
			fPart.SizeWidth.Base = 16;
			fPart.SizeLength.Base = 16;
			fPart.AngularSpreadWidth.Base = 60;
			fPart.AngularSpreadHeight.Base = 60;
			fPart.SourceWidth.Base = 2;
			fPart.SourceHeight.Base = 2;
		}
	}

	maxSkips = 4;
	numSkips = 0;
}

//----------------------------------------------------------------------------

simulated function ZoneChange( ZoneInfo NewZone )
{

	Super.ZoneChange(NewZone);

	if ( NewZone.bWaterZone )
	{
		fPart.bShuttingDown = true;
		LightType = LT_None;
	}
}

//----------------------------------------------------------------------------

// not simulated so the client can't call it
function generateSmallDrip(vector offset)
{
	if ( bInWater ) 
		return;

	clone = spawn(class 'MolotovFire_proj',,,(Location + offset), Rotator(Vect(0,0,1)));

	if ( clone != None ) 
	{
		clone.gotoState('Dropping');
	}
}

//----------------------------------------------------------------------------

simulated function Timer()
{
	enable('HitWall');
}

//----------------------------------------------------------------------------

simulated function PlayBounceSound(vector HitLocation, vector HitNormal, Texture HitTexture)
{

	if (HitTexture != none)
	{
		switch( HitTexture.ImpactID )
		{
			case TID_Stone:					// Stone
			case TID_Metal:					// Metal
			case TID_WoodSolid:				// Solid Wood
			case TID_WoodHollow:			// Hollow Wood
				PlaySound(ColHardSounds[Rand(3)]);
				break;
		
			default:						// default
				PlaySound(ColSoftSounds[Rand(3)]);
				break;
		};

		if ( ImpactSoundClass != None )
			PlayImpactSound( 1, HitTexture, 0, HitLocation, 1.0, 1024, 1.0 );

		// Create the surface effect.
		Dust(HitLocation, HitNormal, HitTexture, 0.5);
	}
}

//----------------------------------------------------------------------------

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	local float threshold, dp, ang;
	local int Flags;
	local vector Start, End;
	local Texture HitTexture;

	start = Location;
	end = start + (-HitNormal * 128);

	HitTexture = TraceTexture(End, Start, Flags);
	
	threshold = cos(60 * 0.0174532);
	dp = Normal(-Velocity) dot HitNormal;
	
	// log("HIT WALL :     "$name);
	/*
	log("HIT WALL Hit Normal:     "$HitNormal);
	log("HIT WALL Threshold:     "$Threshold);
	log("HIT WALL Dot Product:     "$dp);
	log("Hit Wall");
	*/

	wallHitNormal = HitNormal;
	dir = Normal(HitNormal + Normal(Velocity));
	// bCanHitInstigator = true;
	// PlaySound(ImpactSound, SLOT_Misc, 2.0);
	// LoopAnim('Spin',1.0);
	if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered && !bInWater )
	{
		if ( Role == ROLE_Authority )
			if (Wall.AcceptDamage(GetDamageInfo('Fire')))
				Wall.TakeDamage( instigator, Location, MomentumTransfer * Normal(Velocity), getDamageInfo('Fire'));
		SetRotation(Rotator(HitNormal));
		Destroy();
		return;
	}
	MakeNoise(0.3);

	if (numSkips == maxSkips)
	{
		if ( !bInWater )
		{
			SetRotation(Rotator(HitNormal));
			Destroy();
		}
		else
		{
			Velocity = vect(0,0,0);
			SetRotation(Rotator(HitNormal));
		}
		return;
	}

	if (dp > threshold)
	{
		SetRotation(Rotator(HitNormal));
		Destroy();
		return;
	} 
	else 
	{
		PlayBounceSound(Location, HitNormal, HitTexture);

		if ( FRand() > 0.75 )
			generateSmallDrip(vect(0,0,8));

		numSkips ++;

		Velocity = Reflect(-Velocity, HitNormal) * VSize(Velocity) * HitTexture.Elasticity;

		if ( (FRand() > 0.5) && (numSkips > 1) )
		{
			// High skip
			Velocity.x *= 0.5;
			Velocity.y *= 0.5;
			Velocity.z *= 1 + FRand();
			LoopAnim('EndOverEnd',2);
	
		} 
		else 
		{
			// Low Skip
			Velocity *= RandRange(0.8, 1.0);
			Velocity.z *= 0.6;
			LoopAnim('Wobble');
		}
		setRotation(Rotator(-Velocity));
	}

	disable('HitWall');
	setTimer(0.1, false);
}

//----------------------------------------------------------------------------

auto state Flying
{
	simulated function Tick(float DeltaTime)
	{
		//log("MolotovProj: " $ self $ "  Flying: Tick:  bInWater = " $ bInWater);
		flyLen += deltaTime;
		if ( (flyLen > DripTimer) && (FRand() > 0.7) )
		{
			generateSmallDrip(vect(0,0,0));
			flyLen = 0;
			dripTimer = 0.5 + FRand();
		}

	}

	simulated function Landed(vector HitNormal)
	{
		local float threshold, dp;
		local int Flags;
		local vector Start, End;
		local Texture HitTexture;
	
		start = Location;
		end = start + (-HitNormal * 128);
	
		HitTexture = TraceTexture(End, Start, Flags);
		

		threshold = cos(60);
		dp = Normal(-Velocity) dot HitNormal;
		
		PlayBounceSound(Location, HitNormal, HitTexture);
	
		if (dp > threshold )
		{
			setRotation(Rotator(HitNormal));
			Destroy();
		} 
		else 
		{
			numSkips ++;
			Velocity -= 2 * ( Velocity dot HitNormal) * HitNormal;  
			setRotation(Rotator(-Velocity));
		}
	}

	simulated function ProcessTouch(Actor Other, Vector HitLocation)
	{
		// can't hit self
		if (Other != Owner)
		{
			if ( Other.IsA('ScriptedPawn') )
				Pawn(Other).OnFire(true);
			
			if (Other.AcceptDamage(GetDamageInfo('Fire')))
				Other.TakeDamage( instigator, Location, MomentumTransfer * Normal(Velocity), getDamageInfo('Fire'));
			
			SetRotation(rot(0,0,0));
			Destroy();
		}
	}

	simulated function BeginState()
	{
		flyLen = 0;
		DripTimer = 1 + (FRand() * 0.8);

		if ( Level.NetMode != NM_DedicatedServer )
		{
			wind = spawn(class 'DynamiteWind',,,Location);

			if ( Wind != None )
				wind.setBase(self);
		}
	}

}

//----------------------------------------------------------------------------
   
// Destroyed - creathe my explosion and clean up
simulated function Destroyed()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( Region.Zone.bWaterZone )
		{
			Spawn(class 'MolotovWaterExplosion',,,Location, Rotation);
			MakeNoise( 1.0, 2560.0 );
		} 
		else 
		{
			if ( Pawn(Owner) != none )
				Spawn(class 'MolotovExplosion',pawn(Owner),,Location, Rotation);
			else
				Spawn(class 'MolotovExplosion',,,Location, Rotation);
		
			MakeNoise( 5.0, 2560.0 );
		}
		
		if ( fPart != None ) 
			fPart.bShuttingDown = true;
		
		if ( Wind != None ) 
			wind.Destroy();
	}
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     ColHardSounds(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_MoltBounceHard01'
     ColHardSounds(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_MoltBounceHard02'
     ColHardSounds(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_MoltBounceHard03'
     ColSoftSounds(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_MoltBounceSoft01'
     ColSoftSounds(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_MoltBounceSoft02'
     ColSoftSounds(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_MoltBounceSoft03'
     HeadShotMult=1
     Speed=800
     Damage=40
     ProjImpactSound=Sound'Aeons.Weapons.E_Wpn_MoltBounce01'
     MiscSound=Sound'Aeons.Weapons.E_Wpn_MoltExpl01'
     ImpactSound(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_MoltBounceHard01'
     ImpactSound(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_MoltBounceHard02'
     ImpactSound(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_MoltBounceHard03'
     ImpactSoundClass=Class'Aeons.MoltImpact'
     LifeSpan=10
     RotationRate=(Pitch=1024,Yaw=-1024,Roll=1024)
     Mesh=SkelMesh'Aeons.Meshes.Molotov_m'
     DrawScale=2
     LightType=LT_Steady
     LightEffect=LE_TorchWaver
     LightBrightness=217
     LightHue=29
     LightSaturation=21
     LightRadius=19
     bBounce=True
}
