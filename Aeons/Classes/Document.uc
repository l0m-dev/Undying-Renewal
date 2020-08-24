//=============================================================================
// Document.
//=============================================================================
class Document expands Items;
//#exec MESH IMPORT MESH=Document_m SKELFILE=Document.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=140
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You picked up a Document"
     ItemName="Document"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Document_m'
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_LetterPU01'
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Document_m'
     CollisionRadius=16
     CollisionHeight=6
}
