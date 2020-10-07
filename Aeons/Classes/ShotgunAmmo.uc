//=============================================================================
// ShotgunAmmo.
//=============================================================================
class ShotgunAmmo expands Ammo;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv
//#exec MESH IMPORT MESH=ShotgunAmmo_m SKELFILE=ShotgunAmmo.ngf

// Pickup Sound
//#exec AUDIO IMPORT  FILE="I_ShotAmmoPU01.WAV" NAME="I_ShotAmmoPU01" GROUP="Inventory"

state Activated
{
	function Activate()
	{
		local AeonsWeapon wep;
		
		if (Pawn(Owner) != none)
		{
			wep = AeonsWeapon(Pawn(Owner).Weapon);
			if ( Wep.isA('Shotgun') )
			{
				if ( wep.bAltAmmo )
				{
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
		
}

defaultproperties
{
     AmmoAmount=12
     MaxAmmo=60
     UsedInWeaponSlot(5)=5
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=112
     bActivatable=True
     bDisplayableInv=True
     bActive=True
     bActiveToggle=True
     bAmbientGlow=False
     PickupMessage="You picked up shotgun shells"
     ItemName="Shotgun Ammo"
     PickupViewMesh=SkelMesh'Aeons.Meshes.ShotgunAmmo_m'
     PickupViewScale=0.5
     Charge=24
     PickupSound=Sound'Aeons.Inventory.I_ShotAmmoPU01'
     Icon=Texture'Aeons.Icons.Shells_Icon'
     Physics=PHYS_Falling
     Mesh=SkelMesh'Aeons.Meshes.ShotgunAmmo_m'
     DrawScale=0.5
     AmbientGlow=0
     CollisionRadius=12
     CollisionHeight=5
     bCollideActors=True
}
