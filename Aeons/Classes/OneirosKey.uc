//=============================================================================
// OneirosKey.
//=============================================================================
class OneirosKey expands Keys;

var ParticleFX efxA, efxB;

function PostBeginPlay()
{
	super.PostBeginPlay();
	if (Owner == None)
	{
		efxA = spawn(Class'Aeons.Key1FX',,,Location);
		efxB = spawn(Class'Aeons.Key2FX',,,Location);
	}
}

function PickupFunction(Pawn Other)
{
	Super.PickupFunction(Other);
	
	efxA.Shutdown();
	efxB.Shutdown();
}

defaultproperties
{
     InventoryGroup=151
     PickupMessage="Snagged the Oneiros Key"
     ItemName="Oneiros Key"
     PickupViewMesh=None
     bHidden=True
     DrawType=DT_Sprite
     Texture=Texture'Aeons.Icons.Key_Icon'
     CollisionRadius=32
     CollisionHeight=32
}
