//=============================================================================
// LightningRod.
//=============================================================================
class LightningRod expands Items;

//#exec MESH IMPORT MESH=LightningRod_m SKELFILE=LightningRod.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=142
     bDisplayableInv=True
     PickupMessage="You picked up a Lightning Rod"
     ItemName="Lightning Rod"
     PickupViewMesh=SkelMesh'Aeons.Meshes.LightningRod_m'
     Icon=Texture'Aeons.Icons.PuzzlePiece_Icon'
     Mesh=SkelMesh'Aeons.Meshes.LightningRod_m'
}
