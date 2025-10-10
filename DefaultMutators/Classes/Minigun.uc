//=============================================================================
// Minigun.
//=============================================================================
class Minigun expands AeonsWeapon;

//-----------------------------------------------------------------------------
// 1st Person View Mesh
#exec MESH IMPORT MESH=Minigun_m SKELFILE=Minigun.ngf MOVERELATIVE=0

//-----------------------------------------------------------------------------
// Sounds
#exec AUDIO IMPORT FILE="E_Wpn_MinigunFire01.wav" NAME="E_Wpn_MinigunFire01" GROUP="Weapons"
#exec AUDIO IMPORT FILE="E_Wpn_MinigunClick.wav" NAME="E_Wpn_MinigunClick" GROUP="Weapons"
#exec AUDIO IMPORT FILE="E_Wpn_MinigunRotate.wav" NAME="E_Wpn_MinigunRotate" GROUP="Weapons"
#exec AUDIO IMPORT FILE="E_Wpn_MinigunRotateUp.wav" NAME="E_Wpn_MinigunRotateUp" GROUP="Weapons"
#exec AUDIO IMPORT FILE="E_Wpn_MinigunRotateDown.wav" NAME="E_Wpn_MinigunRotateDown" GROUP="Weapons"

//-----------------------------------------------------------------------------

#exec MESH IMPORT MESH=Minigun3rd_m SKELFILE=Minigun3rd\Minigun3rd.ngf

#exec Texture Import File=Minigun_Icon.bmp		Group=Icons	Mips=Off

var int FireSoundId;
var int RotateSoundId;

//-----------------------------------------------------------------------------

function Fire(float F)
{
	if (AmmoType.AmmoAmount <= 0) 
	{
		PlayFireEmpty();
		return;
	}

	gotostate('NormalFire');
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
	}
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
	local int HitJoint, nj, i;
	local Vector TraceStart, X,Y,Z, eyeAdjust, HitLocation, HitNormal, eyeAdj, TraceEnd, start, EyeHeight, dir;
	local rotator bulletDir;
	local vector barrelPlace;
	local Bullet_proj proj;
	//local Sleed sleed;

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

	proj = Bullet_proj(Spawn(ProjectileClass,,, barrelPlace, bulletDir));
	proj.Damage = 10;
	proj.Speed = 20000;
	proj.Velocity = Vector(proj.Rotation) * proj.Speed;
	proj.maxWallHits = 0;

	//sleed = Spawn( class'Sleed',,,Owner.Location + FMax( class'Sleed'.default.CollisionRadius + Owner.CollisionRadius + 50, 72 ) * Vector(Owner.Rotation) + vect(0,0,1) * 15 );
	//sleed.AddVelocity(sleed.CalculateJump( HitLocation ) * 10);

	// Test PlayActuator here!!
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_Quick, 0.5f);
}

state NormalFire
{
	ignores Fire, AnimEnd;
	
	Begin:
		// log("Play Fire Animation");
		PlaySound(Misc2Sound);
		PlayAnim('Fire', [TweenTime]0.5);
		//FinishAnim();
		Sleep(0.8);
		bCanClientFire=true;
		// gotoState('Active');
		if ( PlayerPawn(Owner).bFire != 0 )
			GotoState('Firing');
		else
			Finish();
		
}

state Firing
{
	function Tick(float DeltaTime)
	{
		LoopAnim('Fire');

		if ( PlayerPawn(Owner).bFire == 0 || !AmmoType.UseAmmo(1) )
		{
			PlayerPawn(Owner).bFire = 0; 
			//if (ClipCount <= 0)
			//	PlayFireEmpty();
			PlaySound(Misc3Sound);
			Finish();
		}
		else
			FireWeapon();
	}

	function EndState()
	{
		StopSound(FireSoundId);
		StopSound(RotateSoundId);
	}

	Begin:
		FireSoundId = PlaySound(FireSound, [bNoOverride]true, [Flags]96);
		RotateSoundId = PlaySound(Misc1Sound, [bNoOverride]true, [Flags]96);
		Enable('Tick');
}

state Active
{

	Begin:
		AttachWeapon(AeonsPlayer(Owner).GetWeaponAttachJoint());
		bCanClientFire=true;
		gotoState('Idle');
}

state Idle
{

	ignores Reload;

	function bool PutDown()
	{
		if ( bWeaponUp )
			GotoState('DownWeapon');
		else
			bChangeWeapon = true;
		return True;
	}

	function BeginState()
	{
		bChangeWeapon = false;
	}

	function Tick(float DeltaTime)
	{
        if ( bChangeWeapon )
		{
			//LogActor("bChangeWeapon has been set.");
            GotoState('DownWeapon');
		}
		if (Owner != None)
		{
			if ( VSize(Owner.Velocity) > 300 && !Owner.Region.Zone.bWaterZone )
				LoopAnim('MoveIdle', [TweenTime] TweenFrom('StillIdle', 0.5));
			else
				LoopAnim('StillIdle', [TweenTime] TweenFrom('MoveIdle', 0.5));
		}
	}

	Begin:
		ClientIdleWeapon();
		FinishAnim();
		if ( bChangeWeapon )
			GotoState('DownWeapon');
		else if ( Pawn(Owner).bFire != 0 )
			Fire(0);
		//AddUse(1);
		bWeaponUp = True;
		Enable('Tick');
}

function PlayFireEmpty()
{
	if ( AeonsPlayer(Owner).bWeaponSound )
	{
		PlaySound(AltFireSound);
		AeonsPlayer(Owner).MakePlayerNoise(0.5, 640);
	}
}

simulated function PlayIdleAnim()
{
	bCanClientFire=true;

	if ((VSize(Pawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) )
	{
		LoopAnim('MoveIdle', [TweenTime] 0.0);
	} 
	else 
	{
		LoopAnim('StillIdle', [TweenTime] 0.0);
	}
}

State ClientIdle
{
	simulated function BeginState()
	{
		PlayIdleAnim();
		enable('Tick');
	}
}

//=============================================================================
// ClientFiring
//=============================================================================
state ClientFiring
{
	simulated function AnimEnd()
	{
		if ( !bCanClientFire )
			GotoState('ClientIdle');
		else if ( Pawn(Owner).bFire != 0 )
			Global.ClientFire(0);
		else
		{
			PlayIdleAnim();
			GotoState('ClientIdle');
		}
/*
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
*/
	}
}

defaultproperties
{
	 ThirdPersonJointName=HandleAtt
	 ThirdPersonScale=1.0
	 DrawScale=1
	 AmmoName=Class'Aeons.MinigunAmmo'
     PickupAmmoCount=500
     ReloadCount=500
     AIRating=0.4
     FireSound=Sound'Aeons.Weapons.E_Wpn_MinigunFire01'
     AltFireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MinigunClick'
     SelectSound=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02'
     Misc1Sound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MinigunRotate'
     Misc2Sound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MinigunRotateUp'
     Misc3Sound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MinigunRotateDown'
     bDrawMuzzleFlash=True
     MuzzleScale=1
     FlashY=0.62
     FlashX=0.6
	 FlashLength=0.05
     MFTexture0=Texture'Aeons.MuzzleFlashes.MuzzleFlash0'
     FlashStyle0=STY_Translucent
     FlashStyle0=STY_Translucent
     FlashStyle1=STY_Translucent
     ItemType=WEAPON_Conventional
     AutoSwitchPriority=6
     InventoryGroup=1
     ItemName="Minigun"
     //PlayerViewOffset=(X=2,Y=15,Z=-6)
     PlayerViewOffset=(X=12,Y=13,Z=-13)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.Minigun_m'
     PlayerViewScale=1.0
     PickupViewMesh=SkelMesh'Aeons.Meshes.Minigun3rd_m'
     ThirdPersonMesh=SkelMesh'Aeons.Meshes.Minigun3rd_m'
     bMuzzleFlashParticles=True
     MuzzleFlashStyle=STY_Translucent
     MuzzleFlashScale=0.1
     MuzzleFlashTexture=Texture'Aeons.MuzzleFlashes.MuzzleFlash0'
     bTimedTick=True
     MinTickTime=0.05
     bRotatingPickup=True
     CollisionRadius=100
     CollisionHeight=16
     bGroundMesh=False
     RefireRate=0.05
	 FiringSpeed=0.05
     FireOffset=(Z=-20)
     ProjectileClass=Class'Aeons.Bullet_proj'
	 bReloadable=False
	 Icon=Texture'Minigun_Icon'
     WeaponFov=80
}
