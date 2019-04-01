//=============================================================================
// GoldFlask.
//=============================================================================
class GoldFlask expands Items;
#exec MESH IMPORT MESH=GoldFlask_m SKELFILE=GoldFlask.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=123
     bActivatable=True
     bDisplayableInv=True
     bAmbientGlow=False
     PickupMessage="You picked up a Gold Flask."
     ItemName="Gold Flask"
     PickupViewMesh=SkelMesh'Aeons.Meshes.GoldFlask_m'
     PickupViewScale=0.5
     Icon=Texture'Aeons.Icons.Flask_Icon'
     Mesh=SkelMesh'Aeons.Meshes.GoldFlask_m'
     DrawScale=0.5
     AmbientGlow=0
     CollisionRadius=8
     CollisionHeight=16
}
