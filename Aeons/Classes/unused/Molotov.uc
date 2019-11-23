//=============================================================================
// Molotov.
//=============================================================================
class Molotov expands AeonsWeapon;

var int sndID;
var ParticleFX fuseFX ;
var() Sound FuseLiteSound;
var() Sound IdleSounds[2];
var float Firing;

//=============================================================================
function Fire(float F)
{
	//log("Molotov Fire() ... bFiring = "$bFiring, 'Misc');
	if ( (PlayerPawn(Owner).HeadRegion.Zone.bWaterZone && !bWaterFire) || (Firing > 0.0) || AmmoType.AmmoAmount <= 0)
	{
		return;
	} else {
		super.Fire(F);
	}
}

function PlayFiring()
{
	Firing = 1.0;
	if (fuseFX != none) 
		fuseFX .Destroy();
	// just play the anim - the animation drives the rest of the weapon functionality

	if ( !AeonsPlayer(Owner).AttSpell.IsA('SkullStorm') )
	{
		AeonsPlayer(Owner).AttSpell.BringUp();
		AeonsPlayer(Owner).AttSpell.PlayAnim('FireCantrip',RefireMult,,,0);
		AeonsPlayer(Owner).AttSpell.Finish();
	}

	PlaySound(FuseLiteSound);

	if ( Level.NetMode == NM_Standalone )
	{
		fuseFX = spawn(class 'HUDFuseFX',,,JointPlace('Fuse_5').pos, rotator(JointPlace('Fuse_6').pos - JointPlace('Fuse_5').pos));
		fuseFX.SetBase(self,'fuse_5','root');
	}

	playAnim('Fire',RefireMult,,,0);
	// PlaySound(IdleSounds[Rand(2)]);
}

// send a warning to ScriptedPawns within specified radius
function SendWarning( actor projActor, float Radius, float Duration, float Distance )
{
	local ScriptedPawn		sPawn;

	foreach RadiusActors( class 'ScriptedPawn', sPawn, Radius )
	{
		sPawn.WarnAvoidActor( projActor, Duration, Distance, 0.50 );
	}
}

function Molotov_proj MolotovFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector X,Y,Z, eyeAdjust, HitLocation, HitNormal, eyeAdj, TraceEnd, start;
	local rotator bulletDir;
	local rotator Dir;
	local Dynamite_proj proj;

	AeonsPlayer(Owner).MakePlayerNoise(1.0);

	Dir = Pawn(owner).ViewRotation;

	GetAxes(Dir,X,Y,Z);

	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	
	if ( fuseFX != None ) 
		fuseFX.Destroy();

	// PlaySound(IdleSounds[Rand(2)]);
	
	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fMolotov = 1.0;
	return Spawn(class'Molotov_proj', Pawn(Owner),, Start, Dir);
}

////////////////////////////////////////////////////////
state NormalFire
{
	ignores Fire;

	function EndState()
	{
	}

	Begin:
		MolotovFire(class 'Molotov_proj', ProjectileSpeed, bWarnTarget);
		log ("RefireRate of Molotov = " $ refireRate);
		sleep(refireRate);
		gotoState('NewClip');
	    if (AmmoType.AmmoAmount > 0)
	    {
	        // PlaySound(IdleSounds[Rand(2)]);
			PlayAnim('Select', RefireMult,,,0);
	        FinishAnim();
	    }
}

///////////////////////////////////////////////////////
// Switches the visible weapon mesh for different ammo types (Dynamite -> Molotov)
state SwitchWeaponMesh
{
	Ignores Fire;


	Begin:
		PlayAnim('Down',RefireMult);
		PlaySound(IdleSounds[Rand(2)]);
		FinishAnim();
		ClearAnims();
		if ( !bAltAmmo )
			Mesh = PlayerViewMesh;
		else
			if ( AltAmmoMesh != none )
				Mesh = AltAmmoMesh;

		PlayAnim('Select',RefireMult);
		FinishAnim();
		gotoState('NewClip');
}

///////////////////////////////////////////////////////
state FinishState
{
	function Fire(float F){}

	Begin:
		// sleep(refireRate);
	    FinishAnim();
	    Finish();
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

	Begin:
		PlaySound(IdleSounds[Rand(2)]);
		Sleep(ReloadTime);
	    Owner.PlaySound(Misc1Sound, SLOT_None,2.0);
	    Owner.PlaySound(Misc2Sound, SLOT_None,2.0);
	    if ( AmmoType.AmmoAmount >= ReloadCount )
	        ClipCount = ReloadCount;
	    else
	        ClipCount = AmmoType.AmmoAmount;
	
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) && !PlayerPawn(Owner).bNeverAutoSwitch ) 
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
		else {
			Owner.PlaySound(CockingSound, SLOT_None,2.0);
		}
		GotoState('FinishState');
}


////////////////////////////////////////////////////////
state Idle
{
	simulated function Timer()
	{
//		PlaySound(IdleSounds[Rand(2)]);
		setTimer((1 + FRand() * 3), true);
	}

	function BeginState()
	{
		log ("Idle");		
		Firing = 0.1;

		if ( fuseFX != None ) 
			fuseFX.Destroy();
	}
	
	Begin:
		ClearAnims();
		FinishAnim();
		SetTimer((1 + FRand() * 3), true);
		bPointing=False;
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		{
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
			Firing = 0.0;
		}
		if ( Pawn(Owner).bFire!=0 ) Global.Fire(0.0);
		Disable('AnimEnd');
		LoopAnim('StillIdle');
}

function Tick(float DeltaTime)
{
	if ( (AmmoType != None) && (AmmoType.AmmoAmount > 0) ) 
		bSpecialIcon = false;

	if (Firing > 0.0)
		Firing -= DeltaTime;		
	if ( bChangeWeapon )
		GotoState('DownWeapon');
}

defaultproperties
{
     FuseLiteSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MoltLight01'
     IdleSounds(0)=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MoltSlosh01'
     IdleSounds(1)=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MoltSlosh02'
     bReloadable=True
     ReloadTime=1
     ThirdPersonJointName=MolotovAtt
     AmmoName=Class'Aeons.MolotovAmmo'
     ReloadCount=1
     bWarnTarget=True
     bSpecialIcon=True
     FireOffset=(X=24)
     AIRating=0.6
     SelectSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MoltPU01'
     ItemType=WEAPON_Conventional
     AutoSwitchPriority=8
     InventoryGroup=8
     ItemName="Molotov"
     PlayerViewOffset=(X=-2.9,Y=-11.5,Z=-8.2)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.Molotov1st_m'
     PlayerViewScale=0.1
     PickupViewScale=0.1
     ThirdPersonMesh=SkelMesh'Aeons.Meshes.Molotov3rd_m'
     Mesh=SkelMesh'Aeons.Meshes.Molotov1st_m'
     DrawScale=0.2
}
