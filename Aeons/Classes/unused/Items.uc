//=============================================================================
// Items.
//=============================================================================
class Items expands Pickup;

#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

function PreBeginPlay()
{
	Super.PreBeginPlay();
	if (self.class.name == 'Items')
		Destroy();
}

function Inventory SelectNext()
{
	if ( bActivatable ) 
	{
		return self;
	}
	if ( Inventory != None )
		return Inventory.SelectNext();
	else
		return None;
}

defaultproperties
{
     Physics=PHYS_Falling
}
