//=============================================================================
// WizardEye_proj.
//=============================================================================
class WizardEye_proj expands SpellProjectile;

var WizardEye WEInv;
//var vector WallNormal;
var() Sound StickSound;
var() Sound PopSound;
var() Sound MovementSound[3];

//var AeonsPlayer APOwner;

//var bool bPlayerUsing;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	
	if ( Level.NetMode != NM_DedicatedServer )
		LoopAnim('Idle');
}

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{

	log("WizEyeProj: HitWall");
	//GotoState('Idle');
	SetRotation(Rotator(HitNormal));

	if ( StickSound != none )
		PlaySound(StickSound);
//	WallNormal = HitNormal;
	SetPhysics(PHYS_none);
}

simulated function Landed(vector HitNormal)
{
	//rb GotoState('Idle');
	SetRotation(Rotator(HitNormal));

	if ( StickSound != none )
		PlaySound(StickSound);

	//WallNormal = HitNormal;
	SetPhysics(PHYS_none);
}


function Timer()
{
	if ( AeonsPlayer(Owner).bWizardEye )
	{
		PlaySound(MovementSound[Rand(3)]);
		SetTimer(1 + FRand(), true);
	}
}


simulated function Tick(float deltaTime)
{
	if ( Owner == None ) 
	{
		Destroy();
		return;
	}

	if ( AeonsPlayer(Owner).bWizardEye ) 
	{		
		SetRotation( PlayerPawn(Owner).ViewRotation );
		//Log("WizEyeProj: Tick: playerusing: my rot = " $ Rotation $ " playerviewrot = " $ PlayerPawn(Owner).ViewRotation );
	}
}

/*
// do nothing
state Idle
{

	Begin:
		SetRotation (Rotator(WallNormal));
}

// the player is looking through me.
state ViewedThrough
{
	function Tick(float deltaTime)
	{
		SetRotation( PlayerPawn(Owner).ViewRotation );
	}
	
	function Timer()
	{
		PlaySound(MovementSound[Rand(3)]);
		SetTimer(1 + FRand(), true);
	}

	Begin:
}
*/

/*
simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	AeonsPlayer(Owner).wizEye = self;
	SetBase(Other);
	PlaySound(MiscSound, SLOT_Misc, 2.0);
}
*/

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	Destroy();
}

function Destroyed()
{
	if (PopSound != none)
		PlaySound(PopSound);

	WEInv.EyeDestroyed();
	AeonsPlayer(Owner).wizEye = none;
	if ( AeonsPlayer(Owner).bWizardEye )
		AeonsPlayer(Owner).vwe();
}

defaultproperties
{
     StickSound=Sound'Wpn_Spl_Inv.Inventory.I_WizEyeStick01'
     PopSound=Sound'Wpn_Spl_Inv.Inventory.I_WizEyePop01'
     MovementSound(0)=Sound'Wpn_Spl_Inv.Inventory.I_WizEyeLook01'
     MovementSound(1)=Sound'Wpn_Spl_Inv.Inventory.I_WizEyeLook02'
     MovementSound(2)=Sound'Wpn_Spl_Inv.Inventory.I_WizEyeLook03'
     Speed=1200
     bNetTemporary=False
     bClientAnim=True
     Physics=PHYS_Falling
     LODBias=5
     Mesh=SkelMesh'Aeons.Meshes.WizardEye_m'
     ShadowImportance=1
     DrawScale=3
     CollisionRadius=8
     CollisionHeight=16
}
