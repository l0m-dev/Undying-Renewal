//=============================================================================
// SilverBulletAmmo.
//=============================================================================
class SilverBulletAmmo expands BulletAmmo;

//#exec MESH IMPORT MESH=SilverBullets_m SKELFILE=SilverBullets.ngf

function PreBeginPlay()
{
	if (RGC())
	{
		AmmoAmount = 12;
		MaxAmmo = 96;
	}
	super.PreBeginPlay();
}

function PostBeginPlay()
{
	PickupViewMesh = SkelMesh'Aeons.Meshes.SilverBullets_m';
}

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
				if ( !wep.bAltAmmo )
				{
					// wep.AmmoType.AmmoAmount += wep.ClipCount;
					wep.ClipCount = 0;			// Empty the clip
					wep.bAltAmmo = true;		// Normal Ammo Type
					wep.AmmoType.GotoState('Deactivated');;
					wep.AmmoType = Ammo(Pawn(Owner).FindInventoryType(wep.AltAmmoName));
					wep.gotoState('NewClip');	// Load the New Clip
				}
				else
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

function PickupFunction(Pawn Other)
{
}

defaultproperties
{
     AmmoAmount=6
     MaxAmmo=60
     InventoryGroup=111
     bActive=False
     PickupMessage="You picked up silver bullets"
     ItemName="Silver Bullet Ammo"
     PlayerViewScale=3
     PickupViewMesh=SkelMesh'Aeons.Meshes.SilverBullets_m'
     PickupViewScale=3
     Charge=12
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_RevSilverAmmoPU1'
     Icon=Texture'Aeons.Icons.Bullet_Silver_Icon'
     Mesh=SkelMesh'Aeons.Meshes.SilverBullets_m'
     DrawScale=3
     CollisionRadius=8
}
