//=============================================================================
// Sand.
//=============================================================================
class Sand expands Items;

var() class<ParticleFX> SandClass;

state Activated
{
	function Activate()
	{
		local Pawn PawnOwner;
		PawnOwner = Pawn(Owner);
		
		if ( (Pawn(Owner) != None) && (SandClass != none))
			spawn (SandClass,,,PawnOwner.Location + Vector(PawnOwner.ViewRotation) * 32, PawnOwner.ViewRotation);
	
		PlaySound(ActivateSound);
		Super.Activate();
		if ( numCopies < 0 )
		{
			SelectNext();
			// Pawn(Owner).DeleteInventory(self);
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
     SandClass=Class'Aeons.SandParticleFX'
     ItemType=ITEM_Inventory
     InventoryGroup=130
     bActivatable=True
     bDisplayableInv=True
     ItemName="Sand"
     Charge=20
}
