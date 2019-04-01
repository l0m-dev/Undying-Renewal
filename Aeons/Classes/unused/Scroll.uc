//=============================================================================
// Scroll. 
//=============================================================================
class Scroll expands Items;

#exec MESH IMPORT MESH=Scroll_m SKELFILE=Scroll.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=135
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You picked up a Scroll"
     ItemName="Scroll"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Scroll_m'
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_ScrollPU01'
     Icon=Texture'Aeons.Icons.Scroll_Icon'
     Mesh=SkelMesh'Aeons.Meshes.Scroll_m'
     DrawScale=2
     CollisionRadius=8
}
