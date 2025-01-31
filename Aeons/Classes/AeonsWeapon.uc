//=============================================================================
// AeonsWeapon.		This is the base class for all weapons in Aeons
//=============================================================================
class AeonsWeapon extends Weapon;

//////////////////////////////////////////////////////////////////////////////
//	Import
//////////////////////////////////////////////////////////////////////////////
//#exec AUDIO IMPORT  FILE="E_Wpn_GenPck01.wav" NAME="E_Wpn_GenPck01" GROUP="Weapons"

//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts
//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//////////////////////////////////////////////////////////////////////////////
//	Variables
//////////////////////////////////////////////////////////////////////////////
var() int   NumRicoSounds;
var() sound RicoSounds[8];
var travel int ClipCount;
var() bool  bReloadable;
var() int   hitdamage;
var() float MomentumTransfer; //For instant hit weapons
var bool    bDestroyOnEmpty;
var() localized String ExpireMessage; // Message shown when no weapon ammo and bDestroyOnEmpty
var bool    bDestroyMe; //we've expired and dying
var() bool  bWaterFire; //can fire under water
var() bool  bAltWaterFire; //can alt fire under water
var() float ReloadTime;		// how long do I take to reload?

var() sound OpenSound;
var() sound CloseSound;
var() class<Decal> ExplosionDecal;

var() Mesh AltAmmoMesh;

var() float HeadShotMult;	// Damage Multiplier for a head shot
var() name ThirdPersonJointName;
var float RefireMult;

//weapon new multiplayer variables
var bool bCanClientFire;
var bool bForceFire;
var() float FireTime; //used to synch server and client firing up
var float FireStartTime;
var Mesh TempMesh;
var bool bFiring;

//////////////////////////////////////////////////////////////////////////////
//	Replication
//////////////////////////////////////////////////////////////////////////////
replication
{
    // Things the server should send to the client.
    Reliable if ( bNetOwner && (Role == ROLE_Authority) )
        ClipCount, bCanClientFire, RefireMult; //Affector  //rb can we do without clipcount here ? 
		// maybe move to specific weapons that need it ?
}

//////////////////////////////////////////////////////////////////////////////
//	Functions
//////////////////////////////////////////////////////////////////////////////

function ForceFire()
{
	//Log("AeonsWeapon: Global ForceFire");
	Fire(0);
}

//----------------------------------------------------------------------------

function SetWeaponStay()
{
	if ( Level.NetMode != NM_Standalone && Level.Game.IsA('DeathMatchGame') )
		bWeaponStay = bWeaponStay || DeathMatchGame(Level.Game).bMultiWeaponStay;
	else		
		bWeaponStay = bWeaponStay || Level.Game.bCoopWeaponMode;
}

//----------------------------------------------------------------------------

//
// Toss this item out.
//
function DropFrom(vector StartLocation)
{
	bCanClientFire = false;
	bSimFall = true;
/* //rb
	SimAnim.X = 0;
	SimAnim.Y = 0;
	SimAnim.Z = 0;
	SimAnim.W = 0;
*/
	if ( !SetLocation(StartLocation) )
		return; 
	AIRating = Default.AIRating;
	bMuzzleFlash = 0;
	if ( AmmoType != None )
	{
		PickupAmmoCount = AmmoType.AmmoAmount;
		AmmoType.AmmoAmount = 0;
	}
	RespawnTime = 0.0; //don't respawn
	SetPhysics(PHYS_Falling);
	RemoteRole = ROLE_DumbProxy;
	BecomePickup();
	NetPriority = 2.5;
	bCollideWorld = true;
	if ( Pawn(Owner) != None )
		Pawn(Owner).DeleteInventory(self);
	Inventory = None;
	GotoState('PickUp', 'Dropped');
}

//----------------------------------------------------------------------------

simulated function ClientPutDown(weapon NextWeapon)
{
	if ( Level.NetMode == NM_Client )
	{
		//LogActor("ClientPutDown");
		bCanClientFire = false;
		bMuzzleFlash = 0;
		TweenDown();
		if ( AeonsPlayer(Owner) != None )
			AeonsPlayer(Owner).ClientPending = NextWeapon;
		GotoState('ClientDown');
	}
}

//----------------------------------------------------------------------------

/*
simulated function BringUp()
{
	Super.BringUp();
	bForceFire = false;
	bCanClientFire = false;
	if ( !IsAnimating() && !Level.bIsCutsceneLevel)
		PlayIdleAnim();
	Owner.PlaySound(SelectSound, SLOT_Misc, 1.0);	
}
*/

//----------------------------------------------------------------------------

simulated function TweenToStill()
{
	//LogActor("AeonsWeapon: TweenToStill");
	TweenAnim('Still', 0.1);
}

//----------------------------------------------------------------------------

simulated function AnimEnd()
{
	//Log("AeonsWeapon: Global AnimEnd"); 
	if ( (Level.NetMode == NM_Client) && (Mesh != PickupViewMesh) )
		PlayIdleAnim();
//	else
//		Log("AeonsWeapon: Global AnimEnd: " $ Level.NetMode @ Mesh @ PickupViewMesh);
}

//----------------------------------------------------------------------------

simulated function ForceClientFire()
{
	//LogActor("AeonsWeapon: ForceClientFire");
	ClientFire(0);
}

//----------------------------------------------------------------------------

simulated function bool ClientFire( float Value )
{
	//log("AeonsWeapon: ClientFire: ... bCanClientFire = "$bCanClientFire);
	if ( bCanClientFire && ((Role == ROLE_Authority) || (AmmoType == None) || (AmmoType.AmmoAmount > 0)) )
	{
		if ( (Owner.GetStateName() == 'DialogScene') || (Owner.GetStateName() == 'PlayerCutscene') || (Owner.GetStateName() == 'SpecialKill') || (Owner.GetStateName() == 'Dying') )
			return false;
		
		if ( (PlayerPawn(Owner) != None) 
			&& ((Level.NetMode == NM_Standalone) || PlayerPawn(Owner).Player.IsA('ViewPort')) )
		{
//rb			if ( InstFlash != 0.0 )
//rb				PlayerPawn(Owner).ClientInstantFlash( InstFlash, InstFog);
//rb			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		}
//rb		if ( Affector != None )
//rb			Affector.FireEffect();
		//Log("AeonsWeapon: ClientFire: bCanClientFire && ( Server || Ammo )");
		PlayFiring();
		if ( Role < ROLE_Authority )
		{
			//Log("AeonsWeapon: ClientFire: Client: GotoState('ClientFiring')");
			GotoState('ClientFiring');
		}
		return true;
	}
	return false;
}		

//----------------------------------------------------------------------------

simulated function ClientReloadWeapon(int CurrentClipCount)
{
	// we need to take in CurrentClipCount since ClipCount isn't replicated yet
	if (Level.NetMode != NM_Client || AmmoType == None || GetStateName() == 'ClientReload')
		return;

	if (CurrentClipCount != -1)
		ClipCount = CurrentClipCount;
	
	if ( bReloadable && (AmmoType.AmmoAmount>0) && (AmmoType.AmmoAmount != ClipCount) )
    {
        if ( PlayerPawn(Owner) != None )
            PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		
		if (ClipCount == ReloadCount)
		{
			PlayAnim('ReloadEnd',RefireMult/AeonsPlayer(Owner).refireMultiplier,,,0);
		}
		else
		{
			PlayAnim('ReloadStart',RefireMult / AeonsPlayer(Owner).refireMultiplier,,,0);
		}
		if ( Role < ROLE_Authority )
		{
			GotoState('ClientReload');
		}
	}
}	

//----------------------------------------------------------------------------

simulated function ClientIdleWeapon()
{
    if (Level.NetMode != NM_Client)
		return;
	
	if (GetStateName() != 'ClientIdle')
		GotoState('ClientIdle');
}

//----------------------------------------------------------------------------

function PlaySelect()
{
	//LogActorState("AeonsWeapon: PlaySelect");
	bForceFire = false;
	bCanClientFire = false;
	if ( !IsAnimating() || (AnimSequence != 'Select') && !Level.bIsCutsceneLevel)
		PlayAnim('Select');//rb ,1.0,0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, 1.0);	
}

//----------------------------------------------------------------------------

simulated function PlayPostSelect()
{
	//Log("AeonsWeapon: PlayPostSelect");
	if ( Level.NetMode == NM_Client )
	{
		//Log("AeonsWeapon: PlayPostSelect called on Client");
		if ( (bForceFire || (PlayerPawn(Owner).bFire != 0)) && Global.ClientFire(0) )
			return;
		//Log("AeonsWeapon: PlayPostSelect calling GotoState('')");
		GotoState('ClientIdle');
		AnimEnd();
	}
//	else
//		Log("AeonsWeapon: PlayPostSelect called but Level.NetMode != NM_Client");
}

//----------------------------------------------------------------------------

simulated function TweenDown()
{
	if ( IsAnimating() && (AnimSequence != '') && (AnimSequence == 'Select') ) //(GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence ); //rb , AnimFrame * 0.4 );
	else
		PlayAnim('Down'); //rb , 1.0, 0.05);
}

//----------------------------------------------------------------------------

simulated function PlayIdleAnim()
{
	//LogActorState("PlayIdleAnim: This is Empty!!!");
}

//----------------------------------------------------------------------------

simulated function Landed(vector HitNormal)
{
	local rotator newRot;

	newRot = Rotation;
	newRot.pitch = 0;
	SetRotation(newRot);
}

//----------------------------------------------------------------------------

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
		P.ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
		Item.PlaySound(Item.PickupSound);

//rb 
/*
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
*/
		Item.SetRespawn();   
		return true;
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

//----------------------------------------------------------------------------

auto state Pickup
{
	ignores AnimEnd;

	// Landed on ground.
	simulated function Landed(Vector HitNormal)
	{
		local rotator newRot;

		newRot = Rotation;
		newRot.pitch = 0;
		SetRotation(newRot);
		if ( Role == ROLE_Authority )
		{
			bSimFall = false;
			SetTimer(2.0, false);
		}
	}
}

//----------------------------------------------------------------------------

state ClientFiring
{
	simulated function bool ClientFire(float Value)
	{
		//LogActor("AeonsWeapon: state ClientFiring: ClientFire");
		return false;
	}

	simulated function AnimEnd()
	{
		//LogActor("AeonsWeapon: state ClientFiring: AnimEnd");
		if ((Pawn(Owner) == None)||((AmmoType != None)&&(AmmoType.AmmoAmount <= 0)))
		{
			PlayIdleAnim();
			GotoState('ClientIdle');
		}
		else if ( !bCanClientFire )
			GotoState('ClientIdle');
		else if ( Pawn(Owner).bFire != 0 )
			Global.ClientFire(0);
		else
		{
			PlayIdleAnim();
			GotoState('ClientIdle');
		}
	}


	simulated function BeginState()
	{
		//LogActor("AeonsWeapon: state ClientFiring: BeginState");
	}

	simulated function EndState()
	{
		//LogActor("AeonsWeapon: state ClientFiring: EndState");
		AmbientSound = None;
	}

}

//----------------------------------------------------------------------------

state NormalFire
{
	function ForceFire()
	{
		//LogActor("AeonsWeapon: state NormalFire: ForceFire");
		bForceFire = true;
	}

	function Fire(float F) 
	{
	}

	function AnimEnd()
	{
		//LogActor("AeonsWeapon: state NormalFire: AnimEnd");
		Finish();
	}

	function BeginState()
	{
		//LogActor("AeonsWeapon: NormalFire: BeginState");
	}



Begin:
	//LogActor("AeonsWeapon: state NormalFire: Begin");
	Sleep(0.0);
}

//----------------------------------------------------------------------------

simulated function AttachWeapon(name PawnJointName)
{
	TempMesh = Mesh;
	Mesh = ThirdPersonMesh;
	if ( ThirdPersonJointName != 'none' )
		SetBase( Owner, PawnJointName, ThirdPersonJointName );
	else
		SetBase( Owner, PawnJointName, 'root' );
	Mesh = TempMesh;
}

state Active
{
	ignores animend;
	
	function ForceFire()
	{
		//LogActor("AeonsWeapon: state Active: ForceFire");
		bForceFire = true;
	}

	function EndState()
	{
		//LogActor("AeonsWeapon: state Active: EndState");
		Super.EndState();
		bForceFire = false;
	}

Begin:
	//LogActor("AeonsWeapon: state Active: Begin:");
	
	// our attachment stuff
	AttachWeapon(AeonsPlayer(Owner).GetWeaponAttachJoint());
	
	// eh! mek mi sum pi!
	//PlaySelect();
	FinishAnim();

	if ( bChangeWeapon )
		GotoState('DownWeapon');
	bWeaponUp = True;
	PlayPostSelect();
	FinishAnim();
	bCanClientFire = true;
	
	if ( (Level.Netmode != NM_Standalone) && Owner.IsA('AeonsPlayer')
		&& (PlayerPawn(Owner).Player != None)
		&& !PlayerPawn(Owner).Player.IsA('ViewPort') )
	{
		if ( bForceFire || (Pawn(Owner).bFire != 0) )
			AeonsPlayer(Owner).SendFire(self);
		else if ( !bChangeWeapon )
			AeonsPlayer(Owner).UpdateRealWeapon(self);
	} 
	Finish();
}

//----------------------------------------------------------------------------

/*
State ClientActive
{
	simulated function ForceClientFire()
	{
		//LogActor("AeonsWeapon: state ClientActive: ForceClientFire");
		Global.ClientFire(0);
	}

	simulated function bool ClientFire(float Value)
	{
		//LogActor("AeonsWeapon: state ClientActive: ClientFire");
		bForceFire = true;
		return bForceFire;
	}

	simulated function AnimEnd()
	{
		//LogTime("AeonsWeapon: state ClientActive: AnimEnd Sequence="$AnimSequence);
		if ( Owner == None )
		{
			Global.AnimEnd();
			GotoState('');
		}
		else if ( Owner.IsA('AeonsPlayer') 
			&& (AeonsPlayer(Owner).ClientPending != None) )
			GotoState('ClientDown');
		else if ( bWeaponUp )
		{
			if ( (bForceFire || (PlayerPawn(Owner).bFire != 0)) && Global.ClientFire(0) )
				return;

			PlayIdleAnim();
			GotoState('ClientIdle');
		}
		else
		{
			//LogTime("AeonsWeapon: state ClientActive: calling PlayPostSelect");
			PlayPostSelect();
			bWeaponUp = true;
		}
	}

	simulated function BeginState()
	{
		//LogActor("AeonsWeapon: state ClientActive: BeginState");
		bForceFire = false;
		bWeaponUp = false;
		//PlaySelect();
		PlayAnim('Select',[TweenTime]0.1); // needs some tweentime or it can get stuck and AnimEnd won't trigger
	}

	simulated function EndState()
	{
		//LogActor("AeonsWeapon: state ClientActive: EndState");
		bForceFire = false;
	}
}
*/

state ClientActive
{
	simulated function BeginState()
	{
		//LogActor("AeonsWeapon: state ClientActive: BeginState");
		bForceFire = false;
		bWeaponUp = false;

		// fix PlayerViewOffset being incorrect until replication
		PlayerViewOffset = Default.PlayerViewOffset * 100; //scale since network passes vector components as ints

		//Owner.PlaySound(SelectSound, SLOT_Misc, 1.0);
		GotoState('ClientIdle');
	}
}

//----------------------------------------------------------------------------

State ClientDown
{
	simulated function ForceClientFire()
	{
		Global.ClientFire(0);
	}

	simulated function bool ClientFire(float Value)
	{
		return false;
	}

	simulated function Tick(float DeltaTime)
	{
		local AeonsPlayer A;

		A = AeonsPlayer(Owner);
		if ( !A.bNeedActivate || ((A.Weapon != self) && (A.Weapon != None)) )
			GotoState('ClientIdle');
	}
		
	simulated function AnimEnd()
	{
		local AeonsPlayer A;

		A = AeonsPlayer(Owner);
		if ( A != None )
		{
			if ( (A.ClientPending != None) 
				&& (A.ClientPending.Owner == Owner) )
			{
				A.Weapon = A.ClientPending;
				A.Weapon.GotoState('ClientActive');
				A.ClientPending = None;
				GotoState('ClientIdle');
			}
			else
			{
				Enable('Tick');
				A.NeedActivate();
			}
		}
	}

	simulated function BeginState()
	{
		Disable('Tick');
	}
}

//----------------------------------------------------------------------------

State DownWeapon
{
	ignores Fire, AnimEnd;

	function BeginState()
	{
		//LogActor("AeonsWeapon: state DownWeapon: BeginState");
		
		Super.BeginState();
		bCanClientFire = false;
	}

	function EndState()
	{
		super.EndState();

		//rb our setbase stuff
		SetBase(None);
	}
}

//----------------------------------------------------------------------------

// handles idle animation and weapon getting stuck in an animation
State ClientIdle
{
	simulated function AnimEnd()
	{
		Global.AnimEnd();
	}

	simulated function BeginState()
	{
		PlayIdleAnim();
		// force it to true for now
		if ( Pawn(Owner) != None && Pawn(Owner).Weapon == Self )
			bCanClientFire = True;
		if ( bCanClientFire && (PlayerPawn(Owner) != None) )
		{
			if ( bForceFire || (Pawn(Owner).bFire != 0) )
			{
				Global.ClientFire(0);
				return;
			}
		}
		enable('Tick');
	}

	simulated function Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);

		if (Owner != None)
		{
			if ( VSize(Owner.Velocity) > 300 && !Owner.Region.Zone.bWaterZone )
			{
				if (IsA('Revolver') || IsA('Phoenix'))
					LoopAnim('IdleMove', [TweenTime] TweenFrom('IdleStill', 0.5));
				else
					LoopAnim('MoveIdle', [TweenTime] TweenFrom('StillIdle', 0.5));
			} else {
				if (IsA('Revolver') || IsA('Phoenix'))
					LoopAnim('IdleStill', [TweenTime] TweenFrom('IdleMove', 0.5));
				else
					LoopAnim('StillIdle', [TweenTime] TweenFrom('MoveIdle', 0.5));
			}
		}
	}
}


//----------------------------------------------------------------------------

function BeginPlay()
{
	Super.BeginPlay();
	RefireMult = 1.0;
}

//----------------------------------------------------------------------------

simulated event RenderOverlays( canvas Canvas )
{
	if ( AeonsPlayer(Owner) != None )
	{
		if ( AeonsPlayer(Owner).Opacity == 1.0 )
		{
			if (AeonsPlayer(Owner).bRenderWeapon)
				Opacity = FClamp(Opacity + 0.05, 0, 1);
			else
				Opacity = FClamp(Opacity - 0.05, 0, 1);
		} else {
			Opacity = FClamp(AeonsPlayer(Owner).Opacity, 0.15, 1);
		}
	}

	super.RenderOverlays(Canvas);
}

//----------------------------------------------------------------------------

// fill the weapon with maximum ammo
function FillMaxAmmo()
{
	ClipCount = ReloadCount;
	super.FillMaxAmmo();
}

//----------------------------------------------------------------------------

function PostBeginPlay()
{
    ClipCount = ReloadCount;
    Super.PostBeginPlay();

	// weapon animations for first person spectating, increased bandwith, this would also need increased NetUpdateFrequency
	//if (Level.NetMode != NM_Client)
	//	bClientAnim = false;
}

// weapon animations for first person spectating
/* 
simulated function PostNetBeginPlay()
{
	if (Owner != None && ViewPort(PlayerPawn(Owner).Player) == None)
		bClientAnim = false;
}
*/

//----------------------------------------------------------------------------

/*
function PlayPostSelect()
{
	if ( Owner != none )
		if ( ItemName != "" )
			Pawn(Owner).ClientMessage(ItemName$" Selected");
	super.PlayPostSelect();
}
*/

//----------------------------------------------------------------------------

function float RateSelf( out int bUseAltMode )
{
    if ( (AmmoType != None) && (AmmoType.AmmoAmount <=0) )
        return -2;
    bUseAltMode = 0;
	return AIRating;		// BUGBUG: TEMP: don't add any randomness until AIRatings are balanced
//    return (AIRating + FRand() * 0.05);
}

//----------------------------------------------------------------------------
//rb UT didn't have this in TournamentWeapon?
function Destroyed()
{
    local Actor tmpOwner;

    tmpOwner = Owner;
	Super.Destroyed();
	if( (Pawn(Owner)!=None) && (Pawn(Owner).Weapon == self) )
		Pawn(Owner).Weapon = None;
    if (PlayerPawn(tmpOwner) != None)
    {
        PlayerPawn(tmpOwner).SwitchToBestWeapon();
    }
}

//----------------------------------------------------------------------------

function PlayFireEmpty()
{
}

//----------------------------------------------------------------------------

simulated function PlayFiring()
{
	//LogActor("AeonsWeapon: PlayFiring");
	// just play the anim - the animation drives the rest of the weapon functionality
	playAnim('Fire', 1.0 / AeonsPlayer(Owner).refireMultiplier);//,1.0,,,0);
}

//----------------------------------------------------------------------------
/* //rb
function Fire( float Value )
{
	LogActor("AeonsWeapon: Fire: Value =" $ Value);

    if ( Pawn(Owner).HeadRegion.Zone.bWaterZone && !bWaterFire)
    {
        PlayFireEmpty();
    } 
	else if (bReloadable && ClipCount<=0) 
	{
		checkAltAmmo();
        PlayFireEmpty();
        GoToState('NewClip');
    } 
	else 
	{
		gotoState('');
        Super.Fire(Accuracy);
	}
}
*/

//----------------------------------------------------------------------------
/* //rb new
function Fire( float Value )
{
	RefireMult = 1.0 / AeonsPlayer(Owner).refireMultiplier;
	if ( (AmmoType == None) && (AmmoName != None) )
	{
		// ammocheck
		GiveAmmo(Pawn(Owner));
	}
	if ( AmmoType.UseAmmo(1) )
	{
		LogActorState("AeonsWeapon: Fire: Ammo Available: Executing");
		GotoState('NormalFire');
		bPointing=True;
		bCanClientFire = true;
		ClientFire(Value);
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		if ( bInstantHit )
			TraceFire(0.0);
		else
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
	}
}
*/

//----------------------------------------------------------------------------

function PlayFireSoundServer()
{
	if (bAltAmmo)
		Owner.PlayOwnedSound(AltFireSound);
	else
		Owner.PlayOwnedSound(FireSound);
}

simulated function FireWeapon()
{
	local float Value;
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		if ( PlayerPawn(Owner) != None )
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);

		if ( !bRapidFire && (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
	}

	if ( bInstantHit )
		TraceFire(Value);
	else
	{
		if ( bAltAmmo )
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget, true);
		else
			ProjectileFire(AltProjectileClass, ProjectileSpeed, bWarnTarget, true);
	}
	if ( AeonsPlayer(Owner).bWeaponSound )
	{
	    AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280 * 3);
		if (Level.NetMode == NM_Client)
		{
			if (bAltAmmo)
				Owner.PlaySound(AltFireSound);
			else
				Owner.PlaySound(FireSound);
		}
		else
		{
			// playing sounds here won't replicate since it's a simulated function
			// we need to call a non simulated function
			PlayFireSoundServer();
		}
	}

	if (bMuzzleFlashParticles && Role < ROLE_Authority)
	{
		bMuzzleFlash++;
	}

	bPointing=True;
	//bCanClientFire = true;
	//ClientFire(Value);

	if (Level.NetMode != NM_Client)
	{
		if ( Owner.bHidden )
			CheckVisibility();

		gotoState('NormalFire');
	}
}

//----------------------------------------------------------------------------

function Reload()
{
    if ( bReloadable && (AmmoType.AmmoAmount>0) && (AmmoType.AmmoAmount != ClipCount) )
    {
        if ( PlayerPawn(Owner) != None )
            PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
        GotoState('NewClip');
    }
}

//----------------------------------------------------------------------------

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    local vector realLoc;
    local sound RicoCur; // "current" ricochet sound
    
    // Need a new muzzle flash  
    //realLoc = Owner.Location + CalcDrawOffset();
    //spawn(class'WeaponLight',, '', realLoc + 25.0 * X + 0.1 * FireOffset.Y * Y, rot(0,0,0));

    if ((Other != self) && (Other != Owner) && (Other != None) ) 
    {
        Other.TakeDamage(Pawn(Owner), HitLocation, MomentumTransfer*X, getDamageInfo());

        if ( !Other.IsA('Pawn') && !Other.IsA('Carcass') )
        {
            WallDecal(HitLocation, HitNormal);
            // spawn(class'SmokePuff',,,HitLocation+(HitNormal*9));

            // This ricochet sound call is not correct.
            // The colt is making the ricochet sound, not the bullet hit location.
            RicoCur = RicoSounds[Rand(NumRicoSounds)];
            PlaySound(RicoCur, SLOT_Misc, 25.0);
            MakeNoise(1.0, 1280);
        }
    }       
}

//----------------------------------------------------------------------------

// Finish a firing sequence
function Finish()
{
    local Pawn PawnOwner;
    local PlayerPawn PlayerPawnOwner;
	local bool bForce;

	//Log("AeonsWeapon: Finish()");

	bForce = bForceFire;
	bForceFire = false;

    if ( bChangeWeapon )
	{
        GotoState('DownWeapon');
		return;
	}

    PawnOwner = Pawn(Owner);

	if ( PawnOwner == None )
		return;

    PlayerPawnOwner = PlayerPawn(Owner);

	if ( PlayerPawnOwner == None )
	{
		//rb is this for BOT's  ?
		//Log("AeonsWeapon: I think this is for BOT's.  We shouldn't get here !!!!");	

		/*
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
		*/

	}

/* //rb is this kyle's ?
    else if ( bDestroyOnEmpty && (AmmoType.AmmoAmount<=0) && PlayerPawnOwner != None )
    {
        bDestroyMe = True;
		PawnOwner.ClientMessage(ExpireMessage, 'Event');
        Destroy();
    }
*/

	//LogActor("AeonsWeapon: Finish: bReloadable="$bReloadable$" ClipCount="$ClipCount);

    if ( ((AmmoType != None) && (AmmoType.AmmoAmount<=0)) || (PawnOwner.Weapon != self) )
        GotoState('Idle');
//rb newweapon
	else if (bReloadable && ClipCount<=0)
        GoToState('NewClip');
    else if ( (PawnOwner.bFire!=0 || bForce) && !Region.Zone.bNeutralZone )
        Global.Fire(0);
    else 
	{
		//log("AeonsWeapon:Finish() ... going to state Idle");
        GotoState('Idle');
	}
}

//----------------------------------------------------------------------------

state NewClip
{
	ignores Reload;

	function BeginState()
	{
		ClientReloadWeapon(ClipCount);
	}

    function Finish()
    {
		//LogActor("AeonsWeapon: state NewClip: Finish");
        if ( bChangeWeapon )
            GotoState('DownWeapon');
        else if ( (Pawn(Owner).bFire!=0) && (ClipCount > 0) )
            Global.Fire(0);
        else
            GotoState('Idle');
    }
        
Begin:
	//LogActor("AeonsWeapon: state NewClip: Begin:");
    if ( AmmoType.AmmoAmount >= ReloadCount )
        ClipCount = ReloadCount;
    else
        ClipCount = AmmoType.AmmoAmount;
    Finish();
}

state ClientReload
{
	simulated function bool ClientFire(float Value)
	{
		//bForceFire = bForceFire || ( bCanClientFire && (Pawn(Owner) != None) && (AmmoType.AmmoAmount > 0) );
		//return bForceFire;
		return false;
	}

	simulated function AnimEnd()
	{
		if ( bCanClientFire && (PlayerPawn(Owner) != None) && (AmmoType.AmmoAmount > 0) )
		{
			if ( bForceFire || (Pawn(Owner).bFire != 0) )
			{
				Global.ClientFire(0);
				return;
			}
		}			
		GotoState('ClientIdle');
		Global.AnimEnd();
	}

	simulated function EndState()
	{
		bForceFire = false;
	}

	simulated function BeginState()
	{
		bForceFire = false;
	}
}

//----------------------------------------------------------------------------

simulated function WallDecal(Vector HitLocation, Vector HitNormal)
{
	// log("Projectile:WallDecal");
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
	{
		// log("Projectile:WallDecal:Spawning Decal");
		Spawn(ExplosionDecal,self,,HitLocation, rotator(HitNormal));
	}
}

//----------------------------------------------------------------------------

simulated function float TweenFrom(name NewIdleAnim, float TweenTime)
{
	if (AnimSequence == NewIdleAnim)
		return TweenTime;
	return -1.0;
}

//////////////////////////////////////////////////////////////////////////////
//	Default Properties
//////////////////////////////////////////////////////////////////////////////

defaultproperties
{
     NumRicoSounds=8
     MomentumTransfer=3000
     ExpireMessage="You"
     AIRating=0.3
     PickupMessage="You picked up a weapon"
     ItemName="Hand"
     PickupSound=Sound'Aeons.Weapons.E_Wpn_GenPck01'
     Buoyancy=20
     bClientAnim=True
     ScaleGlow=0.65
     AmbientGlow=0
     bNoSmooth=False
     Mass=25
}
