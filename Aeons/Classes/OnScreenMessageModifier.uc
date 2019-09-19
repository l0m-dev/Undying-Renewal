//=============================================================================
// OnScreenMessageModifier.
//=============================================================================
class OnScreenMessageModifier expands PlayerModifier;

var string DisplayedMessage;
var bool bServerMessage;

function NewMessage(string Message, float HoldTime, optional bool bFromServer)
{
	DisplayedMessage = Message;
	SetTimer(HoldTime, false);
	
	bServerMessage = bFromServer;
}

function Timer()
{
	ClearMessage();
}

function ClearMessage()
{
	DisplayedMessage = "";
}

simulated event RenderOverlays( canvas Canvas )
{
	local float x, y;

	if (DisplayedMessage != "")
	{	
		Canvas.Font = Canvas.MedFont;
		Canvas.TextSize( DisplayedMessage, x, y );
		if ( bServerMessage )
		{
			Canvas.DrawColor.R = 125;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 125;
			Canvas.SetPos(Canvas.ClipX * 0.5 - (x*0.5), Canvas.ClipY * 0.15 );
		} else {
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
			Canvas.SetPos(Canvas.ClipX * 0.5 - (x*0.5), Canvas.ClipY * 0.75 );
		}
		Canvas.DrawText( DisplayedMessage, false );
	}
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
}
