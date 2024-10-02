//=============================================================================
// ArcaneWhorls.
//=============================================================================
class ArcaneWhorls expands Items;

//#exec MESH IMPORT MESH=arcaneWhorls_m SKELFILE=arcaneWhorls_m.ngf
//#exec TEXTURE IMPORT NAME=ArcaneWhorls_Icon FILE=ArcaneWhorls_Icon.PCX GROUP=Icons FLAGS=2

var ManaModifier mMod;
var AeonsPlayer Player;
var() sound GiveSound;
var ParticleFX fx;
var ArcaneWhorlFX HandFX;

replication
{
	unreliable if (Role == ROLE_Authority)
		ClientGiveArcaneWhorls;
}

function BeginPlay()
{
	Super.BeginPlay();
	// fx = Spawn(class 'ActiveEtherTrapFX',,,Location, Rotator(vect(0,0,1)));
}

auto state Pickup
{	
	// Validate touch, and if valid trigger event.
	function bool ValidTouch( actor Other )
	{
		local Actor A;

		if (Other.IsA('AeonsPlayer') && Pawn(Other).bIsPlayer && (Pawn(Other).Health > 0))
		{
			if( Event != '' )
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( Other, Other.Instigator );
			return true;
		}
		return false;
	}

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
			Player = AeonsPlayer(Other);
			ClientGiveArcaneWhorls(Player);
			GotoState('GiveWhorl');
		}
	}

	function BeginState()
	{
		Super.BeginState();
		// NumCopies = 0;
	}
}

state GiveWhorl
{

	Begin:
		if (Level.NetMode != NM_DedicatedServer)
		{
			HandFX = spawn(class 'ArcaneWhorlFX', Player.AttSpell,,Location);
			HandFX.SetPlayer(Player);
			Player.OverlayActor = HandFX;
			// fx.Shutdown();
		}
		PlaySound(GiveSound);
		AttSpell(Player.AttSpell).PlayOneshotAnim('ArcaneWhorl', 1.0);
		mMod = ManaModifier(Player.ManaMod);
		mMod.manaPerSec += 1;
		mMod.updateManaTimer();
		Player.ManaWhorlsFound = Clamp(Player.ManaWhorlsFound+1, 0, 5);
		Player.AttSpell.SetTexture(1, AeonsSpell(Player.AttSpell).SpellHandTextures[Player.ManaWhorlsFound-1]);
		sleep(2.5);
		if (Level.NetMode != NM_DedicatedServer)
		{
			HandFX.Shutdown();
			Player.OverlayActor = none;
		}
		Destroy();
}

simulated function ClientGiveArcaneWhorls(AeonsPlayer aPlayer)
{
	if (Level.NetMode != NM_Client)
		return;
		
	Player = aPlayer;
	GotoState('ClientGiveWhorl');
}

simulated state ClientGiveWhorl
{

	Begin:
		HandFX = spawn(class 'ArcaneWhorlFX', Player.AttSpell,,Location);
		HandFX.SetPlayer(Player);
		Player.OverlayActor = HandFX;
		Player.AttSpell.SetTexture(1, AeonsSpell(Player.AttSpell).SpellHandTextures[Player.ManaWhorlsFound-1]);
		sleep(2.5);
		HandFX.Shutdown();
		Player.OverlayActor = none;
}

defaultproperties
{
     GiveSound=Sound'Wpn_Spl_Inv.Inventory.I_ArchWhrlUse01'
     bCanHaveMultipleCopies=True
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=104
     PickupMessage="You discovered an Arcane Whorl"
     ItemName="ArcaneWhorls"
     PlayerViewOffset=(X=-4,Y=10,Z=-2.5)
     PlayerViewScale=0.1
     PickupViewMesh=SkelMesh'Aeons.Meshes.translocation_m'
     PickupViewScale=0.35
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_ArcWhrlPU01'
     Icon=Texture'Aeons.Icons.ArcaneWhorls_Icon'
     Mesh=SkelMesh'Aeons.Meshes.translocation_m'
     DrawScale=0.35
}
