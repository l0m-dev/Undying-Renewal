//=============================================================================
// SleedSeed. 
//=============================================================================
class SleedSeed expands Items;

//#exec MESH IMPORT MESH=SleedSeed_m SKELFILE=SleedSeed.ngf

defaultproperties
{
     InventoryGroup=136
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You picked up a Sleed Seed"
     ItemName="Sleed Seed"
     PickupViewMesh=SkelMesh'Aeons.Meshes.SleedSeed_m'
     PickupViewScale=2
     Icon=Texture'Aeons.Icons.SleedSeed_Icon'
     Mesh=SkelMesh'Aeons.Meshes.SleedSeed_m'
     DrawScale=2
     CollisionRadius=12
     CollisionHeight=20
}
