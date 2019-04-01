//=============================================================================
// Sextant.
//=============================================================================
class Sextant expands Items;

#exec MESH IMPORT MESH=Sextant_m SKELFILE=Sextant.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=143
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You found a Sextant"
     ItemName="Sextant"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Sextant_m'
     PickupViewScale=2
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_GlassPU01'
     Icon=Texture'Aeons.Icons.PuzzlePiece_Icon'
     Mesh=SkelMesh'Aeons.Meshes.Sextant_m'
     DrawScale=2
     CollisionRadius=24
     CollisionHeight=8
}
