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

auto state Pickup
{	
	function Touch( actor Other )
	{
		local Inventory Copy;
		if ( ValidTouch(Other) ) 
		{
			Copy = SpawnCopy(Pawn(Other));
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
			if (bActivatable && Pawn(Other).SelectedItem==None) 
				Pawn(Other).SelectedItem=Copy;
			if (bActivatable && bAutoActivate && Pawn(Other).bAutoActivate) Copy.Activate();
			if ( PickupMessageClass == None )
				Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
			else
				Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
			PlaySound (PickupSound,,2.0);	
			Pickup(Copy).PickupFunction(Pawn(Other));
			efxA.Shutdown();
			efxB.Shutdown();
		}
	}

	function Trigger( Actor Other, Pawn EventInstigator )
	{
		local PlayerPawn P;
		
		ForEach AllActors(class 'PlayerPawn', P)
		{
			break;
		}

		if ( p!= none )
			Touch(P);
	}

	function BeginState()
	{
		Super.BeginState();
		NumCopies = 0;
	}
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
