//=============================================================================
// VideoWindow.
//=============================================================================
class VideoWindow expands ShellWindow;


//#exec OBJ LOAD FILE=\aeons\sounds\Shell_HUD.uax PACKAGE=Shell_HUD

//#exec Texture Import File=Video_0.bmp Mips=Off
//#exec Texture Import File=Video_1.bmp Mips=Off
//#exec Texture Import File=Video_2.bmp Mips=Off
//#exec Texture Import File=Video_3.bmp Mips=Off
//#exec Texture Import File=Video_4.bmp Mips=Off
//#exec Texture Import File=Video_5.bmp Mips=Off

//#exec Texture Import File=video_advan_up.bmp Mips=Off
//#exec Texture Import File=video_advan_dn.bmp Mips=Off
//#exec Texture Import File=video_advan_ov.bmp Mips=Off

/* 
//#exec Texture Import File=video_adv_up.bmp Flags=2 Mips=Off
//#exec Texture Import File=video_adv_dn.bmp Flags=2 Mips=Off
//#exec Texture Import File=video_adv_ov.bmp Flags=2 Mips=Off
*/

//#exec Texture Import File=video_ok_up.bmp Mips=Off
//#exec Texture Import File=video_ok_dn.bmp Mips=Off
//#exec Texture Import File=video_ok_ov.bmp Mips=Off

//#exec Texture Import File=video_Cancel_up.bmp Mips=Off
//#exec Texture Import File=video_Cancel_dn.bmp Mips=Off
//#exec Texture Import File=video_Cancel_ov.bmp Mips=Off

//#exec Texture Import File=Video_resol_up.bmp  Mips=Off
//#exec Texture Import File=Video_resol_dn.bmp  Mips=Off
//#exec Texture Import File=Video_resol_ov.bmp  Mips=Off

/*
//#exec Texture Import File=Video_res_up.bmp Flags=2 Mips=Off
//#exec Texture Import File=Video_res_dn.bmp Flags=2 Mips=Off
//#exec Texture Import File=Video_res_ov.bmp Flags=2 Mips=Off
*/
//----------------------------------------------------------------------------

var UWindowWindow AdvVideo;

var ShellButton Advanced;
var ShellButton Resolutions[5]; // resolutions currently displayed in the scrollable list
var string ResolutionList[31]; // complete list of available resolutions
var int CurrentRow; // current row in scrollable resolution list
var ShellButton OK;
var ShellButton Cancel;
var ShellButton Down;
var ShellButton Up;
var ShellButton BitDepth_16, BitDepth_32;
var ShellButton ChangeDriver;

var ShellLabel DriverLabel;
var ShellLabel ResLabel;

var ShellSlider BrightnessSlider;

var float OrigBrightness, Brightness;

var string OriginalRes;
var string NewRes;
var int ColorDepth;

var sound ChangeSound;
var bool bInitialized;
var bool bSaveChanges;

var int		SmokingWindows[3];
var float	SmokingTimers[3];

//----------------------------------------------------------------------------

function Created()
{

	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;

	Super.Created();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	for ( i = 0; i < 3; i++ )
		SmokingWindows[i] = -1;

	Advanced = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	Advanced.Template = NewRegion(35,108,160,64);

	Advanced.TexCoords.X = 0;
	Advanced.TexCoords.Y = 0;
	Advanced.TexCoords.W = 160;
	Advanced.TexCoords.H = 64;

	Advanced.Manager = Self;
	Advanced.Style = 5;

	Advanced.bBurnable = true;
	Advanced.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Advanced.UpTexture =   texture'video_advan_up';
	Advanced.DownTexture = texture'video_advan_dn';
	Advanced.OverTexture = texture'video_advan_ov';
	Advanced.DisabledTexture = None;

	// Brightness Slider
	BrightnessSlider = ShellSlider(CreateWindow(class'ShellSlider', 515*RootScaleX, 386*RootScaleY, 228*RootScaleX, 26*RootScaleY));

	BrightnessSlider.TexCoords = NewRegion(0,0,32,32);
	BrightnessSlider.Template = NewRegion(515,386,228,26);
	BrightnessSlider.SetSlider(0,0,32,32);

	BrightnessSlider.SetRange(0.0, 1.0, 0.05);
	BrightnessSlider.SetValue(0.5);

	BrightnessSlider.Manager = Self;
	BrightnessSlider.Style = 5;

	//UT used this 
	BrightnessSlider.bNoSlidingNotify = True;

	BrightnessSlider.UpTexture =   texture'aeons.cntrl_slidr';
	BrightnessSlider.DownTexture = texture'aeons.cntrl_slidr';
	BrightnessSlider.OverTexture = texture'aeons.cntrl_slidr';
	BrightnessSlider.DisabledTexture = None;

// Resolution buttons
	for( i=0; i<ArrayCount(Resolutions); i++ )
	{
		Resolutions[i] = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

		Resolutions[i].Template = NewRegion(254, 156+(54+5)*i, 204, 54);

		Resolutions[i].Manager = Self;
		Resolutions[i].Style = 5;
		Resolutions[i].TextX = 0;
		Resolutions[i].TextY = 0;

		Resolutions[i].Align = TA_Center;

		Resolutions[i].TexCoords = NewRegion(0,0,204,54);

		Resolutions[i].UpTexture =   texture'Video_resol_up';
		Resolutions[i].DownTexture = texture'Video_resol_dn';
		Resolutions[i].OverTexture = texture'Video_resol_ov';

		/*
		TextColor.R = 184;
		TextColor.G = 141;
		TextColor.B = 111;
		*/
		
		TextColor.R = 255;
		TextColor.G = 255;
		TextColor.B = 255;
		
		Resolutions[i].SetTextColor(TextColor);
		Resolutions[i].Font = 4;
	}

	ResolutionList[ 0] = "640x360";	
	ResolutionList[ 1] = "640x480";
	ResolutionList[ 2] = "848x480";
	ResolutionList[ 3] = "800x600";
	ResolutionList[ 4] = "1024x600";
	ResolutionList[ 5] = "1024x768";
	ResolutionList[ 6] = "1152x864";
	ResolutionList[ 7] = "1280x720";
	ResolutionList[ 8] = "1280x800";
	ResolutionList[ 9] = "1366x768";
	ResolutionList[10] = "1280x960";
	ResolutionList[11] = "1440x900";
	ResolutionList[12] = "1280x1024";
	ResolutionList[13] = "1600x900";
	ResolutionList[14] = "1680x1050";
	ResolutionList[15] = "1600x1200";
	ResolutionList[16] = "1440x1080";
	ResolutionList[17] = "1920x1080";
	ResolutionList[18] = "1920x1200";
	ResolutionList[19] = "1920x1440";
	ResolutionList[20] = "2560x1080";
	ResolutionList[21] = "2048x1536";
	ResolutionList[22] = "2560x1440";
	ResolutionList[23] = "2560x1600";
	ResolutionList[24] = "2560x1920";
	ResolutionList[25] = "3440x1440";
	ResolutionList[26] = "2732x2048";
	ResolutionList[27] = "3200x1800";
	ResolutionList[28] = "2800x2100";
	ResolutionList[29] = "3200x2400";
	ResolutionList[30] = "3840x2160";
	
// Resolution scroll buttons
	Up =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	Down =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	Up.Style = 5;
	Down.Style = 5;

	Up.Template =	NewRegion(466,130,64,128);
	Down.Template = NewRegion(466,388,64,128);

	Up.TexCoords = NewRegion(0,0,64,128);
	Down.TexCoords = NewRegion(0,0,64,128);

	Up.bRepeat = True;
	Down.bRepeat = True;

	Up.key_interval = 0.08;
	Down.key_interval = 0.08;

	Up.Manager = Self;
	Down.Manager = Self;

	Up.UpTexture =   texture'Cntrl_upbut_up';
	Up.DownTexture = texture'Cntrl_upbut_dn';
	Up.OverTexture = texture'Cntrl_upbut_ov';
	Up.DisabledTexture = texture'Cntrl_upbut_ds';

	Down.UpTexture =   texture'Cntrl_dnbut_up';
	Down.DownTexture = texture'Cntrl_dnbut_dn';
	Down.OverTexture = texture'Cntrl_dnbut_ov';
	Down.DisabledTexture = texture'Cntrl_dnbut_ds';


// 16 Bit Button
	BitDepth_16 = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	//BitDepth_16.TexCoords.X = NewRegion(0,0,82,36);
	
	// position and size in designed resolution of 800x600
	BitDepth_16.Template = NewRegion(550,311,82,36);

	BitDepth_16.Manager = Self;
	BitDepth_16.Style = 5;
	BitDepth_16.Text = "16bit";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	BitDepth_16.SetTextColor(TextColor);
	BitDepth_16.Align = TA_Center;
	BitDepth_16.Font = 4;


	BitDepth_16.TexCoords = NewRegion(0,0,204,54);
	BitDepth_16.UpTexture =   None;//texture'Video_BitDepth_16_up';
	BitDepth_16.DownTexture = None;//texture'Video_BitDepth_16_dn';
	BitDepth_16.OverTexture = None;//texture'Video_BitDepth_16_ov';
	BitDepth_16.DisabledTexture = None;


	
// 32 bit button	
	BitDepth_32 = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	//BitDepth_32.TexCoords.X = NewRegion(0,0,82,36);
	
	// position and size in designed resolution of 800x600
	BitDepth_32.Template = NewRegion(644,309,82,36);

	BitDepth_32.Manager = Self;
	BitDepth_32.Style = 5;
	BitDepth_32.Text = "32bit";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	BitDepth_32.SetTextColor(TextColor);
	BitDepth_32.TextStyle=1;
	BitDepth_32.Align = TA_Center;
	BitDepth_32.Font = 4;

	BitDepth_32.TexCoords = NewRegion(0,0,204,54);
	BitDepth_32.UpTexture =			None;
	BitDepth_32.DownTexture =		None;
	BitDepth_32.OverTexture =		None;
	BitDepth_32.DisabledTexture =	None;


// Change Driver button	
	ChangeDriver = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	// position and size in designed resolution of 800x600
	ChangeDriver.Template = NewRegion(556,260,180,48);

	ChangeDriver.Manager = Self;
	ChangeDriver.Style = 5;
	ChangeDriver.Text = "Change Driver";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	ChangeDriver.SetTextColor(TextColor);
	ChangeDriver.TextStyle=1;
	ChangeDriver.Align = TA_Center;
	ChangeDriver.Font = 4;

	ChangeDriver.TexCoords = NewRegion(0,0,204,54);

	ChangeDriver.UpTexture =		texture'Video_resol_up';
	ChangeDriver.DownTexture =		texture'Video_resol_up';
	ChangeDriver.OverTexture =		texture'Video_resol_ov';
	ChangeDriver.DisabledTexture =	None;


// OK Button
	OK = ShellButton(CreateWindow(class'ShellButton', 30*RootScaleX, 108*RootScaleY, 138*RootScaleX, 60*RootScaleY));

	OK.TexCoords.X = 0;
	OK.TexCoords.Y = 0;
	OK.TexCoords.W = 138;
	OK.TexCoords.H = 60;

	// position and size in designed resolution of 800x600
	OK.Template = NewRegion(30,394,138,60);

	OK.Manager = Self;
	Ok.Style = 5;

	OK.bBurnable = true;
	OK.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	OK.UpTexture =   texture'Video_ok_up';
	OK.DownTexture = texture'Video_ok_dn';
	OK.OverTexture = texture'Video_ok_ov';
	OK.DisabledTexture = None;

// Cancel Button
	Cancel = ShellButton(CreateWindow(class'ShellButton', 30*RootScaleX, 200*RootScaleY, 138*RootScaleX, 60*RootScaleY));

	Cancel.TexCoords.X = 0;
	Cancel.TexCoords.Y = 0;
	Cancel.TexCoords.W = 138;
	Cancel.TexCoords.H = 60;

	// position and size in designed resolution of 800x600
	Cancel.Template = NewRegion(30,494,138,60);

	Cancel.Manager = Self;
	Cancel.Style = 5;

	Cancel.bBurnable = true;
	Cancel.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Cancel.UpTexture =   texture'Video_cancel_up';
	Cancel.DownTexture = texture'Video_cancel_dn';
	Cancel.OverTexture = texture'Video_cancel_ov';
	Cancel.DisabledTexture = None;

// Driver label.  OpenGl, D3D, Software, etc
	DriverLabel = ShellLabel(CreateWindow(class'ShellLabel', 1,1,1,1));

	DriverLabel.Template=NewRegion(566, 183, 158, 38);
	DriverLabel.Manager = Self;
	DriverLabel.Text = "";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	DriverLabel.SetTextColor(TextColor);
	DriverLabel.Align = TA_Center;
	DriverLabel.Font = 4;

// Res label.  current res
	ResLabel = ShellLabel(CreateWindow(class'ShellLabel', 1,1,1,1));

	ResLabel.Template=NewRegion(566, 218, 158, 38);
	ResLabel.Manager = Self;
	ResLabel.Text = "";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	ResLabel.SetTextColor(TextColor);
	ResLabel.Align = TA_Center;
	ResLabel.Font = 4;

	// initialize resolution list and scroll buttons
	CurrentRow = 0;
	Up.bDisabled = true;
	Down.bDisabled = false;

	Root.Console.bBlackout = True;

	GetCurrentSettings();
	GetStartingRow();
	RefreshButtons();
	
	Resized();

	bInitialized=True;
}

function GetStartingRow()
{
	local int i;
	for ( i=0; i<ArrayCount(ResolutionList); i++ )
	{
		if ( ResLabel.Text ~= ResolutionList[i] )
		{
			break;
		}
	}
	CurrentRow = clamp(i - (ArrayCount(Resolutions) / 2), 0, ArrayCount(ResolutionList) - ArrayCount(Resolutions));

	if ( CurrentRow > 0 ) 
	{
		Up.bDisabled = false;
	}
	if ( CurrentRow >= ArrayCount(ResolutionList) - ArrayCount(Resolutions) )
	{
		Down.bDisabled = true;
	}
}

function Message(UWindowWindow B, byte E)
{
	local int i;
	
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			if ( ShellButton(B).bDisabled ) 
				return;
			for ( i=0; i<ArrayCount(Resolutions); i++ )
			{
				if ( B == Resolutions[i] )
				{
					ResolutionClicked(B);
					return;
				}
				
			}
			switch (B)
			{
				case Advanced:
					AdvVideoPressed();
					break;

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

				case Up:
					ScrolledUp();
					break;

				case Down:
					ScrolledDown();
					break;

				case BitDepth_16:
					SetColorDepth(16);
					break;

				case BitDepth_32:
					SetColorDepth(32);
					break;

				case ChangeDriver:
					ChangeDriverPressed();
					break;
			}
			break;

		case DE_Change:
			switch (B)
			{
				case BrightnessSlider:
					BrightnessChanged();
					break;
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
		if (Key == Root.Console.EInputKey.IK_MWheelUp && !Up.bDisabled)
			ScrolledUp();
		if (Key == Root.Console.EInputKey.IK_MWheelDown && !Down.bDisabled)
			ScrolledDown();
		break;
	}

	Super.WindowEvent(Msg, C, X, Y, Key);
}

function OverEffect(ShellButton B)
{
	switch (B) 
	{
		case OK:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case Advanced:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;

		case Cancel:
			SmokingWindows[2] = 1;
			SmokingTimers[2] = 90;
			break;
	}
}

function SetColorDepth( int NewColorDepth )
{
	
	if ( ColorDepth != NewColorDepth )
	{
		NewRes = GetPlayerOwner().ConsoleCommand("GetCurrentRes") $ "x" $ NewColorDepth;

		GetPlayerOwner().ConsoleCommand("SetRes "$ NewRes );

		OriginalRes = GetPlayerOwner().ConsoleCommand("GetCurrentRes") $ "x" $ GetPlayerOWner().ConsoleCommand("GetCurrentColorDepth");


		if ( GetPlayerOWner().ConsoleCommand("GetCurrentColorDepth") == "16" && DriverLabel.Text != "3DFX")
		{
			ColorDepth = 16;
			BitDepth_16.UpTexture = texture'Video_resol_dn';
			BitDepth_16.OverTexture = texture'Video_resol_dn';
			BitDepth_16.DownTexture = texture'Video_resol_dn';

			BitDepth_32.UpTexture = texture'Video_resol_up';
			BitDepth_32.OverTexture = texture'Video_resol_ov';
			BitDepth_32.DownTexture = texture'Video_resol_up';
		}
		else
		{
			ColorDepth = 32;
			BitDepth_32.UpTexture = texture'Video_resol_dn';
			BitDepth_32.OverTexture = texture'Video_resol_dn';
			BitDepth_32.DownTexture = texture'Video_resol_dn';

			BitDepth_16.UpTexture = texture'Video_resol_up';
			BitDepth_16.OverTexture = texture'Video_resol_ov';
			BitDepth_16.DownTexture = texture'Video_resol_up';
		}

	}

}

function ChangeDriverPressed()
{
	//	ConfirmDriver = MessageBox(ConfirmDriverTitle, ConfirmDriverText, MB_YesNo, MR_No);
	
	GetPlayerOwner().EnableSaveGame();
	
	GetPlayerOwner().ConsoleCommand("SaveGame 99");
	GetPlayerOwner().ConsoleCommand("deletesavelevels");
	GetPlayerOwner().ConsoleCommand("RELAUNCH -changevideo?-nointro");
	
	Close();
}



function ResolutionClicked(UWindowWindow B)
{
	local int i;
	
	if ( ColorDepth == 16 ) 
		NewRes = ShellButton(b).Text $ "x16"; // @ added a space before so the check never worked
	else
		NewRes = ShellButton(b).Text $ "x32";


	if ( OriginalRes != NewRes )
	{

		for ( i=0; i<ArrayCount(Resolutions); i++ )
		{
			Resolutions[i].UpTexture =   texture'Video_resol_up';
			Resolutions[i].DownTexture = texture'Video_resol_up';
			Resolutions[i].OverTexture = texture'Video_resol_ov';
		}

		//GetPlayerOwner().ConsoleCommand("SetRes "$ ShellButton(B).Text $ "x" $ GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth"));
		GetPlayerOwner().ConsoleCommand("SetRes "$ NewRes );

		OriginalRes = GetPlayerOwner().ConsoleCommand("GetCurrentRes") $ "x" $ GetPlayerOWner().ConsoleCommand("GetCurrentColorDepth");
	}

}

function ScrolledUp()
{
	local int i;
	
	if ( (ChangeSound != none) && bInitialized ) 
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

	CurrentRow--;
	if ( CurrentRow <= 0 ) 
	{
		CurrentRow = 0;
		Up.bDisabled = true;
	}

	if ( CurrentRow < ArrayCount(ResolutionList) - ArrayCount(Resolutions) )
	{
		Down.bDisabled = false;
	}

	RefreshButtons();

}

function ScrolledDown()
{
	local int i;
	
	if ( (ChangeSound != none) && bInitialized ) 
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );
	
	CurrentRow++;
	if ( CurrentRow + ArrayCount(Resolutions) >= ArrayCount(ResolutionList) ) 
	{
		Down.bDisabled = true;
	}

	if ( CurrentRow > 0 ) 
	{
		Up.bDisabled = false;
	}

	RefreshButtons();
}

function RefreshButtons()
{
	local int i;

	for( i=0; i<ArrayCount(Resolutions); i++ )
	{
		Resolutions[i].Text = ResolutionList[CurrentRow + i];
	}

}

function BrightnessChanged()
{
	local sound changedsound;

//	changedsound = Sound(DynamicLoadObject("LevelMechanics.Catacombs.A14_WoodCrk02", class'Sound'));

	if ( (ChangeSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

	Brightness = BrightnessSlider.Value;

	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness " $ Brightness );

	GetPlayerOwner().ConsoleCommand("FLUSH");
}

function GetCurrentSettings()
{
	local string VideoDriverClassName;//, ClassLeft, ClassRight, VideoDriverDesc;
	local int i;
	
	// get current values and save
	OrigBrightness = float(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager Brightness"));
	
	// set local values to current values
	OrigBrightness = FClamp( OrigBrightness, 0.0, 1.0 );
	
	// link up shell components with variables
	BrightnessSlider.SetValue(OrigBrightness);

	if ( GetPlayerOWner().ConsoleCommand("GetCurrentColorDepth") == "16" && GetPlayerOwner().ConsoleCommand("GetCurrentDriver") != "3DFX")
	{
		ColorDepth = 16;
		BitDepth_16.UpTexture = texture'Video_resol_dn';
		BitDepth_16.OverTexture = texture'Video_resol_dn';
		BitDepth_16.DownTexture = texture'Video_resol_dn';

		BitDepth_32.UpTexture = texture'Video_resol_up';
		BitDepth_32.OverTexture = texture'Video_resol_ov';
		BitDepth_32.DownTexture = texture'Video_resol_up';
	}
	else
	{
		ColorDepth = 32;
		BitDepth_32.UpTexture = texture'Video_resol_dn';
		BitDepth_32.OverTexture = texture'Video_resol_dn';
		BitDepth_32.DownTexture = texture'Video_resol_dn';

		BitDepth_16.UpTexture = texture'Video_resol_up';
		BitDepth_16.OverTexture = texture'Video_resol_ov';
		BitDepth_16.DownTexture = texture'Video_resol_up';
	}
	
	VideoDriverClassName = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice Class");
	i = InStr(VideoDriverClassName, "'");
	// Get class name from class'...'
	if(i != -1)
	{
		VideoDriverClassName = Mid(VideoDriverClassName, i+1);
		i = InStr(VideoDriverClassName, "'");
		VideoDriverClassName = Left(VideoDriverClassName, i);
		//ClassLeft = Left(VideoDriverClassName, InStr(VideoDriverClassName, "."));
		//ClassRight = Mid(VideoDriverClassName, InStr(VideoDriverClassName, ".") + 1);
		//VideoDriverDesc = Localize(ClassRight, "ClassCaption", ClassLeft);
	}

	DriverLabel.Text = GetPlayerOwner().ConsoleCommand("GetCurrentDriver");
	ResLabel.Text = GetPlayerOwner().ConsoleCommand("GetCurrentRes"); 
	
	if (VideoDriverClassName ~= "d3d11drv.d3d11renderdevice")
		DriverLabel.Text = DriverLabel.Text$" 11";
	
	// Will save changes by default
	bSaveChanges = True;
}


function UndoChanges()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness " $ OrigBrightness );
	GetPlayerOwner().ConsoleCommand("FLUSH");
}


function SaveChanges()
{

}


function AdvVideoPressed()
{
	PlayNewScreenSound();

	if (AdvVideo == None ) 
		AdvVideo = ManagerWindow(Root.CreateWindow(class'AdvVideoWindow', 100, 100, 200, 200, Root, True));
	else
		AdvVideo.ShowWindow();		
}


function Resized()
{
	local int i;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	//fix might be better to have AeonsRootWindow or UWindowRootWindow know the active window
	// I think there is already a variable for that, i'll look later

	if ( AdvVideo != None )
		AdvVideo.Resized();

	Advanced.ManagerResized(RootScaleX, RootScaleY);

	if ( OK != None ) 
		OK.ManagerResized(RootScaleX, RootScaleY);

	if ( Cancel != None ) 
		Cancel.ManagerResized(RootScaleX, RootScaleY);

	if ( Up != None ) 
		Up.ManagerResized(RootScaleX, RootScaleY);

	if ( Down != None ) 
		Down.ManagerResized(RootScaleX, RootScaleY);

	BitDepth_16.ManagerResized(RootScaleX, RootScaleY);
	BitDepth_32.ManagerResized(RootScaleX, RootScaleY);
	DriverLabel.ManagerResized(RootScaleX, RootScaleY);
	ResLabel.ManagerResized(RootScaleX, RootScaleY);
	ChangeDriver.ManagerResized(RootScaleX, RootScaleY);

	for ( i=0; i<ArrayCount(Resolutions); i++ )
	{
		Resolutions[i].ManagerResized(RootScaleX, RootScaleY);
	}

	if ( BrightnessSlider != None ) 
		BrightnessSlider.ManagerResized(RootScaleX, RootScaleY);

	ResLabel.Text = GetPlayerOwner().ConsoleCommand("GetCurrentRes"); 
}


function Paint(Canvas C, float X, float Y)
{
	local int i;
	//local string res;
	local color textcolor;

	Super.Paint(C, X, Y);

	Super.PaintSmoke(C, OK, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, Advanced, SmokingWindows[1], SmokingTimers[1]);
	Super.PaintSmoke(C, Cancel, SmokingWindows[2], SmokingTimers[2]);

	//res = GetPlayerOwner().ConsoleCommand("GetCurrentRes");
	//reslabel.text = res;

	for ( i=0; i<ArrayCount(Resolutions); i++ )
	{
		if ( ResLabel.Text ~= Resolutions[i].Text )
		{
			//DrawStretchedTexture(C, Resolutions[i].WinLeft, Resolutions[i].WinTop, Resolutions[i].WinWidth, Resolutions[i].WinHeight, texture'Aeons.Particles.SOft_pfx');		
			Resolutions[i].UpTexture = texture'Video_resol_dn';
			Resolutions[i].DownTexture = texture'Video_resol_up';
			Resolutions[i].OverTexture = texture'Video_resol_dn';
		} else {
			Resolutions[i].UpTexture =   texture'Video_resol_up';
			Resolutions[i].DownTexture = texture'Video_resol_dn';
			Resolutions[i].OverTexture = texture'Video_resol_ov';
		}
	}

	C.DrawColor = C.Default.DrawColor;
	C.Style = 1;

}


function Close(optional bool bByParent)
{
	if ( bSaveChanges ) 
		SaveChanges();
	else
		UndoChanges();

	bSaveChanges = false;

	HideWindow();
}


function ShowWindow()
{
	Super.ShowWindow();

	GetCurrentSettings();
	GetStartingRow();
	RefreshButtons();
}


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
     ChangeSound=Sound'Shell_HUD.Shell.SHELL_SliderClick'
     BackNames(0)="UndyingShellPC.Video_0"
     BackNames(1)="UndyingShellPC.Video_1"
     BackNames(2)="UndyingShellPC.Video_2"
     BackNames(3)="UndyingShellPC.Video_3"
     BackNames(4)="UndyingShellPC.Video_4"
     BackNames(5)="UndyingShellPC.Video_5"
}
