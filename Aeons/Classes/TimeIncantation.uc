//=============================================================================
// TimeIncantation.
//=============================================================================
class TimeIncantation expands Items;

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=125
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You found the Time Incantation and a Silver Key"
     ItemName="Time Incantation"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Document_m'
     PickupViewScale=2
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_ScrollPU01'
     Icon=Texture'Aeons.Icons.PuzzlePiece_Icon'
     Mesh=SkelMesh'Aeons.Meshes.Document_m'
     DrawScale=2
     bMRM=False
     CollisionHeight=8
}
