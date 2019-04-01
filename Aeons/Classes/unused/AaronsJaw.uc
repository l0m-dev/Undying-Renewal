//=============================================================================
// AaronsJaw.
//=============================================================================
class AaronsJaw expands Items;
#exec MESH IMPORT MESH=AaronsJaw_m SKELFILE=AaronsJaw.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=138
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You found Aaron's Room Key and Aaron's Jaw"
     ItemName="Aaron's Jaw"
     PickupViewMesh=SkelMesh'Aeons.Meshes.AaronsJaw_m'
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_AaronJawPU01'
     Icon=Texture'Aeons.Icons.PuzzlePiece_Icon'
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.AaronsJaw_m'
     DrawScale=2
     CollisionRadius=16
     CollisionHeight=10
}
