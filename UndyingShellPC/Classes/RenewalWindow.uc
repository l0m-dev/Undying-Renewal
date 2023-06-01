class RenewalWindow extends UWindowFramedWindow;

var float OldParentWidth, OldParentHeight;

function Created() 
{
	Super.Created();
	bSizable = True;
	bStatusBar = True;
	bLeaveOnScreen = False;
	bAlwaysOnTop = True;
	
	//Root.Console.bBlackout = True; // if true the window position is reset when window is shown
	
	OldParentWidth = ParentWindow.WinWidth;
	OldParentHeight = ParentWindow.WinHeight;

	SetDimensions();

	SetAcceptsFocus();
	FocusWindow();
}

function ShowWindow()
{
	Super.ShowWindow();
	BringToFront();

	if(ParentWindow.WinWidth != OldParentWidth || ParentWindow.WinHeight != OldParentHeight)
	{
		SetDimensions();
		OldParentWidth = ParentWindow.WinWidth;
		OldParentHeight = ParentWindow.WinHeight;
	}
	FocusWindow();
	ClientArea.ShowWindow();
}

function HideWindow()
{
	//Root.Console.bBlackOut = False;
	Super.HideWindow();
}

function ResolutionChanged(float W, float H)
{
	SetDimensions();
}

function SetDimensions()
{
	if (ParentWindow.WinWidth < 500)
	{
		SetSize(200, 150);
	} else {
		SetSize(410, 310);
	}
	WinLeft = ParentWindow.WinWidth/2 - WinWidth/2;
	WinTop = ParentWindow.WinHeight/2 - WinHeight/2;
}

function Close(optional bool bByParent)
{
	//ClientArea.Close(True);
	//HideWindow();
	//Super.Close();
	HideWindow();
	//if(Root.Console.bQuickKeyEnable)
	//	Root.Console.CloseUWindow();
}

defaultproperties
{
     ClientClass=Class'UndyingShellPC.RenewalSettingsPage'
     WindowTitle="Renewal Menu"
}
