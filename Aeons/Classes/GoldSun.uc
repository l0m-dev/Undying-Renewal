//=============================================================================
// GoldSun.
//=============================================================================
class GoldSun expands Items;
//#exec MESH IMPORT MESH=GoldSun_m SKELFILE=GoldSun.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=141
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You found a Chest Key and the Sun Medallion"
     ItemName="Sun Medallion"
     PickupViewMesh=SkelMesh'Aeons.Meshes.GoldSun_m'
     PickupViewScale=2
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_GoldPU01'
     Icon=Texture'Aeons.Icons.PuzzlePiece_Icon'
     Mesh=SkelMesh'Aeons.Meshes.GoldSun_m'
     DrawScale=2
     CollisionRadius=8
     CollisionHeight=20
     bCollideWorld=True
}
