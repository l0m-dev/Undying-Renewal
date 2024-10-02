//=============================================================================
// AdvCreateGameWindow.
//=============================================================================
class AdvCreateGameWindow extends UWindowDialogClientWindow;

var UMenuPageControl Pages;
var UWindowSmallCloseButton CloseButton;

var AdvCreateGameGeneralPage GameplayPage;

var localized string ServerTab;
var UWindowPageControlPage Network;

var string StatusBarText;

function UWindowPageControlPage AddScrollPage(string Caption, class<UWindowDialogClientWindow> ClientClass)
{
	local UWindowPageControlPage Tab;

	class'UWindow.UWindowScrollingDialogClient'.default.ClientClass = ClientClass;
	Tab = Pages.AddPage(Caption, class'UWindow.UWindowScrollingDialogClient');
	class'UWindow.UWindowScrollingDialogClient'.default.ClientClass = None;

	return Tab;
}

function Created() 
{
	bLeaveOnScreen = True; // if it can be shown in game
	//bAlwaysOnTop = True;

	Cursor = Root.DefaultNormalCursor;
	
	Pages = UMenuPageControl(CreateWindow(class'UMenuPageControl', 0, 0, 1, 1));
	Pages.SetMultiLine(True);

	GameplayPage = AdvCreateGameGeneralPage(UWindowScrollingDialogClient(AddScrollPage(class'RenewalWindow'.default.GameplayTab, class'AdvCreateGameGeneralPage').Page).ClientArea);
	AddScrollPage(ServerTab, class'AdvCreateGameServerPage');

	CloseButton = UWindowSmallCloseButton(CreateControl(class'UWindowSmallCloseButton', 0, 0, 1, 1));
	
	Resized();

	Super.Created();
}

function ToolTip(string strTip) 
{
	StatusBarText = strTip;
}

function Resized()
{
	SetSize(300 * Root.ScaleY, 200 * Root.ScaleY);
	WinLeft = Root.WinWidth - WinWidth - 100 * Root.ScaleY;
	WinTop = 100 * Root.ScaleY;

	Pages.SetSize(WinWidth, WinHeight - 24*Root.ScaleY);	// OK, Cancel area

	CloseButton.SetSize(48*Root.ScaleY, 16*Root.ScaleY);
	CloseButton.WinLeft = WinWidth-52*Root.ScaleY;
	CloseButton.WinTop = WinHeight-20*Root.ScaleY;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture T;

	T = GetLookAndFeelTexture();
	DrawUpBevel( C, 0, LookAndFeel.TabUnselectedM.H*Root.ScaleY, WinWidth, WinHeight-LookAndFeel.TabUnselectedM.H*Root.ScaleY, T);

	C.Font = Root.Fonts[F_Normal];
	C.DrawColor.r = 0;
	C.DrawColor.g = 0;
	C.DrawColor.b = 0;

	ClipTextWidth(C, 6*Root.ScaleY, WinHeight - 20*Root.ScaleY, StatusBarText, WinWidth - 11*Root.ScaleY);

	C.DrawColor.r = 255;
	C.DrawColor.g = 255;
	C.DrawColor.b = 255;
}

function GetDesiredDimensions(out float W, out float H)
{	
	Super(UWindowWindow).GetDesiredDimensions(W, H);
	H += 30*Root.ScaleY;
}


function ShowWindow()
{
	Super.ShowWindow();
	BringToFront();
	FocusWindow();
}

function Close(optional bool bByParent)
{
	HideWindow();
}

defaultproperties
{
     ServerTab="Server"
}
