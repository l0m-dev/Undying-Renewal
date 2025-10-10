//=============================================================================
// AdvControlWindow.
//=============================================================================
class AdvControlWindow expands ShellWindow;

#exec OBJ LOAD FILE=..\sounds\Shell_HUD.uax PACKAGE=Shell_HUD
#exec OBJ LOAD FILE=..\textures\ShellTextures.utx PACKAGE=ShellTextures

//#exec Texture Import File=AdvControls_0.bmp Mips=Off
//#exec Texture Import File=AdvControls_1.bmp Mips=Off
//#exec Texture Import File=AdvControls_2.bmp Mips=Off
//#exec Texture Import File=AdvControls_3.bmp Mips=Off
//#exec Texture Import File=AdvControls_4.bmp Mips=Off
//#exec Texture Import File=AdvControls_5.bmp Mips=Off


var ShellButton OK;
var ShellButton Cancel;

var ShellCheckbox	CheckBoxes[6];
var int OriginalValues[6];


var() sound ChangeSound;
var() sound CheckboxSound;

var bool bInitialized;
var bool bSaveChanges;

var int		SmokingWindows[2];
var float	SmokingTimers[2];

function Created()
{

	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;

	Super.Created();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

//--

	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;

	SmokingWindows[0] = -1;
	SmokingWindows[1] = -1;

	// CheckBoxes for Shadows and Decals
	for ( i = 0; i < ArrayCount(CheckBoxes); i++ )
	{
		CheckBoxes[i] = ShellCheckbox(CreateWindow(class'ShellCheckBox', 1,1,1,1));
		
		CheckBoxes[i].TexCoords = NewRegion(0,0,39,37);
		CheckBoxes[i].Manager = Self;

		CheckBoxes[i].UpTexture =   None;
		CheckBoxes[i].DownTexture = texture'audio_x';
		CheckBoxes[i].OverTexture = None;
		CheckBoxes[i].DisabledTexture = None;
	}

	CheckBoxes[0].Template = NewRegion(202,222,34,34);
	CheckBoxes[1].Template = NewRegion(206,298,34,34);
	CheckBoxes[2].Template = NewRegion(207,371,34,34);
	CheckBoxes[3].Template = NewRegion(480,228,34,34);
	CheckBoxes[4].Template = NewRegion(484,306,34,34);
	CheckBoxes[5].Template = NewRegion(487,378,34,34);




// OK Button
	OK = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	OK.TexCoords = NewRegion(0,0,160,64);
	OK.Template = NewRegion(10,392,160,64);

	OK.Manager = Self;
	OK.Style = 5;

	OK.bBurnable = true;
	OK.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	OK.UpTexture =   texture'ShellTextures.cntrl_ok_up';
	OK.DownTexture = texture'ShellTextures.cntrl_ok_dn';
	OK.OverTexture = texture'ShellTextures.cntrl_ok_ov';
	OK.DisabledTexture = None;

// Cancel Button
	Cancel = ShellButton(CreateWindow(class'ShellButton', 30*RootScaleX, 500*RootScaleY, 138*RootScaleX, 60*RootScaleY));

	Cancel.TexCoords = NewRegion(0,0,160,64);

	// position and size in designed resolution of 800x600
	Cancel.Template = NewRegion(20,507,138,60);

	Cancel.Manager = Self;
	Cancel.Style = 5;

	Cancel.bBurnable = true;
	Cancel.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Cancel.UpTexture =   texture'ShellTextures.cntrl_cancl_up';
	Cancel.DownTexture = texture'ShellTextures.cntrl_cancl_dn';
	Cancel.OverTexture = texture'ShellTextures.cntrl_cancl_ov';
	Cancel.DisabledTexture = None;



//--
	Root.Console.bBlackout = True;
	Resized();

	GetCurrentSettings();
	bInitialized=True;
}

function GetCurrentSettings()
{
	local bool value;
	local int i;
	
	CheckBoxes[0].bChecked = GetPlayerOwner().bAlwaysMouselook;
	CheckBoxes[1].bChecked = GetPlayerOwner().bLookUpStairs;
	CheckBoxes[2].bChecked = !GetPlayerOwner().bNeverAutoSwitch;
	CheckBoxes[3].bChecked = GetPlayerOwner().bSnapToLevel;
	CheckBoxes[4].bChecked = GetPlayerOwner().bMouseDecel;
	CheckBoxes[5].bChecked = GetPlayerOwner().bMouseSmoothing;

	for ( i=0; i<ArrayCount(CheckBoxes); i++ )
	{
		OriginalValues[i] = int(CheckBoxes[i].bChecked);
	}

	// default will be to save changes--only discard changes if cancel is clicked
	bSaveChanges = True;
}

function LookSpringChecked()
{
	GetPlayerOwner().bSnapToLevel = CheckBoxes[3].bChecked;

	if ( GetPlayerOwner().bSnapToLevel ) 
	{
		// if LookSpring enabled, disable mouselook
		CheckBoxes[0].bChecked = false;
		GetPlayerOwner().bAlwaysMouseLook = false;
	}
}

function MouselookChecked()
{
	GetPlayerOwner().bAlwaysMouseLook =CheckBoxes[0].bChecked;

	if ( GetPlayerOwner().bAlwaysMouseLook ) 
	{
		// if MouseLook enabled, disable AutoSlope and LookSpring 
		GetPlayerOwner().ChangeStairLook(false);
		CheckBoxes[1].bChecked = false; 

		CheckBoxes[3].bChecked = false;
		GetPlayerOwner().bSnapToLevel = false;
	}

}

function AutoSlopeChecked()
{
	GetPlayerOwner().ChangeStairLook(CheckBoxes[1].bChecked);
	CheckBoxes[0].bChecked = GetPlayerOwner().bAlwaysMouseLook; 
	
	if ( GetPlayerOwner().bLookUpStairs )
		GetPlayerOwner().bKeyboardLook = false;

	//GetPlayerOwner().bLookUpStairs = CheckBoxes[1].bChecked;
}

function AutoSwitchChecked()
{
	GetPlayerOwner().bNeverAutoSwitch = !CheckBoxes[2].bChecked;
}

function MouseSmoothChecked()
{
	GetPlayerOwner().bMouseSmoothing = CheckBoxes[5].bChecked;
}

function MouseDecelChecked()
{
	GetPlayerOwner().bMouseDecel = CheckBoxes[4].bChecked;
}

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case OK:
					bSaveChanges = true;
					PlayNewScreenSound();
					Close();
					break;

				case Cancel:
					bSaveChanges = false;
					PlayNewScreenSound();
					Close();
					break;
			}
			break;

		case DE_Change:
			switch (B)
			{
				case CheckBoxes[0]:
					MouselookChecked();
					break;

				case CheckBoxes[1]:
					AutoSlopeChecked();
					break;

				case CheckBoxes[2]:
					AutoSwitchChecked();
					break;

				case CheckBoxes[3]:
					LookSpringChecked();
					break;

				case CheckBoxes[4]:
					MouseDecelChecked();
					break;

				case CheckBoxes[5]:
					MouseSmoothChecked();
					break;


			}
			break;

		case DE_MouseEnter:
			OverEffect(ShellButton(B));
			break;
	}
}

function OverEffect(ShellButton B)
{
	switch (B) 
	{
		case OK:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case Cancel:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;
	}
}

function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C, X, Y);

	Super.PaintSmoke(C, OK, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, Cancel, SmokingWindows[1], SmokingTimers[1]);
}

function SaveConfigs()
{
	GetPlayerOwner().SaveConfig();
	Super.SaveConfigs();
}

function UndoChanges()
{
	GetPlayerOwner().bAlwaysMouselook	= bool(OriginalValues[0]);
	GetPlayerOwner().bLookUpStairs		= bool(OriginalValues[1]);
	GetPlayerOwner().bNeverAutoSwitch	= !bool(OriginalValues[2]);
	GetPlayerOwner().bSnapToLevel		= bool(OriginalValues[3]);
	GetPlayerOwner().bMouseDecel		= bool(OriginalValues[4]);
	GetPlayerOwner().bMouseSmoothing	= bool(OriginalValues[5]);
}

function Resized()
{
	local int i;	local float RootScaleX, RootScaleY;

	Super.Resized();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	for ( i = 0; i < ArrayCount(CheckBoxes); i++ )
		if ( Checkboxes[i] != None )
			Checkboxes[i].ManagerResized(RootScaleX, RootScaleY);

	if ( OK != None ) 
		OK.ManagerResized(RootScaleX, RootScaleY);

	if ( Cancel != None ) 
		Cancel.ManagerResized(RootScaleX, RootScaleY);
}


function Close(optional bool bByParent)
{
	if ( !bSaveChanges ) 
		UndoChanges();

	bSaveChanges = false;

	HideWindow();
}


function HideWindow()
{
	Root.Console.bBlackOut = False;
	Super.HideWindow();
}

function ShowWindow()
{
	Super.ShowWindow();

	GetCurrentSettings();
}

defaultproperties
{
     ChangeSound=Sound'Shell_HUD.Shell.SHELL_SliderClick'
     CheckboxSound=Sound'Shell_HUD.Shell.SHELL_CheckBox'
     BackNames(0)="ShellTextures.AdvControls_0"
     BackNames(1)="ShellTextures.AdvControls_1"
     BackNames(2)="ShellTextures.AdvControls_2"
     BackNames(3)="ShellTextures.AdvControls_3"
     BackNames(4)="ShellTextures.AdvControls_4"
     BackNames(5)="ShellTextures.AdvControls_5"
}
