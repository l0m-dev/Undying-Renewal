//=============================================================================
// EnergyKey.
//=============================================================================
class EnergyKey expands Keys;

var ParticleFX efxA, efxB, efxC;

function PostBeginPlay()
{
	super.PostBeginPlay();
	if ( Owner == None )
	{
		efxA = spawn(Class'Aeons.FireFlyTrailFX',,,Location);
		efxA.SetBase(self);
		efxB = spawn(Class'Aeons.FireFlyTrailFliesFX',,,Location);
		efxB.SetBase(self);
		efxC = spawn(Class'Aeons.FireFlyTrail_particles',,,Location);
		efxC.SetBase(self);
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
			efxA.bShuttingDown = true;
			efxB.bShuttingDown = true;
			efxC.bShuttingDown = true;
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
     InventoryGroup=173
     PickupMessage="You found an Energy Key"
     ItemName="Energy Key"
     PickupViewMesh=None
     PickupSound=Sound'LevelMechanics.Onieros.E09_PortalOut01'
     bHidden=True
     Texture=Texture'Aeons.Icons.Key_Icon'
     CollisionRadius=32
     CollisionHeight=32
}
