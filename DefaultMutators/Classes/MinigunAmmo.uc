//=============================================================================
// MinigunAmmo.
//=============================================================================
class MinigunAmmo expands Ammo;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

#exec MESH IMPORT MESH=MinigunAmmo_m SKELFILE=Minigun\MinigunAmmo.ngf

#exec AUDIO IMPORT FILE="Minigun\I_MinigunAmmoPU1.WAV" NAME="I_MinigunAmmoPU1" GROUP="Inventory"

#exec Texture Import File=Minigun\MinigunBullets_Icon.bmp	Group=Icons Mips=Off

auto state Pickup
{
     function Landed(Vector HitNormal)
     {
          Super.Landed(HitNormal);
          if ( bRotatingPickup )
		     SetPhysics(PHYS_Rotating);
     }
}

function PickupFunction(Pawn Other)
{
}

defaultproperties
{
     AmmoAmount=50
     MaxAmmo=500
     UsedInWeaponSlot(4)=4
     bCanActivate=False
     ItemType=ITEM_Inventory
     InventoryGroup=118
     bActivatable=True
     bDisplayableInv=True
     bActive=True
     bActiveToggle=True
     bAmbientGlow=False
     PickupMessage="You picked up bullets"
     ItemName="Minigun Ammo"
     PickupViewMesh=SkelMesh'Aeons.Meshes.MinigunAmmo_m'
     PickupViewScale=1
     PickupSound=Sound'Aeons.Inventory.I_MinigunAmmoPU1'
     Icon=Texture'Aeons.Icons.MinigunBullets_Icon'
     Physics=PHYS_Falling
     Mesh=SkelMesh'Aeons.Meshes.MinigunAmmo_m'
     DrawScale=1
     AmbientGlow=0
     CollisionRadius=32
     CollisionHeight=32
     bCollideActors=True
     RotationRate=(Yaw=5000)
     DesiredRotation=(Yaw=30000)
     bRotatingPickup=True
     bFixedRotationDir=True
}
