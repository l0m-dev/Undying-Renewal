//=============================================================================
// ManaWell.
//=============================================================================
class ManaWell expands Items;

//#exec MESH IMPORT MESH=manaWell_m SKELFILE=ManaWell.ngf
// #exec TEXTURE IMPORT NAME=ManaWell_Icon FILE=ManaWell_Icon.PCX GROUP=Icons FLAGS=2

var() int CapacityIncrease;

auto state Pickup
{	
	function Touch( actor Other )
	{
		local Inventory Copy;
		if ( ValidTouch(Other) ) 
		{
			Copy = SpawnCopy(Pawn(Other));
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
			if (bActivatable && Pawn(Other).SelectedItem==None) 
				Pawn(Other).SelectedItem=Copy;
			if (bActivatable && bAutoActivate && Pawn(Other).bAutoActivate) Copy.Activate();
			if ( PickupMessageClass == None )
				Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
			else
				Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
			PlaySound (PickupSound,,2.0);	
			Pickup(Copy).PickupFunction(Pawn(Other));

			Pawn(Other).AddManaCapacity(CapacityIncrease);
			Pawn(Other).DeleteInventory(self);
		}
	}

	function BeginState()
	{
		Super.BeginState();
		NumCopies = 0;
	}
}

defaultproperties
{
     CapacityIncrease=10
     bAutoActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=106
     bActivatable=True
     PickupMessage="You discovered a Mana Well"
     ItemName="ManaWell"
     PickupViewMesh=SkelMesh'Aeons.Meshes.manaWell_m'
     PickupViewScale=2
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_ManaWellPU01'
     Mesh=SkelMesh'Aeons.Meshes.manaWell_m'
     DrawScale=2
     CollisionRadius=16
     CollisionHeight=12
}
