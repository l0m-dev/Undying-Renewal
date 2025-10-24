//=============================================================================
// Shotgun.
//=============================================================================
class Shotgun expands AeonsWeapon;

// 1st person player view mesh
//#exec MESH IMPORT MESH=Shotgun1st_m SKELFILE=Shotgun1st\Shotgun1st_m.ngf MOVERELATIVE=0
//#exec MESH ORIGIN MESH=Shotgun1st_m YAW=64

// Notifys
//#exec MESH NOTIFY SEQ=Fire TIME=0.01 FUNCTION=FireWeapon
//#exec MESH NOTIFY SEQ=ReloadStart TIME=0.371 FUNCTION=PlayOpenSound
//#exec MESH NOTIFY SEQ=ReloadEnd TIME=0.333 FUNCTION=PlayCloseSound

// 3rd person player view mesh
//#exec MESH IMPORT MESH=Shotgun3rd_m SKELFILE=Shotgun3rd\Shotgun3rd.ngf

// =============================================================================

var int  click;
var int		sndID;
var bool bChangeToFire;
var vector startTrace;
var() int   Range;      
var() int   MomentumTransfer; // Momentum imparted by each "pellet" trace.
var() float radius;
var() int numPellets;
var() int numPhosphors;
var() float maxDamage;
var() sound FlourishSound;
var() sound DoubleFireSound;
var() sound ToggleDoubleBarrel;
var sound LoadShellSound, LoadAltShellSound;


var int NumToReload;

// =============================================================================
// Animation and Sound stuff
// =============================================================================

simulated function DoubleBarrelToggle()
{
	PlaySound(ToggleDoubleBarrel);
}
function PlayFireEmpty()
{
	if ( AeonsPlayer(Owner).bWeaponSound )
	{
		Owner.PlaySound(Misc1Sound, SLOT_None, 3.5);
		AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
	}
}

function PlayCloseSound()
{
	if ( AeonsPlayer(Owner).bWeaponSound )
	{
	    Owner.PlayOwnedSound(CloseSound, SLOT_None,2.0);
		AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
	}
}

function PlayOpenSound()
{
	if ( AeonsPlayer(Owner).bWeaponSound )
	{
		Owner.PlayOwnedSound(OpenSound, SLOT_None,2.0);
		AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
	}
}

// =============================================================================
// =============================================================================
/*
function Fire( float Value )
{
	if ( AeonsPlayer(Owner).bDoubleShotgun && (ClipCount == 2) )
	{
		if ( AmmoType.UseAmmo(2) )
			PlayFiring();
	} else {
		if ( AmmoType.UseAmmo(1) )
			PlayFiring();
	}
}
*/

//----------------------------------------------------------------------------
// Note:	This was in the original AeonsWeapon.  Brought up to Shotgun for
//			now so that AeonsWeapon can continue to resemble TournamentWeapon
//----------------------------------------------------------------------------
function Fire( float Value )
{
	if ( AeonsPlayer(Owner).IsInCutsceneState() )
		return;

//	LogActor("Shotgun: Fire: Value =" $ Value);

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
	//log("PlayFiring Called within the Shotgun");
	PlayAnim( 'Fire', 1.0 / AeonsPlayer(Owner).refireMultiplier,,,0.0);
//new	if ( Role == ROLE_Authority )
//		ClipCount--;
//	PlayOwnedSound(FireSound, SLOT_Misc, 4.0);	
//	bMuzzleFlash++;
}

//----------------------------------------------------------------------------

// modified projectile fire function for the shotgun only
function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
	local Vector X,Y,Z, eyeAdjust, HitLocation, HitNormal, eyeAdj, TraceEnd, start;
	local rotator bulletDir, aimOffset;
	local vector barrelPlace;
	local projectile p;

	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);

	barrelPlace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	bulletDir = Rotator(Normal(PlayerPawn(Owner).EyeTraceLoc - barrelPlace));

	aimOffset.roll = radius * randRange(-1.0,1.0) * 182.04;
	aimOffset.pitch = radius * randRange(-1.0,1.0) * 182.04;
	aimOffset.yaw = radius * randRange(-1.0,1.0) * 182.04;

	if (bAltAmmo)
		AimOffset *= 2;

	bulletDir += aimOffset;

	// log("Spawning a class : "$ProjClass.name);
	p = Spawn(ProjClass,,, barrelPlace, bulletDir);

	p.default.damage = maxDamage / numPellets;
	if ( !bMakeImpactSound )
	{
		Pellet_proj(p).bMakeImpactSound = false;
		// p.PawnImpactSound = none;
	}
}

function FireStuff()
{
/*
    local vector StartTrace, barrelDir;
    local int i;

	startTrace = (jointPlace('Barrel1')).pos;
	barrelDir = Normal( startTrace - (jointPlace('Shaft')).pos );

	if ( PlayerPawn(Owner) != None )
	{
		PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
	}

	bPointing=True;
	PlayFiring();

	if ( !bAltAmmo )
	{
		// spawn fx
		Spawn(class 'ShotgunMuzzleFlash',,,		StartTrace, rotator(barrelDir));				// more efficent muzzle flash
		spawn(class 'ShotgunSmokeFX', , , 		StartTrace, rotator(barrelDir));				// Smoke
		Spawn(class 'ShotgunWeaponLight',,'', 	StartTrace + (barrelDir * 32), rot(0,0,0));	// Light
		Spawn(class 'ExplosionWind',,,			StartTrace);

		// fire pellets
		if ( AeonsPlayer(Owner).bDoubleShotgun && (ClipCount == 2) )
		{
			for (i=0; i<(numPellets*2); i++)
				ProjectileFire(ProjectileClass, ProjectileSpeed, false);
		} else {
			for (i=0; i<numPellets; i++)
				ProjectileFire(ProjectileClass, ProjectileSpeed, false);
		}
	}
	else
		for (i=0; i<numPhosphors; i++)
			ProjectileFire(AltProjectileClass, ProjectileSpeed, false);
*/

    local vector StartTrace, X, Y, Z;
    local int i;
	local vector DrawOffset;
	local rotator bulletDir;
	local vector barrelPlace;
	local vector HitLocation;
	
	if ( PlayerPawn(Owner) != None )
	{
		PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
	}

	bPointing=True;
	PlayFiring();

	// Actuator Effect (strong burst that quickly dies off)
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_FadeOut, 0.8f);
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_Quick, 0.4f);


	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	DrawOffset = CalcDrawOffset() + Owner.Location + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	// Pawn(Owner).eyeTrace(HitLocation,,4096);
	bulletDir = Rotator(PlayerPawn(Owner).EyeTraceLoc - DrawOffset);

	bMuzzleFlash ++;

	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fShells = 1.0;
	
	if ( !bAltAmmo )
	{
		//Spawn(class 'ShotgunMuzzleFlash',,,		StartTrace, rotator(barrelDir));				// more efficent muzzle flash
		spawn(class 'ShotgunSmokeFX', , , 		Owner.Location + CalcDrawOffset() - 20*Y - 25*Z + 40*X, bulletDir);		// Smoke

		Spawn(class 'ShotgunWeaponLight',,'', 	DrawOffset, rot(0,0,0));	// Light
		Spawn(class 'ExplosionWind',,,			DrawOffset);

		// fire pellets
		if ( AeonsPlayer(Owner).bDoubleShotgun && (ClipCount == 2) )
		{
			for (i=0; i<(numPellets*2); i++)
			{
				if ( i == 0 )
					ProjectileFire(ProjectileClass, ProjectileSpeed, false, true);
				else
					ProjectileFire(ProjectileClass, ProjectileSpeed, false, false);
			}
		} else {
			for (i=0; i<numPellets; i++)
			{
				if ( i == 0 )
					ProjectileFire(ProjectileClass, ProjectileSpeed, false, true);
				else
					ProjectileFire(ProjectileClass, ProjectileSpeed, false, false);
			}
		}
	} else {
		//Spawn(class 'ShotgunMuzzleFlash',,,		StartTrace, rotator(barrelDir));				// more efficent muzzle flash
		Spawn(class 'ShotgunWeaponLight',,'', 	DrawOffset, rot(0,0,0));	// Light
		Spawn(class 'ExplosionWind',,,			DrawOffset);

		// fire phosphors
		if ( AeonsPlayer(Owner).bDoubleShotgun && (ClipCount == 2) )
		{
			for (i=0; i<(numPhosphors*2); i++)
				ProjectileFire(AltProjectileClass, ProjectileSpeed, false, true);
		} else {
			for (i=0; i<numPhosphors; i++)
				ProjectileFire(AltProjectileClass, ProjectileSpeed, false, true);
		}
	}
}

function PlayFireSoundServer()
{
	if (bAltAmmo)
		Owner.PlayOwnedSound(AltFireSound, SLOT_None, 2);
	else if ( AeonsPlayer(Owner).bDoubleShotgun )
		Owner.PlayOwnedSound(DoubleFireSound);
	else	
		Owner.PlayOwnedSound(FireSound);
}

simulated function FireWeapon()
{
	local float Value;

	//log("Shotgun: FireWeapon");
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		if ( PlayerPawn(Owner) != None )
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);

		if ( !bRapidFire && (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
	}

	if ( bInstantHit )
		TraceFire(Value);
	else {
	/*
		if ( bAltAmmo )
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
		else
			ProjectileFire(AltProjectileClass, ProjectileSpeed, bWarnTarget);
	*/
	}
	if ( AeonsPlayer(Owner).bWeaponSound )
	{
	    AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280 * 3);
		if (Level.NetMode == NM_Client)
		{
			if (bAltAmmo)
				Owner.PlaySound(AltFireSound, SLOT_None, 2);
			else if ( AeonsPlayer(Owner).bDoubleShotgun )
				Owner.PlaySound(DoubleFireSound);
			else	
				Owner.PlaySound(FireSound);
		}
		else
		{
			PlayFireSoundServer();
		}
	}

	if (bMuzzleFlashParticles && Role < ROLE_Authority)
	{
		bMuzzleFlash++;
	}

	bPointing=True;

	if (Level.NetMode != NM_Client)
	{
		if ( Owner.bHidden )
			CheckVisibility();

		gotoState('NormalFire');
	}

	// shotgun gore, on already dead pawns
	if ( RGORE() )
	{
		if ( FRand() > 0.5 )
			Patrick(Owner).DetachJointEx(None, 200);
		else
			Patrick(Owner).DestroyJointEx(200);
	}
}

//----------------------------------------------------------------------------

simulated function PlayIdleAnim()
{
	//Log("Shotgun: PlayIdleAnim");
	LoopAnim('StillIdle', [TweenTime] 0.0);
}

//----------------------------------------------------------------------------

simulated function PlayReloading()
{
	//LogTime("Shotgun: PlayReloading");
	PlayAnim('ReloadStart', RefireMult / AeonsPlayer(Owner).refireMultiplier);
}

//----------------------------------------------------------------------------

state NormalFire
{
	ignores Fire;

	Begin:
		FireStuff();
		if (AeonsPlayer(Owner).bDoubleShotgun && (ClipCount == 2))
		{
			AmmoType.UseAmmo(1);
			ClipCount -= 2;
		} else {
			ClipCount -= 1;
		}

		if ( Owner.bHidden )
			CheckVisibility();

	    FinishAnim();
		if (ClipCount == 0)
			gotoState('NewClip');
		sleep(refireRate * AeonsPlayer(Owner).refireMultiplier);
	    Finish();
}

////////////////////////////////////////////////////////
state NewClip
{
	ignores Fire, Reload;

	function BeginState()
	{
		PlayerPawn(Owner).bReloading = true;
		ClientReloadWeapon(ClipCount);
	}

	function EndState()
	{
		PlayerPawn(Owner).bReloading = false;
	}

	Begin:
		// Only play this animation when we actually have bullets to reload.
		if (Level.TimeSeconds < 0.5)
		{
			GotoState('Idle');
			Stop;
		}

		if (AmmoType.AmmoAmount > 0)
		{
			PlayAnim('ReloadStart', RefireMult / AeonsPlayer(Owner).refireMultiplier);
			FinishAnim();
		}

		while ( (ClipCount < ReloadCount) && (ClipCount < AmmoType.AmmoAmount) )
		{
	        if ( bChangeWeapon )
	            GotoState('DownWeapon');

			if ( AeonsPlayer(Owner).bWeaponSound )
				AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
			
			if ( bAltAmmo )
				sndID = PlaySound(LoadAltShellSound);
			else
				sndID = PlaySound(LoadShellSound);

			sleep(0.5 * (1/RefireMult * AeonsPlayer(Owner).refireMultiplier));
			//FinishSound(sndID);
			ClipCount++;
			
			if (AeonsPlayer(Owner).refireMultiplier < 0.6 && ClipCount < ReloadCount)
				ClipCount++;
		}
		
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) && !PlayerPawn(Owner).bNeverAutoSwitch) 
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
		else {
			PlayAnim('ReloadEnd', RefireMult / AeonsPlayer(Owner).refireMultiplier);
			FinishAnim();
		}
		Finish();
}

//=============================================================================
state Idle
{
	simulated function Tick(float DeltaTime)
	{
		if (Owner != None)
		{
			if ( VSize(Owner.Velocity) > 300 && !Owner.Region.Zone.bWaterZone )
				loopAnim('MoveIdle', RefireMult, [TweenTime] TweenFrom('StillIdle', 0.5));
			else
				loopAnim('StillIdle', RefireMult, [TweenTime] TweenFrom('MoveIdle', 0.5));
		}
	}

	simulated function Timer()
	{
		if ( VSize(PlayerPawn(Owner).Velocity) < 300 && !AeonsPlayer(Owner).IsInCutsceneState() )
			if (FRand() > 0.75)
				gotoState(getStateName(),'Flourish');
	}

	FLOURISH:
		disable('Tick');
		PlayAnim('Twirl', RefireMult);
		PlaySound(FlourishSound);
		FinishAnim();
		goto 'Begin';

	Begin:
		ClientIdleWeapon();
		PlayIdleAnim();
		//if ( Pawn(Owner).bFire != 0 && !Region.Zone.bNeutralZone )
		//	Global.Fire(0);
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
		//Log("Shotgun: state ClientFiring: AnimEnd");
		if ( (Pawn(Owner) == None) || (Ammotype.AmmoAmount <= 0) )
		{
			PlayIdleAnim();
			GotoState('ClientIdle');
		}
		else if ( !bCanClientFire )
			GotoState('ClientIdle');
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
				GotoState('ClientIdle');
			}
			
		}
	}
}


//=============================================================================
// ClientReload
//=============================================================================

state ClientReload
{
	simulated function PlayCloseSound()
	{
		if ( AeonsPlayer(Owner).bWeaponSound )
		{
			Owner.PlaySound(CloseSound, SLOT_None, 2.0);
			AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
		}
	}

	simulated function PlayOpenSound()
	{
		if ( AeonsPlayer(Owner).bWeaponSound )
		{
			Owner.PlaySound(OpenSound, SLOT_None, 2.0);
			AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
		}
	}

	simulated function bool ClientFire(float Value)
	{
		//bForceFire = bForceFire || ( bCanClientFire && (Pawn(Owner) != None) && (AmmoType.AmmoAmount > 0) );
		//return bForceFire;
		return false;
	}

	simulated function Timer()
	{
		if (AeonsPlayer(Owner).refireMultiplier >= 0.6 && ClipCount + 1 < ReloadCount) // ClipCount + 1 because it's not updated yet
		{
			SetTimer(0.5 * (1/RefireMult * AeonsPlayer(Owner).refireMultiplier), false);
		}
		else
		{
			PlayAnim('ReloadEnd',1.0/AeonsPlayer(Owner).refireMultiplier,,,0);//fix 1.0 / AeonsPlayer(Owner).refireMultiplier);
//			PlaySound(CloseSound, SLOT_None, 4.0*AeonsPlayer(Owner).VolumeMultiplier);
		}
	}

	simulated function AnimEnd()
	{
		//log("Shotgun: state ClientReload: AnimEnd: Sequence = " $ AnimSequence);

		if ( ((AnimSequence == 'ReloadStart') || (AnimSequence == 'ReloadStart_Morph')) && (AmmoType.AmmoAmount > 0) )
		{
			SetTimer(0.5 * (1/RefireMult * AeonsPlayer(Owner).refireMultiplier), false);//fix RefireRate * AeonsPlayer(Owner).refireMultiplier, false);
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
		GotoState('ClientIdle');
		Global.AnimEnd();
	}

	simulated function EndState()
	{
		bForceFire = false;
	}

	simulated function BeginState()
	{
		//log("Shotgun: state ClientReload: BeginState");
		bForceFire = false;
	}
}

//////////////////////////////////////////////////////////////////////////////
//	Default Properties
//////////////////////////////////////////////////////////////////////////////

defaultproperties
{
     Range=4096
     MomentumTransfer=1000
     Radius=6
     numPellets=6
     numPhosphors=6
     maxDamage=60
     FlourishSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotSpin01'
     DoubleFireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotDblFire01'
     ToggleDoubleBarrel=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotToggle01'
     LoadShellSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotLoadPhos03'
     LoadAltShellSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotLoadReg03'
     bReloadable=True
     hitdamage=50
     ExpireMessage="no ammo"
     bWaterFire=True
     ReloadTime=1
     OpenSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotOpen01'
     CloseSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotClose01'
     ThirdPersonJointName=ShotgunAtt
     AmmoName=Class'Aeons.ShotgunAmmo'
     AltAmmoName=Class'Aeons.PhosphorusShellAmmo'
     ReloadCount=2
     PickupAmmoCount=24
     ProjectileClass=Class'Aeons.Pellet_proj'
     AltProjectileClass=Class'Aeons.Phosphorus_proj'
     Accuracy=1.8
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotFireReg01'
     AltFireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotFirePhos01'
     SelectSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotPU1'
     Misc1Sound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_DryClickShot01'
     MessageNoAmmo=""
     bDrawMuzzleFlash=True
     MuzzleScale=2
     FlashY=0.69583
     FlashX=0.34531
     MFTexture0=Texture'Aeons.MuzzleFlashes.MuzzleFlash0'
     FlashStyle0=STY_Translucent
     ItemType=WEAPON_Conventional
     AutoSwitchPriority=2
     InventoryGroup=5
     bAmbientGlow=False
     PickupMessage="You picked up a Shotgun"
     ItemName="Shotgun"
     PlayerViewOffset=(X=-1,Y=-13.5,Z=-5.5)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.Shotgun1st_m'
     PlayerViewScale=0.1
     PickupViewMesh=SkelMesh'Aeons.Meshes.Shotgun3rd_m'
     ThirdPersonMesh=SkelMesh'Aeons.Meshes.Shotgun3rd_m'
     bMuzzleFlashParticles=True
     MuzzleFlashStyle=STY_Translucent
     MuzzleFlashScale=0.1
     MuzzleFlashTexture=Texture'Aeons.MuzzleFlashes.MuzzleFlash0'
     PickupSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotPU1'
     Tag=Shotgun
     Event=ShotgunPickedUp
     Mesh=SkelMesh'Aeons.Meshes.Shotgun3rd_m'
     AmbientGlow=102
     bRotatingPickup=False
     DeathMessage="%k ravaged %o with buckshot."
     AltDeathMessage="%k flayed %o with buckshot."
}
