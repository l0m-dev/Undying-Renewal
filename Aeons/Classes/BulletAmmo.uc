//=============================================================================
// BulletAmmo.
//=============================================================================
class BulletAmmo expands Ammo;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

// #exec MESH IMPORT MESH=bulletammo_m SKELFILE=bulletammo_m.ngf
//#exec MESH IMPORT MESH=RevolverAmmo_m SKELFILE=RevolverAmmo.ngf

//#exec AUDIO IMPORT  FILE="I_RevAmmoPU01.WAV" NAME="I_RevAmmoPU01" GROUP="Inventory"

state Activated
{
	function Activate()
	{
		local AeonsWeapon wep;
		
		if (Pawn(Owner) != none)
		{
			wep = AeonsWeapon(Pawn(Owner).Weapon);
			if ( Wep.isA('Revolver') )
			{
				if ( wep.bAltAmmo )
				{
					bActive = true;
					// wep.AmmoType.AmmoAmount += wep.ClipCount;
					wep.ClipCount = 0;			// Empty the clip
					wep.bAltAmmo = false;		// Normal Ammo Type
					wep.AmmoType.bActive = false;
					wep.AmmoType = Ammo(Pawn(Owner).FindInventoryType(wep.AmmoName));
					wep.gotoState('NewClip');	// Load the New Clip
					bActive = true;
				}
			} else {
				Pawn(Owner).ClientMessage("Invalid ammo type for your currently selected weapon");
				/*
				if ( wep.AmmoType != self )
					bActive = false;
				else
					bActive = false;
				*/

			}
		}
	}
	
	Begin:
		Activate();
}

state Deactivated
{
	Begin:
		bActive = false;
		
}

function PickupFunction(Pawn Other)
{
}

defaultproperties
{
     AmmoAmount=24
     MaxAmmo=90
     UsedInWeaponSlot(4)=4
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=110
     bActivatable=True
     bDisplayableInv=True
     bActive=True
     bActiveToggle=True
     bAmbientGlow=False
     PickupMessage="You picked up bullets"
     ItemName="Bullet Ammo"
     PickupViewMesh=SkelMesh'Aeons.Meshes.RevolverAmmo_m'
     PickupViewScale=0.5
     PickupSound=Sound'Aeons.Inventory.I_RevAmmoPU01'
     Icon=Texture'Aeons.Icons.Bullet_Icon'
     Physics=PHYS_Falling
     Mesh=SkelMesh'Aeons.Meshes.RevolverAmmo_m'
     DrawScale=0.5
     AmbientGlow=0
     CollisionRadius=12
     CollisionHeight=5
     bCollideActors=True
}
