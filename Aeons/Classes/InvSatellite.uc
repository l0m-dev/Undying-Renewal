//=============================================================================
// InvSatellite.
//=============================================================================
class InvSatellite expands Info;

//#exec TEXTURE IMPORT FILE=InvSatellite.pcx GROUP=System Mips=On

var InventoryGenerator InvGen;
var() float RespawnTimer;
var Class<Inventory> NextSpawnClass;
var Inventory MyInv;

function PostBeginPlay()
{
	ForEach AllActors(class 'InventoryGenerator', InvGen)
	{
		if ( InvGen.Event == Tag )
			break;
		else
			InvGen = none;
	}

	if ( InvGen == none )
		Destroy();

	NextSpawnClass = InvGen.PickedUp();

	if ( NextSpawnClass != none )
	{
		MyInv = Spawn(NextSpawnClass,self,,Location);
		MyInv.SetCollision(false, false);
	}
}

function Touch(Actor Other)
{
	// log("MyInv = "$MyInv$" MyInv.Owner = "$MyInv.Owner, 'Misc');
	if ( MyInv.Owner == self )
	{
		if ( Other.IsA('PlayerPawn') )
		{
			MyInv.bHeldItem = true;
			MyInv.GiveTo(PlayerPawn(Other));
			NextSpawnClass = InvGen.PickedUp();
			SetTimer( RespawnTimer, true );
		}
	}
}

function Timer()
{
	// log("MyInv = "$MyInv$" MyInv.Owner = "$MyInv.Owner, 'Misc');
	if ( (NextSpawnClass != none) && MyInv.Owner != self )
	{
		MyInv = Spawn(NextSpawnClass,self,,Location);
		MyInv.SetCollision(false, false);
	}

}

defaultproperties
{
     Texture=Texture'Aeons.System.InvSatellite'
     CollisionRadius=32
     CollisionHeight=32
     bCollideActors=True
}
