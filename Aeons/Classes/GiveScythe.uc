//=============================================================================
// GiveScythe.
//=============================================================================
class GiveScythe expands Info;

function Trigger(Actor Other, Pawn Instigator)
{
	local AeonsPlayer P;
	local Weapon NewWeapon;

	ForEach AllActors (class 'AeonsPlayer', P)
	{
		break;
	}
	
	if (P != none)
	{
		if (P.Inventory.FindItemInGroup(class'Aeons.Scythe'.default.InventoryGroup) == none)
		{
			newWeapon = Spawn(class'Aeons.Scythe');
			if( newWeapon != None )
			{
				newWeapon.Instigator = P;
				newWeapon.BecomeItem();
				P.AddInventory(newWeapon);
				newWeapon.BringUp();
				newWeapon.GiveAmmo(P);
				newWeapon.SetSwitchPriority(P);
				newWeapon.WeaponSet(P);
			}
		}
	}
}

defaultproperties
{
}
