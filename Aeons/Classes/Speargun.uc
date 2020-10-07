//=============================================================================
// Speargun.
//=============================================================================
class Speargun expands AeonsWeapon;

//=============================================================================
// 1st person view mesh
//#exec MESH IMPORT MESH=Speargun1st_m SKELFILE=Speargun1st\Speargun1st.ngf MOVERELATIVE=0
//#exec MESH ORIGIN MESH=Speargun1st_m YAW=64

//#exec MESH NOTIFY SEQ=Fire TIME=0.077 FUNCTION=FireWeapon
//#exec MESH NOTIFY SEQ=ReloadEnd TIME=0.5 FUNCTION=PlayReloadSound

//=============================================================================
// Pickup Mesh
//#exec MESH IMPORT MESH=spear_m SKELFILE=spear_m.ngf
//#exec MESH IMPORT MESH=Spear_proj_m SKELFILE=Spear_proj.ngf
//#exec MESH IMPORT MESH=Spear_Tribesman_m SKELFILE=Spear_Tribesman.ngf
//#exec MESH IMPORT MESH=Speargun_Jemaas_m SKELFILE=Speargun_Jemaas.ngf

//#exec MESH IMPORT MESH=speargun_m SKELFILE=speargun_m.ngf


//=============================================================================
// 3rd Person mesh
//#exec MESH IMPORT MESH=Speargun3rd_m SKELFILE=Speargun3rd\SpeargunPat.ngf

//=============================================================================
var() float ChargeTimer;
var float ChargeLen;

var Spear_proj spear;
var bool bCharged;

var() sound InsertSound;
var() sound ReloadSound;
var() sound ChargedSound;
// var ParticleFX ChargedFX;
var int SoundID;
var travel bool bZoomedIn;

//=============================================================================
function PreBeginPlay()
{
	Super.PreBeginPlay();
	ProjectileClass = class'Spear_proj';
	ProjectileSpeed = class'Spear_proj'.default.speed;
}

function Charge()
{
	
	// ChargedFX = Spawn(class 'ChargedSpearFX',self,,Location);
	// AeonsPlayer(Owner).OverlayActor = ChargedFX;
	// log("Speargun: Charge()", 'Misc');
	bCharged = true;
	AmbientSound = ChargedSound;
	ChargeLen = 0;
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
	local Vector X,Y,Z, eyeAdjust, HitLocation, HitNormal, eyeAdj, TraceEnd, start;
	local rotator bulletDir;
	local vector barrelPlace;
	local Spear_Proj spear;
	local int HitJoint;

	// Pawn(Owner).eyeTrace(HitLocation,,4096);

	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);

	BarrelPlace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	PlayerPawn(Owner).EyeTrace(HitLocation, HitNormal, HitJoint, 8192, true);
	BulletDir = Rotator(Normal(HitLocation - barrelPlace));

	Spear = Spawn(class 'spear_proj', Pawn(Owner),, barrelPlace, bulletDir);
	if ( bCharged )
	{
		Spear.Electrify();
		PlaySound(AltFireSound);
	}

	AmbientSound = None;

	ChargeLen = 0;
	// ChargedFX.Destroy();
	AeonsPlayer(Owner).OverlayActor = none;
	bCharged = false;
	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fSpears = 1.0;
}

////////////////////////////////////////////////////////
state NormalFire
{
	ignores Fire;
	
	function bool PutDown()
	{
		AmbientSound = none;
		PlayerPawn(Owner).desiredFOV = PlayerPawn(Owner).defaultFOV;
		GotoState('DownWeapon');
		return True;
	}

	Begin:
        if ( PlayerPawn(Owner) != None )
            PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		// ProjectileFire(ProjectileClass, ProjectileSpeed, true);
		// Test PlayActuator here!!
		PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_Quick, 0.3f);
		gotoState('NewClip');
}

state FinishState
{
	function bool PutDown()
	{
		PlayerPawn(Owner).desiredFOV = PlayerPawn(Owner).defaultFOV;
		GotoState('DownWeapon');
		return True;
	}

	Begin:
	    // FinishAnim();
	    Finish();
}

//----------------------------------------------------------------------------
// Note:	This was in the original AeonsWeapon.  Brought up to Speargun for
//			now so that AeonsWeapon can continue to resemble TouranmentWeapon
//----------------------------------------------------------------------------
function Fire( float Value )
{
	// LogActor("Speargun: Fire: Value =" $ Value);

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


//----------------------------------------------------------------------------
simulated function PlayFiring()
{
	// log("PlayFiring Called within the Speargun");
	PlayAnim( 'Fire', 1.0 / AeonsPlayer(Owner).refireMultiplier,,,0.0);
//	if ( Role == ROLE_Authority )
//		ClipCount--;
//	PlayOwnedSound(FireSound, SLOT_Misc, 4.0);	
//	bMuzzleFlash++;
}

simulated function PlayIdleAnim()
{
	// log("Speargun: PlayIdleAnim");
	LoopAnim('StillIdle');
}

////////////////////////////////////////////////////////
state NewClip
{
	ignores Fire, Reload;

	function BeginState()
	{
		PlayerPawn(Owner).bReloading = true;
	}

	function EndState()
	{
		PlayerPawn(Owner).bReloading = false;
	}

	function bool PutDown()
	{
		PlayerPawn(Owner).desiredFOV = PlayerPawn(Owner).defaultFOV;
		GotoState('DownWeapon');
		return True;
	}

	Begin:
		if (Level.TimeSeconds < 0.5)
		{
			GotoState('Idle');
			Stop;
		}

		if ( AeonsPlayer(Owner).bWeaponSound )
		{
		    Owner.PlaySound(Misc1Sound, SLOT_None,2.0);
			AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
		}

		if (AmmoType.AmmoAmount > 0)
		{
			PlayAnim('DownEmpty', RefireMult);
			FinishAnim();
			PlaySound(InsertSound,, 0.5);
			sleep(reloadTime * (1.0 / RefireMult));
			logactorstate("sleeping for "$ reloadTime * (1.0 / RefireMult) $" seconds");		
		}		
		
	    // Owner.PlaySound(Misc2Sound, SLOT_None,2.0);
	    if ( AmmoType.AmmoAmount >= ReloadCount )
	        ClipCount = ReloadCount;
	    else
	        ClipCount = AmmoType.AmmoAmount;
	
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) && !PlayerPawn(Owner).bNeverAutoSwitch ) 
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
		else {
			PlayAnim('ReLoadEnd', RefireMult);
			FinishAnim();
			// Log("Speargun: state NewClip; FinishAnim is done with " $AnimSequence);
		}

		// Owner.PlaySound(CockingSound, SLOT_None,2.0);
		gotoState('FinishState');
}

//=============================================================================
state Idle
{
	simulated function Tick(float DeltaTime)
	{
		if (bZoomedIn && (AeonsPlayer(Owner).Weapon == self))
			AeonsPlayer(Owner).DesiredFOV = AeonsPlayer(Owner).ZoomFOV;

		if ( bCharged )
		{
			ChargeLen += DeltaTime;
			if ( ChargeLen > ChargeTimer )
			{
				log("Speargun: Charge has run out ", 'Misc');
				//if (ChargedFX != none)
				//	ChargedFX.Destroy();
				AeonsPlayer(Owner).OverlayActor = none;
				bCharged = false;
			}
		} else {
			ChargeLen = 0;
		}

		if ( (VSize(PlayerPawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) )
			loopAnim('MoveIdle', RefireMult);
		else
			loopAnim('StillIdle', RefireMult);
	}

	function bool PutDown()
	{
		AmbientSound = none;
		PlayerPawn(Owner).desiredFOV = PlayerPawn(Owner).defaultFOV;
		GotoState('DownWeapon');
		return True;
	}

	simulated function Timer()
	{
		if ( VSize(PlayerPawn(Owner).Velocity) < 200 )
			if (FRand() > 0.75)
				gotoState(getStateName(),'Flourish');
	}

	FLOURISH:
		disable('Tick');
		PlayAnim('Twirl', RefireMult);
		FinishAnim();
		goto 'Begin';
		
	Begin:
		enable('Tick');
		setTimer(8 + FRand()*5,true);
}


function Tick(float DeltaTime)
{
	ChargeLen += DeltaTime;

	if ( ChargeLen >ChargeTimer )
	{
		//if (ChargedFX != none)
			//ChargedFX.Destroy();
		AeonsPlayer(Owner).OverlayActor = none;
		bCharged = false;
	}

	if ( bChangeWeapon )
		GotoState('DownWeapon');
}


simulated function PlayReloading()
{
	Log("Speargun: PlayReloading");
	PlayAnim('DownEmpty',1.0 / AeonsPlayer(Owner).refireMultiplier,,,0);//, RefireMult);
}



//=============================================================================
// ClientFiring
//=============================================================================
state ClientFiring
{
	simulated function AnimEnd()
	{
		Log("Speargun: state ClientFiring: AnimEnd");

		if ( (Pawn(Owner) == None) || (Ammotype.AmmoAmount <= 0) )
		{
			PlayIdleAnim();
			GotoState('');
		}
		else if ( !bCanClientFire )
			GotoState('');
		else
		{
			PlayReloading();
			GotoState('ClientReload');
		}

		//else if ( Pawn(Owner).bFire != 0 )
		//		Global.ClientFire(0);
	}

	function bool PutDown()
	{
		PlayerPawn(Owner).desiredFOV = PlayerPawn(Owner).defaultFOV;
		GotoState('DownWeapon');
		return True;
	}
	simulated function BeginState()
	{
		PlayReloading();
		GotoState('ClientReload');
	}
}


//=============================================================================
// ClientReload
//=============================================================================
state ClientReload
{
	simulated function bool ClientFire(float Value)
	{
		bForceFire = bForceFire || ( bCanClientFire && (Pawn(Owner) != None) && (AmmoType.AmmoAmount > 0) );
		return bForceFire;
	}

	simulated function Timer()
	{
		Log("Speargun: state ClientReload: Timer");
		PlayAnim('ReloadEnd',1.0 / AeonsPlayer(Owner).refireMultiplier,,,0);
	}

	function bool PutDown()
	{
		PlayerPawn(Owner).desiredFOV = PlayerPawn(Owner).defaultFOV;
		GotoState('DownWeapon');
		return True;
	}

	simulated function AnimEnd()
	{
		log("Speargun: state ClientReload: AnimEnd for " $AnimSequence);
		/*
		log("Speargun:NormalFire:AnimEnd() called");
		if ( ((AnimSequence == 'Fire') || (AnimSequence == 'Fire_Morph')) && (AmmoType.AmmoAmount > 0) )
		{
			Log("Speargun: NormalFire: AnimEnd: Anim Sequence = 'Fire' .... calling PlayReloading");
			GotoState(getStateName(), 'ReloadStart');
		}*/
		if ( ((AnimSequence == 'DownEmpty') || (AnimSequence == 'DownEmpty_Morph')) && (AmmoType.AmmoAmount > 0) )
		{
			//Log("Speargun: state ClientReload: setting timer to " $ RefireRate * AeonsPlayer(Owner).refireMultiplier );
			//rb new
			logactorstate("Setting Timer to " $ reloadTime * (1.0 / RefireMult));
			SetTimer(reloadTime * (1.0 / RefireMult), false);
			//SetTimer(RefireRate * AeonsPlayer(Owner).refireMultiplier, false);
			return;
		}

		if ( bCanClientFire && (PlayerPawn(Owner) != None) && (AmmoType.AmmoAmount > 0) )
		{
			if ( bForceFire || (Pawn(Owner).bFire != 0) )
			{
				log("Speargun: state ClientReload: AnimEnd: Calling ClientFire");
				Global.ClientFire(0);
				return;
			}
		}			

		GotoState('');
		Global.AnimEnd();
	}

	simulated function EndState()
	{
		bForceFire = false;
	}

	simulated function BeginState()
	{
		bForceFire = false;
		log("ClientReload State: BeginState() function call...");
//		GotoState(getStateName(), 'ReloadStart');		
	}
/*
	ReloadStart:
		log("ClientReload State: Begin...");
		FinishAnim();
		Sleep(RefireRate * AeonsPlayer(Owner).refireMultiplier);
		GotoState(getStateName(), 'ReloadEnd');
		
	ReloadEnd:
		log("ClientReload State: ReloadEnd...");
		PlayAnim('ReloadEnd',,,,0);
		FinishAnim();
		// Finish();
*/
}

function PlayReloadSound()
{
	log("Speargun: playreloadsound");
	PlaySound(ReloadSound);
}

simulated function ClientPutDown(weapon NextWeapon)
{
	PlayerPawn(Owner).desiredFOV = PlayerPawn(Owner).defaultFOV;
	super.ClientPutDown(NextWeapon);
}

defaultproperties
{
     ChargeTimer=10
     InsertSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_SpeargunInsert01'
     ReloadSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_SpeargunReload01'
     ChargedSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_SpeargunElecLp01'
     bWaterFire=True
     ReloadTime=0.75
     ThirdPersonJointName=SpeargunAtt
     AmmoName=Class'Aeons.SpearAmmo'
     ReloadCount=1
     PickupAmmoCount=24
     bWarnTarget=True
     FireOffset=(X=32,Z=-20)
     ProjectileClass=Class'Aeons.Spear_proj'
     shakemag=1200
     shaketime=0.3
     AIRating=0.5
     RefireRate=1
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_Speargunfire01'
     AltFireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_SpearElecFire01'
     SelectSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_SpeargunPU1'
     ItemType=WEAPON_Conventional
     AutoSwitchPriority=4
     InventoryGroup=6
     PickupMessage="You picked up a Speargun"
     ItemName="Speargun"
     PlayerViewOffset=(X=-4.8,Y=-13.3)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.Speargun1st_m'
     PlayerViewScale=0.1
     PickupViewMesh=SkelMesh'Aeons.Meshes.Speargun3rd_m'
     PickupViewScale=1.5
     ThirdPersonMesh=SkelMesh'Aeons.Meshes.Speargun3rd_m'
     PickupSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_SpeargunPU1'
     RotationRate=(Yaw=0)
     Mesh=SkelMesh'Aeons.Meshes.Speargun3rd_m'
     AmbientGlow=102
}
