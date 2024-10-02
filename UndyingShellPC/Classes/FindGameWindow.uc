//=============================================================================
// FindGameWindow.
//=============================================================================
class FindGameWindow extends UBrowserMainWindow;

function Created()
{
	Super.Created();

	// make sure WindowShown event is called for PageControl and its pages
	// this is needed for UBrowserServerListWindow
	ShowWindow();
}

function Close(optional bool bByParent) 
{
	if(bStandaloneBrowser)
		Root.Console.CloseUWindow();
	else
		Super.Close(bByParent);

	if (!Root.bWindowVisible)
	{
		ParentWindow.Close();
		MainMenuWindow(AeonsRootWindow(Root).MainMenu).Close();
	}
}

function SetSizePos()
{
	if(Root.WinHeight < 400)
		SetSize(Root.WinWidth - 10, Root.WinHeight-32);
	else
		SetSize(Root.WinWidth - 10, Root.WinHeight-50);

	WinLeft = Int((Root.WinWidth - WinWidth) / 2);
	WinTop = Int((Root.WinHeight - WinHeight) / 2);

	MinWinHeight = WinHeight - 20;
}

function Resized()
{
	SetSizePos();
	Super.Resized();
}

defaultproperties
{
	WindowTitleString="Undying Server Browser"
}