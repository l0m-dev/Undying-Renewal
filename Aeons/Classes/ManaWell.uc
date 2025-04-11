//=============================================================================
// ManaWell.
//=============================================================================
class ManaWell expands Items;

//#exec MESH IMPORT MESH=manaWell_m SKELFILE=ManaWell.ngf
// #exec TEXTURE IMPORT NAME=ManaWell_Icon FILE=ManaWell_Icon.PCX GROUP=Icons FLAGS=2

var() int CapacityIncrease;

function PickupFunction(Pawn Other)
{
	Super.PickupFunction(Other);

	Other.AddManaCapacity(CapacityIncrease);
	Other.DeleteInventory(self);
}

defaultproperties
{
     CapacityIncrease=10
     bAutoActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=106
     bActivatable=True
     PickupMessage="You discovered a Mana Well"
     ItemName="ManaWell"
     PickupViewMesh=SkelMesh'Aeons.Meshes.manaWell_m'
     PickupViewScale=2
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_ManaWellPU01'
     Mesh=SkelMesh'Aeons.Meshes.manaWell_m'
     DrawScale=2
     CollisionRadius=16
     CollisionHeight=12
}
