//=============================================================================
// OnScreenMessageModifier.
//=============================================================================
class OnScreenMessageModifier expands PlayerModifier;

var string DisplayedMessage;

function NewMessage(string Message, float HoldTime)
{
	DisplayedMessage = Message;
	SetTimer(HoldTime, false);
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
		Canvas.DrawColor.R = 125;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 125;
		Canvas.Font = Canvas.MedFont;
		Canvas.TextSize( DisplayedMessage, x, y );
		Canvas.SetPos(Canvas.ClipX * 0.5 - (x*0.5), Canvas.ClipY * 0.15 );
		Canvas.DrawText( DisplayedMessage, false );
	}
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
}
