class UMenuTempClientWindow extends UWindowDialogClientWindow
	config;

var UWindowWrappedTextArea T;

function Created() 
{
	local Color C;

	T = UWindowWrappedTextArea(CreateWindow(class'UWindowWrappedTextArea', 0, 0, WinWidth, WinHeight));
	T.SetFont(F_Normal);

	C.R = 255;
	C.G = 255;
	C.B = 255;
	T.SetTextColor(C);

	T.AddText("Hello World.  This is a test.  Wow amazing");
	T.AddText(" eh.  This is a test.  Wow amazing"$Chr(13)$"well I'm thrilled, hope you are ");
	T.AddText("Hello World.  This is a test.  Wow amazing");
	T.AddText(" eh.  This is a test.  Wow amazing"$Chr(13)$"well I'm thrilled, hope you are ");
	T.AddText("Hello World.  This is a test.  Wow amazing");
	T.AddText(" eh.  This is a test.  Wow amazing"$Chr(13)$"well I'm thrilled, hope you are ");
	T.AddText("Hello World.  This is a test.  Wow amazing");
	T.AddText(" eh.  This is a test.  Wow amazing"$Chr(13)$"well I'm thrilled, hope you are ");
	T.AddText("Hello World.  This is a test.  Wow amazing");
	T.AddText(" eh.  This is a test.  Wow amazing"$Chr(13)$"well I'm thrilled, hope you are ");
	T.AddText("Hello World.  This is a test.  Wow amazing");
	T.AddText(" eh.  This is a test.  Wow amazing"$Chr(13)$"well I'm thrilled, hope you are ");
	T.AddText("Hello World.  This is a test.  Wow amazing");
	T.AddText(" eh.  This is a test.  Wow amazing"$Chr(13)$"well I'm thrilled, hope you are ");
	T.AddText("Hello World.  This is a test.  Wow amazing");
	T.AddText(" eh.  This is a test.  Wow amazing"$Chr(13)$"well I'm thrilled, hope you are ");

	Super.Created();
}

function Resized()
{
	T.WinWidth = WinWidth;
	T.WinHeight = WinHeight;
}

function Paint(Canvas C, float X, float Y)
{
	Tile(C, Texture'Background');
}

defaultproperties
{
}
