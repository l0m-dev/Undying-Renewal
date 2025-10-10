//=============================================================================
// PowderOfSiren.
//=============================================================================
class PowderOfSiren expands Items;

//#exec MESH IMPORT MESH=powderOfSiren_m SKELFILE=PowderSiren.ngf
//// #exec TEXTURE IMPORT NAME=PowderOfSiren_Icon FILE=PowderOfSiren_Icon.PCX GROUP=Icons FLAGS=2

var particleFX effect;
var PowderOfSiren_proj pSiren;

function createPowder()
{
	local vector spawnLoc;

	if ( Owner != none )
	{
		spawnLoc = Pawn(Owner).Location + ( Vector(Pawn(Owner).ViewRotation) * 48);
		pSiren = spawn(class 'PowderOfSiren_proj',Pawn(Owner),,spawnLoc);
	} else {
		log("No Owner");
	}
}

state Activated
{
	function Activate()
	{
		if ( (Pawn(Owner) != None) )
		{
			createPowder();
			numCopies --;
		}

		if ( numCopies < 0 )
		{
			SelectNext();
			Pawn(Owner).DeleteInventory(self);
		}
		Super.Activate();
	}
	Begin:
		Activate();
}

state Deactivated
{
	Begin:
}

defaultproperties
{
     bCanHaveMultipleCopies=True
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=107
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You gained a Powder of the Siren"
     ItemName="PowderOfSiren"
     PickupViewMesh=SkelMesh'Aeons.Meshes.powderOfSiren_m'
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_PowderPU01'
     Icon=Texture'Aeons.Icons.SirenPowder_Icon'
     Mesh=SkelMesh'Aeons.Meshes.powderOfSiren_m'
     CollisionRadius=8
     CollisionHeight=12
}
