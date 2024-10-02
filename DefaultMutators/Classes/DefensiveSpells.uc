class DefensiveSpells extends Mutator
	transient;

function ModifyPlayer(Pawn Other)
{
	local AeonsPlayer AP;
	local Spell newSpell;
	
	AP = AeonsPlayer(Other);

	if (AP != None)
	{
		AP.bDrawStealth = true;

		if (AP.Inventory.FindItemInGroup(class'Aeons.Mindshatter'.default.InventoryGroup) == none)
		{
			newSpell = Spawn(class'Aeons.Mindshatter');
			if( newSpell != None )
			{
				newSpell.GiveTo(AP);
				newSpell.LocalCastingLevel = 4;
				newSpell.CastingLevel = 4;
			}
		}

		if (AP.Inventory.FindItemInGroup(class'Aeons.PowerWord'.default.InventoryGroup) == none)
		{
			newSpell = Spawn(class'Aeons.PowerWord');
			if( newSpell != None )
			{
				newSpell.GiveTo(AP);
				newSpell.LocalCastingLevel = 4;
				newSpell.CastingLevel = 4;
			}
		}

		if (AP.Inventory.FindItemInGroup(class'Aeons.Ward'.default.InventoryGroup) == none)
		{
			newSpell = Spawn(class'Aeons.Ward');
			if( newSpell != None )
			{
				newSpell.GiveTo(AP);
				newSpell.LocalCastingLevel = 4;
				newSpell.CastingLevel = 4;
			}
		}

		if (AP.Inventory.FindItemInGroup(class'Aeons.Firefly'.default.InventoryGroup) == none)
		{
			newSpell = Spawn(class'Aeons.Firefly');
			if( newSpell != None )
			{
				newSpell.GiveTo(AP);
				newSpell.LocalCastingLevel = 4;
				newSpell.CastingLevel = 4;
			}
		}

		if (AP.Inventory.FindItemInGroup(class'Aeons.IncantationOfSilence'.default.InventoryGroup) == none)
		{
			newSpell = Spawn(class'Aeons.IncantationOfSilence');
			if( newSpell != None )
			{
				newSpell.GiveTo(AP);
				newSpell.LocalCastingLevel = 4;
				newSpell.CastingLevel = 4;
			}
		}

		if (AP.Inventory.FindItemInGroup(class'Aeons.Phase'.default.InventoryGroup) == none)
		{
			newSpell = Spawn(class'Aeons.Phase');
			if( newSpell != None )
			{
				newSpell.GiveTo(AP);
				newSpell.LocalCastingLevel = 4;
				newSpell.CastingLevel = 4;
			}
		}

		if (AP.Inventory.FindItemInGroup(class'Aeons.ShalasVortex'.default.InventoryGroup) == none)
		{
			newSpell = Spawn(class'Aeons.ShalasVortex');
			if( newSpell != None )
			{
				newSpell.GiveTo(AP);
				newSpell.LocalCastingLevel = 4;
				newSpell.CastingLevel = 4;
			}
		}
	}

	Super.ModifyPlayer(Other);
}