//=============================================================================
// Dynamite_proj.
//=============================================================================
class Dynamite_proj expands WeaponProjectile;

// ==============================================================================
// Sounds
// ==============================================================================
#exec AUDIO IMPORT FILE="E_Wpn_DynaExpl01.wav" NAME="E_Wpn_DynaExpl01" GROUP="Weapons"
#exec AUDIO IMPORT FILE="E_Wpn_DynaExpl02.wav" NAME="E_Wpn_DynaExpl02" GROUP="Weapons"
#exec AUDIO IMPORT FILE="E_Wpn_DynaExpl03.wav" NAME="E_Wpn_DynaExpl03" GROUP="Weapons"

#exec AUDIO IMPORT FILE="E_Wpn_DynaExplUnderwater01.WAV" NAME="E_Wpn_DynaExplUnderwater01" GROUP="Weapons"
#exec AUDIO IMPORT FILE="E_Wpn_DynaExplWater01.WAV" NAME="E_Wpn_DynaExplWater01" GROUP="Weapons"

#exec AUDIO IMPORT FILE="E_Wpn_DynaFuse01.wav" NAME="E_Wpn_DynaFuse01" GROUP="Weapons"

#exec AUDIO IMPORT FILE="..\Dynamite_proj\E_Wpn_DynaFuseLp01.wav" NAME="E_Wpn_DynaFuseLp01" GROUP="Weapons"
#exec AUDIO IMPORT FILE="..\Dynamite_proj\E_Wpn_DynaThrow01.wav" NAME="E_Wpn_DynaThrow01" GROUP="Weapons"

// ==============================================================================
var bool bInWater;				// Projectile is in the water
var bool bFuseLit;				// fuse is lit
var bool bDropped;				// Dynamite was dropped
var bool bDelayExplosion;		// Delay the Explosion?
var int i, sndID;
var() float fuseLen;
var vector loc;
var zoneInfo zi;
var ParticleFX fuseFX, FuseFX2;
var place fusePlace;
var() sound BounceSound[3];
var() sound UnderWaterExplosionSound;
var() sound WaterExplosionSound;
var() sound ExplosionSounds[3];
var wind wind;

var int MinBounceMagnitude;
// ==============================================================================

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	GenerateFuseFX();
}

simulated function SpinRate(float F)
{
	LoopAnim( 'Spin1', F + (0.5*FRand()) );
}

simulated function GenerateFuseFX()
{
	if ( Level.NetMode == NM_DedicatedServer ) 
		return;

	fusePlace = JointPlace('Bone03');
	fuseFX = spawn(class 'DynamiteFuseFX',self,,fusePlace.pos);
	fuseFX.setBase(self,'Bone03');
	fuseFX.RemoteRole = ROLE_None;
	
	FuseFX2 = spawn(class 'DynamiteFuse2FX',self,,fusePlace.pos);
	FuseFX2.setBase(self,'Bone03');
	FuseFX2.RemoteRole = ROLE_None;
}

simulated function BubbleFuse()
{
	local vector p;
	
	if ( fuseFX != None )
	{
		p = fuseFX.location;
		fuseFX.Destroy();
		fuseFX = spawn(class 'BubbleFuseFX',self,,p);
		fuseFX.setBase(self,'Bone03');
	}
}

simulated function ZoneChange( ZoneInfo NewZone )
{
	if ( NewZone.bWaterZone )
	{
		BubbleFuse();
		bInWater = true;
	} 
	else
		bInWater = false;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Velocity = speed * Vector(Rotation);
	SetTimer(fuseLen, false);
}

simulated function Timer()
{
	GotoState('Blow');
}

simulated function Landed(vector HitNormal)
{
	local Texture HitTexture;
	local int flags;
	local vector newDir;
	local float v;
	
	v = VSize(Velocity);
	newDir = reflect(-Normal(Velocity), HitNormal);
	newDir.z *= 0.65;
	Velocity = (v * 0.25) * newDir;

	if ( ImpactSoundClass != None )
	{
		HitTexture = TraceTexture(location - HitNormal*CollisionHeight * 2, location , flags );

		if ( HitTexture != None ) 
			PlayImpactSound( 1, HitTexture, 0, Location, 1.0, 1024, 1.0 );
	}

	MakeNoise(0.3);

	if (v < MinBounceMagnitude)
	{
		PlayAnim('none');
		setPhysics(PHYS_None);
	} 
	else
		LoopAnim('Spin2',0.5);
}

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	local Texture HitTexture;
	local int flags;
	local vector newDir;
	local float v;

	if ( ImpactSoundClass != None )
	{
		HitTexture = TraceTexture(location - HitNormal*CollisionHeight * 2, location , flags );

		if ( HitTexture != None ) 
			PlayImpactSound( 1, HitTexture, 0, Location, 1.0, 1024, 1.0 );
	}
	//PlaySound(ImpactSound, SLOT_Misc, 2.0);
	//playSound(BounceSound[rand(3)], SLOT_Misc);

	MakeNoise(0.3);


	v = VSize(Velocity);
	newDir = reflect(-Normal(Velocity), HitNormal);
	newDir.z *= 0.65;
	Velocity = (v * 0.25) * newDir;

	if (v < MinBounceMagnitude)
	{
		PlayAnim('none');
		setPhysics(PHYS_None);
		if ( Wind != None )
			wind.Destroy();
	} else
		LoopAnim('Spin2',0.5);

}

simulated function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	if ( !DInfo.bMagical )
	{
		if ((DInfo.DamageType == 'dyn_Concussive') || (DInfo.DamageType == 'skull_Concussive') || (DInfo.DamageType == 'phx_Concussive') || (DInfo.DamageType == 'sigil_Concussive') || (DInfo.DamageType == 'Fire'))
			bDelayExplosion = true;

		gotoState('Blow');
	}
}

// ==============================================================================
// 
// ==============================================================================
state Throw
{

	simulated function Tick(float DeltaTime)
	{
		//if (VSize(Velocity) > 8)
		//	PlayAnim('');
	}

	function Timer()
	{
		// sndID = playSound(FuseSound,SLOT_Interact,0.5);
	}

	simulated function BeginState()
	{
		Velocity = ((vector(Rotation) + vect(0,0,0.25)) * speed) + Owner.Velocity;
		Wind = Spawn(class 'DynamiteWind',,,Location);
		Wind.setBase(self);
		SetTimer(getSoundDuration(FuseSound), true);
		
		// fix
		if ( Level.NetMode == NM_Standalone ) 
			if ( FuseSound != none )
				AmbientSound = FuseSound;
	}

	Begin:
		Sleep(fuseLen);
		GotoState('Blow');
		
}

state JustSitThere
{

	Begin:
		if (wind != none)
			wind.Destroy();
		PlayAnim('none');
		SetPhysics(PHYS_None);
}
// ==============================================================================
// Idle
// ==============================================================================
auto state Idle
{

	Begin:
}

// ==============================================================================
// Blow
// ==============================================================================
state Blow
{
	function Tick(float DeltaTime);
	
// 	simulated function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo);

	simulated function BeginState()
	{
		if ( bDelayExplosion ) 
			SetTimer(0.35, false);
		else
		{
			Disable('TakeDamage');
			StopSound(sndID);
			Destroy();
		}
	}

	simulated function Timer()
	{
			Disable('TakeDamage');
			Destroy();
	}
/*
	Begin:
		if (bDelayExplosion)
			sleep((FRand() * 0.5) + 0.15);
		// I'm blowing up... no need to take any more damage!!!

		Disable('TakeDamage');
		destroy();
*/
}


/*
simulated function Expired()
{
	Warn("SoundID=" $ SndID);

	if (wind != none)
		wind.Destroy();
	stopSound(sndID);
	if ( fuseFX != None )
		fuseFX.bShuttingDown = true;
	if ( fuseFX2 != None )
		fuseFX2.bShuttingDown = true;

}
*/

simulated function Destroyed()
{
	Warn("SoundID=" $ SndID);

	if (Wind != none)
		Wind.Destroy();
	
	if ( sndID > 0 )
		StopSound(sndID);
	
	if ( fuseFX != None )
		FuseFX.bShuttingDown = true;

	if ( fuseFX2 != None )
		FuseFX2.bShuttingDown = true;

	if ( Region.Zone.bWaterZone )
		Spawn (class 'UnderwaterExplosionFX',,,Location);
	else
		Spawn (class 'DynamiteExplosion',Pawn(Owner),,Location);

	MakeNoise( 5.0, 2560.0 );
}


simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local vector NewDir;
	
	if ( Other.IsA('Pawn') && (Other != Owner) )
		Pawn(Other).PlayDamageMethodImpact('Medium', HitLocation, Normal(Location-HitLocation));

	NewDir = Normal(Velocity);
	NewDir.z = 0;
	Velocity = (-NewDir) * speed * 0.25;
}

defaultproperties
{
     fuseLen=3
     BounceSound(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_DynaBounceGen01'
     BounceSound(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_DynaBounceGen02'
     BounceSound(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_DynaBounceGen03'
     UnderWaterExplosionSound=Sound'Aeons.Weapons.E_Wpn_DynaExplUnderwater01'
     WaterExplosionSound=Sound'Aeons.Weapons.E_Wpn_DynaExplWater01'
     ExplosionSounds(0)=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     ExplosionSounds(1)=Sound'Aeons.Weapons.E_Wpn_DynaExpl02'
     ExplosionSounds(2)=Sound'Aeons.Weapons.E_Wpn_DynaExpl03'
     MinBounceMagnitude=40
     FuseSound=Sound'Aeons.Weapons.E_Wpn_DynaFuseLp01'
     ExplodeSound=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     HeadShotMult=1
     Speed=600
     Damage=100
     MomentumTransfer=150000
     MyDamageType=dyn_concussive
     MyDamageString="blown up"
     ProjImpactSound=Sound'Impacts.SurfaceSpecific.E_Wpn_DynaBounceGen01'
     ExplosionDecal=Class'Aeons.ExplosionDecal'
     ImpactSound(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_DynaBounceGen01'
     ImpactSound(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_DynaBounceGen02'
     ImpactSound(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_DynaBounceGen03'
     ImpactSoundClass=Class'Aeons.DynImpact'
     bNetTemporary=False
     Physics=PHYS_Falling
     LifeSpan=0
     Mesh=SkelMesh'Aeons.Meshes.Dynamite_m'
     SoundRadius=64
     SoundVolume=128
     ImpactID=OT_Dynamite
     CollisionRadius=16
     CollisionHeight=8
     bProjTarget=True
     LightType=LT_Flicker
     LightBrightness=255
     LightHue=33
     LightRadius=18
     bBounce=True
}
