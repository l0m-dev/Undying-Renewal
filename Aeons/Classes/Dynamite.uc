//=============================================================================
// Dynamite.
//=============================================================================
class Dynamite expands Items;

//=============================================================================
// Molotov 1st person view
////#exec MESH IMPORT MESH=Molotov1st_m SKELFILE=Molotov1st\Molotov1st_m.ngf MOVERELATIVE=0
////#exec MESH ORIGIN MESH=Molotov1st_m YAW=64
////#exec MESH NOTIFY SEQ=Fire TIME=0.719 FUNCTION=FireWeapon

//=============================================================================
// Dynamite 1st persin view mesh
////#exec MESH IMPORT MESH=Dynamite1st_m SKELFILE=Dynamite1st\Dynamite1st.ngf MOVERELATIVE=0
////#exec MESH ORIGIN MESH=Dynamite1st_m YAW=64

// Notifys -------------------------------------------------------------------
//// #exec MESH NOTIFY SEQ=Fire TIME=0.719 FUNCTION=FireWeapon
//// #exec MESH NOTIFY SEQ=EndFire TIME=0.462 FUNCTION=ThrowLit
////#exec MESH NOTIFY SEQ=FireEnd TIME=0.462 FUNCTION=ThrowLit

//=============================================================================
// Dynamite - projectile and pickup
//#exec MESH IMPORT MESH=Dynamite_m SKELFILE=Dynamite\Dynamite_m.ngf

// Sound
//#exec AUDIO IMPORT FILE="..\Dynamite_proj\E_Wpn_DynaFuse01.wav" NAME="E_Wpn_DynaFuse01" GROUP="Weapons"

// Load the sound package
#exec OBJ LOAD FILE=..\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//=============================================================================
var int sndID, returnID;
var float heldTime, pFuseLen;
var float initialFuseLen;	// how long the fuse is
var float FuseDelay;		// how long the player has to hold the mouse button down to light the fuse

var int FuseID;

var Dynamite_proj 	dProj;	// Dynamite Projectile
var ParticleFX FuseFX;
var bool bFiring, bDropping;

var() Sound FuseLiteSound;
var() Sound FuseSound;
var() float MinSpeed;
var() float MaxSpeed;

var float ThrowStr;

//rb test
var bool bLit;

//=============================================================================

state Activated
{
	function Activate()
	{
		if ( !PlayerPawn(Owner).HeadRegion.Zone.bWaterZone && !PlayerPawn(Owner).HeadRegion.Zone.bNeutralZone && (PlayerPawn(Owner).Health >= 0) )
		{
			NumCopies --;
			DynamiteDrop(class 'DynamiteAmmo', 300, false, true);

			GameStateModifier(AeonsPlayer(Owner).GameStateMod).fDynamite = 1.0;
			
			if ( numCopies < 0 )
			{
				SelectNext();
				Pawn(Owner).DeleteInventory(self);
			}
		}
		GotoState('');
	}
	

	Begin:
		Activate();
}


/*
simulated function PlayFiring()
{
	// just play the anim - the animation drives the rest of the weapon functionality
	AeonsPlayer(Owner).AttSpell.BringUp();
	AeonsPlayer(Owner).AttSpell.PlayAnim('FireCantrip',RefireMult * 2,,,0);
	PlayAnim('FireStart',RefireMult,,,0);
}*/

// send a warning to ScriptedPawns within specified radius
function SendWarning( actor projActor, float Radius, float Duration, float Distance )
{
	local ScriptedPawn		sPawn;

	foreach RadiusActors( class 'ScriptedPawn', sPawn, Radius )
	{
		sPawn.WarnAvoidActor( projActor, Duration, Distance, 0.50 );
	}
}

function DynamiteAmmo DynamiteDrop(class<Ammo> AmmoClass, float ProjSpeed, bool bWarn, optional bool bDrop)
{
    /*local vector  Start, FireDir, X,Y,Z;
    local DynamiteAmmo A;
    
    GetAxes(PlayerPawn(Owner).ViewRotation, X, Y, Z);
	
	AeonsPlayer(Owner).MakePlayerNoise(1.0);

    FireDir = Normal(vector(Pawn(Owner).ViewRotation));
	Start = Location + (Z * 16) + (Y * -8) + (FireDir * 24);
	// log("-=-=-=- Dynamite Fire Location is in zone "$Level.GetZone(Start), 'Misc');

    A = Spawn(class 'DynamiteAmmo', Pawn(Owner),, Start,Rotator(FireDir));  
    A.Velocity = (FireDir * 600) + Owner.Velocity;
    A.Spin();
    return A;*/

	// Owner.PlaySound(FireSound, SLOT_None,2.0);
    // AeonsPlayer(Owner).MakePlayerNoise(1.0, 1280*3);
	
	dProj = DynamiteFire(class 'Dynamite_proj', 300, false, false);
	//dProj.SpinRate(1.0);
	dProj.bFuseLit = true;
	dProj.FuseLen = 3;
	dProj.GotoState('Throw');
}

function Dynamite_proj DynamiteFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, optional bool bDrop)
{
	local Vector X,Y,Z, eyeAdjust, HitLocation, HitNormal, eyeAdj, TraceEnd, start;
	local rotator bulletDir;
	local rotator Dir;
	local Dynamite_proj Proj;

//	AmmoType.UseAmmo(1);
	Dir = Pawn(owner).ViewRotation;

	GetAxes(Dir,X,Y,Z);

	Start = Owner.Location + (Vector(Dir) * Owner.CollisionRadius);
	// log("-=-=-=- Dynamite Fire Location is in zone "$Level.GetZone(Start), 'Misc');
	
	Proj = Spawn(class'Dynamite_proj', Pawn(Owner),, Start, Dir);
	if ( bWarn )
		SendWarning( proj, 2000.0, proj.default.FuseLen, 512.0 );	// MG: should these "magic numbers" be extracted from the Dynamite_proj?

	return Proj;
}

/*function ThrowLit()
{
	Owner.PlaySound(FireSound, SLOT_None,2.0);
    AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);

	// get rid of the fuse
	if ( FuseFX != none )
		FuseFX.Destroy();

	dProj = DynamiteFire(class 'Dynamite_proj', ProjectileSpeed, bWarnTarget, false);
	dProj.Speed = dProj.default.Speed * FClamp(ThrowStr, 0.5, 1.0);
	dProj.SpinRate(FClamp(ThrowStr, 0.3333, 1.0));
	dProj.bFuseLit = true;
	dProj.FuseLen = pFuseLen;
	dProj.GotoState('Throw');

	bFiring = false;
	AeonsPlayer(Owner).FireHeldTime = 0;
	HeldTime=0;
	stopSound(sndID);
	// gotoState('NewClip');
}

////////////////////////////////////////////////////////
state Hold
{

	function AnimEnd()
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		{
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
			bChangeWeapon=true;
		}
	}

	function Tick(float deltaTime)
	{
		if ( bFiring )
		{
			// log("Dynamite: state Hold: Tick: HeldTime=" $ HeldTime, 'Misc');

			// Held it too long - blow up.
			if ( HeldTime > (FuseDelay + InitialFuseLen) )
			{
				// held it too long - spawn and blow up
				dProj = DynamiteFire(class 'Dynamite_proj', ProjectileSpeed, bWarnTarget, false);
				dProj.gotoState('Blow');
				StopSound(SndID);
				bFiring = false;
				AeonsPlayer(Owner).FireHeldTime=0;
				HeldTime = 0;
				bLit=false;

				GotoState('Hold', 'ExplodeInHand');
			}

			if ( PlayerPawn(Owner).bFire == 0)
			{
				bLit = false;
				pFuseLen = (3.0 - heldTime); // + 1.0;
				ThrowStr = HeldTime / 3.0;
				PlayAnim('FireEnd',RefireMult,,,0);
				Disable('Tick');
				GotoState( ,'FireEnd');
			}
			HeldTime = AeonsPlayer(Owner).FireHeldTime;
		}
	}

	function BeginState()
	{
		AeonsPlayer(Owner).FireHeldTime = 0;
		// Log("Dynamite: State Hold: BeginState", 'Misc');
	}
	
	ExplodeInHand:
		Disable('Tick');
		HeldTime = 0;
		AeonsPlayer(Owner).FireHeldTime=0;
		Sleep(RefireRate);
		Enable('Tick');
		Finish();
		Stop;
	
	FireEnd:
		// log (" ------ Trying to finish the FireEnd Anim", 'Misc');
		FinishAnim();
		// log (" ------ Finished the FireEnd Anim", 'Misc');
		Finish();		
	Begin:

}

// ===========================================================
// Normal Fire Stste
// ===========================================================
state NormalFire
{
	function Fire(float Value)
	{
		// log ("Fire() called within Normal Fire state",'Misc');
	}

	function Timer()
	{
		// Log("Dynamite: state NormalFire: Timer: HeldTime=" $ HeldTime $ " FuseDelay="$FuseDelay, 'Misc');
		if ( HeldTime > FuseDelay )
			gotoState('NormalFire','START_THROW');
	}

	simulated function BeginState()
	{
		// AeonsPlayer(Owner).FireHeldTime=0;
	}

	function FireWeapon()
	{
		stopSound(sndID);
		bFiring = false;
		AeonsPlayer(Owner).FireHeldTime=0;
		Finish();
		GotoState('NewClip');
	}

	function Tick(float deltaTime)
	{
		//rb I moved this up here so it executes first
		//Log("Dynamite: state NormalFire: Tick: HeldTime=" $ HeldTime $ " FuseDelay=" $ FuseDelay, 'Misc');
		
		if ( (HeldTime >= FuseDelay) )
		{
			// PlayAnim('Fire',RefireMult,,,0);
			bLit = true;
			gotoState('NormalFire','START_THROW');
		} else if ( (HeldTime < FuseDelay) && ( PlayerPawn(Owner).bFire == 0) ) {
			// log ("Held Time, "$HeldTime$", is less than the fire delay, and the player is not firing - going to IdleState", 'Misc');
			Finish();
			GotoState('Idle');
		}
		//heldTime = AeonsPlayer(Owner).FireHeldTime;
		HeldTime = AeonsPlayer(Owner).FireHeldTime;
		// log("HeldTime incrementing to "$HeldTime, 'Misc');

	}
	
	START_THROW:
		log("NormalFire state START_THROW Label", 'Misc');
		//rb test
		//heldtime=0;

		Disable('Tick');
		AeonsPlayer(Owner).AttSpell.BringUp();
		AeonsPlayer(Owner).AttSpell.PlayAnim('FireCantrip',RefireMult,,,0);
		Sleep(0.5);
		// PlaySound(FuseLiteSound);
		AeonsPlayer(Owner).AttSpell.Finish();

	    AeonsPlayer(Owner).MakePlayerNoise(1.0, 1280);

		Sleep(0.5 * (1.0/RefireMult));

		//rb put back later and fix so fuse is clientside only
		if ( FuseFX != none )
			FuseFX.Destroy();

		FuseFX = spawn(class 'HUDFuseFX',,,JointPlace('Fuse_5').pos, rotator(JointPlace('Fuse_6').pos - JointPlace('Fuse_5').pos));
 		FuseFX.SetBase(self,'fuse_5','root');
		// log ("FuseFX != none ..... FuseFX = "$FuseFX, 'Misc');
		
		// fix if ( Level.NetMode == NM_Standalone ) 
		sndID = playSound(FuseSound,,1);

		HeldTime = 0;
		sleep(0.25 * (1.0/RefireMult));
		playAnim('StartFire',RefireMult,,,0);
		// log("Dynamite: state NormalFire: going to state Hold", 'Misc');
		Enable('Tick');
		gotoState('Hold');
		Stop;

	THROW:
		// log("NormalFire state THROW Label", 'Misc');
		PlayAnim('FireEnd',RefireMult,,,0);
		sleep(1);
		FinishAnim();
		Stop;
		
	Begin:
		// log("NormalFire state BEGIN Label -- bFiring is "$bFiring, 'Misc');
		if ( !bFiring && (AmmoType.AmmoAmount >= 1) )
		{
			//rb took out timer and moved to Tick resolution
			//setTimer(fuseDelay,false);
			bFiring = true;
		}
}

//----------------------------------------------------------------------------
//	State
//----------------------------------------------------------------------------
state FinishState
{

	Begin:
		// sleep(refireRate);
	    FinishAnim();
	    Finish();
}

//----------------------------------------------------------------------------
//	State
//----------------------------------------------------------------------------
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
		PlayAnim('Down');
		FinishAnim();
		ClearAnims();
		
		if ( FuseFX != None ) 
			FuseFX.Shutdown();

		sleep(reloadTime * (1.0/RefireMult));
		//Owner.PlaySound(Misc1Sound, SLOT_None,2.0);
		//Owner.PlaySound(Misc2Sound, SLOT_None,2.0);

	    if ( AmmoType.AmmoAmount >= ReloadCount )
	        ClipCount = ReloadCount;
	    else
	        ClipCount = AmmoType.AmmoAmount;
	
	    // Owner.PlaySound(CockingSound, SLOT_None,2.0);
		gotoState('FinishState');
}


//----------------------------------------------------------------------------
//	State
//----------------------------------------------------------------------------
state Idle
{
	function Fire(float F)
	{
		// log ("Called Fire() withing Idle state",'Misc');
		if ( !bDropping )
			Global.Fire(F);
	}
	
	function Tick(float DeltaTime)
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo

		if ( !bDropping )
		{
			if ( (VSize(PlayerPawn(Owner).Velocity) > 200) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) )
			{
				if (AnimSequence != 'IdleMove')
					LoopAnim('IdleMove',RefireMult);
			} else {
				if (AnimSequence != 'IdleStill')
					LoopAnim('IdleStill',RefireMult);
			}
		} else {
			// log("bDropping is true", 'Misc');
		}
	}

	function BeginState()
	{
		Enable('Tick');
		HeldTime = 0;
		bFiring = false;
	}

	Dropping:
		PlayAnim('Down');
		Sleep(0.5);
		AmmoType.UseAmmo(1);
		DynamiteDrop(class 'DynamiteAmmo', ProjectileSpeed, bWarnTarget, true);

		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo

		FinishAnim();
		bDropping=false;
		Stop;

	Begin:
		// log("Idle state BEGIN Label", 'Misc');
		// FinishAnim();
		// StopSound(fuseID);
		bPointing=False;
		
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
			Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo

		if ( Pawn(Owner).bFire!=0 )
			Global.Fire(0.0);
		
		Disable('AnimEnd');
}

//----------------------------------------------------------------------------

function Tick(float DeltaTime)
{
	if ( bChangeWeapon )
		GotoState('DownWeapon');
}

//----------------------------------------------------------------------------
//	State
//----------------------------------------------------------------------------
state ClientFiring
{


}

//----------------------------------------------------------------------------
//	State
//----------------------------------------------------------------------------
state ClientHolding
{

}
*/
//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     bCanHaveMultipleCopies=True
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=116
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You picked up Dynamite"
     ItemName="Dynamite"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Dynamite_m'
     PickupSound=Sound'Aeons.Inventory.I_DynAmmoPU01'
     Icon=Texture'Aeons.Icons.Dynamite_Icon'
     Mesh=SkelMesh'Aeons.Meshes.Dynamite_m'
     DrawScale=0.2
     CollisionRadius=8
     bCollideWorld=True
}
