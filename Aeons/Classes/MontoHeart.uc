//=============================================================================
// MontoHeart. 
//=============================================================================
class MontoHeart expands Items;

//#exec MESH IMPORT MESH=MontoHeart_m SKELFILE=MontoHeart.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=133
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You picked up a Monto Heart"
     PickupViewMesh=SkelMesh'Aeons.Meshes.MontoHeart_m'
     PickupViewScale=2
     Icon=Texture'Aeons.Icons.MontoHeart_Icon'
     Mesh=SkelMesh'Aeons.Meshes.MontoHeart_m'
     DrawScale=2
     CollisionRadius=24
     CollisionHeight=26
}
