//=============================================================================
// InventoryGenerator.
//=============================================================================
class InventoryGenerator expands Generator;

#exec TEXTURE IMPORT FILE=InventoryGenerator.pcx GROUP=System Mips=On

var() class<Inventory> 	InvClasses[8];		// classes of inventory I can 
var() float				DistWts[8];			// weights for distribution
var() int 				NumInvClasses;		// number of inventory classes

function class<Inventory> PickedUp()
{
	local float Decision, f;
	local int i, InvIdx;
	

	if ( NumInvClasses > 0 )
	{
		return InvClasses[Rand(NumInvClasses)];

/*		Decision = FRand();
		
		for ( i=0; i<NumInvClasses; i++ )
		{
			if ( DistWts[i] < (Decision + f) )
			{
				InvIdx = i;
				break;
			} else {
				f += DistWts[i];
			}
		}
*/
	}
	return none;
}

defaultproperties
{
     Texture=Texture'Aeons.System.InventoryGenerator'
}
