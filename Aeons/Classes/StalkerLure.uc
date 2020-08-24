//=============================================================================
// StalkerLure. 
//=============================================================================
class StalkerLure expands Items;

//#exec MESH IMPORT MESH=StalkerLure_m SKELFILE=StalkerLure.ngf
//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=137
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="This is Stalker Lure"
     ItemName="Stalker Lure"
     PickupViewMesh=SkelMesh'Aeons.Meshes.StalkerLure_m'
     PickupViewScale=2
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_GlassPU01'
     Icon=Texture'Aeons.Icons.StalkerLure_Icon'
     Mesh=SkelMesh'Aeons.Meshes.StalkerLure_m'
     DrawScale=2
     CollisionRadius=8
     CollisionHeight=28
}
