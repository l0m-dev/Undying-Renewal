//=============================================================================
// PSX2CreditsWindow.
//=============================================================================
class PSX2CreditsWindow expands ShellWindow;

//#exec Texture Import File=PSX2Credits_0.bmp Mips=Off
//#exec Texture Import File=PSX2Credits_1.bmp Mips=Off
//#exec Texture Import File=PSX2Credits_2.bmp Mips=Off
//#exec Texture Import File=PSX2Credits_3.bmp Mips=Off
//#exec Texture Import File=PSX2Credits_4.bmp Mips=Off
//#exec Texture Import File=PSX2Credits_5.bmp Mips=Off

//----------------------------------------------------------------------------

var ShellButton PCCreditsButton;

var int		SmokingWindows;
var float	SmokingTimers;

//----------------------------------------------------------------------------

function Created()
{

	local int i;
	local color TextColor;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Created();
	
	AeonsRoot = AeonsRootWindow(Root);

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}

	RootScaleX = AeonsRoot.ScaleX;
	RootScaleY = AeonsRoot.ScaleY;
	//--

	SmokingWindows = -1;

	PCCreditsButton = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	PCCreditsButton.Template = NewRegion(665,520,88,51);

	PCCreditsButton.TexCoords = NewRegion(0,0,88,51);

	PCCreditsButton.Manager = Self;
	PCCreditsButton.Style = 5;

	PCCreditsButton.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	PCCreditsButton.UpTexture =   texture'Book_Left_up';
	PCCreditsButton.DownTexture = texture'Book_Left_dn';
	PCCreditsButton.OverTexture = texture'Book_Left_ov';
	PCCreditsButton.DisabledTexture = None;

	//--
	Root.Console.bBlackout = True;
	Resized();
}

//----------------------------------------------------------------------------

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case PCCreditsButton:
					PlayNewScreenSound();
					Close();
					break;
			}
			break;

		case DE_Change:
			switch (B)
			{
			}
			break;

		case DE_MouseEnter:
			OverEffect(ShellButton(B));
			break;
	}
}

function OverEffect(ShellButton B)
{
	// we changed to arrows which don't burn
	return;

	switch (B) 
	{
		case PCCreditsButton:
			SmokingWindows = 1;
			SmokingTimers = 90;
			break;
	}
}

//----------------------------------------------------------------------------

function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C,X,Y);

	// we changed to arrows which don't burn
	return;

	Super.PaintSmoke(C, PCCreditsButton, SmokingWindows, SmokingTimers);
}

//----------------------------------------------------------------------------

function Resized()
{
	local int W, H, XMod, YMod, i;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}
	
	if ( PCCreditsButton != None )
		PCCreditsButton.ManagerResized(RootScaleX, RootScaleY);
}

//----------------------------------------------------------------------------

function Close(optional bool bByParent)
{
	HideWindow();
}

//----------------------------------------------------------------------------

function HideWindow()
{
	Root.Console.bBlackOut = False;
	Super.HideWindow();
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     BackNames(0)="UndyingShellPC.PSX2Credits_0"
     BackNames(1)="UndyingShellPC.PSX2Credits_1"
     BackNames(2)="UndyingShellPC.PSX2Credits_2"
     BackNames(3)="UndyingShellPC.PSX2Credits_3"
     BackNames(4)="UndyingShellPC.PSX2Credits_4"
     BackNames(5)="UndyingShellPC.PSX2Credits_5"
}
