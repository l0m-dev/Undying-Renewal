//=============================================================================
// EtherTrap.
//=============================================================================
class EtherTrap expands Items;

var() localized string FailMessage;

function Activate()
{
	gotoState('Activated');
}

state Activated
{
	function Activate()
	{
		local vector x, y, z, targetLoc;
		local Actor A;
				
		if ( PlayerPawn(Owner) != None )
		{
			Pawn(Owner).GetAxes(PlayerPawn(Owner).ViewRotation, x, y, z);

			targetLoc = PlayerPawn(Owner).Location + (X * 64);
			if ((Level.GetZone(TargetLoc) == 0) || !(FastTrace(Owner.Location, TargetLoc)))
			{
				AeonsPlayer(Owner).ScreenMessage(FailMessage, 3.0);
				return;
			}

			Owner.PlaySound(ActivateSound);
			A = Spawn(class 'EtherTrapTrigger',,,TargetLoc ); //, Rotator(vect(0,0,1)));

			if (A != none)
			{
				numcopies--;
				if ( numCopies < 0 )
				{
					SelectNext();
					Pawn(Owner).DeleteInventory(self);
				}
			} else {
				AeonsPlayer(Owner).ScreenMessage(FailMessage, 3.0);
			}
		}
	
		Super.Activate();
		if ( numCopies < 0 )
		{
			SelectNext();
			Pawn(Owner).DeleteInventory(self);
		}
		gotoState('Deactivated');
	}	
	
	Begin:
		Activate();
}


state Deactivated
{
	
	Begin:
		bActive = false;
		// Pawn(Owner).selectedItem = none;
	
}

defaultproperties
{
     FailMessage="Ether Trap won't fit here"
     bCanHaveMultipleCopies=True
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=109
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You gained an Ether Trap"
     PickupViewMesh=SkelMesh'Aeons.Meshes.EtherTrap_m'
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_EtherTrapPU01'
     ActivateSound=Sound'Wpn_Spl_Inv.Inventory.I_EtherTrapUse01'
     Icon=Texture'Aeons.Icons.EtherTrap_Icon'
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.EtherTrap_m'
     CollisionRadius=16
     CollisionHeight=4
}
