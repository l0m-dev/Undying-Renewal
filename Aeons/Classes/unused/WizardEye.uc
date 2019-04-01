//=============================================================================
// WizardEye.
//=============================================================================
class WizardEye expands Items;

// Use temp mesh for now
#exec MESH IMPORT MESH=WizardEye_m SKELFILE=WizardEye.ngf
// #exec TEXTURE IMPORT NAME=WizEye_Icon FILE=WizEye_Icon.PCX GROUP=Icons FLAGS=2

var WizardEye_proj wizEye;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	LoopAnim('Idle');
}

function Activate()
{
	local vector startPos;
	
	if ( AeonsPlayer(Owner).wizEye == none )
	{
		PlaySound(ActivateSound);
		startPos = PlayerPawn(Owner).Location + (Vector(PlayerPawn(Owner).ViewRotation) * 64);
		wizEye = spawn(class 'WizardEye_proj',PlayerPawn(Owner),,startPos);
		WizEye.WEInv = self;
		wizEye.velocity = Vector(PlayerPawn(Owner).ViewRotation) * wizEye.default.speed;
		AeonsPlayer(Owner).wizEye = WizEye;
	} 
	else 
	{
		AeonsPlayer(Owner).vwe();
	}
}

function EyeDestroyed()
{
	Pawn(Owner).DeleteInventory(self);
}

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=102
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You gained a Wizard's Eye"
     ItemName="WizardEye"
     PickupViewMesh=SkelMesh'Aeons.Meshes.WizardEye_m'
     PickupViewScale=2
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_WizEyePU01'
     ActivateSound=Sound'Wpn_Spl_Inv.Inventory.I_WizEyeUse01'
     Icon=Texture'Aeons.Icons.WizardEye_Icon'
     bClientAnim=True
     RemoteRole=ROLE_DumbProxy
     Mesh=SkelMesh'Aeons.Meshes.WizardEye_m'
     DrawScale=2
     CollisionRadius=12
     CollisionHeight=14
}
