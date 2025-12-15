//=============================================================================
// ShellComponent - a control which notifies a parent window
//=============================================================================
class ShellComponent extends UWindowWindow;

#exec TEXTURE IMPORT NAME=ControllerButtons FILE=Textures\ControllerButtons.bmp GROUP="Icons" MIPS=OFF

var ManagerWindow	Manager;

var int TextStyle;
var string Text;
var int Font;
var color TextColor;
var TextAlign Align;
var float TextX, TextY;		// changed by BeforePaint functions
var bool bHasKeyboardFocus;
var bool bNoKeyboard;
var bool bAcceptExternalDragDrop;
var string HelpText;
var float MinWidth, MinHeight;	// minimum heights for layout control

// position and size on default resolution
var region Template;

var ShellComponent	TabNext;
var ShellComponent	TabPrev;


function Created()
{
	if(!bNoKeyboard)
		SetAcceptsFocus();
}

function KeyFocusEnter()
{
	Super.KeyFocusEnter();
	bHasKeyboardFocus = True;
}

function KeyFocusExit()
{
	Super.KeyFocusExit();
	bHasKeyboardFocus = False;
}

function SetHelpText(string NewHelpText)
{
	HelpText = NewHelpText;
}

function SetText(string NewText)
{
	Text = NewText;
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
}

function SetFont(int NewFont)
{
	Font = NewFont;
}

function SetTextColor(color NewColor)
{
	TextColor = NewColor;
}


function Register(ManagerWindow	W)
{
	Manager = W;
	SendMessage(DE_Created);
}


function SendMessage(byte E)
{
	if(Manager != None)
	{
		Manager.Message(Self, E);
	}
}


function KeyDown(int Key, float X, float Y)
{
	local PlayerPawn P;
	local ShellComponent N;

	P = Root.GetPlayerOwner();

	switch (Key)
	{
	case P.EInputKey.IK_Tab:
		
		if(TabNext != None)
		{
			N = TabNext;
			while(N != Self && !N.bWindowVisible)
				N = N.TabNext;

			N.ActivateWindow(0, False);
		}
		break;
	default:
		Super.KeyDown(Key, X, Y);
		break;
	}

}

function MouseMove(float X, float Y)
{
	Super.MouseMove(X, Y);
	SendMessage(DE_MouseMove);
}

function MouseEnter()
{
	Super.MouseEnter();
	SendMessage(DE_MouseEnter);
}

function MouseLeave()
{
	Super.MouseLeave();
	SendMessage(DE_MouseLeave);
}

function ManagerResized(float ScaleX, float ScaleY)
{
	ScaleX = Manager.InnerWidth / Root.OriginalWidth;
	ScaleY = Manager.InnerHeight / Root.OriginalHeight;

	if (ScaleX > ScaleY) {
		ScaleX = ScaleY;
	} else {
		ScaleY = ScaleX;
	}

	WinLeft		= Manager.InnerLeft + Template.x * ScaleX;
	WinTop		= Manager.InnerTop + Template.y * ScaleY;
	WinWidth	= Template.w * ScaleX;
	WinHeight	= Template.h * ScaleY;
}

defaultproperties
{
     TextStyle=1
}
