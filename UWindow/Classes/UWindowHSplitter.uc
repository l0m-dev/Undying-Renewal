//=============================================================================
// UWindowHSplitter - a horizontal splitter component
//=============================================================================
class UWindowHSplitter extends UWindowWindow;

var UWindowWindow			LeftClientWindow;
var UWindowWindow			RightClientWindow;
var bool					bSizing;
var float					SplitPos;
var float					MinWinWidth;
var float					OldWinWidth;
var float					MaxSplitPos;
var bool					bRightGrow;
var bool					bSizable;

function Created() 
{
	Super.Created();
	bAlwaysBehind = True;
	SplitPos = WinWidth / 2;
	MinWinWidth = 24*Root.ScaleY;

	OldWinWidth = WinWidth;
}

function Paint(Canvas C, float X, float Y) 
{
	local Texture T;

	T = GetLookAndFeelTexture();
	DrawUpBevel(C, SplitPos, 0, 7*Root.ScaleY, WinHeight, T);
}

function BeforePaint(Canvas C, float X, float Y) 
{
	local float NewW, NewH;

	// Make Left panel resize
	if(OldWinWidth != WinWidth && !bRightGrow)
	{
		SplitPos = SplitPos + WinWidth - OldWinWidth;
	}

	SplitPos = FClamp(SplitPos, MinWinWidth, WinWidth - 7*Root.ScaleY - MinWinWidth);
	if(MaxSplitPos != 0)
		SplitPos = FClamp(SplitPos, 0, MaxSplitPos);

	NewW = SplitPos;
	NewH = WinHeight;
	
	if(NewH != LeftClientWindow.WinHeight || NewW != LeftClientWindow.WinWidth)
	{
		LeftClientWindow.SetSize(NewW, NewH);
	}

	LeftClientWindow.WinTop = 0;
	LeftClientWindow.WinLeft = 0;

	NewW = WinWidth - SplitPos - 7*Root.ScaleY;

	if(NewH != RightClientWindow.WinHeight || NewW != RightClientWindow.WinWidth)
	{
		RightClientWindow.SetSize(NewW, NewH);
	}
	RightClientWindow.WinTop = 0;
	RightClientWindow.WinLeft = SplitPos + 7*Root.ScaleY;
	

	OldWinWidth = WinWidth;
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);

	if(bSizable && (X >= SplitPos) && (X <= SplitPos + 7*Root.ScaleY)) 
	{
		bSizing = True;
		Root.CaptureMouse();
	}
}

function MouseMove(float X, float Y)
{

	if(bSizable && (X >= SplitPos) && (X <= SplitPos + 7*Root.ScaleY)) 
		Cursor = Root.HSplitCursor;
	else
		Cursor = Root.DefaultNormalCursor;

	if(bSizing && bMouseDown)
	{
		SplitPos = X;
	} else bSizing = False;
}

defaultproperties
{
     bSizable=True
}
