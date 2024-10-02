class Lantern extends Mutator
	transient;

function ModifyPlayer(Pawn Other)
{
	local AeonsPlayer AP;
	local Items newItem;

	AP = AeonsPlayer(Other);

	if (AP != None)
	{
		if (AP.FindInventoryType(class'Aeons.Lantern') == none)
		{
			newItem = Spawn(class'Aeons.Lantern',,,AP.Location);
			if( newItem != None )
			{
				newItem.GiveTo(AP);
				newItem.setBase(AP);
			}
		}
	}

	Super.ModifyPlayer(Other);
}