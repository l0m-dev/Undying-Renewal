//=============================================================================
// AdvVideoWindow.
//=============================================================================
class AdvVideoWindow expands ShellWindow;

//#exec OBJ LOAD FILE=\aeons\sounds\Shell_HUD.uax PACKAGE=Shell_HUD

//#exec Texture Import File=AdvVideo_0.bmp Mips=Off
//#exec Texture Import File=AdvVideo_1.bmp Mips=Off
//#exec Texture Import File=AdvVideo_2.bmp Mips=Off
//#exec Texture Import File=AdvVideo_3.bmp Mips=Off
//#exec Texture Import File=AdvVideo_4.bmp Mips=Off
//#exec Texture Import File=AdvVideo_5.bmp Mips=Off

var ShellButton OK;
var ShellButton Cancel;
var ShellCheckbox	CheckBoxes[2];
var ShellSlider SkinDetailSlider;
var ShellSlider WorldDetailSlider;
var ShellSlider MinFrameRateSlider;
var ShellSlider MinQualitySlider;

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
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Created();
	
	AeonsRoot = AeonsRootWindow(Root);

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}
	else
	{
		RootScaleX = Root.ScaleX;
		RootScaleY = Root.ScaleY;
	}

	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;

	SmokingWindows[0] = -1;
	SmokingWindows[1] = -1;

	// CheckBoxes for Shadows and Decals
	for ( i = 0; i < 2; i++ )
	{
		CheckBoxes[i] = ShellCheckbox(CreateWindow(class'ShellCheckBox', 1,1,1,1));
		
		CheckBoxes[i].TexCoords = NewRegion(0,0,39,37);
		CheckBoxes[i].Manager = Self;

		CheckBoxes[i].UpTexture =   None;
		CheckBoxes[i].DownTexture = texture'audio_x';
		CheckBoxes[i].OverTexture = None;
		CheckBoxes[i].DisabledTexture = None;
	}

	CheckBoxes[0].Template = NewRegion(686,192,39,37);
	CheckBoxes[1].Template = NewRegion(686,285,39,37);


	// SkinDetail Slider
	SkinDetailSlider = ShellSlider(CreateWindow(class'ShellSlider', 255*RootScaleX, 215*RootScaleY, 216*RootScaleX, 26*RootScaleY));

	SkinDetailSlider.TexCoords = NewRegion(0,0,32,32);
	SkinDetailSlider.Template = NewRegion(223,180,250,29);
	SkinDetailSlider.SetSlider(0,0,32,32);

	SkinDetailSlider.SetRange(0.0, 2.0, 1.0);

	SkinDetailSlider.Manager = Self;
	SkinDetailSlider.Style = 5;

	//UT used this 
	SkinDetailSlider.bNoSlidingNotify = True;

	SkinDetailSlider.UpTexture =   texture'aeons.cntrl_slidr';
	SkinDetailSlider.DownTexture = texture'aeons.cntrl_slidr';
	SkinDetailSlider.OverTexture = texture'aeons.cntrl_slidr';
	SkinDetailSlider.DisabledTexture = None;


	// WorldDetail Slider
	WorldDetailSlider = ShellSlider(CreateWindow(class'ShellSlider', 255*RootScaleX, 215*RootScaleY, 216*RootScaleX, 26*RootScaleY));

	WorldDetailSlider.TexCoords = NewRegion(0,0,32,32);
	WorldDetailSlider.Template = NewRegion(223,249,250,29);
	WorldDetailSlider.SetSlider(0,0,32,32);

	WorldDetailSlider.SetRange(0.0, 2.0, 1.0);

	WorldDetailSlider.Manager = Self;
	WorldDetailSlider.Style = 5;

	//UT used this 
	WorldDetailSlider.bNoSlidingNotify = True;

	WorldDetailSlider.UpTexture =   texture'aeons.cntrl_slidr';
	WorldDetailSlider.DownTexture = texture'aeons.cntrl_slidr';
	WorldDetailSlider.OverTexture = texture'aeons.cntrl_slidr';
	WorldDetailSlider.DisabledTexture = None;


	// MinFrameRate Slider
	MinFrameRateSlider = ShellSlider(CreateWindow(class'ShellSlider', 255*RootScaleX, 386*RootScaleY, 228*RootScaleX, 26*RootScaleY));

	MinFrameRateSlider.TexCoords = NewRegion(0,0,32,32);
	MinFrameRateSlider.Template = NewRegion(223,310,250,29);
	MinFrameRateSlider.SetSlider(0,0,32,32);

	MinFrameRateSlider.SetRange(10.0, 90.0, 10.0);

	MinFrameRateSlider.Manager = Self;
	MinFrameRateSlider.Style = 5;

	MinFrameRateSlider.Text = "";
	MinFrameRateSlider.SetTextColor(TextColor);
	MinFrameRateSlider.Font = 0;

	//UT used this 
	MinFrameRateSlider.bNoSlidingNotify = True;

	MinFrameRateSlider.UpTexture =   texture'aeons.cntrl_slidr';
	MinFrameRateSlider.DownTexture = texture'aeons.cntrl_slidr';
	MinFrameRateSlider.OverTexture = texture'aeons.cntrl_slidr';
	MinFrameRateSlider.DisabledTexture = None;


	// MinQuality Slider
	MinQualitySlider = ShellSlider(CreateWindow(class'ShellSlider', 255*RootScaleX, 465*RootScaleY, 228*RootScaleX, 26*RootScaleY));

	MinQualitySlider.TexCoords = NewRegion(0,0,32,32);
	MinQualitySlider.Template = NewRegion(223,379,250,29);
	MinQualitySlider.SetSlider(0,0,32,32);

	MinQualitySlider.SetRange(0.0, 1.0, 0.1);

	MinQualitySlider.Manager = Self;
	MinQualitySlider.Style = 5;

	//UT used this 
	MinQualitySlider.bNoSlidingNotify = True;

	MinQualitySlider.UpTexture =   texture'aeons.cntrl_slidr';
	MinQualitySlider.DownTexture = texture'aeons.cntrl_slidr';
	MinQualitySlider.OverTexture = texture'aeons.cntrl_slidr';
	MinQualitySlider.DisabledTexture = None;


// OK Button
	OK = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	OK.TexCoords.X = 0;
	OK.TexCoords.Y = 0;
	OK.TexCoords.W = 160;
	OK.TexCoords.H = 60;

	// position and size in designed resolution of 800x600
	OK.Template = NewRegion(30,475,160,60);

	OK.Manager = Self;
	Ok.Style = 5;

	OK.bBurnable = true;
	OK.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	OK.UpTexture =   texture'Cntrl_ok_up';
	OK.DownTexture = texture'Cntrl_ok_dn';
	OK.OverTexture = texture'Cntrl_ok_ov';
	OK.DisabledTexture = None;

// Cancel Button
	Cancel = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	Cancel.TexCoords = NewRegion(0,0,160,60);

	// position and size in designed resolution of 800x600
	Cancel.Template = NewRegion(30,535,160,60);

	Cancel.Manager = Self;
	Cancel.Style = 5;

	Cancel.bBurnable = true;
	Cancel.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Cancel.UpTexture =   texture'Cntrl_cancl_up';
	Cancel.DownTexture = texture'Cntrl_cancl_dn';
	Cancel.OverTexture = texture'Cntrl_cancl_ov';
	Cancel.DisabledTexture = None;

	Root.Console.bBlackout = True;
	Resized();

	GetCurrentSettings();
	bInitialized=True;
}

function GetCurrentSettings()
{
	local string detail;

	detail = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager SkinDetail");
	Log("SkinDetail = "$detail);
	if ( detail ~= "Low" )
		SkinDetailSlider.SetValue(0);
	else if ( detail ~= "Medium" )
		SkinDetailSlider.SetValue(1);
	else if ( detail ~= "High" )
		SkinDetailSlider.SetValue(2);
	else
		Log("Detail setting isn't Low/Medium/High!");

	detail = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager TextureDetail");
	Log("WorldDetail = "$detail);
	if ( detail ~= "Low" )
		WorldDetailSlider.SetValue(0);
	else if ( detail ~= "Medium" )
		WorldDetailSlider.SetValue(1);
	else if ( detail ~= "High" )
		WorldDetailSlider.SetValue(2);
	else
		Log("Detail setting isn't Low/Medium/High!");

	MinFrameRateSlider.SetValue(float(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager MinDesiredFrameRate")));
	MinQualitySlider.SetValue(float(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager MinQuality")));
	CheckBoxes[0].bChecked = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager ActorShadows"));
	CheckBoxes[1].bChecked = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager Decals"));

	// default will be to save changes--only discard changes if cancel is clicked
	bSaveChanges = True;
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
					ShadowsChanged();
					break;

				case CheckBoxes[1]:
					DecalsChanged();
					break;

				case SkinDetailSlider:
					SkinDetailChanged();
					break;

				case WorldDetailSlider:
					WorldDetailChanged();
					break;

				case MinFramerateSlider:
					MinFramerateChanged();
					break;

				case MinQualitySlider:
					MinQualityChanged();
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

function ShadowsChanged()
{
	if ( (CheckboxSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( CheckboxSound,, 0.25, [Flags]482 );
}

function DecalsChanged()
{
	if ( (CheckboxSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( CheckboxSound,, 0.25, [Flags]482 );
}

function SkinDetailChanged()
{
	if ( (ChangeSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

}

function WorldDetailChanged()
{
	if ( (ChangeSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

}

function MinFrameRateChanged()
{
	if ( (ChangeSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

}

function MinQualityChanged()
{
	if ( (ChangeSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

}

function SaveChanges()
{
	local string detail;

	switch (SkinDetailSlider.Value)
	{
		case 0:
			detail = "Low";
			break;

		case 1:
			detail = "Medium";
			break;

		case 2:
			detail = "High";
			break;

		default:
			break;
	}
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager SkinDetail "$detail);

	switch (WorldDetailSlider.Value)
	{
		case 0:
			detail = "Low";
			break;

		case 1:
			detail = "Medium";
			break;

		case 2:
			detail = "High";
			break;

		default:
			break;
	}
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail "$detail);

	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager ActorShadows " $ Checkboxes[0].bChecked );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Decals " $ Checkboxes[1].bChecked );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager MinDesiredFrameRate " $ MinFrameRateSlider.Value );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager MinQuality " $ MinQualitySlider.Value );
	GetPlayerOwner().ConsoleCommand("FLUSH");
}

function Resized()
{
	local int i;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = Root.ScaleX;
		RootScaleY = Root.ScaleY;
	}
	else
	{
		RootScaleX = 1.0;
		RootScaleY = 1.0;
	}

	if ( SkinDetailSlider != None ) 
		SkinDetailSlider.ManagerResized(RootScaleX, RootScaleY);

	if ( WorldDetailSlider != None ) 
		WorldDetailSlider.ManagerResized(RootScaleX, RootScaleY);

	if ( MinFramerateSlider != None ) 
		MinFramerateSlider.ManagerResized(RootScaleX, RootScaleY);

	if ( MinQualitySlider != None ) 
		MinQualitySlider.ManagerResized(RootScaleX, RootScaleY);

	for ( i = 0; i < 2; i++ )
		if ( Checkboxes[i] != None )
			Checkboxes[i].ManagerResized(RootScaleX, RootScaleY);

	if ( OK != None ) 
		OK.ManagerResized(RootScaleX, RootScaleY);

	if ( Cancel != None ) 
		Cancel.ManagerResized(RootScaleX, RootScaleY);
}


function Close(optional bool bByParent)
{
	if ( bSaveChanges ) 
		SaveChanges();

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
     BackNames(0)="UndyingShellPC.AdvVideo_0"
     BackNames(1)="UndyingShellPC.AdvVideo_1"
     BackNames(2)="UndyingShellPC.AdvVideo_2"
     BackNames(3)="UndyingShellPC.AdvVideo_3"
     BackNames(4)="UndyingShellPC.AdvVideo_4"
     BackNames(5)="UndyingShellPC.AdvVideo_5"
}
