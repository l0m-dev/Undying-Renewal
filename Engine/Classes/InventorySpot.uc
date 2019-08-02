//=============================================================================
// InventorySpot.
//=============================================================================
class InventorySpot extends NavigationPoint
	native;

var Inventory markedItem;

defaultproperties
{
     bEndPointOnly=True
     bHiddenEd=True
     bCollideWhenPlacing=False
     CollisionRadius=20
     CollisionHeight=40
}
