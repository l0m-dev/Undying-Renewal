//=============================================================================
// UBrowserRootWindow - root window subclass for UnrealBrowser
//=============================================================================
class FindGameWindow extends UWindowRootWindow;

var	UBrowserMainWindow MainWindow;


function Created()
{
	Super.Created();
	
	MainWindow = UBrowserMainWindow(CreateWindow(class'UBrowserMainWindow', 0, 0, 1600, 900));
	MainWindow.bStandaloneBrowser = True;
	MainWindow.WindowTitle = "Undying Browser";
	Resized();
}


function Resized()
{
	Super.Resized();
	
	MainWindow.SetSize(WinWidth, WinHeight);

	MainWindow.WinLeft = 0;
	MainWindow.WinTop = 0;
}

defaultproperties
{
     LookAndFeelClass="UMenu.UMenuMetalLookAndFeel"
}