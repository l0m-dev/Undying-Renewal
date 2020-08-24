//=============================================================================
// Diary.
//=============================================================================
class Diary expands Items;

//#exec MESH IMPORT MESH=Diary_m SKELFILE=Diary.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=139
     bDisplayableInv=True
     PickupMessage="You picked up a Diary"
     ItemName="Diary"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Diary_m'
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Diary_m'
     CollisionRadius=10
     CollisionHeight=12
}
