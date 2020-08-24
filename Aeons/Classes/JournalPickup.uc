//=============================================================================
// JournalPickup.
//=============================================================================
class JournalPickup expands Pickup;

//#exec OBJ LOAD FILE=\aeons\sounds\LevelMechanics.uax PACKAGE=LevelMechanics
//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var() class<JournalEntry>	JournalClass;
var() bool					bShowImmediate; // whether or not to bring up book on pickup
var() Sound JournalWritingSound;	// scribble sound to indicate journal has been written to
var() bool bPlayWritingSound;

/*
     PickupSound=Sound'Aeons.Weapons.E_Wpn_GenPck01'
     Physics=PHYS_Falling
*/
//=============================================================================
// Pickup state: this inventory item is sitting on the ground.

event StartLevel()
{
	local PlayerPawn Player;
	
	ForEach AllActors(class 'PlayerPawn', Player)
	{
		break;
	}

	if ( ItemName == "" )
		ItemName = GetItemName(string(Class));

	if ( ConditionalEvent != 'none' )
		if ( Player.CheckGameEvent(ConditionalEvent) )
			Destroy();
	
	Super.StartLevel();
}

auto state Pickup
{
	singular function ZoneChange( ZoneInfo NewZone )
	{
		local float splashsize;
		local actor splash;

		if( NewZone.bWaterZone && !Region.Zone.bWaterZone ) 
		{
			splashSize = 0.000025 * Mass * (250 - 0.5 * Velocity.Z);
			if ( NewZone.EntrySound != None )
				PlaySound(NewZone.EntrySound, SLOT_Interact, splashSize);
			if ( NewZone.EntryActor != None )
			{
				splash = Spawn(NewZone.EntryActor); 
				if ( splash != None )
					splash.DrawScale = 2 * splashSize;
			}
		}
	}

	// Validate touch, and if valid trigger event.
	function bool ValidTouch( actor Other )
	{
		local Actor A;

		if ( ConditionalEvent != 'none' )
		{
			if ( Other.IsA('PlayerPawn') )
				PlayerPawn(Other).CheckGameEvent(ConditionalEvent, true);
		}

		if( Other.bIsPawn && Pawn(Other).bIsPlayer && (Pawn(Other).Health > 0) && Level.Game.PickupQuery(Pawn(Other), self) )
		{
			if( Event != '' )
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( Other, Other.Instigator );
			return true;
		}

		return false;
	}
		
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		local PlayerPawn P;

		// if journal pickup was triggered, let's not do the usual pickup sound
		PickupSound = None;
		
		ForEach AllActors(class 'PlayerPawn', P)
		{
			break;
		}

		if ( p!= none )
			Touch(P);
	}

	// When touched by an actor.
	function Touch( actor Other )
	{
		// If touched by a player pawn, let him pick this up.
		if( ValidTouch(Other) )
		{
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
			//SpawnCopy(Pawn(Other));
			if ( PickupMessageClass == None )
				Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
			else
				Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );

			Other.PlaySound (PickupSound);

			// show the book with our Entry
			if ( AeonsPlayer(Other) != None )
			{
				AeonsPlayer(Other).GiveJournal(JournalClass, bShowImmediate);
				if ( bPlayWritingSound )
					Other.PlaySound (JournalWritingSound, [Volume] 1.5);
			}

			//if ( Level.Game.Difficulty > 1 )
			//	Other.MakeNoise(0.1 * Level.Game.Difficulty);
			//if ( Pawn(Other).MoveTarget == self )
			//	Pawn(Other).MoveTimer = -1.0;		

			Destroy();
		}
		//else if ( bTossedOut && (Other.Class == Class)
		//		&& Inventory(Other).bTossedOut )
		//		Destroy();
	}

	// Landed on ground.
	function Landed(Vector HitNormal)
	{
		local rotator newRot;
		newRot = Rotation;
		newRot.pitch = 0;
		SetRotation(newRot);
		SetTimer(2.0, false);
	}

	// Make sure no pawn already touching (while touch was disabled in sleep).
	function CheckTouching()
	{
		local int i;

		bSleepTouch = false;
		for ( i=0; i<8; i++ )
			if ( (Touching[i] != None) && Touching[i].IsA('Pawn') )
				Touch(Touching[i]);
	}

	function Timer()
	{
		if ( RemoteRole != ROLE_SimulatedProxy )
		{
			NetPriority = 1.4;
			RemoteRole = ROLE_SimulatedProxy;
			if ( bHeldItem )
			{
				if ( bTossedOut )
					SetTimer(15.0, false);
				else
					SetTimer(40.0, false);
			}
			return;
		}

		if ( bHeldItem )
		{
			if (  (FRand() < 0.1) || !PlayerCanSeeMe() )
				Destroy();
			else
				SetTimer(3.0, true);
		}
	}

	function BeginState()
	{
		BecomePickup();
		bCollideWorld = true;
		if ( bHeldItem )
			SetTimer(30, false);
		else if ( Level.bStartup )
		{
			bAlwaysRelevant = true;
			NetUpdateFrequency = 8;
		}
	}

	function EndState()
	{
		bCollideWorld = false;
		bSleepTouch = false;
	}

Begin:
	BecomePickup();
	if ( bRotatingPickup && (Physics != PHYS_Falling) )
		SetPhysics(PHYS_Rotating);

Dropped:
	if( bAmbientGlow )
		AmbientGlow=255;
	if( bSleepTouch )
		CheckTouching();
}



function bool HandlePickupQuery( inventory Item )
{
	if ( Inventory == None )
		return false;

	//return Inventory.HandlePickupQuery(Item);
}

defaultproperties
{
     JournalWritingSound=Sound'LevelMechanics.MonasteryPast.A01_QuillWriting2'
     bPlayWritingSound=True
     ItemType=ITEM_Inventory
     InventoryGroup=200
     bAmbientGlow=False
     PickupMessage="New Journal Entry"
     ItemName="JournalPickup"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Journal_m'
     MaxDesireability=0
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_BookPU01'
     Mesh=SkelMesh'Aeons.Meshes.Journal_m'
     DrawScale=0.5
     AmbientGlow=0
     CollisionRadius=16
     CollisionHeight=16
}
