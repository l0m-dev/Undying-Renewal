//=============================================================================
// QuitWindow.
//=============================================================================
class QuitWindow expands ShellWindow;

//#exec Texture Import File=Quit_0.bmp Mips=Off
//#exec Texture Import File=Quit_1.bmp Mips=Off
//#exec Texture Import File=Quit_2.bmp Mips=Off
//#exec Texture Import File=Quit_3.bmp Mips=Off
//#exec Texture Import File=Quit_4.bmp Mips=Off
//#exec Texture Import File=Quit_5.bmp Mips=Off

//#exec Texture Import File=quit_yes_up.bmp Mips=Off Flags=2
//#exec Texture Import File=quit_yes_ov.bmp Mips=Off Flags=2
//#exec Texture Import File=quit_yes_dn.bmp Mips=Off Flags=2

//#exec Texture Import File=quit_no_up.bmp Mips=Off Flags=2
//#exec Texture Import File=quit_no_ov.bmp Mips=Off Flags=2
//#exec Texture Import File=quit_no_dn.bmp Mips=Off Flags=2

//----------------------------------------------------------------------------

var ShellButton Yes;
var ShellButton No;

var int		SmokingWindows[2];
var float	SmokingTimers[2];

//----------------------------------------------------------------------------

function Created()
{

	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;

	Super.Created();
	
	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;
//--

	SmokingWindows[0] = -1;
	SmokingWindows[1] = -1;

	Yes = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	Yes.Template = NewRegion(210,307,160,64);
	Yes.TexCoords = NewRegion(0,0,160,64);

	Yes.bBurnable = true;
	Yes.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Yes.Manager = Self;
	Yes.Style = 5;

	Yes.UpTexture =   texture'Cntrl_ok_up';
	Yes.DownTexture = texture'Cntrl_ok_dn';
	Yes.OverTexture = texture'Cntrl_ok_ov';
	Yes.DisabledTexture = None;
	
		
	No = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	No.Template = NewRegion(388,307,160,64);
	No.TexCoords = NewRegion(0,0,160,64);

	No.bBurnable = true;
	No.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	No.Manager = Self;
	No.Style = 5;

	No.UpTexture =   texture'Cntrl_cancl_up';
	No.DownTexture = texture'Cntrl_cancl_dn';
	No.OverTexture = texture'Cntrl_cancl_ov';
	No.DisabledTexture = None;

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
				case No: 
					NoPressed();
					break;

				case Yes:
					YesPressed();
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

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{
	switch(Msg)
	{
	case WM_KeyDown:
		if (Key == 89)			// Y key
			YesPressed();
		else if (Key == 78)		// N key
			NoPressed();
		break;
	}

	Super.WindowEvent(Msg, C, X, Y, Key);
}

function OverEffect(ShellButton B)
{
	switch (B) 
	{
		case Yes:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case No:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;
	}
}

function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C, X, Y);

	Super.PaintSmoke(C, Yes, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, No, SmokingWindows[1], SmokingTimers[1]);
}

//----------------------------------------------------------------------------

function YesPressed()
{
	PlayNewScreenSound();
	Root.Quitgame();
}

//----------------------------------------------------------------------------

function NoPressed()
{
	PlayNewScreenSound();
	Close();
}

//----------------------------------------------------------------------------

function Resized()
{
	local int W, H, XMod, YMod, i;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	Yes.ManagerResized(RootScaleX, RootScaleY);
	No.ManagerResized(RootScaleX, RootScaleY);
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
     BackNames(0)="UndyingShellPC.Quit_0"
     BackNames(1)="UndyingShellPC.Quit_1"
     BackNames(2)="UndyingShellPC.Quit_2"
     BackNames(3)="UndyingShellPC.Quit_3"
     BackNames(4)="UndyingShellPC.Quit_4"
     BackNames(5)="UndyingShellPC.Quit_5"
}
