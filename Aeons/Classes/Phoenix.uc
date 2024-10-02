//=============================================================================
// Phoenix.
//=============================================================================
class Phoenix expands AeonsWeapon;

// set bRotatingPickup to False to not interfere with old rotation code

//#exec MESH IMPORT MESH=PhoenixHand_m SKELFILE=PhoenixHand.ngf
//#exec MESH ORIGIN MESH=PhoenixHand_m YAW=64

//#exec MESH NOTIFY SEQ=Fire TIME=0.3548 FUNCTION=ReleaseEgg
//#exec MESH NOTIFY SEQ=Fire TIME=0.6 FUNCTION=SmallExplosion
//#exec MESH NOTIFY SEQ=Fire TIME=0.7 FUNCTION=FireWeapon

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//=============================================================================
var Phoenix_Proj GuidedShell;
var int Scroll;
var PlayerPawn GuidingPawn;
var bool	bGuiding, bCanFire, bShowStatic, bFiring;
var rotator StartRotation;
var Pawn PawnOwner;
var actor Egg;
//=============================================================================

replication
{
	// Things the server should send to the client.
	reliable if( bNetOwner && (Role==ROLE_Authority) )
		bGuiding, bShowStatic, bFiring;
}

function BecomePickup()
{
	super.BecomePickup();
	bClientAnim = false;
	PlayAnim( 'pickup_pose' );
}

function BecomeItem()
{
	super.BecomeItem();
	bClientAnim = true;
}

simulated function PostRender( canvas Canvas )
{
	local int i, numReadouts, OldClipX, OldClipY;
	local float XScale;

	bOwnsCrossHair = ( bGuiding || bShowStatic );

	bClientAnim = true;

	if ( !bGuiding )
	{
		if ( !bShowStatic )
			return;

		Canvas.SetPos( 0, 0);
		Canvas.Style = ERenderStyle.STY_Normal;
		//if ( Owner.IsA('PlayerPawn') )
		//	PlayerPawn(Owner).ViewTarget = None;
		return;
	}
	if (GuidedShell != None)
		GuidedShell.PostRender(Canvas);
	OldClipX = Canvas.ClipX;
	OldClipY = Canvas.ClipY;
	XScale = FMax(0.5, int(Canvas.ClipX/640.0));
	Canvas.SetPos( 0.5 * OldClipX - 128 * XScale, 0.5 * OldClipY - 128 * XScale );
	if ( Level.bHighDetailMode )
		Canvas.Style = ERenderStyle.STY_Translucent;
	else
		Canvas.Style = ERenderStyle.STY_Normal;

	numReadouts = OldClipY/128 + 2;
	for ( i = 0; i < numReadouts; i++ )
	{ 
		Canvas.SetPos(1,Scroll + i * 128);
		Scroll--;
		if ( Scroll < -128 )
			Scroll = 0;
	}
}	
// ================================================================================
simulated function PlayFiring()
{
	if ( !bFiring )
	{
		bFiring = true;
		PlayAnim('Fire');		
		// log("Playing Fire Sound", 'Misc');
		// PlayOwnedSound(FireSound, SLOT_None, 2.0);
	}
}
simulated function PlayIdleAnim()
{
	if ( (VSize(PlayerPawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) )
		loopAnim('IdleMove',RefireMult, [TweenTime] 0.0);
	else
		loopAnim('IdleStill',RefireMult, [TweenTime] 0.0);
}
simulated function SmallExplosion()
{
	local vector Loc;

	Loc = Pawn(Owner).Location + (vect(0,0,1) * Pawn(Owner).EyeHeight) + vector(Pawn(Owner).ViewRotation) * 24;
	spawn (class 'PhoenixEggFX',Pawn(Owner),,Loc);
}

simulated function ReleaseEgg()
{
	local vector Loc, x,y,z;
	
	Pawn(Owner).GetAxes(Pawn(Owner).ViewRotation, x, y, z);

	Loc = Pawn(Owner).Location + vect(0,0,1) * Pawn(Owner).EyeHeight + (x * 24) + (y * -10) + (z * -10);
	if ( Egg != none )
		Egg.Destroy();
	Egg = spawn(class 'PhoenixEgg',Pawn(Owner),,Loc);
}

// ================================================================================
simulated function FireWeapon()
{
	PlayOwnedSound(FireSound, SLOT_None,4.0);

	if (Level.NetMode == NM_Client)
	{
		if ( Egg != none )
			Egg.Destroy();
		return;
	}

	PawnOwner = Pawn(Owner);
	// GhelzUse(manaCostPerLevel[castingLevel]);
	PlayFiring();

	if ( Owner.bHidden )
		CheckVisibility();

	PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
	bPointing = true;
	// Pawn(Owner).PlayRecoil(FiringSpeed);
	PlayFiring();
	GuidedShell = Phoenix_Proj(ProjectileFire(class 'Phoenix_Proj', ProjectileSpeed, bWarnTarget, true));
	GuidedShell.SetOwner(Owner);
	GuidedShell.CastingLevel = 3;
	PlayerPawn(Owner).ViewTarget = GuidedShell;
	GuidedShell.Guider = PlayerPawn(Owner);
	ClientFire(0);
	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fPhoenix = 1.0;
	if ( Egg != none )
		Egg.Destroy();
	GotoState('Guiding');
}

// ================================================================================
function Fire( float Value )
{
	PawnOwner = Pawn(Owner);

    if ( PawnOwner.HeadRegion.Zone.bWaterZone && !bWaterFire) {
		PlayFireEmpty();
	} else {
		//SayMagicWords();
		if ( AmmoType.UseAmmo(1) )
		{
			GotoState('NormalFire');

			/*
			// GhelzUse(manaCostPerLevel[castingLevel]);
			PlayFiring();

			if ( Owner.bHidden )
				CheckVisibility();

			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
			bPointing=True;
			// Pawn(Owner).PlayRecoil(FiringSpeed);
			PlayFiring();
			GuidedShell = Phoenix_Proj(ProjectileFire(class 'Phoenix_Proj', ProjectileSpeed, bWarnTarget, true));
			GuidedShell.SetOwner(Owner);
			GuidedShell.CastingLevel = 3;
			PlayerPawn(Owner).ViewTarget = GuidedShell;
			GuidedShell.Guider = PlayerPawn(Owner);
			ClientFire(0);
			GameStateModifier(AeonsPlayer(Owner).GameStateMod).fPhoenix = 1.0;
			*/
			// GotoState('Guiding');
		}
	}
}

// ================================================================================
/* removes PlayFiring from ClientFire and adds sound
simulated function bool ClientFire( float Value )
{
//	if ( bCanClientFire && ((Role == ROLE_Authority) || (AmmoType == None) || (AmmoType.AmmoAmount > 0)) )
	if ( bCanClientFire && (Role == ROLE_Authority) )
	{
//		if ( Affector != None )
	//		Affector.FireEffect();
		PlayOwnedSound(FireSound, SLOT_None,4.0);
		return true;
	}
	return false;
}
*/

// needs a delay on client only
simulated function bool ClientFire( float Value )
{
	if (!bFiring && Super.ClientFire(Value))
	{
		//PlayOwnedSound(FireSound, SLOT_None,4.0);
		return true;
	}
	return false;
}

state NormalFire
{
	Begin:
		PlayAnim('Fire',,,,0);
		FinishAnim();
		Finish();
}

// ================================================================================
// Guiding State
// ================================================================================
state Finishing
{
	Begin:
		if (AmmoType.AmmoAmount > 0)
		{
			loopAnim('IdleStill',RefireMult); // todo: check speed for IdleMove
			sleep(0.5);
			GotoState('Idle');
		}
		else
		{
			Pawn(Owner).SwitchToBestWeapon();
			GotoState('DownWeapon');
		}		
}

// ================================================================================
// Guiding State
// ================================================================================
state Guiding
{
	function Fire( float Value )
	{
		local Actor PCam;

		if ( !bCanFire )
			return;
		if ( GuidedShell != None)
		{
			if (GuidedShell.GetStateName() != 'Release')
			{
				GuidedShell.GotoState('Release');
				GuidedShell.RemoteRole = ROLE_SimulatedProxy;
				PCam = Spawn(class 'PhoenixCameraProjectile',GuidedShell,,GuidedShell.Location, GuidedShell.Rotation);
				PlayerPawn(Owner).ViewTarget = PCam;
			}
		}
		else
		{
			bCanClientFire = true;

			if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
				Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
			GotoState('Finishing');
		}
	}
	
	function FireAttSpell(float f)
	{
		Fire(F);
	}

	function BeginState()
	{
		AeonsPlayer(Owner).bPhoenix = true;
		Scroll = 0;
		bGuiding = true;
		bCanFire = false;
		if ( Owner.IsA('PlayerPawn') )
		{
			AeonsPlayer(Owner).GotoState('GuidingPhoenix');
			GuidingPawn = PlayerPawn(Owner);
			GuidingPawn.DesiredFOV = 130;
			StartRotation = PlayerPawn(Owner).ViewRotation;
			PlayerPawn(Owner).ClientAdjustGlow(-0.2,vect(200,0,0));
			//PlayerPawn(Owner).Freeze();
			// Test PlayActuator here!!
			PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_NormalShake, 100000.0f);
		}
	}

	function EndState()
	{
		// log("Phoenix Guiding EndState", 'Misc');
		AeonsPlayer(Owner).bPhoenix = false;
		bFiring = false;
		bGuiding = false;
		if ( GuidingPawn != None )
		{
			//PlayerPawn(Owner).UnFreeze(); // done in GuidingPhoenix EndState
			GuidingPawn.ClientAdjustGlow(0.2,vect(-200,0,0));
			GuidingPawn.ClientSetRotation(StartRotation);
			GuidingPawn.DesiredFOV = GuidingPawn.default.DesiredFOV;
			if (GuidingPawn.Health > 0)
			{
				GuidingPawn.GotoState('PlayerWalking');//ClientGotoState
			}
			GuidingPawn.ViewTarget = None;
			GuidingPawn = None;
			// Test PlayActuator here!!
			PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_FadeOut, 0.1f);
		}
	}


	Begin:
		PlayAnim('');
		Sleep(0.25);
		bCanFire = true;
}

simulated function Tick(float DeltaTime)
{
	local rotator r;

	// left for compatibility with broken PHYS_Rotating
	if ( (GetStateName() == 'Pickup') && Physics == PHYS_None && (Owner == none) )
	{
		RemoteRole = ROLE_SimulatedProxy; // needed because MoveThingy changes RemoteRole

		r = rotation;
		r.yaw += 8192 * DeltaTime;
		SetRotation(r);
	}
}

// ================================================================================
// Idle State
// ================================================================================
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
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) && !PlayerPawn(Owner).bNeverAutoSwitch) 
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo

        if ( bChangeWeapon )
            GotoState('DownWeapon');

		if (Owner != None)
		{
			if ( VSize(Owner.Velocity) > 300 && !Owner.Region.Zone.bWaterZone )
				loopAnim('IdleMove',RefireMult, [TweenTime] TweenFrom('IdleStill', 0.5));
			else
				loopAnim('IdleStill',RefireMult, [TweenTime] TweenFrom('IdleMove', 0.5));
		}
	}

	Begin:
		ClientIdleWeapon();
		PlayIdleAnim();
		if ( bChangeWeapon )
			GotoState('DownWeapon');
		bWeaponUp = True;

		enable('Tick');
		setTimer(8 + FRand()*5,true);

}

State ClientIdle
{
	simulated function BeginState()
	{
		Super.BeginState();
		PlayAnim('');
	}
}

// ================================================================================
// ================================================================================

defaultproperties
{
     AmmoName=Class'Aeons.PhoenixAmmo'
     PickupAmmoCount=3
     FireOffset=(X=16) // X was 32 but it was spawning in walls if too close
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhoenixLaunch01'
     ItemType=WEAPON_Conventional
     AutoSwitchPriority=7
     InventoryGroup=7
     PickupMessage="You picked up the Phoenix"
     ItemName="Phoenix"
     PlayerViewOffset=(X=-5.37,Y=-11.2,Z=-9.4)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.PhoenixHand_m'
     PlayerViewScale=0.1
     PickupViewMesh=SkelMesh'Aeons.Meshes.Phoenix_m'
     ThirdPersonMesh=SkelMesh'Aeons.Meshes.PhoenixAmmo_m'
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.Phoenix_m'
     ThirdPersonScale=0.333
     bClientAnim=False
     bRotatingPickup=False
     DeathMessage="%o was incinerated by the phoenix."
     AltDeathMessage="%o was firebombed by the phoenix."
}
