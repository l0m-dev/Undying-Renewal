//=============================================================================
// Pickup items.
//=============================================================================
class Pickup extends Inventory
	abstract
	native
	nativereplication;

var inventory Inv;
var savable travel int NumCopies;
var() bool bCanHaveMultipleCopies;  // if player can possess more than one of this
var() bool bCanActivate;			// Item can be selected and activated
var() localized String ExpireMessage; // Messages shown when pickup charge runs out
var() bool bAutoActivate;

replication
{
	// Things the server should send to the client.
	reliable if( bNetOwner && (Role==ROLE_Authority) )
		NumCopies;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	PickupMessage = default.PickupMessage;
}

function TravelPostAccept()
{
	Super.TravelPostAccept();
	PickupFunction(Pawn(Owner));
}

//
// Advanced function which lets existing items in a pawn's inventory
// prevent the pawn from picking something up. Return true to abort pickup
// or if item handles the pickup
function bool HandlePickupQuery( inventory Item )
{
	if ( item.IsA(self.class.name) )
	{
		if (bCanHaveMultipleCopies) 
		{   // for items like Artifact
			NumCopies++;
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
			if ( Item.PickupMessageClass == None )
				Pawn(Owner).ClientMessage(item.PickupMessage, 'Pickup');
			else
				Pawn(Owner).ReceiveLocalizedMessage( item.PickupMessageClass, 0, None, None, item.Class );
			Item.PlaySound (Item.PickupSound,,2.0);
			Item.SetRespawn();
			AmbientSound = none;
		}
		else if ( bDisplayableInv ) 
		{		
			if ( Charge<Item.Charge )	
				Charge= Item.Charge;
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
			if ( Item.PickupMessageClass == None )
				Pawn(Owner).ClientMessage(item.PickupMessage, 'Pickup');
			else
				Pawn(Owner).ReceiveLocalizedMessage( item.PickupMessageClass, 0, None, None, item.Class );
			Item.PlaySound (item.PickupSound,,2.0);
			Item.SetReSpawn();
			AmbientSound = none;
		}
		return true;				
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

function float UseCharge(float Amount);

function inventory SpawnCopy( pawn Other )
{
	local inventory Copy;

	Copy = Super.SpawnCopy(Other);
	Copy.Charge = Charge;
	return Copy;
}

auto state Pickup
{	
		// Validate touch, and if valid trigger event.
	/* km - this is causing double pickups of items
	
	function bool ValidTouch( actor Other )
	{
		local bool isPlayer, retval;
		
		isPlayer = Other.bIsPawn && Pawn(Other).bIsPlayer && (Pawn(Other).Health > 0);

		retval = isPlayer && Level.Game.PickupQuery(Pawn(Other), self);
	
		if( retval || (isPlayer && (((Pawn(Other).Inventory != none) && Pawn(Other).Inventory.HandlePickupQuery( self )) && bCanHaveMultipleCopies)) )
			SendEvents( Other );

		return retval;
	}*/

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
			AmbientSound = none;
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

function PickupFunction(Pawn Other)
{
	SetOwner(Other);
}

//
// This is called when a usable inventory item has used up it's charge.
//
function UsedUp()
{
	if ( Pawn(Owner) != None )
	{
		bActivatable = false;
		Pawn(Owner).NextItem();
		if (Pawn(Owner).SelectedItem == Self) {
			Pawn(Owner).NextItem();	
			if (Pawn(Owner).SelectedItem == Self) Pawn(Owner).SelectedItem=None;
		}
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogItemDeactivate(Self, Pawn(Owner));
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogItemDeactivate(Self, Pawn(Owner));
		if ( ItemMessageClass != None )
			Pawn(Owner).ReceiveLocalizedMessage( ItemMessageClass, 0, None, None, Self.Class );
		else
			Pawn(Owner).ClientMessage(ExpireMessage);	
	}
	Owner.PlaySound(DeactivateSound);
	Destroy();
}


state Activated
{
	function Activate()
	{
		if ( (Pawn(Owner) != None) && Pawn(Owner).bAutoActivate 
			&& bAutoActivate && (Charge>0) )
				return;

		Super.Activate();	
	}
}

defaultproperties
{
     bRotatingPickup=False
     bSavable=True
     ShadowImportance=0.5
     bGroundMesh=False
}
