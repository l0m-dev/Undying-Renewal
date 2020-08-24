//=============================================================================
// ScarrowInk. 
//=============================================================================
class ScarrowInk expands Items;

//#exec MESH IMPORT MESH=ScarrowInk_m SKELFILE=ScarrowInk.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=134
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="This is Scarrow Ink"
     ItemName="Scarrow Ink"
     PickupViewMesh=SkelMesh'Aeons.Meshes.ScarrowInk_m'
     PickupViewScale=2
     Icon=Texture'Aeons.Icons.PuzzlePiece_Icon'
     Mesh=SkelMesh'Aeons.Meshes.ScarrowInk_m'
     DrawScale=2
     CollisionRadius=16
     CollisionHeight=24
     bCollideWorld=True
}
