//=============================================================================
// OnScreenMessage.
//=============================================================================
class OnScreenMessage expands Info;

#exec TEXTURE IMPORT FILE=osm.pcx GROUP=System Mips=Off Flags=2

var AeonsPlayer Player;
var int i;
var float W, H, Wmax;
var() localized string Text[32];
var() color TextColor;
var() float DisplayTime;
var() float px, py;
var() bool FadeToBlack;
var() bool bHideHUD;

function Trigger ( Actor Other, Pawn Instigator )
{
	// log("Triggered  ......... ...........        ......................",'Misc');
	ForEach AllActors(class 'AeonsPlayer', Player)
	{
		break;
	}

	if ( Player != none )
		GotoState('Holding');
}

state Holding
{
	function BeginState()
	{
		if (Text[1] == "")
		{
			Player.ScreenMessage(Text[0], DisplayTime);
			GotoState('');
		} else {
			if ( FadeToBlack )
				Player.ClientAdjustGlow(-1.0,vect(0,0,0));

			// log("Found Player Too ...................",'Misc');
			Player.OverlayActor = self;
			SetTimer(DisplayTime, false);
		}
	}

	function Timer()
	{
		if ( FadeToBlack )
			Player.ClientAdjustGlow(1.0,vect(0,0,0));

		Player.OverlayActor = none;
		Player = none;
		GotoState('');
	}

	function Trigger(Actor Other, Pawn Instigator){}

	Begin:
		
}

function RenderOverlays(Canvas Canvas)
{
	// log ("Render Overlays .........");
	if ( Player != none )
	{
		// log("Canvas = "$Canvas$" Canvas Size = "$Canvas.ClipX$" x "$Canvas.ClipY, 'Misc');
		Canvas.DrawColor = TextColor;
		Canvas.Font = Canvas.MedFont;
		Canvas.Style = Style;
		// Canvas.Font = MyFont;
		
		// DAVE SAYS:  let's center the block of text based on the longest text line
		Wmax = 0;
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
		//Canvas.SetPos(Canvas.ClipX * px, Canvas.ClipY * py );
		Canvas.SetPos(px, Canvas.ClipY * py );

		for (i=0; i<32; i++)
		{
			Canvas.DrawText( Text[i], false );
			Canvas.SetPos(px, Canvas.CurY );
		}
	}
}

defaultproperties
{
     Text(0)="Message goes here"
     TextColor=(R=255,G=255,B=255)
     DisplayTime=10
     FadeToBlack=True
     Texture=Texture'Aeons.System.osm'
     DrawScale=0.5
}
