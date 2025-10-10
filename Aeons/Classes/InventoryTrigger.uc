//=============================================================================
// InventoryTrigger.
//=============================================================================
class InventoryTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigInventory FILE=TrigInventory.pcx GROUP=System Mips=Off Flags=2

var() class<Inventory> InventoryType;
var() bool bDeleteInv;
var() bool bSelected;
var() sound	InvFoundSound;
var() sound	InvNotFoundSound;
var() name FailEvent;
var() localized string PrefixMsg;
var() localized string PrefixNeedMsg;
var() localized string TheString;
var() localized string AString;
var string Msg;
var AeonsPlayer Player;
var string ItemName;
var color TextColor;
var name InvClassName;

function bool DoInvCheck(actor Other)
{
	local Inventory Inv;
	local Actor A;

	InvClassName = InventoryType.name;
	
	if ( Other.isA('AeonsPlayer') && (InventoryType != none) )
	{
		/*
		if ( bSelected && !InventoryType.IsA('Keys') )
		{
			// Inventory we are checking for is the currently selected inventory item
			if ( AeonsPlayer(Other).SelectedItem.IsA(InventoryType.name) )
			{
				if ( bDeleteInv )
					AeonsPlayer(Other).DeleteInventory(AeonsPlayer(Other).SelectedItem);
				// AeonsPlayer(Other).ClientMessage("Inv found");

				if (InvFoundSound != none)
					PlaySound(InvFoundSound);

				return true;
			}
		} else {*/
			// Inventory we are checking for is contained within the players inventory.
			Inv = AeonsPlayer(Other).FindInventoryType(InventoryType);
			if ( Inv != None )
			{
				ItemName = Inv.ItemName;
				AeonsPlayer(Other).ClientMessage("Found Item - "$ItemName);

				if ( bDeleteInv )
					AeonsPlayer(Other).DeleteInventory(Inv);
				// AeonsPlayer(Other).ClientMessage("Inv found");

				if (InvFoundSound != none)
					PlaySound(InvFoundSound);

				return true;
			}
		//}
	}
	
	if (InvNotFoundSound != none)
		PlaySound(InvNotFoundSound);
	
	if (FailEvent != 'none')
	{
		ForEach AllActors (class 'Actor', A, FailEvent)
		{
			A.Trigger(self, none);
		}
	}

	return false;
}

function Touch( actor Other )
{
	local actor A;

	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		if ( Event != '' )
			if ( DoInvCheck(Other) )
			{
				if ( bTriggerOnceOnly )
					// Ignore future touches.
					SetCollision(False);
				foreach AllActors( class 'Actor', A, Event )
				{
					if ( A.IsA('Trigger') )
					{
						// handle Pass Thru message
						if ( Trigger(A).bPassThru )
						{
							Trigger(A).PassThru(Other);
						}
					}
					A.Trigger( Other, Other.Instigator );
				}
				Player = AeonsPlayer(Other);
				GotoState('Holding');
			}

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if( Message != "" && Level.bDebugMessaging)
			Other.Instigator.ClientMessage( Message );

		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);

	}
}

state Holding
{
	function BeginState()
	{
		local string str;

		if ( Player != none )
		{
			str = GetOverlayString();
			log("overlay string = "$str, 'Misc');
			Player.ScreenMessage(str, 3.0);
			GotoState('');
		}
	}

	function Timer(){}
	function Trigger(Actor Other, Pawn Instigator){}
	function Touch(Actor Other){}

	Begin:
		
}

function string GetOverlayString()
{
	local string str;

	switch ( InvClassName )
	{
		case 'AaronsRoomKey':
		case 'BethanyRoomKey':
		case 'BethanysGateKey':
		case 'JosephsRoomKey':
		case 'AaronsJaw':
			Msg = "";
			break;
		
		case 'Document':
			Msg = "a";
				break;

		case 'AbbotKey':
		case 'ChapelKey':
		case 'ChestKey':
		case 'EastWingKey':
		case 'EnergyKey':
		case 'GardenKey':
		case 'GoldKey':
		case 'KitchenKey':
		case 'LighthouseGateKey':
		case 'LockerKey':
		case 'MonasteryKey':
		case 'OneirosKey':
		case 'PriestKey':
		case 'SeaChestKey':
		case 'ServantKey':
		case 'SilverKey':
		case 'StudyKey':
		case 'TowerKey':
		case 'TrapdoorKey':
		case 'WidowsWatchKey':
		case 'WorkRoomKey':
		case 'GoldSun':
		case 'LightningRod':
		case 'MercuryFlask':
		case 'MistFlute':
		case 'MontoHeart':
		case 'ScarrowInk':
		case 'Sextant':
		case 'SleedSeed':
		case 'StalkerLure':
		case 'TimeIncantation':
		case 'TranslocationScroll':
			Msg = "the";
			break;

	}
	
	if ( Msg == "" )
		str = ""$PrefixMsg$" "$ItemName;
	else if (Msg == "the")
		str = ""$PrefixMsg$" "$TheString$" "$ItemName;
	else
		str = ""$PrefixMsg$" "$AString$" "$ItemName;

	return str;

	/*
	Canvas.SetPos(Canvas.ClipX * 0.4, Canvas.ClipY * 0.7 );
	Canvas.Font = Canvas.MedFont;
	// Canvas.Style = STY_Translucent;
	Canvas.DrawText( str, false );
	*/

}

defaultproperties
{
     PrefixMsg="You used"
     PrefixNeedMsg="You need"
     TheString="the"
     AString="a"
     TextColor=(R=255,G=255,B=255)
     Texture=Texture'Aeons.System.TrigInventory'
     DrawScale=0.5
}
