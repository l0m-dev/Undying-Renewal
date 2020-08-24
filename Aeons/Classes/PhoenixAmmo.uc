//=============================================================================
// PhoenixAmmo.
//=============================================================================
class PhoenixAmmo expands Ammo;

//#exec MESH IMPORT MESH=PhoenixAmmo_m SKELFILE=PheonixEgg.ngf

defaultproperties
{
     AmmoAmount=1
     MaxAmmo=10
     UsedInWeaponSlot(7)=7
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=117
     bAmbientGlow=False
     PickupMessage="You picked up a Phoenix Egg"
     ItemName="Phoenix Ammo"
     PickupViewMesh=SkelMesh'Aeons.Meshes.PhoenixAmmo_m'
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_PhoenixAmmoPU01'
     Physics=PHYS_Falling
     Mesh=SkelMesh'Aeons.Meshes.PhoenixAmmo_m'
     AmbientGlow=0
     CollisionRadius=12
     CollisionHeight=5
     bCollideActors=True
}
