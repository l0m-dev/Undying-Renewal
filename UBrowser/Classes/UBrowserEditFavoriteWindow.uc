class UBrowserEditFavoriteWindow expands UWindowFramedWindow;

var UWindowSmallCloseButton CloseButton;
var UWindowSmallButton OKButton;
var localized string OKText;

function Created()
{
	Super.Created();

	OKButton = UWindowSmallButton(CreateWindow(class'UWindowSmallButton', WinWidth-108, WinHeight-24, 48, 16));
	CloseButton = UWindowSmallCloseButton(CreateWindow(class'UWindowSmallCloseButton', WinWidth-56, WinHeight-24, 48, 16));
	OKButton.Register(UBrowserEditFavoriteCW(ClientArea));
	OKButton.SetText(OKText);
	SetSizePos();
}

function ResolutionChanged(float W, float H)
{
	Super.ResolutionChanged(W, H);
	SetSizePos();
}

function SetSizePos()
{
	SetSize(FMin(Root.WinWidth-20*Root.ScaleY, 400*Root.ScaleY), 160*Root.ScaleY);

	WinLeft = Int((Root.WinWidth - WinWidth) / 2);
	WinTop = Int((Root.WinHeight - WinHeight) / 2);
}

function Resized()
{
	Super.Resized();
	ClientArea.SetSize(ClientArea.WinWidth, ClientArea.WinHeight-24*Root.ScaleY);
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);

	SetSizePos();

	OKButton.WinLeft = ClientArea.WinLeft+ClientArea.WinWidth-104*Root.ScaleY;
	OKButton.WinTop = ClientArea.WinTop+ClientArea.WinHeight+4*Root.ScaleY;
	OKButton.WinWidth = 48*Root.ScaleY;
	CloseButton.WinLeft = ClientArea.WinLeft+ClientArea.WinWidth-52*Root.ScaleY;
	CloseButton.WinTop = ClientArea.WinTop+ClientArea.WinHeight+4*Root.ScaleY;
	CloseButton.WinWidth = 48*Root.ScaleY;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture T;

	T = GetLookAndFeelTexture();
	DrawUpBevel( C, ClientArea.WinLeft, ClientArea.WinTop + ClientArea.WinHeight, ClientArea.WinWidth, 24*Root.ScaleY, T);

	Super.Paint(C, X, Y);
}

defaultproperties
{
     OKText="OK"
     ClientClass=Class'UBrowser.UBrowserEditFavoriteCW'
     WindowTitle="Edit Favorite"
}
