//=============================================================================
// PhosphorusShellAmmo.
//=============================================================================
class PhosphorusShellAmmo expands ShotgunAmmo;

//#exec MESH IMPORT MESH=PhosShells_m SKELFILE=PhosphorusShells.ngf

function PreBeginPlay()
{
	if (RGC())
	{
		AmmoAmount = 6;
		MaxAmmo = 30;
	}
	super.PreBeginPlay();
}

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
				if ( !wep.bAltAmmo )
				{
					// wep.AmmoType.AmmoAmount += wep.ClipCount;
					wep.ClipCount = 0;			// Empty the clip
					wep.bAltAmmo = true;		// Normal Ammo Type
					wep.AmmoType.GotoState('Deactivated');
					wep.AmmoType = Ammo(Pawn(Owner).FindInventoryType(wep.AltAmmoName));
					wep.gotoState('NewClip');	// Load the New Clip
				}
				else if ( wep.ClipCount == 1 )
				{
					wep.Reload();
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

defaultproperties
{
     AmmoAmount=4
     MaxAmmo=20
     InventoryGroup=113
     bActive=False
     PickupMessage="You picked up phosphorus shells"
     ItemName="Phosphorus Shells"
     PickupViewMesh=SkelMesh'Aeons.Meshes.PhosShells_m'
     PickupViewScale=1.5
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_ShotPhosAmmoPU1'
     Icon=Texture'Aeons.Icons.Shells_Phos_Icon'
     Physics=PHYS_None
     Mesh=SkelMesh'Aeons.Meshes.PhosShells_m'
     DrawScale=1.5
     CollisionRadius=8
}
