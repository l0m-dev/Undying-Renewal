//=============================================================================
// Items.
//=============================================================================
class Items expands Pickup;

#exec OBJ LOAD FILE=..\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

function PreBeginPlay()
{
	Super.PreBeginPlay();
	if (self.class.name == 'Items')
		Destroy();
}

simulated function Inventory SelectNext()
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
     M_Activated=""
     M_Selected=""
     M_Deactivated=""
     Physics=PHYS_Falling
}
