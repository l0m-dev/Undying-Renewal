//=============================================================================
// Revolver.
//=============================================================================
class Revolver expands AeonsWeapon;

// ============================================================================
// Pickup Mesh
//#exec MESH IMPORT MESH=Revolver_Half_m SKELFILE=Revolver_Half.ngf

//#exec MESH IMPORT MESH=Revolver_m SKELFILE=Revolver_m.ngf

// Notifys


// ============================================================================
// 1st Person View Mesh
//#exec MESH IMPORT MESH=Revolver1st_m SKELFILE=Revolver1st\Revolver1st_m.ngf MOVERELATIVE=0
//#exec MESH ORIGIN MESH=Revolver1st_m YAW=64

// Notifys
//#exec MESH NOTIFY SEQ=Fire TIME=0.143 FUNCTION=FireWeapon
//#exec MESH NOTIFY SEQ=ReloadEnd TIME=0.5 FUNCTION=PlayClose
//#exec MESH NOTIFY SEQ=ReloadStart TIME=0.382 FUNCTION=PlayOpen

// ============================================================================
// 3rd Person view mesh
//#exec MESH IMPORT MESH=Revolver3rd_m SKELFILE=Revolver3rd.ngf
//#exec MESH IMPORT MESH=RevolverPat_m SKELFILE=Revolver_Pat.ngf

// ============================================================================

var sound LoadShellSound, LoadAltShellSound;

// reloading
var int numToReload, i;
var int rndSoundID, snID;
var RevolverMuzzleFlash mFlash;
var() sound FlourishSound;

//----------------------------------------------------------------------------

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
/*
	local int HitJoint, nj, i;
	local Vector TraceStart, X,Y,Z, eyeAdjust, HitLocation, HitNormal, eyeAdj, TraceEnd, start;
	local rotator bulletDir;
	local vector barrelPlace;
	
	Pawn(Owner).eyeTrace(HitLocation,,4096);

	barrelPlace = (jointPlace('Barrel1')).pos;

	bulletDir = Rotator(Normal(HitLocation - barrelPlace));

	Spawn(class 'RevolverWeaponLight',,'', barrelPlace + (Vector(PlayerPawn(Owner).ViewRotation) * 64), rot(0,0,0));
	mFlash = Spawn(class 'RevolverMuzzleFlash',Pawn(Owner),,barrelPlace,BulletDir);
	mFlash.setBase(self, 'Barrel1', 'none');
	
	if ( bAltAmmo )
		Spawn(AltProjectileClass,,, barrelPlace, bulletDir);
	else {
		Spawn(ProjectileClass,,, barrelPlace, bulletDir);
	}
*/

	local int HitJoint, nj, i;
	local Vector TraceStart, X,Y,Z, eyeAdjust, HitLocation, HitNormal, eyeAdj, TraceEnd, start, EyeHeight, dir;
	local rotator bulletDir;
	local vector barrelPlace;

	EyeHeight.z = Pawn(Owner).EyeHeight;
	// Pawn(Owner).eyeTrace(HitLocation,,4096);
	
	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	HitLocation = (Owner.Location + EyeHeight) + X * 4096;
	
	
	barrelPlace = Owner.Location + EyeHeight + (X*Owner.CollisionRadius); // fire from your eye
	// barrelPlace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	if ( AeonsPlayer(Owner).MindshatterMod.bActive )
	{
		Dir = Normal( Normal(HitLocation - barrelPlace) + (VRand() * 0.35) );
		BulletDir = Rotator(dir);
	} else {
		BulletDir = Rotator(Normal(HitLocation - barrelPlace));	
	}

	bMuzzleFlash ++;

	Spawn(class 'RevolverWeaponLight',,'', barrelPlace, rot(0,0,0));

	if ( bAltAmmo )
		Spawn(AltProjectileClass,,, barrelPlace, bulletDir);
	else 
		Spawn(ProjectileClass,,, barrelPlace, bulletDir);

	// Test PlayActuator here!!
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_Quick, 0.5f);
}


//----------------------------------------------------------------------------
// Note:	This was in the original AeonsWeapon.  Brought up to Revolver for
//			now so that AeonsWeapon can continue to resemble TournamentWeapon
//----------------------------------------------------------------------------
function Fire( float Value )
{
	if ( (AeonsPlayer(Owner).GetStateName() == 'DialogScene') || (AeonsPlayer(Owner).GetStateName() == 'PlayerCutscene') || (AeonsPlayer(Owner).GetStateName() == 'SpecialKill'))
		return;

//	LogActor("Revolver: Fire: Value =" $ Value);

    if ( Pawn(Owner).HeadRegion.Zone.bWaterZone && !bWaterFire)
    {
        PlayFireEmpty();
    } 
	else if (bReloadable && ClipCount<=0) 
	{
		checkAltAmmo();
        PlayFireEmpty();
        if (AmmoType.AmmoAmount > 0)
		{
			log("Revolver going to NewClip State A", 'Misc');
			GoToState('NewClip');
		}
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
	log("PlayFiring Called within the Revolver");
	PlayAnim( 'Fire', 1.0 / AeonsPlayer(Owner).refireMultiplier,,,0.0);
	if ( Role == ROLE_Authority )
		ClipCount--;
//	PlayOwnedSound(FireSound, SLOT_Misc, 4.0);	
//	bMuzzleFlash++;
}

//----------------------------------------------------------------------------

/*
function PlayFiring()
{
	Log("Revolver: PlayFiring:  ClipCount=" $ ClipCount);
    ClipCount--;
	super.PlayFiring();
}
*/
//----------------------------------------------------------------------------

function PlayFireEmpty()
{
	if ( AeonsPlayer(Owner).bWeaponSound )
	{
		PlaySound(Misc1Sound);
		AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
	}
}

//----------------------------------------------------------------------------

function PlayClose()
{
    if ( AeonsPlayer(Owner).bWeaponSound )
    {
		PlaySound(CloseSound, SLOT_None,4.0* AeonsPlayer(Owner).VolumeMultiplier);
		AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
	}
}

//----------------------------------------------------------------------------

function PlayOpen()
{
    if ( AeonsPlayer(Owner).bWeaponSound )
    {
		PlaySound(OpenSound, SLOT_None,2.0* AeonsPlayer(Owner).VolumeMultiplier);
		AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
	}
}

//----------------------------------------------------------------------------
/*
function TweenDown()
{
    if ( ClipCount<=0 )
        PlayAnim('DownEmpty',RefireMult);
    else
        PlayAnim('Down',RefireMult);

    if ( AeonsPlayer(Owner).bWeaponSound )
    {
		PlaySound(Misc3Sound);
		AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
	}
}
*/
//----------------------------------------------------------------------------

simulated function PlayIdleAnim()
{
	Log("Revolver: PlayIdleAnim");
	LoopAnim('IdleStill');
}

//----------------------------------------------------------------------------

simulated function PlayReloading()
{
	PlayAnim('ReloadStart', 1.0 / AeonsPlayer(Owner).refireMultiplier);
}

//=============================================================================
// Normal Fire
//=============================================================================
state NormalFire
{
	ignores Fire;

	Begin:
		sleep(refireRate * AeonsPlayer(Owner).refireMultiplier);
		FinishAnim();
		Finish();
}

//=============================================================================
// Reload
//=============================================================================
state NewClip
{
	ignores Fire, Reload;
	
	function BeginState()
	{
		Log("Revolver: state NewClip: BeginState");
		PlayerPawn(Owner).bReloading = true;
	}

	function EndState()
	{
		Log("Revolver: state NewClip: EndState");
		PlayerPawn(Owner).bReloading = false;
	}

	Begin:
		if (Level.TimeSeconds < 0.5)
		{
			GotoState('Idle');
			Stop;
		}
		log ("Revolver Roloading ... Time = "$Level.TimeSeconds,'Misc');
		checkAltAmmo();
		// TweenDown();
		
		numToReload = ReloadCount - ClipCount;

		if (AmmoType.AmmoAmount < numToReload )
			numToReload = AmmoType.AmmoAmount;

		// Do we have any bullets to reload?
		if (numToReload > 0)
		{
			PlayAnim('ReloadStart',RefireMult / AeonsPlayer(Owner).refireMultiplier,,,0);
			FinishAnim();
		}

		for (i=0; i<numToReload; i++)
		{
	        if ( bChangeWeapon )
	    		GotoState('DownWeapon');

			LogTime("Revolver: state NewClip: Playing Sound " $ i);
			if ( bAltAmmo )
				/*snID = */PlayOwnedSound(LoadAltShellSound, SLOT_Misc, FClamp(2.0* AeonsPlayer(Owner).VolumeMultiplier, 0.1, 2.0));
			else
				/*snID = */PlayOwnedSound(LoadShellSound, SLOT_Misc, FClamp(2.0* AeonsPlayer(Owner).VolumeMultiplier, 0.1, 2.0));

		    if ( AeonsPlayer(Owner).bWeaponSound )
				AeonsPlayer(Owner).MakePlayerNoise(0.25, 320);

			ClipCount ++;

			if ( bAltAmmo )
				Sleep( GetSoundDuration(LoadAltShellSound) * AeonsPlayer(Owner).refireMultiplier);
			else
				Sleep( GetSoundDuration(LoadShellSound) * AeonsPlayer(Owner).refireMultiplier);

			//FinishSound(snID);
			LogTime("Revolver: state NewClip: Finished Sound " $ i);
		}
		
		// sleep(1);

		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) && !PlayerPawn(Owner).bNeverAutoSwitch) 
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
		else {

			PlayAnim('ReloadEnd',RefireMult/AeonsPlayer(Owner).refireMultiplier,,,0);
			FinishAnim();

			if ( AmmoType.AmmoAmount >= ReloadCount )
				ClipCount = ReloadCount;
			else
				ClipCount = AmmoType.AmmoAmount;
		
		}
		// GotoState('Idle');
		Finish();
}

//=============================================================================
// Idle
//=============================================================================
state Idle
{
	simulated function BeginState()
	{
		bChangeWeapon = false;
	}

	simulated function bool PutDown()
	{
		if ( bWeaponUp )
			GotoState('DownWeapon');
		else
			bChangeWeapon = true;
		return True;
	}

	simulated function Tick(float DeltaTime)
	{
        if ( bChangeWeapon )
            GotoState('DownWeapon');

		if ( (VSize(PlayerPawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) )
			loopAnim('IdleMove',RefireMult);
		else
			loopAnim('IdleStill',RefireMult);
	}

	simulated function Timer()
	{
		if ( VSize(PlayerPawn(Owner).Velocity) < 300 && (PlayerPawn(Owner).GetStateName() != 'DialogScene') && (PlayerPawn(Owner).GetStateName() != 'PlayerCutScene') && (PlayerPawn(Owner).GetStateName() != 'SpecialKill'))
			if (FRand() > 0.75)
				gotoState(getStateName(),'Flourish');
	}

	FLOURISH:
		disable('Tick');
		PlayAnim('Flourish',RefireMult);
		PlaySound(FlourishSound);
		FinishAnim();
		goto 'Begin';
		
	Begin:
		FinishAnim();
		if ( bChangeWeapon )
			GotoState('DownWeapon');
		bWeaponUp = True;

		enable('Tick');
		setTimer(8 + FRand()*5,true);

}

//=============================================================================
// ClientFiring
//=============================================================================
state ClientFiring
{
	simulated function AnimEnd()
	{
		Log("Revolver: state ClientFiring: AnimEnd");
		if ( (Pawn(Owner) == None) || (Ammotype.AmmoAmount <= 0) )
		{
			PlayIdleAnim();
			GotoState('');
		}
		else if ( !bCanClientFire )
			GotoState('');
		else
		{
			if ( ClipCount <= 0 ) 
			{
				PlayReloading();
				GotoState('ClientReload');
			}
			else if ( Pawn(Owner).bFire != 0 )
				Global.ClientFire(0);
			else
			{
				PlayIdleAnim();
				GotoState('');
			}
			
		}
	}
}


//=============================================================================
// ClientReload
//=============================================================================
state ClientReload
{
	simulated function PlayOpen()
	{
		if ( AeonsPlayer(Owner).bWeaponSound )
		{
			PlaySound(OpenSound, SLOT_None, 2.0*AeonsPlayer(Owner).VolumeMultiplier);
			AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
		}
	}

	simulated function PlayClose()
	{
		if ( AeonsPlayer(Owner).bWeaponSound )
		{
			PlaySound(CloseSound, SLOT_None, 4.0*AeonsPlayer(Owner).VolumeMultiplier);
			AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
		}
	}

	simulated function bool ClientFire(float Value)
	{
		bForceFire = bForceFire || ( bCanClientFire && (Pawn(Owner) != None) && (AmmoType.AmmoAmount > 0) );
		return bForceFire;
	}

	simulated function Timer()
	{
		log("Revolver: state ClientReload: Timer: ClipCount=" $ ClipCount $ " ReloadCount=" $ ReloadCount); 
		if ( ClipCount < ReloadCount )
		{
			if ( bAltAmmo )
			{
				PlaySound(LoadAltShellSound, SLOT_Misc, 2.0*AeonsPlayer(Owner).VolumeMultiplier);
				//SetTimer(GetSoundDuration(LoadAltShellSounds[0]), false);
				SetTimer(0.2,false);
			}
			else
			{
				log("Revolver: state ClientReload: Timer: PlayingSound"); 
				PlaySound(LoadShellSound, SLOT_Misc, 2.0*AeonsPlayer(Owner).VolumeMultiplier);
				//SetTimer(GetSoundDuration(LoadShellSounds[0]), false);
				SetTimer(0.2,false);
			}

		}
		else
		{
			PlayAnim('ReloadEnd',1.0/AeonsPlayer(Owner).refireMultiplier,,,0);//fix 1.0 / AeonsPlayer(Owner).refireMultiplier);
//			PlaySound(CloseSound, SLOT_None, 4.0* AeonsPlayer(Owner).VolumeMultiplier);
		}
	}

	simulated function AnimEnd()
	{
		log("Revolver: state ClientReload: AnimEnd: Sequence = " $ AnimSequence);

		if ( ((AnimSequence == 'ReloadStart') || (AnimSequence == 'ReloadStart_Morph')) && (AmmoType.AmmoAmount > 0) )
		{		
			numToReload = ReloadCount - ClipCount;
	
			if (AmmoType.AmmoAmount < numToReload )
				numToReload = AmmoType.AmmoAmount;

			SetTimer(RefireRate * AeonsPlayer(Owner).refireMultiplier, false);//fix RefireRate * AeonsPlayer(Owner).refireMultiplier, false);
			return;
		}

		if ( bCanClientFire && (PlayerPawn(Owner) != None) && (AmmoType.AmmoAmount > 0) )
		{
			if ( bForceFire || (Pawn(Owner).bFire != 0) )
			{
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
		log("Revolver: ClientReload State: BeginState() function call...");
//		GotoState(getStateName(), 'ReloadStart');
		bForceFire = false;
	}
/*
	ReloadStart:
		log("Revolver: ClientReload State: Begin...");
		FinishAnim();
		Sleep(RefireRate * AeonsPlayer(Owner).refireMultiplier);
		GotoState(getStateName(), 'ReloadEnd');
		
	ReloadEnd:
		log("Revolver: ClientReload State: ReloadEnd...");
		PlayAnim('ReloadEnd',1.0/AeonsPlayer(Owner).refireMultiplier,,,0);
		FinishAnim();
		// Finish();
*/
}

//////////////////////////////////////////////////////////////////////////////
//	Default Properties
//////////////////////////////////////////////////////////////////////////////

defaultproperties
{
     LoadShellSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevLoadReg01'
     LoadAltShellSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevLoadSilver01'
     FlourishSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevSpin01'
     bReloadable=True
     MomentumTransfer=500
     ExpireMessage=""
     bWaterFire=True
     bAltWaterFire=True
     ReloadTime=2
     OpenSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevUnload01'
     CloseSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevClose01'
     ThirdPersonJointName=RevolverAtt
     AmmoName=Class'Aeons.BulletAmmo'
     AltAmmoName=Class'Aeons.SilverBulletAmmo'
     ReloadCount=6
     PickupAmmoCount=36
     FiringSpeed=0.25
     FireOffset=(Z=-20)
     ProjectileClass=Class'Aeons.Bullet_proj'
     AltProjectileClass=Class'Aeons.SilverBullet_proj'
     RefireRate=0.3
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevFireReg01'
     AltFireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevFireSilver01'
     SelectSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevPU1'
     Misc1Sound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevDryFire01'
     bDrawMuzzleFlash=True
     MuzzleScale=2
     FlashY=0.69583
     FlashX=0.34531
     MFTexture0=Texture'Aeons.MuzzleFlashes.MuzzleFlash0'
     FlashStyle0=STY_Translucent
     ItemType=WEAPON_Conventional
     PickupMessage="You picked up a Revolver"
     ItemName="Revolver"
     PlayerViewOffset=(X=-6.22,Y=-13.4,Z=-3.3)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.Revolver1st_m'
     PlayerViewScale=0.1
     PickupViewMesh=SkelMesh'Aeons.Meshes.Revolver_m'
     ThirdPersonMesh=SkelMesh'Aeons.Meshes.RevolverPat_m'
     bMuzzleFlashParticles=True
     MuzzleFlashStyle=STY_Translucent
     MuzzleFlashScale=0.1
     MuzzleFlashTexture=Texture'Aeons.MuzzleFlashes.MuzzleFlash0'
     PickupSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevPU1'
     bTimedTick=True
     MinTickTime=0.05
     RotationRate=(Yaw=0)
     Mesh=SkelMesh'Aeons.Meshes.Revolver_m'
     CollisionRadius=16
     CollisionHeight=16
}
