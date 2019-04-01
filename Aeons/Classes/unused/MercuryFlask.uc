//=============================================================================
// MercuryFlask.
//=============================================================================
class MercuryFlask expands Items;
#exec MESH IMPORT MESH=MercuryFlask_m SKELFILE=MercuryFlask.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=124
     bActivatable=True
     bDisplayableInv=True
     bAmbientGlow=False
     PickupMessage="You found a Mercury Flask and the Monastery Key"
     ItemName="Mercury Flask"
     PickupViewMesh=SkelMesh'Aeons.Meshes.MercuryFlask_m'
     PickupViewScale=0.5
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_GlassPU01'
     Icon=Texture'Aeons.Icons.Flask_Icon'
     Mesh=SkelMesh'Aeons.Meshes.MercuryFlask_m'
     DrawScale=0.5
     AmbientGlow=0
     CollisionRadius=16
     CollisionHeight=16
}
