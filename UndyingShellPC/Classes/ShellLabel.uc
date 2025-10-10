//=============================================================================
// ShellLabel - A label 
//=============================================================================
class ShellLabel extends ShellComponent;

var bool bScrollingText;
var float ScrollingOffsetX, MaxScrollX, ScrollDir, ScrollDelay;

const SCROLL_SPEED = 40.0f;
const SCROLL_DELAY = 2.0f;

function Created()
{
	TextX = 0;
	TextY = 0;
}

function ResetScroll()
{
	ScrollingOffsetX = 0;
	ScrollDir = 1.0;
	ScrollDelay = SCROLL_DELAY;
}

function SetText(string NewText)
{
	Super.SetText(NewText);

	ResetScroll();
}

function ManagerResized(float ScaleX, float ScaleY)
{
	Super.ManagerResized(ScaleX, ScaleY);
	
	ResetScroll();
}

function Paint(Canvas C, float X, float Y)
{
	local float W, H;
	
	Super.Paint(C, X, Y);
	
	C.Font = Root.Fonts[Font];

	TextSize(C, Text, W, H);

	bScrollingText = (W >= WinWidth);
	
	TextY = (WinHeight - H) / 2;
	switch (Align)
	{
		case TA_Left:
			break;
		case TA_Center:
			TextX = (WinWidth - W)/2;
			break;
		case TA_Right:
			TextX = WinWidth - W;
			break;
	}	

	if (bScrollingText)
	{
		MaxScrollX = W - WinWidth;
		TextX = -ScrollingOffsetX;
	}

	if(Text != "")
	{
		C.DrawColor = TextColor;
		C.Font = Root.Fonts[Font];
		C.Style = TextStyle;
		C.bNoSmooth = false;
		ClipText(C, TextX, TextY, Text);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}

	C.Style = 1;
}

function Tick(float Delta) 
{
	if ( bScrollingText )
	{
		if ( ScrollDelay > 0 )
		{
			ScrollDelay -= Delta;
		}
		else
		{
			ScrollingOffsetX = ScrollingOffsetX + SCROLL_SPEED*Root.ScaleY*Delta*ScrollDir;
			if ( ScrollingOffsetX > MaxScrollX )
			{
				ScrollingOffsetX = MaxScrollX;
				ScrollDir = -1;
				ScrollDelay = SCROLL_DELAY;
			}
			else if ( ScrollingOffsetX < 0 )
			{
				ScrollingOffsetX = 0;
				ScrollDir = 1;
				ScrollDelay = SCROLL_DELAY;
			}
		}
	}
}

defaultproperties
{
}
