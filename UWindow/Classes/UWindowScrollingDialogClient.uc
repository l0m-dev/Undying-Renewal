class UWindowScrollingDialogClient extends UWindowPageWindow;

var bool bShowHorizSB;
var bool bShowVertSB;

var UWindowDialogClientWindow	ClientArea;
var UWindowDialogClientWindow	FixedArea;
var class<UWindowDialogClientWindow> ClientClass;
var class<UWindowDialogClientWindow> FixedAreaClass;

var UWindowVScrollBar VertSB;
var UWindowHScrollBar HorizSB;
var UWindowBitmap	  BRBitmap;

function Created()
{
	Super.Created();

	if(FixedAreaClass != None)
	{
		FixedArea = UWindowDialogClientWindow(CreateWindow(FixedAreaClass, 0, 0, 100, 100, OwnerWindow));
		FixedArea.bAlwaysOnTop = True;
	}
	else
		FixedArea = None;

	ClientArea = UWindowDialogClientWindow(CreateWindow(ClientClass, 0, 0, WinWidth, WinHeight, OwnerWindow));

	VertSB = UWindowVScrollbar(CreateWindow(class'UWindowVScrollbar', WinWidth-12, 0, 12, WinHeight));
	VertSB.bAlwaysOnTop = True;
	VertSB.HideWindow();

	HorizSB = UWindowHScrollbar(CreateWindow(class'UWindowHScrollbar', 0, WinHeight-12, WinWidth, 12));
	HorizSB.bAlwaysOnTop = True;
	HorizSB.HideWindow();

	BRBitmap = UWindowBitmap(CreateWindow(class'UWindowBitmap', WinWidth-12, WinHeight-12, 12, 12));
	BRBitmap.bAlwaysOnTop = True;
	BRBitmap.HideWindow();
	BRBitmap.bStretch = True;
}


function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{
	if (ClientArea.AllowScroll())
	{
		switch(Msg)
		{
		case WM_KeyDown:
			switch(Key)
			{
			case Root.Console.EInputKey.IK_Up:
			case Root.Console.EInputKey.IK_MWheelUp:
				VertSB.Scroll(-20);
				break;
			case Root.Console.EInputKey.IK_Down:
			case Root.Console.EInputKey.IK_MWheelDown:
				VertSB.Scroll(20);
				break;
			case Root.Console.EInputKey.IK_PageUp:
				VertSB.Scroll(-(VertSB.MaxVisible-1));
				break;
			case Root.Console.EInputKey.IK_PageDown:
				VertSB.Scroll(VertSB.MaxVisible-1);
				break;
			}
			break;
		}
	}

	Super.WindowEvent(Msg, C, X, Y, Key);
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float ClientWidth, ClientHeight;
	local float FixedHeight;
	local float ScaledScrollbarWidth;


	if(FixedArea != None)
		FixedHeight = FixedArea.WinHeight;
	else
		FixedHeight = 0;

	ClientWidth = ClientArea.DesiredWidth;
	ClientHeight = ClientArea.DesiredHeight;

	if(ClientWidth <= WinWidth)
		ClientWidth = WinWidth;

	if(ClientHeight <= WinHeight - FixedHeight)
		ClientHeight = WinHeight - FixedHeight;

	ClientArea.SetSize(ClientWidth, ClientHeight);

	bShowVertSB = (ClientHeight > WinHeight - FixedHeight);
	bShowHorizSB = (ClientWidth > WinWidth);

	ScaledScrollbarWidth = LookAndFeel.Size_ScrollbarWidth*Root.ScaleY;

	if(bShowHorizSB)
	{
		// re-examine need for vertical SB now we've got smaller client area.

		ClientHeight = ClientArea.DesiredHeight;

		if(ClientHeight <= WinHeight - ScaledScrollbarWidth - FixedHeight)
			ClientHeight = WinHeight - ScaledScrollbarWidth - FixedHeight;

		bShowVertSB = (ClientHeight > WinHeight - ScaledScrollbarWidth - FixedHeight);
	}

	if(bShowVertSB)
	{
		VertSB.ShowWindow();
		VertSB.WinTop = 0;
		VertSB.WinLeft = WinWidth - ScaledScrollbarWidth;
		VertSB.WinWidth = ScaledScrollbarWidth;
		if(bShowHorizSB) 
		{
			BRBitmap.ShowWindow();
			BRBitmap.WinWidth = ScaledScrollbarWidth;
			BRBitmap.WinHeight = ScaledScrollbarWidth;
			BRBitmap.WinTop = WinHeight - ScaledScrollbarWidth - FixedHeight;
			BRBitmap.WinLeft = WinWidth - ScaledScrollbarWidth;

			BRBitmap.T = GetLookAndFeelTexture();
			//BRBitmap.R = LookAndFeel.SBBackground;

			VertSB.WinHeight = WinHeight - ScaledScrollbarWidth - FixedHeight;
		}
		else
		{
			BRBitmap.HideWindow();
			VertSB.WinHeight = WinHeight - FixedHeight;
		}

		VertSB.SetRange(0, ClientHeight, VertSB.WinHeight, 10);	
	}
	else
	{
		BRBitmap.HideWindow();
		VertSB.HideWindow();
		VertSB.Pos = 0;		
	}

	if(bShowHorizSB)
	{
		HorizSB.ShowWindow();
		HorizSB.WinLeft = 0;
		HorizSB.WinTop = WinHeight - ScaledScrollbarWidth - FixedHeight;
		HorizSB.WinHeight = ScaledScrollbarWidth;
		if(bShowVertSB)
			HorizSB.WinWidth = WinWidth - ScaledScrollbarWidth;
		else
			HorizSB.WinWidth = WinWidth;

		HorizSB.SetRange(0, ClientWidth, HorizSB.WinWidth, 10);	
	}
	else
	{
		HorizSB.HideWindow();
		HorizSB.Pos = 0;		
	}

	ClientArea.WinLeft = -HorizSB.Pos;
	ClientArea.WinTop = -VertSB.Pos;

	if(FixedArea != None)
	{
		FixedArea.WinLeft = 0;
		FixedArea.WinTop = WinHeight - FixedHeight;
		if(FixedArea.WinWidth != WinWidth)
			FixedArea.SetSize(WinWidth, FixedArea.WinHeight);
	}

	Super.BeforePaint(C, X, Y);
}

function GetDesiredDimensions(out float W, out float H)
{	
	Super(UWindowWindow).GetDesiredDimensions(W, H);
}

function Paint(Canvas C, float X, float Y)
{
}

defaultproperties
{
     ClientClass=Class'UWindow.UWindowDialogClientWindow'
}
