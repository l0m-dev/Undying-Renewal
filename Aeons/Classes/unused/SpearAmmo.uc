//=============================================================================
// SpearAmmo.
//=============================================================================
class SpearAmmo expands Ammo;

#exec MESH IMPORT MESH=spearBundle_m SKELFILE=spearBundle.ngf
#exec MESH IMPORT MESH=spearAmmo_m SKELFILE=spearBundle.ngf
#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

defaultproperties
{
     AmmoAmount=4
     MaxAmmo=20
     bAmbientGlow=False
     PickupMessage="You picked up some spears"
     PickupViewMesh=SkelMesh'Aeons.Meshes.spearBundle_m'
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_SpearAmmoPU01'
     Physics=PHYS_Falling
     Mesh=SkelMesh'Aeons.Meshes.spearAmmo_m'
     AmbientGlow=0
     CollisionRadius=32
     CollisionHeight=4
}
