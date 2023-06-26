class Lantern extends Mutator;

function Timer()
{
	local AeonsPlayer aPlayer;
	local Items newItem;
	
	Super.Timer();

	foreach AllActors(class'AeonsPlayer', aPlayer)
	{
		if (aPlayer.Inventory.FindItemInGroup(class'Aeons.Lantern'.default.InventoryGroup) == none)
		{
			newItem = Spawn(class'Aeons.Lantern',,,aPlayer.Location);
			if( newItem != None )
			{
				newItem.GiveTo(aPlayer);
				newItem.setBase(aPlayer);
			}
		}
	}
}

function PostBeginPlay()
{
	SetTimer(1.5, false);
}