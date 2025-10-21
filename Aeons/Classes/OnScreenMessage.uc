//=============================================================================
// OnScreenMessage.
//=============================================================================
class OnScreenMessage expands Info;

//#exec TEXTURE IMPORT FILE=osm.pcx GROUP=System Mips=Off Flags=2

var AeonsPlayer Player;
var int i;
var float W, H, Wmax;
var() localized string Text[32];
var() color TextColor;
var() float DisplayTime;
var() float px, py;
var() bool FadeToBlack;
var() bool bHideHUD;
var() bool bCenterIndividualLines;

var localized string DoorWontOpenMessage;
var localized string GateWontOpenMessage;

function PreBeginPlay()
{
	if (Text[1] == "")
	{
		// basic common text localization
		// .default is also translated
		switch (Text[0])
		{
			case "This door will not open":
			case "DoorWontOpen":
				Text[0] = DoorWontOpenMessage;
				break;
			case "This gate will not open":
			case "GateWontOpen":
				Text[0] = GateWontOpenMessage;
				break;
		}
	}
	
	// todo: to replicate multi-line messages we need to replicate this actor and set bNoDelete=True
	// don't do this yet, perhaps we should instead combine the lines with Chr(13) $ Chr(10) and split them later
	/*
	if (Text[1] != "")
	{
		for (i=0; i<32; i++)
		{
			if (Text[i] != "")
				CombinedText = CombinedText $ Text[i] $ Chr(13) $ Chr(10);
		}
		bAlwaysRelevant = true;
		RemoteRole = ROLE_SimulatedProxy;
	}
	*/
} 

function Trigger ( Actor Other, Pawn Instigator )
{
	local InventoryTrigger InvTrig;
	local string SavedPrefix;
	local AeonsPlayer aPlayer;

	// log("Triggered  ......... ...........        ......................",'Misc');

	// extract message from InventoryTrigger so we don't need to translate this message
	InvTrig = InventoryTrigger(Other);
	if (class'Utility'.static.GetLanguage() != "int" && InvTrig != None && Text[1] == "" && InStr(Text[0], "You need ") == 0)
	{
		SavedPrefix = InvTrig.PrefixMsg;

		InvTrig.PrefixMsg = InvTrig.PrefixNeedMsg;
		InvTrig.InvClassName = InvTrig.InventoryType.name;
		InvTrig.ItemName = InvTrig.InventoryType.default.ItemName;
		Text[0] = InvTrig.GetOverlayString();

		InvTrig.PrefixMsg = SavedPrefix;
	}

	Player = AeonsPlayer(Instigator);

	if (Text[1] == "")
	{
		// single line text
		if( Player != None )
		{
			Player.ScreenMessage(Text[0], DisplayTime);
		}
		else
		{
			ForEach AllActors(class 'AeonsPlayer', aPlayer)
			{
				aPlayer.ScreenMessage(Text[0], DisplayTime);
			}
		}
	}
	else
	{
		// multi-line text
		GotoState('Holding');
	}
}

state Holding
{
	function BeginState()
	{
		local AeonsPlayer aPlayer;

		if( Player != None )
		{
			if ( FadeToBlack )
				Player.ClientAdjustGlow(-1.0,vect(0,0,0));

			// log("Found Player Too ...................",'Misc');
			Player.OverlayActor = self; // not replicated
		}
		else
		{
			ForEach AllActors(class 'AeonsPlayer', aPlayer)
			{
				if ( FadeToBlack )
					aPlayer.ClientAdjustGlow(-1.0,vect(0,0,0));

				// log("Found Player Too ...................",'Misc');
				aPlayer.OverlayActor = self; // not replicated
			}
		}

		SetTimer(DisplayTime, false);
	}

	function Timer()
	{
		local AeonsPlayer aPlayer;

		if( Player != None )
		{
			if ( FadeToBlack )
				Player.ClientAdjustGlow(1.0,vect(0,0,0));

			if ( Player.OverlayActor == self )
				Player.OverlayActor = none; // not replicated

			Player = none;
		}
		else
		{
			ForEach AllActors(class 'AeonsPlayer', aPlayer)
			{
				if ( FadeToBlack )
					aPlayer.ClientAdjustGlow(1.0,vect(0,0,0));

				if ( aPlayer.OverlayActor == self )
					aPlayer.OverlayActor = none; // not replicated
			}
		}

		GotoState('');
	}

	function Trigger(Actor Other, Pawn Instigator){}

	Begin:
		
}

// don't move to state yet since client actor won't be in that state
simulated function RenderOverlays(Canvas Canvas)
{
	// log ("Render Overlays .........");
	// log("Canvas = "$Canvas$" Canvas Size = "$Canvas.ClipX$" x "$Canvas.ClipY, 'Misc');
	Canvas.DrawColor = TextColor;
	Canvas.Font = Canvas.MedFont;
	Canvas.Style = Style;
	// Canvas.Font = MyFont;
	
	// DAVE SAYS:  let's center the block of text based on the longest text line
	Wmax = 0;
	
	if (!bCenterIndividualLines)
	{
		for (i=0; i<32; i++)
		{
			if ( Text[i] != "" )
			{
				Canvas.StrLen(Text[i], W, H);
				if ( W > Wmax )
					Wmax = W;
			}
		}
		px = (Canvas.ClipX - Wmax)/2;
	}
	else
	{
		Canvas.bCenter = true;
		px = 0;
	}
	
	//Canvas.SetPos(Canvas.ClipX * px, Canvas.ClipY * py );
	Canvas.SetPos(px, Canvas.ClipY * py );

	for (i=0; i<32; i++)
	{
		Canvas.DrawText( Text[i], false );
		Canvas.SetPos(px, Canvas.CurY );
	}
}

defaultproperties
{
     Text(0)="Message goes here"
     TextColor=(R=255,G=255,B=255)
     DisplayTime=10
     px=0.35
     py=0.70
     FadeToBlack=True
     Texture=Texture'Aeons.System.osm'
     DrawScale=0.5
     DoorWontOpenMessage="This door will not open"
     GateWontOpenMessage="This gate will not open"
}
