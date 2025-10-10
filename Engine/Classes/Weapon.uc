//=============================================================================
// Parent class of all weapons.
//=============================================================================
class Weapon extends Inventory
	abstract
	native;

// removed nativereplication to replicate bAltAmmo

//#exec Texture Import File=Textures\Weapon.pcx Name=S_Weapon Mips=On Flags=2

//-----------------------------------------------------------------------------
// Weapon ammo/firing information:
// Two-element arrays here are defined for normal fire (0) and alt fire (1).
var() float   MaxTargetRange;    // Maximum distance to target.
var() class<ammo> AmmoName;      // Type of ammo used.
var() class<ammo> AltAmmoName;   // Type of ammo used.
var() byte    ReloadCount;       // Amount of ammo depletion before reloading. 0 if no reloading is done.
var() int     PickupAmmoCount;   // Amount of ammo initially in pick-up item.
var travel ammo	AmmoType;		 // Inventory Ammo being used.
var	  bool	  bPointing;		 // Indicates weapon is being pointed
var() bool	  bInstantHit;		 // If true, instant hit rather than projectile firing weapon
var(WeaponAI) bool	  bWarnTarget;		 // When firing projectile, warn the target
var(WeaponAI) bool	  bAltWarnTarget;	 // When firing alternate projectile, warn the target
var   bool	  bWeaponUp;		 // Used in Active State
var   bool	  bChangeWeapon;	 // Used in Active State
var   bool 	  bLockedOn;
var(WeaponAI) bool	  bSplashDamage;	 // used by bot AI
var(WeaponAI) bool	  bRecommendSplashDamage; //if true, bot preferentially tries to use splash damage
											  // rather than direct hits
var(WeaponAI) bool	  bRecommendAltSplashDamage; //if true, bot preferentially tries to use splash damage
											  // rather than direct hits
var() bool	  bWeaponStay;
var() bool	  bOwnsCrosshair;	// this weapon is responsible for drawing its own crosshair (in its postrender function)
var	  bool	  bHideWeapon;		// if true, weapon is not rendered
var(WeaponAI) bool	  bMeleeWeapon; //Weapon is only a melee weapon
var() bool	  bRapidFire;		// used by human animations in determining firing animation (for still firing)
var	travel  bool	  bSpecialIcon;

var() float	  FiringSpeed;		// used by human animations in determining firing speed

var()   vector	FireOffset;		 // Offset from drawing location for projectile/trace start
var()   class<projectile> ProjectileClass;
var()   class<projectile> AltProjectileClass;
var()	name MyDamageType;
var()	name AltDamageType;
var		float	ProjectileSpeed;
var		float	AltProjectileSpeed;
var		float	AimError;		// Aim Error for bots (note this value doubled if instant hit weapon)
var()	float	ShakeMag;
var()	float	ShakeTime;
var()	float   ShakeVert;
var(WeaponAI)	float	AIRating;
var(WeaponAI)	float	RefireRate;
var()   float   Accuracy;       //inherent weapon accuracy -for rapid fire spread

//-----------------------------------------------------------------------------
// Sound Assignments
var() sound 	FireSound;
var() sound 	AltFireSound;
var() sound 	CockingSound;
var() sound 	SelectSound;
var() sound 	Misc1Sound;
var() sound 	Misc2Sound;
var() sound 	Misc3Sound;

var() Localized string MessageNoAmmo;
var() Localized string DeathMessage;
var() Color NameColor;	// used when drawing name on HUD

var Rotator AdjustedAim;

// Alternate Ammo methods
var travel bool bAltAmmo;			// Weapon has AltAmmo loaded

//-----------------------------------------------------------------------------
// Muzzle Flash
// weapon is responsible for setting and clearing bMuzzleFlash whenever it wants the
// MFTexture drawn on the canvas (see RenderOverlays() )
var bool bSetFlashTime;
var(MuzzleFlash) bool bDrawMuzzleFlash;
var byte bMuzzleFlash;
var float FlashTime;
var(MuzzleFlash) float MuzzleScale, FlashY, FlashX, FlashLength; //FlashO, FlashC, FlashLength, ;
var(MuzzleFlash) texture MFTexture0, MFTexture1;
var(MuzzleFlash) ERenderStyle FlashStyle0,FlashStyle1;

// var(MuzzleFlash) int FlashS;	// size of (square) texture/2
// var(MuzzleFlash) texture MuzzleFlare;
// var(MuzzleFlash) float FlareOffset; 

var() float WeaponFov;
var() Localized string AltDeathMessage;

// Network replication
//
replication
{
	// Things the server should send to the client.
	reliable if( bNetOwner && (Role==ROLE_Authority) )
		AmmoType, bLockedOn, bHideWeapon,
		bAltAmmo;
	
	reliable if( Role==ROLE_Authority )
		ClientIdleWeapon, ClientReloadWeapon; // things like activating items are server sided so this is needed for now
}

//=============================================================================
// Inventory travelling across servers.

event TravelPostAccept()
{
	Super.TravelPostAccept();
	if ( Pawn(Owner) == None )
		return;
	if ( AmmoName != None )
	{
		if ( !bAltAmmo )
			AmmoType = Ammo(Pawn(Owner).FindInventoryType(AmmoName));
		else
			AmmoType = Ammo(Pawn(Owner).FindInventoryType(AltAmmoName));

		if ( AmmoType == None )
		{
			if (!bAltAmmo)
				AmmoType = Spawn(AmmoName);	// Create ammo type required		
			else
				AmmoType = Spawn(AltAmmoName);	// Create ammo type required		

			Pawn(Owner).AddInventory(AmmoType);		// and add to player's inventory
			AmmoType.BecomeItem();
			AmmoType.AmmoAmount = PickUpAmmoCount; 
			AmmoType.GotoState('Idle2');
		}
	}
	if ( self == Pawn(Owner).Weapon )
		BringUp();
	else GoToState('Idle2');
}

function Destroyed()
{
	Super.Destroyed();
	if( (Pawn(Owner)!=None) && (Pawn(Owner).Weapon == self) )
		Pawn(Owner).Weapon = None;
}

//=============================================================================
// Weapon rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
	local rotator NewRot;
	local bool bPlayerOwner;
	local int Hand;
	local PlayerPawn PlayerOwner;
	local float	InnerLeft, InnerWidth;

	if ( bHideWeapon || (Owner == None) )
		return;

	PlayerOwner = PlayerPawn(Owner);

	if ( PlayerOwner != None )
	{
		if ( PlayerOwner.DesiredFOV != PlayerOwner.DefaultFOV )
			return;
		bPlayerOwner = true;
		Hand = PlayerOwner.Handedness;

		if (  (Level.NetMode == NM_Client) && (Hand == 2) )
		{
			bHideWeapon = true;
			return;
		}
	}

	if ( !bPlayerOwner || (PlayerOwner.Player == None) )
		Pawn(Owner).WalkBob = vect(0,0,0);

	if ( (bMuzzleFlash > 0) && bDrawMuzzleFlash && Level.bHighDetailMode && (MFTexture0 != None) )
	{
		if (Canvas.SizeY / Canvas.SizeX < 0.75 )
		{
			InnerWidth = Canvas.SizeY / 0.75;
			InnerLeft = (Canvas.SizeX - InnerWidth) / 2;
		}
		else
		{
			InnerWidth = Canvas.SizeX;
			InnerLeft = 0;
		}

		MuzzleScale = Default.MuzzleScale * Canvas.ClipY/480.0; // Canvas.ClipX/640.0
		if ( !bSetFlashTime )
		{
			bSetFlashTime = true;
			FlashTime = Level.TimeSeconds + FlashLength;
		}
		else if ( FlashTime < Level.TimeSeconds )
			bMuzzleFlash = 0;
		if ( bMuzzleFlash > 0 )
		{
			/*
			if ( Hand == 0 )
				Canvas.SetPos(Canvas.ClipX/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipX * (-0.2 * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipY * (FlashY + FlashC));
			else
				Canvas.SetPos(Canvas.ClipX/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipX * (Hand * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - 0.5 * MuzzleScale * FlashS + Canvas.ClipY * FlashY);
			*/
			
			Canvas.SetPos((InnerLeft + InnerWidth * FlashX) - (0.5 * MFTexture0.USize * MuzzleScale), (Canvas.ClipY * FlashY) - (0.5 * MFTexture0.USize * MuzzleScale));
			// Canvas.SetPos((Canvas.ClipX * FlashX) - (0.5 * FlashS * MuzzleScale), (Canvas.ClipY * FlashY) - (0.5 * FlashS * MuzzleScale));
			Canvas.Style = FlashStyle0;
			Canvas.DrawIcon(MFTexture0, MuzzleScale);

			if (MFTexture1 != none)
			{
				Canvas.Style = FlashStyle1;
				Canvas.SetPos((InnerLeft + InnerWidth * FlashX) - (0.5 * MFTexture1.USize * MuzzleScale), (Canvas.ClipY * FlashY) - (0.5 * MFTexture1.USize * MuzzleScale));
				Canvas.DrawIcon(MFTexture1, MuzzleScale);
			}

			Canvas.Style = 1;
		}
	}
	else
		bSetFlashTime = false;



	SetLocation( Owner.Location + CalcDrawOffset() );
	NewRot = Pawn(Owner).ViewRotation;

	if ( Hand == 0 )
		newRot.Roll = -2 * Default.Rotation.Roll;
	else
		newRot.Roll = Default.Rotation.Roll * Hand;

	setRotation(newRot);

	Canvas.DrawActorFixedFov(self, 90, false);
}

//-------------------------------------------------------
// AI related functions

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetWeaponStay();
	MaxDesireability = 1.2 * AIRating;
	if ( ProjectileClass != None )
	{
		ProjectileSpeed = ProjectileClass.Default.Speed;
		MyDamageType = ProjectileClass.Default.MyDamageType;
	}
	if ( AltProjectileClass != None )
	{
		AltProjectileSpeed = AltProjectileClass.Default.Speed;
		AltDamageType = AltProjectileClass.Default.MyDamageType;
	}
}

function bool SplashJump()
{
	return false;
}

function SetWeaponStay()
{
	bWeaponStay = bWeaponStay || Level.Game.bCoopWeaponMode;
}

// tell the bot how much it wants this weapon
// called when the bot is trying to decide which inventory item to go after next
event float BotDesireability(Pawn Bot)
{
	local Weapon AlreadyHas;
	local float desire;

	// bots adjust their desire for their favorite weapons
	desire = MaxDesireability + Bot.AdjustDesireFor(self);

	// see if bot already has a weapon of this type
	AlreadyHas = Weapon(Bot.FindInventoryType(class)); 
	if ( AlreadyHas != None )
	{
		if ( (RespawnTime < 10) 
			&& ( bHidden || (AlreadyHas.AmmoType == None) 
				|| (AlreadyHas.AmmoType.AmmoAmount < AlreadyHas.AmmoType.MaxAmmo)) )
			return 0;

		// can't pick it up if weapon stay is on
		if ( (!bHeldItem || bTossedOut) && bWeaponStay )
			return 0;
		if ( AlreadyHas.AmmoType == None )
			return 0.25 * desire;

		// bot wants this weapon for the ammo it holds
		if ( AlreadyHas.AmmoType.AmmoAmount > 0 )
			return FMax( 0.25 * desire, 
					AlreadyHas.AmmoType.MaxDesireability
					 * FMin(1, 0.15 * AlreadyHas.AmmoType.MaxAmmo/AlreadyHas.AmmoType.AmmoAmount) ); 
		else
			return 0.05;
	}
	
	// incentivize bot to get this weapon if it doesn't have a good weapon already
	if ( (Bot.Weapon == None) || (Bot.Weapon.AIRating <= 0.4) )
		return 2*desire;

	return desire;
}

function float RateSelf( out int bUseAltMode )
{
	if ( (AmmoType != None) && (AmmoType.AmmoAmount <=0) )
		return -2;
	bUseAltMode = int(FRand() < 0.4);
	return (AIRating + FRand() * 0.05);
}

// return delta to combat style
function float SuggestAttackStyle()
{
	return 0.0;
}

function float SuggestDefenseStyle()
{
	return 0.0;
}

//-------------------------------------------------------

simulated function PreRender( canvas Canvas );
simulated function PostRender( canvas Canvas );

function ClientWeaponEvent(name EventType);

function bool HandlePickupQuery( inventory Item )
{
	local int OldAmmo;
	local Pawn P;

	if (Item.Class == Class)
	{
		if ( Weapon(item).bWeaponStay && (!Weapon(item).bHeldItem || Weapon(item).bTossedOut) )
			return true;
		P = Pawn(Owner);
		if ( AmmoType != None )
		{
			OldAmmo = AmmoType.AmmoAmount;
			if ( AmmoType.AddAmmo(Weapon(Item).PickupAmmoCount) && (OldAmmo == 0) 
				&& (P.Weapon.class != item.class) && !P.bNeverSwitchOnPickup )
					WeaponSet(P);
		}
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
		if (Item.PickupMessageClass == None)
			P.ClientMessage(Item.PickupMessage, 'Pickup');
		else
			P.ReceiveLocalizedMessage( Item.PickupMessageClass, 0, None, None, item.Class );
		Item.PlaySound(Item.PickupSound);
		Item.MakeNoise(0.5, (1280*0.5));
		Item.SetRespawn();   
		return true;
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

// set which hand is holding weapon
function setHand(float Hand)
{
	// Left = 1,   Right = -1
	Hand = 1;

	if ( Hand == 2 )
	{
		PlayerViewOffset.Y = 0;
		FireOffset.Y = 0;
		bHideWeapon = true;
		return;
	}
	else
		bHideWeapon = false;

	if ( Hand == 0 )
	{
		PlayerViewOffset.X = Default.PlayerViewOffset.X * 0.88;
		PlayerViewOffset.Y = -0.2 * Default.PlayerViewOffset.Y;
		PlayerViewOffset.Z = Default.PlayerViewOffset.Z * 1.12;
	}
	else
	{
		PlayerViewOffset.X = Default.PlayerViewOffset.X;
		PlayerViewOffset.Y = Default.PlayerViewOffset.Y * Hand;
		PlayerViewOffset.Z = Default.PlayerViewOffset.Z;
	}

	PlayerViewOffset *= 100; //scale since network passes vector components as ints
	FireOffset.Y = Default.FireOffset.Y * Hand;
}


function toggleAmmoType()
{
	local Ammo NewAmmo;
	
	if ( (AmmoType.AmmoAmount <= 0) && (AmmoType != none) )
	{
		AmmoType.GotoState('Deactivated');
		if ( bAltAmmo )
		{
			NewAmmo = Ammo(Pawn(Owner).FindInventoryType(AmmoName));
		} else {
			NewAmmo = Ammo(Pawn(Owner).FindInventoryType(AltAmmoName));
		}
		if ( NewAmmo != None )
			NewAmmo.Activate();
	}
}

function checkAltAmmo()
{
	local Ammo NewAmmo;

	if (AmmoType != none)
		if ( AmmoType.AmmoAmount <= 0 )
		{
			if ( bAltAmmo )
			{
				AmmoType.GotoState('Deactivated');
				NewAmmo = Ammo(Pawn(Owner).FindInventoryType(AmmoName));
				if ( NewAmmo != None )
					NewAmmo.Activate();
				PlayerPawn(Owner).SelectedItem = NewAmmo;
			}
			// don't automaticly switch to Alternate ammo type.
			//else
			//	AmmoType = Ammo(Pawn(Owner).FindInventoryType(AltAmmoName));
		}
}


//
// Change weapon to that specificed by F matching inventory weapon's Inventory Group.
/*
simulated function Inventory FindItemInGroup( byte F )
{
	local Inventory Inv;
	local Weapon newWeapon;
	local int Count;

	for( Inv=self; Inv!=None && Count < 1000; Inv=Inv.Inventory )
	{
		if ( Inv.InventoryGroup == F )
		{
			newWeapon = Weapon(Inv);
			if ( newWeapon != None )
			{
				newWeapon.checkAltAmmo();
				newWeapon.bHaveTokens = ((newWeapon.AmmoType == None) || (newWeapon.AmmoType.AmmoAmount > 0));
			}
			return newWeapon;
		}
		Count++;
	}

	return None;
}
*/

// Either give this inventory to player Other, or spawn a copy
// and give it to the player Other, setting up original to be respawned.
// Also add Ammo to Other's inventory if it doesn't already exist
//
function inventory SpawnCopy( pawn Other )
{
	local Weapon Copy;

	if( Level.Game.ShouldRespawn(self) )
	{
		Copy = spawn(Class,Other,,,rot(0,0,0));
		Copy.Tag           = Tag;
		Copy.Event         = Event;
		Copy.PickupAmmoCount = PickupAmmoCount;
		if ( AmmoName != None )
			Copy.AmmoName = AmmoName;
		if ( !bWeaponStay )
			GotoState('Sleeping');
	}
	else
		Copy = self;

	Copy.RespawnTime = 0.0;
	Copy.bHeldItem = true;
	Copy.bTossedOut = false;
	Copy.GiveTo( Other );
	Copy.Instigator = Other;
	Copy.GiveAmmo(Other);
	Copy.SetSwitchPriority(Other);
	if ( !Other.bNeverSwitchOnPickup )
		Copy.WeaponSet(Other);
	Copy.AmbientGlow = 0;
	return Copy;
}

function SetSwitchPriority(pawn Other)
{
	local int i;
	local name temp, carried;

	if ( PlayerPawn(Other) != None )
	{
		for ( i=0; i<ArrayCount(PlayerPawn(Other).WeaponPriority); i++)
			if ( PlayerPawn(Other).WeaponPriority[i] == class.name )
			{
				AutoSwitchPriority = i;
				return;
			}
		// else, register this weapon
		carried = class.name;
		for ( i=AutoSwitchPriority; i<ArrayCount(PlayerPawn(Other).WeaponPriority); i++ )
		{
			if ( PlayerPawn(Other).WeaponPriority[i] == '' )
			{
				PlayerPawn(Other).WeaponPriority[i] = carried;
				return;
			}
			else if ( i<ArrayCount(PlayerPawn(Other).WeaponPriority)-1 )
			{
				temp = PlayerPawn(Other).WeaponPriority[i];
				PlayerPawn(Other).WeaponPriority[i] = carried;
				carried = temp;
			}
		}
	}		
}

function GiveAmmo( Pawn Other )
{
	if ( AmmoName == None )
		return;

	if ( !bAltAmmo )
		AmmoType = Ammo(Other.FindInventoryType(AmmoName));
	else
		AmmoType = Ammo(Other.FindInventoryType(AltAmmoName));

	if ( AmmoType != None )
		AmmoType.AddAmmo(PickUpAmmoCount);
	else
	{
		if ( !bAltAmmo )
			AmmoType = Spawn(AmmoName);	// Create ammo type required
		else
			AmmoType = Spawn(AltAmmoName);	// Create ammo type required

		Other.AddInventory(AmmoType);		// and add to player's inventory
		AmmoType.BecomeItem();
		AmmoType.AmmoAmount = PickUpAmmoCount; 
		AmmoType.GotoState('Idle2');
	}
}	

// fill the weapon with maximum ammo
function FillMaxAmmo()
{
	AmmoType.AmmoAmount = AmmoType.MaxAmmo;
}

// Return the switch priority of the weapon (normally AutoSwitchPrioirity, but may be
// modified by environment (or by other factors for bots)
function float SwitchPriority() 
{
	local float temp;
	local int bTemp;

	if ( !Owner.IsA('PlayerPawn') )
		return RateSelf(bTemp);
	else if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) )
	{
		if ( Pawn(Owner).Weapon == self )
			return -0.5;
		else
			return -1;
	}
	else 
		return AutoSwitchPriority;
}

// Compare self to current weapon.  If better than current weapon, then switch
function bool WeaponSet(Pawn Other)
{
	local bool bSwitch,bHaveAmmo;
	local Inventory Inv;
	local weapon W;
	
	if ( Other.Weapon == self)
		return false;

	if ( Other.Weapon == None )
	{
		Other.PendingWeapon = self;
		Other.ChangedWeapon();
		return true;	
	}
	else if ( !PlayerPawn(Owner).bNeverAutoSwitch ) //Other.Weapon.SwitchPriority() < SwitchPriority() ) 
	{
		W = Other.PendingWeapon;
		Other.PendingWeapon = self;
		GotoState('');

		if ( Other.Weapon.PutDown() )
			return true;
		Other.PendingWeapon = W;
		return false;
	}
	else 
	{
		GoToState('');
		return false;
	}
}

function Weapon RecommendWeapon( out float rating, out int bUseAltMode )
{
	local Weapon Recommended;
	local float oldRating, oldFiring;
	local int oldMode;

	if ( Owner.IsA('PlayerPawn') )
		rating = SwitchPriority();
	else
	{
		rating = RateSelf(bUseAltMode);
		if ( (self == Pawn(Owner).Weapon) && (Pawn(Owner).Enemy != None) 
			&& ((AmmoType == None) || (AmmoType.AmmoAmount > 0)) )
			rating += 0.21; // tend to stick with same weapon
	}
	if ( inventory != None )
	{
		Recommended = inventory.RecommendWeapon(oldRating, oldMode);
		if ( (Recommended != None) && (oldRating > rating) )
		{
			rating = oldRating;
			bUseAltMode = oldMode;
			return Recommended;
		}
	}
	return self;
}

// Toss this weapon out
function DropFrom(vector StartLocation)
{
	if ( !SetLocation(StartLocation) )
		return; 
	AIRating = Default.AIRating;
	bMuzzleFlash = 0;
	AmbientSound = None;
	if ( AmmoType != None )
	{
		PickupAmmoCount = AmmoType.AmmoAmount;
		AmmoType.AmmoAmount = 0;
	}
	Super.DropFrom(StartLocation);
}

// Become a pickup
function BecomePickup()
{
	Super.BecomePickup();
	SetDisplayProperties(Default.Style, Default.Texture, Default.bUnlit, Default.bMeshEnviromap );
}

simulated function TweenToStill();

//**************************************************************************************
//
// Firing functions and states
//

function CheckVisibility()
{
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	if( Owner.bHidden && (PawnOwner.Health > 0) && (PawnOwner.Visibility < PawnOwner.Default.Visibility) )
	{
		Owner.bHidden = false;
		PawnOwner.Visibility = PawnOwner.Default.Visibility;
	}
}

simulated function bool ClientFire( float Value )
{
//	log("Weapon: ClientFire: Warning, this just returns True!");
	return true;
}

function ForceFire();

function Fire( float Value )
{
	local Pawn P, P2;
	local Vector FireDir, WpnToPawn;
	local Float DotProd, BigRatio, VecLen, Thresh, Ratio;
	
	if (AmmoType.UseAmmo(1))
	{
		if (PlayerPawn(Owner).bUsingAutoAim)
			AutoAimDir = Pawn(Owner).ViewRotation;

		if (!PlayerPawn(Owner).bHaveTarget && PlayerPawn(Owner).bUsingAutoAim)
		{
			BigRatio = 0.0;
			FireDir = vector (Pawn(Owner).ViewRotation);
			ForEach RadiusActors(class 'Pawn', P, 2048)
			{
				if (P.Health > 0.0)	// Only check live actors.
				{
					if (P.JointIndex('Pelvis') >= 0)
						WpnToPawn = P.JointPlace('Pelvis').Pos - Pawn(Owner).Location;
					else
						WpnToPawn = P.JointPlace('Spine2').Pos - Pawn(Owner).Location;
					VecLen = Sqrt (WpnToPawn.X * WpnToPawn.X + WpnToPawn.Y * WpnToPawn.Y + WpnToPawn.Z * WpnToPawn.Z);
					WpnToPawn.Z -= Pawn(Owner).EyeHeight;
					WpnToPawn = Normal (WpnToPawn);
					DotProd = FireDir dot WpnToPawn;
					Thresh = 1.0 - (4.0 / VecLen);
					if (Thresh < 0.85)
						Thresh = 0.85;
					Ratio = (DotProd - Thresh) / (1.0 - Thresh);
					
					if ((DotProd > Thresh) && (Ratio > BigRatio))
					{
						AutoAimDir = rotator (WpnToPawn);
						P2 = P;
						BigRatio = Ratio;
					}
				}
			}
			if (P2 != None)
				P2.WeaponFireNotify(self.class.name, Pawn(Owner));
		}
		else
		{
			ForEach RadiusActors(class 'Pawn', P, 2048)
			{
				if ( P != Pawn(Owner) )
				{
					if ( FastTrace(Pawn(Owner).Location, P.Location) )
						P.WeaponFireNotify(self.class.name, Pawn(Owner));
				}
			}
		}
		PlayFiring();
		// GotoState('NormalFire');
	}
	else
		GotoState('NewClip');
}
/*
this is our new one, but we are trying the one above to see if we can 
keep as much of the original weapon functionality as possible
function Fire( float Value )
{
	LogActor("Weapon: Fire");

	if (AmmoType.UseAmmo(1))
	{
		GotoState('NormalFire');
		if ( PlayerPawn(Owner) != None )
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		bPointing=True;

		PlayFiring();
		if ( !bRapidFire && (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		if ( bInstantHit )
			TraceFire(0.0);
		else
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
		if ( Owner.bHidden )
			CheckVisibility();
	}
}
*/

simulated function ClientIdleWeapon()
{
	//log("Weapon: ClientIdleWeapon");
}

simulated function ClientReloadWeapon(int CurrentClipCount)
{
	//log("Weapon: ClientReloadWeapon");
}

function Reload();

simulated function PlayFiring()
{
	//log("Weapon: PlayFiring");
	//Play firing animation and sound
}

simulated function PlayAltFiring()
{
	//Play alt firing animation and sound
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
	local Vector Start, EndTrace, X,Y,Z;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	PlayerPawn(Owner).MakePlayerNoise(1.0);
	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = PawnOwner.AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
	EndTrace = Start + Accuracy * (FRand() - 0.5 )* Y * 1000
		+ Accuracy * (FRand() - 0.5 ) * Z * 1000;
	AdjustedAim = rotator( (EndTrace - Start) + 10000 * vector(AdjustedAim) );
	return Spawn(ProjClass,,, Start,AdjustedAim);	
}

function TraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local int HitJoint;
	local actor Other;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);

	PlayerPawn(Owner).MakePlayerNoise(1.0);
	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	StartTrace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = PawnOwner.AdjustAim(1000000, StartTrace, 2*AimError, False, False);	
	EndTrace = StartTrace + Accuracy * (FRand() - 0.5 )* Y * 1000
		+ Accuracy * (FRand() - 0.5 ) * Z * 1000;
	X = vector(AdjustedAim);
	EndTrace += (10000 * X); 
	Other = PawnOwner.TraceShot(HitLocation,HitNormal,HitJoint,EndTrace,StartTrace);
	ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	//Spawn appropriate effects at hit location, any weapon lights, and damage hit actor
}

// Finish a firing sequence
function Finish()
{
	local Pawn PawnOwner;

	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
		return;
	}

	PawnOwner = Pawn(Owner);
	if ( PlayerPawn(Owner) == None )
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) )
		{
			PawnOwner.StopFiring();
			PawnOwner.SwitchToBestWeapon();
			if ( bChangeWeapon )
				GotoState('DownWeapon');
		}
		else if ( (PawnOwner.bFire != 0) && (FRand() < RefireRate) )
			Global.Fire(0);
		else 
		{
			PawnOwner.StopFiring();
			GotoState('Idle');
		}
		return;
	}
	if ( ((AmmoType != None) && (AmmoType.AmmoAmount<=0)) || (PawnOwner.Weapon != self) )
		GotoState('Idle');
	else if ( PawnOwner.bFire!=0 )
		Global.Fire(0);
	else 
		GotoState('Idle');
}

///////////////////////////////////////////////////////
state NormalFire
{
	function Fire(float F) 
	{
	}

Begin:
	FinishAnim();
	Finish();
}

//**********************************************************************************
// Weapon is up, but not firing
state Idle
{
	function AnimEnd()
	{
		//LogActor("state Idle: AnimEnd");
		PlayIdleAnim();
	}

	function bool PutDown()
	{
		//LogActor("state Idle: PutDown");
		GotoState('DownWeapon');
		return True;
	}

Begin:
	//LogActor("state Idle: Begin");
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	if ( Pawn(Owner).bFire!=0 ) Fire(0.0);
	Disable('AnimEnd');
	PlayIdleAnim();
	ClientIdleWeapon();
}

//
// Bring newly active weapon up
state Active
{
	function Fire(float F) 
	{
	}

	function bool PutDown()
	{
		if ( bWeaponUp ) //rb UT had this for early switch ? || (AnimFrame < 0.75) )
			GotoState('DownWeapon');
		else
			bChangeWeapon = true;
		return True;
	}

	function BeginState()
	{
		//LogActor("Weapon: state Active: BeginState, Settting bChangeWeapon to false");
		bChangeWeapon = false;
	}

Begin:
	FinishAnim();
	if ( bChangeWeapon )
		GotoState('DownWeapon');
	bWeaponUp = True;
	PlayPostSelect();
	FinishAnim();
	Finish();
}

//
// Putting down weapon in favor of a new one.
//
State DownWeapon
{
	ignores Fire, Reload; //rb I had Reload commented out before Multiplayer PreAlpha

	function bool PutDown()
	{
		//LogActor("Weapon: state DownWeapon: PutDown");
		Pawn(Owner).ClientPutDown(self, Pawn(Owner).PendingWeapon);
		return true; //just keep putting it down
	}

	function BeginState()
	{
		//LogActor("Weapon: state DownWeapon: BeginState");
		bChangeWeapon = false;
		bMuzzleFlash = 0;
		Pawn(Owner).ClientPutDown(self, Pawn(Owner).PendingWeapon);
	}

Begin:
	//LogActor("Weapon: state DownWeapon: Begin:");
	if (((!self.IsA('Molotov')) && (!self.IsA('Phoenix'))) || (AmmoType.AmmoAmount > 0))
	{
		TweenDown();	
		FinishAnim();
	}
	else
	{
		TweenSelect();
	}
	//Sleep(2);
	Pawn(Owner).ChangedWeapon();
}

simulated function ClientPutDown(Weapon NextWeapon);

function BringUp()
{
	if ( Owner.IsA('PlayerPawn') )
	{
		SetHand(PlayerPawn(Owner).Handedness);
		//rb	UT had this, but we commented out a long time ago
		//		I guess our zoom is persistent through weapon changes
		//PlayerPawn(Owner).EndZoom();
	}	
	bWeaponUp = false;
	PlaySelect();
	GotoState('Active');
}

function RaiseUp(Weapon OldWeapon)
{
	BringUp();
}

function bool PutDown()
{
	bChangeWeapon = true;
	return true; 
}

function TweenDown()
{
	//Log("Weapon: TweenDown");
	if ( (AnimSequence != '') && (AnimSequence == 'Select') ) //(GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence ); //rb TweenAnim( AnimSequence, AnimFrame * 0.4 );
	else
		PlayAnim('Down'); //rb PlayAnim('Down', 1.0, 0.05);
}

function TweenSelect()
{
	TweenAnim('Select'); //rb TweenAnim('Select',0.001);
}

function PlaySelect()
{
	PlayAnim('Select',,,,0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).VolumeMultiplier);
	PlayerPawn(Owner).MakePlayerNoise(0.5 * Pawn(Owner).VolumeMultiplier, 640 * Pawn(Owner).VolumeMultiplier);
}

function PlayPostSelect()
{
}

function PlayIdleAnim()
{
}

defaultproperties
{
     MaxTargetRange=4096
     ProjectileSpeed=1000
     AltProjectileSpeed=1000
     aimerror=550
     shakemag=300
     shaketime=0.1
     shakevert=5
     AIRating=0.1
     RefireRate=0.5
     MessageNoAmmo=" has no ammo."
     DeathMessage="%o was killed by %k's %w."
     AltDeathMessage="%o was killed by %k's %w."
     NameColor=(R=255,G=255,B=255)
     MuzzleScale=4
     FlashLength=0.1
     AutoSwitchPriority=1
     InventoryGroup=1
     PickupMessage="You got a weapon"
     ItemName="Weapon"
     RespawnTime=30
     PlayerViewOffset=(X=30,Z=-5)
     MaxDesireability=0.5
     WeaponFov=110
     Icon=Texture'Engine.S_Weapon'
     Texture=Texture'Engine.S_Weapon'
     bNoSmooth=True
}
