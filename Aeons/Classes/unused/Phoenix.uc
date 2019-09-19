//=============================================================================
// Phoenix.
//=============================================================================
class Phoenix expands AeonsWeapon;

#exec MESH IMPORT MESH=PhoenixHand_m SKELFILE=PhoenixHand.ngf
#exec MESH ORIGIN MESH=PhoenixHand_m YAW=64

#exec MESH NOTIFY SEQ=Fire TIME=0.1548 FUNCTION=ReleaseEgg
#exec MESH NOTIFY SEQ=Fire TIME=0.4 FUNCTION=SmallExplosion
#exec MESH NOTIFY SEQ=Fire TIME=0.5 FUNCTION=FireWeapon

#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

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
		bGuiding, bShowStatic;
}

function BecomePickup()
{
	super.BecomePickup();
	PlayAnim( 'pickup_pose' );
}

simulated function PostRender( canvas Canvas )
{
	local int i, numReadouts, OldClipX, OldClipY;
	local float XScale;

	bOwnsCrossHair = ( bGuiding || bShowStatic );

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
function SmallExplosion()
{
	local vector Loc;

	Loc = Pawn(Owner).Location + (vect(0,0,1) * Pawn(Owner).EyeHeight) + vector(Pawn(Owner).ViewRotation) * 24;
	spawn (class 'PhoenixEggFX',Pawn(Owner),,Loc);
}

function ReleaseEgg()
{
	local vector Loc, x,y,z;
	
	Pawn(Owner).GetAxes(Pawn(Owner).ViewRotation, x, y, z);

	Loc = Pawn(Owner).Location + vect(0,0,1) * Pawn(Owner).EyeHeight + (x * 24) + (y * -10) + (z * -10);
	if ( Egg != none )
		Egg.Destroy();
	Egg = spawn(class 'PhoenixEgg',Pawn(Owner),,Loc);
}

// ================================================================================
function FireWeapon()
{
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
	GuidedShell.CastingLevel = 5;
	PlayerPawn(Owner).ViewTarget = GuidedShell;
	GuidedShell.Guider = PlayerPawn(Owner);
	ClientAltFire(0);
	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fPhoenix = 1.0;
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
			ClientAltFire(0);
			GameStateModifier(AeonsPlayer(Owner).GameStateMod).fPhoenix = 1.0;
			*/
			// GotoState('Guiding');
		}
	}
}

// ================================================================================
simulated function bool ClientAltFire( float Value )
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
		if ( GuidedShell != None )
		{
			GuidedShell.GotoState('Release');
			PCam = Spawn(class 'PhoenixCameraProjectile',GuidedShell,,GuidedShell.Location, GuidedShell.Rotation);
			PlayerPawn(Owner).ViewTarget = PCam;
			// GuidedShell.Explode(GuidedShell.Location,Vect(0,0,1));
		}
		bCanClientFire = true;

		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
		GotoState('Finishing');
	}
	
	function FireAttSpell(float f)
	{
		Fire(F);
	}

	function BeginState()
	{
		// log("Phoenix Guiding BeginState", 'Misc');
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
			PlayerPawn(Owner).Freeze();
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
			//PlayerPawn(Owner).UnFreeze();
			GuidingPawn.ClientAdjustGlow(0.2,vect(-200,0,0));
			GuidingPawn.ClientSetRotation(StartRotation);
			GuidingPawn.DesiredFOV = GuidingPawn.default.DesiredFOV;
			GuidingPawn.GotoState('PlayerWalking');
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

function Tick(float DeltaTime)
{
	local rotator r;

	if ( (GetStateName() == 'Pickup') && (Owner == none) )
	{
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

		if ( (VSize(PlayerPawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) )
			loopAnim('IdleMove',RefireMult);
		else
			loopAnim('IdleStill',RefireMult);
	}

	Begin:
		PlayAnim('');
		FinishAnim();
		if ( bChangeWeapon )
			GotoState('DownWeapon');
		bWeaponUp = True;

		enable('Tick');
		setTimer(8 + FRand()*5,true);

}

// ================================================================================
// ================================================================================

defaultproperties
{
     AmmoName=Class'Aeons.PhoenixAmmo'
     PickupAmmoCount=3
     FireOffset=(X=32)
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
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.Phoenix_m'
}
