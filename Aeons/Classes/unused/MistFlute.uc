//=============================================================================
// MistFlute. 
//=============================================================================
class MistFlute expands Items;

#exec MESH IMPORT MESH=MistFlute_m SKELFILE=MistFlute.ngf

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=144
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You picked up the Mist Flute"
     ItemName="Mist Flute"
     PickupViewMesh=SkelMesh'Aeons.Meshes.MistFlute_m'
     PickupViewScale=2
     Icon=Texture'Aeons.Icons.MistFlute_Icon'
     Mesh=SkelMesh'Aeons.Meshes.MistFlute_m'
     DrawScale=2
     CollisionRadius=8
     CollisionHeight=24
}
