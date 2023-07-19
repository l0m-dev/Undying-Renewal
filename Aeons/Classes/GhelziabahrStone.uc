//=============================================================================
// GhelziabahrStone.
//=============================================================================
class GhelziabahrStone expands AeonsWeapon;

//-----------------------------------------------------------------------------
// 1st Person View Mesh
//#exec MESH IMPORT MESH=GhelziabahrStone1st_m SKELFILE=GhelziabahrStone1st\GhelziabahrStone1st.ngf MOVERELATIVE=0
//#exec MESH ORIGIN MESH=GhelziabahrStone1st_m YAW=64

//-----------------------------------------------------------------------------
// Sounds
//#exec AUDIO IMPORT FILE="E_Wpn_GhelFire01.wav" NAME="E_Wpn_GhelFire01" GROUP="Weapons"

//-----------------------------------------------------------------------------

// Notifys
//#exec MESH NOTIFY SEQ=Fire TIME=0.100 FUNCTION=FireWeapon

//#exec MESH IMPORT MESH=GhelzStonePickup_m SKELFILE=GhelziabahrStone3rd\GhelzStone.ngf

//#exec OBJ LOAD FILE=\aeons\textures\FX.utx PACKAGE=FX

//-----------------------------------------------------------------------------

var travel int useMeter;		// Use Meter for the ghelzibahar Stone
var int chargeCount;
var int Damage;
var() int SpawnHoundLimit;
var() sound SpawnHoundSound;
var() texture GlowTexture;
var bool bGlowStone;
var float GlowFlashX, GlowFlashY;

function PostBeginPlay()
{
	super.PostBeginPlay();
	AmmoType.AmmoAmount = 9999;
}

function FellOutOfWorld()
{
	LogStack();
	super.FellOutOfWorld();
}

function EncroachedBy( actor Other )
{
	LogStack();
	super.EncroachedBy( Other );
}

function Destroyed()
{
	LogStack();
	super.Destroyed();
}

function PlayHoundAnim()
{
	GotoState('HoundAnim');
}

state HoundAnim
{
	ignores Fire, Reload, PutDown;

	
	Begin:
		Owner.PlaySound(SpawnHoundSound);
		PlayAnim('Hound',RefireMult);
		FinishAnim();
		GotoState('Idle');
}

function addUse(int amt)
{
	if (!RGC())
	{
		return;
	}
	useMeter += amt;
	if ( useMeter > SpawnHoundLimit )
	{
		useMeter = 0;
		if ( AeonsPlayer(Owner).SpawnHound() )
		{
			GotoState('HoundAnim');
		}
	}
}

function MeleeAttack(float Range)
{
	local vector x, y, z, hitloc, momentum;
	local actor Other;
	local int healthTaken;
	local vector impulse;
	local GhelzRingFX g;
	
	impulse = vect(0,0,0);
	impulse.z = (chargeCount/20.0) * 256;
	// log("Impulse: "$Impulse);

	spawn(class 'GhelziabahrRing',,,Owner.Location, rot(0,0,0));
	
	//rb net spawn(class 'GhelzRingFX',Pawn(Owner),,Location,rot(0,0,0));
	g = spawn(class 'GhelzRingFX',Pawn(Owner),,Owner.Location,rot(0,0,0));
	g.setBase(Owner);
	
	spawn(class 'PulseWind',,,Owner.Location);

	GetAxes(PlayerPawn(Owner).ViewRotation, x, y, z);

	
	foreach RadiusActors(class'Actor', Other, range, Owner.Location)
	{
		if (Other != Owner)
		{
			if ((Other.Location - Owner.Location) Dot X > 0 && Other.IsA('Pawn'))
			{
				hitloc = Other.Location + (Other.Location - Owner.Location) * Other.CollisionRadius;
				healthTaken = damage;
	
				x = Vector(PlayerPawn(Owner).ViewRotation);
	
				if ( x.z < 0 )
						x.z = 0.5;
				if ( ( Other.Mass < 1000 ) &&
					 Other.bMovable && 
					 !Other.bScryeOnly &&
					 !Other.Region.Zone.bWaterZone &&
					 ( FastTrace( Owner.Location, Other.Location ) ) && 
					 !( (Other.Physics == PHYS_None) || (Other.Physics == PHYS_Attached) ) )
				{
					Other.SetPhysics( PHYS_Falling );
					Other.Velocity = x * (RandRange(400.0, 600.0) * (100.0/Other.Mass));
					Other.Bump( self );
					if ( Other.IsA('ScriptedPawn') )
						ScriptedPawn(Other).Stoned( pawn(Owner) );
				}
			}
	
//			momentum = (Other.Location - Owner.Location) * (MomentumTransfer/Other.Mass) + impulse;
	//		Other.Velocity += momentum;
		}
	}
	
	addUse(RandRange(2, 5));
}

function Fire(float F)
{
	gotostate('NormalFire');
}

// Called by the FireAnimation
function FireWeapon()
{
	PlaySound(FireSound);
	AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);
	MeleeAttack(256);
	bMuzzleFlash ++;

	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fGhelz = 1.0;
	// Test PlayActuator here!!
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_LightShake, 0.4f);
}

state NormalFire
{
	ignores Fire, Reload;
	
	Begin:
		// log("Play Fire Animation");
		PlayAnim('Fire', 1 / AeonsPlayer(Owner).refireMultiplier);
		FinishAnim();
		chargeCount=0;
		bCanClientFire=true;
		// sleep(refirerate);
		// gotoState('Active');
		Finish();
}


state Active
{

	Begin:
		SetBase( Owner, 'Revolver_Attach_Hand', 'root' );
		// SetBase( Owner, 'L_Wrist', 'root' );
		bCanClientFire=true;
		//gotoState('Idle');
		GotoState('Idle');
}

state Idle
{

	ignores Reload;
	
	function Fire(float F) 
	{
		gotoState('NormalFire');
	}

	function bool PutDown()
	{
		LogStack();
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
		if ( chargeCount < 20 )
		{
			chargeCount += 1;
			//AddUse(1);
		}

        if ( bChangeWeapon )
		{
			LogActor("bChangeWeapon has been set.");
            GotoState('DownWeapon');
		}
		if ((VSize(Pawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) )
		{
			LoopAnim('MoveIdle');
		} else {
			LoopAnim('StillIdle');
		}
	}

	
	simulated function Timer()
	{
		if ( VSize(PlayerPawn(Owner).Velocity) < 200 )
			if (FRand() > 0.75)
				gotoState(getStateName(),'Flourish');
	}


	FLOURISH:
		disable('Tick');
		PlayAnim('Hound',RefireMult);
		FinishAnim();
		goto 'Begin';

	Begin:
		FinishAnim();
		if ( bChangeWeapon )
			GotoState('DownWeapon');
		chargeCount = 0;
		//AddUse(1);
		bWeaponUp = True;
		Enable('Tick');
		// setTimer(0.05, true);
		setTimer(8 + FRand()*6,true);
	

}

/*
function PlayPostSelect()
{
	log("Ghelz: PlayPostSelect");
	// PlayerPawn(Owner).ClientMessage("Ghelziabahr Stone Selected");
}
*/

simulated function Glow()
{
	Spawn(class 'GhelzGlowScriptedFX',self,,Location);
	// PlayerPawn(Owner).ClientMessage("Ghelz -  - GLOW!");
	// glow effect and animation here.
}

simulated function PlayIdleAnim()
{
	LogActorState("PlayIdleAnim: Ghelz");
	bCanClientFire=true;

	if ((VSize(Pawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) )
	{
		LoopAnim('MoveIdle');
	} 
	else 
	{
		LoopAnim('StillIdle');
	}
}

//=============================================================================
// ClientFiring
//=============================================================================
state ClientFiring
{
	simulated function AnimEnd()
	{
		Log("Ghelz: state ClientFiring: AnimEnd");

		if ( Pawn(Owner).bFire != 0 )
			Global.ClientFire(0);
		else
		{
			PlayIdleAnim();
			GotoState('');
		}

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
				//PlayReloading();
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

simulated function RenderOverlays( canvas Canvas )
{
	local rotator NewRot;
	local bool bPlayerOwner;
	local int Hand;
	local PlayerPawn PlayerOwner;

	if ( bHideWeapon || (Owner == None) )
		return;

	PlayerOwner = PlayerPawn(Owner);

	if ( PlayerOwner != None )
	{
		if ( PlayerOwner.DesiredFOV != PlayerOwner.DefaultFOV )
			return;
		bPlayerOwner = true;
		Hand = PlayerOwner.Handedness;

		if ( (Level.NetMode == NM_Client) && (Hand == 2) )
		{
			bHideWeapon = true;
			return;
		}
	}

	if ( !bPlayerOwner || (PlayerOwner.Player == None) )
		Pawn(Owner).WalkBob = vect(0,0,0);

	if ( bGlowStone && (GlowTexture != None) )
	{
		MuzzleScale = Default.MuzzleScale * Canvas.ClipX/640.0;
		Canvas.SetPos((Canvas.ClipX * FlashX) - (0.5 * GlowTexture.USize * MuzzleScale), (Canvas.ClipY * FlashY) - (0.5 * GlowTexture.USize * MuzzleScale));
		Canvas.Style = FlashStyle0;
		Canvas.DrawIcon(GlowTexture, MuzzleScale);
	}

	Super.RenderOverlays(Canvas);
}

defaultproperties
{
     SpawnHoundLimit=2000
     GlowTexture=WetTexture'FX.Gglow_wet'
     GlowFlashX=0.35
     GlowFlashY=0.677
     MomentumTransfer=300
     ExpireMessage="Expire Message"
	 AmmoName=Class'Aeons.GhelziabahrAmmo'
     PickupAmmoCount=20
     AIRating=0.4
     FireSound=Sound'Aeons.Weapons.E_Wpn_GhelFire01'
     SelectSound=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02'
     bDrawMuzzleFlash=True
     MuzzleScale=3
     FlashY=0.777
     FlashX=0.3078
     FlashLength=0.5
     MFTexture0=Texture'Aeons.MuzzleFlashes.Ghelz_Glow'
     MFTexture1=Texture'Aeons.MuzzleFlashes.Ghelz_Glow2'
     FlashStyle0=STY_Translucent
     FlashStyle1=STY_Translucent
     ItemType=WEAPON_Conventional
     AutoSwitchPriority=6
     InventoryGroup=2
     ItemName="Gel'ziabar Stone"
     PlayerViewOffset=(X=-5.4,Y=-11,Z=-9.5)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.GhelziabahrStone1st_m'
     PlayerViewScale=0.1
     PickupViewMesh=SkelMesh'Aeons.Meshes.GhelzStonePickup_m'
     ThirdPersonMesh=SkelMesh'Aeons.Meshes.GhelzStonePickup_m'
     bMuzzleFlashParticles=True
     MuzzleFlashStyle=STY_Translucent
     MuzzleFlashScale=1
     MuzzleFlashTexture=Texture'Aeons.MuzzleFlashes.Ghelz_Glow2'
     bTimedTick=True
     MinTickTime=0.05
     CollisionRadius=8
     CollisionHeight=4
     bGroundMesh=False
}
