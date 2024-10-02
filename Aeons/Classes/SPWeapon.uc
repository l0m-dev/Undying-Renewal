//=============================================================================
// SPWeapon.
//=============================================================================
class SPWeapon expands Visible
	abstract;

/* Force-Recompile */

//****************************************************************************
// Member vars.
//****************************************************************************

var() class<Projectile>		ProjClass;			// Projectile fired by the weapon.
var() float					RefireRate;			// Time between shots.
var() sound					FireSound;			// Sound made when firing a shot.
var() bool					bReloadable;		// Set if weapon can be reloaded.
var() float					ReloadTime;			// Time required to reload clip.
var() int					ReloadCount;		// Amount put into clip when reloading.
var() bool					bIsMagical;			// This weapon is actually a spell.
var() float					SpoolUpTime;		// Time needed to charge spell/weapon.
var() float					Accuracy;			// Inherent accuracy.
var() name					AimAnim;			// Aiming weapon/spell animation name.
var() name					RecoilAnim;			// Recoil animation name.
var() name					ReloadStartAnim;	// Name of the reload start animation
var() name					ReloadEndAnim;		// Name of the reload start animation
var int						ClipCount;			// Shots remaining in clip.
var float					ReloadTimer;		// Time left until reload is finished.
var float					RefireFactor;		// Owner's desired refire rate factor.
var() float					FireSoundRadius;	// Radius for sound made by weapon.

// km - further additions for effects and such
var() class<Actor>			MuzzleFlashClass;	// Muzzle flash class to spawn when firing
var() class<Light>			LightClass;			// Class of light to create in front of the SP
var() class<Actor>			EffectClass;		// Class of effect (i.e. particle system smoke) to generate;
var() class<Inventory>		DropClass;
var() class<Inventory>		PickupClass1;
var() class<Inventory>		PickupClass2;

var() name					FireJointName;		// Name of the joint in this weapon mesh that the projectile
												// should fire from - if none, then the projectile will fire
												// from it's location which is likely to be the hand. 

var() vector				EffectOffset;		// If no FireJointName is specified, then I add this vector
												// offset (in this weapon's local axis space; X = forward)
												// to it's location and create the effects there.

//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();

	RefireFactor = 1.0;
	if ( bReloadable )
		ClipCount = ReloadCount;
	else
		ClipCount = -1;
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );

	if ( ReloadTimer > 0.0 )
	{
		ReloadTimer = FMax( ReloadTimer - DeltaTime, 0.0 );
		if ( ReloadTimer == 0.0 )
			Reloaded();
	}
}


//****************************************************************************
// New class functions.
//****************************************************************************
// Drop the weapon
function DropPickups()
{
	local vector		X, Y, Z;
	local Inventory		Inv;

	GetAxes( Owner.Rotation, X, Y, Z );

	if ( PickupClass1 != none )
	{
		Inv = Spawn( PickupClass1,,, Owner.Location + Y * 32, rot(0,0,0) );
		Inv.Velocity = Y * 128;
		Inv.SetPhysics( PHYS_Falling );
	}

	if ( PickupClass2 != none )
	{
		Inv = Spawn( PickupClass2,,, Owner.Location - Y * 32, rot(0,0,0) );
		Inv.Velocity = -Y * 128;
		Inv.SetPhysics( PHYS_Falling );
	}
}

// Drop the weapon
function Drop()
{
	local vector		X, Y, Z;
	local Inventory		Inv;

	GetAxes( Owner.Rotation, X, Y, Z );

	if ( DropClass != none )
	{
		Inv = Spawn( DropClass,,, Owner.Location + X * 32, rot(0,0,0) );
		Inv.Velocity = X * 128;
		Inv.SetPhysics( PHYS_Falling );
	}

	Destroy();
}

// Start weapon firing.
function StartFiring()
{
	GotoState( 'Fire' );
}

// Stop weapon firing.
function StopFiring()
{
	GotoState( 'Idle' );
}

// Set refire rate factor.
function SetRefireFactor( float Rate )
{
	RefireFactor = FMax( 1.0, Rate );
}

// Fire once.
function Projectile FireProjectile()
{
	local ScriptedPawn	SPOwner;
	local pawn			EPawn;
	local vector		PStart;
	local rotator		RAim;

	local vector 		X, Y, Z;

	SPOwner = ScriptedPawn(Owner);
	if ( SPOwner != none )
	{
		GetAxes( SPOwner.Rotation, X, Y, Z );

		// Create the projectile at the location of the effect but shifted forward by the collision radius of the Pawn
		PStart = Location + ( X * SPOwner.CollisionRadius );
		EPawn = SPOwner.Enemy;

		if ( EPawn != none )
			RAim = SPOwner.WeaponAimAt( EPawn, PStart, Accuracy * SPOwner.WeaponAccuracy, true, ProjClass.default.MaxSpeed );
		else
			RAim = SPOwner.WeaponAim( PStart + vector(Owner.Rotation) * 100.0, PStart, Accuracy * SPOwner.WeaponAccuracy );
		return Spawn( ProjClass, Owner,, PStart, RAim );
	}
	return none;
}

function GenerateEffects()
{
	local vector 		EffectLoc, LightLoc, X, Y, Z;

	GetAxes( Rotation, X, Y, Z );
	EffectLoc = GetEffectLocation();

	// Light flash
	if ( LightClass != none )
	{
		LightLoc = Location + ( X * pawn(Owner).CollisionRadius ) + ( Y * EffectOffset.Y ) + ( Z * EffectOffset.Z );
		Spawn( LightClass,,, LightLoc );
	}

	// Effect 
	if ( EffectClass != none )
		Spawn( EffectClass,,, EffectLoc, rotator(X) );

	// Muzzle Flash
	if ( MuzzleFlashClass != none )
		Spawn( MuzzleFlashClass,,, EffectLoc, rotator(X) );
}

//
function PlaySoundFiring()
{
	Owner.PlaySound( FireSound, SLOT_Misc, 1.0,, FireSoundRadius );
	Owner.MakeNoise( 3.0, 1280 * 3 );
}

// Notification that reload is complete.
function Reloaded()
{
}

// Query if weapon is ready to fire.
function bool ReadyToFire()
{
	return ( ReloadTimer <= 0.0 );
}

function PlayReloadStart()
{
	if ( ReloadStartAnim != '' )
		PlayAnim( ReloadStartAnim,, MOVE_None );
}

function PlayReloadEnd()
{
	if ( ReloadEndAnim != '' )
		PlayAnim( ReloadEndAnim,, MOVE_None );
}

function vector GetEffectLocation()
{
	local vector 	X, Y, Z;

	GetAxes( Rotation, X, Y, Z );

	if ( FireJointName != '' )
		return JointPlace(FireJointName).pos;
	else
		return Location + ( X * EffectOffset.X ) + ( Y * EffectOffset.Y ) + ( Z * EffectOffset.Z );
}

function FireEffects()
{
	GenerateEffects();
	PlaySoundFiring();
}


//****************************************************************************
// State code.
//****************************************************************************

//****************************************************************************
// Idle
// Default startup state
//****************************************************************************
auto state Idle
{
	// *** overridden functions ***

BEGIN:
} // state Idle


//****************************************************************************
// Fire
// Default firing state
//****************************************************************************
state Fire
{
	// *** overridden functions ***
	function Reloaded()
	{
		GotoState( , 'FIREAWAY' );
	}

	// *** new (state only) functions ***
	function Reload()
	{
		ClipCount = ReloadCount;
		ScriptedPawn(Owner).WeaponReload( self );
		ReloadTimer = FVariant( ReloadTime, ReloadTime * 0.10 );
	}


BEGIN:
FIREAWAY:
	if ( ReloadTimer > 0.0 )
		goto 'WAIT';
	if ( bReloadable && ( ClipCount == 0 ) )
		goto 'RELOAD';
	if ( pawn(Owner).bFire == 0 )
		StopFiring();

	if ( ScriptedPawn(Owner).PreWeaponFire( self ) )
	{
		FireProjectile();
		GenerateEffects();
		PlaySoundFiring();
		ClipCount -= 1;
		ScriptedPawn(Owner).WeaponFired( self );
	}
	else
		ScriptedPawn(Owner).WeaponMisFired( self );

	if ( bReloadable && ( ClipCount == 0 ) )
		Reload();
	if ( ClipCount != 0 )
		Sleep( FVariant( RefireRate * RefireFactor, RefireRate * RefireFactor * 0.05 ) );
	goto 'FIREAWAY';

RELOAD:
	Reload();

WAIT:
}

defaultproperties
{
     FireSoundRadius=1600
     DrawType=DT_None
     CollisionRadius=4
     CollisionHeight=4
     bGroundMesh=False
     RemoteRole=ROLE_SimulatedProxy
}
