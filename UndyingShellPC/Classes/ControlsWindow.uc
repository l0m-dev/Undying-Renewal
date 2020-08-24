//=============================================================================
// ControlsWindow.
//=============================================================================
class ControlsWindow expands ShellWindow;

//#exec OBJ LOAD FILE=\aeons\sounds\Shell_HUD.uax PACKAGE=Shell_HUD

// Textures ////////////////////////////////////////////////
//#exec Texture Import File=Controls_0.bmp Mips=Off
//#exec Texture Import File=Controls_1.bmp Mips=Off
//#exec Texture Import File=Controls_2.bmp Mips=Off
//#exec Texture Import File=Controls_3.bmp Mips=Off
//#exec Texture Import File=Controls_4.bmp Mips=Off
//#exec Texture Import File=Controls_5.bmp Mips=Off

//#exec Texture Import File=cntrl_ok_ov.BMP	Mips=Off
//#exec Texture Import File=cntrl_ok_up.BMP	Mips=Off
//#exec Texture Import File=cntrl_ok_dn.BMP	Mips=Off

//#exec Texture Import File=cntrl_cancl_ov.BMP	Mips=Off
//#exec Texture Import File=cntrl_cancl_up.BMP	Mips=Off
//#exec Texture Import File=cntrl_cancl_dn.BMP	Mips=Off

//#exec Texture Import File=Cntrl_defau_up.bmp	Mips=Off
//#exec Texture Import File=Cntrl_dafau_ov.bmp	Mips=Off
//#exec Texture Import File=Cntrl_defau_dn.bmp	Mips=Off

//#exec Texture Import File=Cntrl_upbut_up.BMP	Mips=Off
//#exec Texture Import File=Cntrl_upbut_ov.BMP	Mips=Off
//#exec Texture Import File=Cntrl_upbut_dn.BMP	Mips=Off
//#exec Texture Import File=Cntrl_upbut_ds.BMP	Mips=Off

//#exec Texture Import File=Cntrl_dnbut_up.BMP	Mips=Off
//#exec Texture Import File=Cntrl_dnbut_ov.BMP	Mips=Off
//#exec Texture Import File=Cntrl_dnbut_dn.BMP	Mips=Off
//#exec Texture Import File=Cntrl_dnbut_ds.BMP	Mips=Off


//#exec Texture Import File=cntrl_slidr.BMP	Mips=Off
//#exec Texture Import File=cntrl_selec.BMP	Mips=Off

// Controls /////////////////////////////////////////////////

var UWindowWindow AdvControls;

var ShellButton		Advanced;
var ShellButton		OK;
var ShellButton		Cancel;
var ShellButton		DefaultsButton;
var ShellButton		Commands[7];
var ShellButton		AltCommands[7];
var ShellButton		Down;
var ShellButton		Up;
var ShellButton		CrossHairButton;

var ShellSlider		SensitivitySlider;

var ShellCheckbox	InvertMouse;

//var ShellLabel		Actions[7];
var ShellButton		Actions[7];

var ShellButton		SelectedButton;

var() sound ChangeSound;
var() sound CheckboxSound;
var bool bInitialized;


//var ShellSlider   Sensitivity;

var int		SmokingWindows[4];
var float	SmokingTimers[4];

// Variables ////////////////////////////////////////////////
var bool bInvertMouse, OrigbInvertMouse;
var float OrigSensitivity;

var texture CurrentCrossHair;

var bool	bSelecting;
var bool 	bWasSelecting;
var bool	bIsAlternate;

var int		SelectedRow, SelectedCol;

var int		CurrentRow;
var int		VisibleRows;

var bool bSaveChanges;

var string MenuValues1[70], OrigMenuValues1[70];
var string MenuValues2[70], OrigMenuValues2[70];

var localized string AliasNames[70];
var int AliasCount;

var localized string LabelList[70];


// Functions ////////////////////////////////////////////////
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

	SmokingWindows[0] = -1;
	SmokingWindows[1] = -1;
	SmokingWindows[2] = -1;
	SmokingWindows[3] = -1;

//create components
	for( i=0; i<7; i++ )
	{
		Actions[i] = ShellButton(CreateWindow(class'ShellButton', 180*RootScaleX, 178*RootScaleY, 208*RootScaleX, 26*RootScaleY));

		Actions[i].Template = NewRegion(180, 178+(26+10)*i,208,26);

		Actions[i].Manager = Self;

		Actions[i].Align = TA_Center;
		Actions[i].Text = "";
		Actions[i].TextX = 0;
		Actions[i].TextY = 0;

		Actions[i].TextStyle = 3;

		TextColor.R = 235;
		TextColor.G = 179;
		TextColor.B = 29;
		Actions[i].SetTextColor(TextColor);
		Actions[i].Font = 4;

		/*
		Actions[i].UpTexture =			texture'Engine.DefaultTexture';
		Actions[i].DownTexture =		texture'Engine.DefaultTexture';
		Actions[i].OverTexture =		texture'Engine.DefaultTexture';
		Actions[i].DisabledTexture =	None;
		*/
	}

// Command clickable regions
	for( i=0; i<7; i++ )
	{
		Commands[i] = ShellButton(CreateWindow(class'ShellButton', 390*RootScaleX, 178*RootScaleY, 165*RootScaleX, 26*RootScaleY));

		//Commands[i].TexCoords = NewRegion(0,0,64,64);
		Commands[i].Template = NewRegion(390,178+(26+10)*i,165,26);

		Commands[i].Manager = Self;
		Commands[i].Align = TA_Center;
		Commands[i].Text = "";
		Commands[i].TextX = 0;
		Commands[i].TextY = 0;

		Commands[i].TextStyle = 3;

		TextColor.R = 192;
		TextColor.G = 192;
		TextColor.B = 192;
		Commands[i].SetTextColor(TextColor);
		Commands[i].Font = 4;

		/*
		Commands[i].UpTexture =			texture'Engine.DefaultTexture';
		Commands[i].DownTexture =		texture'Engine.DefaultTexture';
		Commands[i].OverTexture =		texture'Engine.DefaultTexture';
		Commands[i].DisabledTexture =	None;
		*/
	}
	
	
// AltCommand clickable regions
	for( i=0; i<7; i++ )
	{
		AltCommands[i] = ShellButton(CreateWindow(class'ShellButton', 563*RootScaleX, 178*RootScaleY, 165*RootScaleX, 26*RootScaleY));

		//AltCommands[i].TexCoords = NewRegion(0,0,64,64);
		AltCommands[i].Template = NewRegion(563,178+(26+10)*i,165,26);

		AltCommands[i].Manager = Self;
		AltCommands[i].Align = TA_Center;
		AltCommands[i].Text = "";
		AltCommands[i].TextX = 0;
		AltCommands[i].TextY = 0;
		
		AltCommands[i].TextStyle = 3;
		
		TextColor.R = 192;
		TextColor.G = 192;
		TextColor.B = 192;
		AltCommands[i].SetTextColor(TextColor);
		AltCommands[i].Font = 4;

		/*
		AltCommands[i].UpTexture =			texture'Engine.DefaultTexture';
		AltCommands[i].DownTexture =		texture'Engine.DefaultTexture';
		AltCommands[i].OverTexture =		texture'Engine.DefaultTexture';
		AltCommands[i].DisabledTexture =	None;
		*/
	}
	

// scroll buttons
	Up =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	Down =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	Up.Style = 5;
	Down.Style = 5;

	Up.Template =	NewRegion(724,150,64,128);
	Down.Template = NewRegion(722,342,64,128);

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


// OK Button
	OK = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	OK.TexCoords = NewRegion(0,0,160,64);
	OK.Template = NewRegion(10,392,160,64);

	OK.Manager = Self;
	OK.Style = 5;

	OK.bBurnable = true;
	OK.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	OK.UpTexture =   texture'cntrl_ok_up';
	OK.DownTexture = texture'cntrl_ok_dn';
	OK.OverTexture = texture'cntrl_ok_ov';
	OK.DisabledTexture = None;

// Cancel Button
	Cancel = ShellButton(CreateWindow(class'ShellButton', 30*RootScaleX, 500*RootScaleY, 138*RootScaleX, 60*RootScaleY));

	Cancel.TexCoords = NewRegion(0,0,160,64);

	// position and size in designed resolution of 800x600
	Cancel.Template = NewRegion(20,507,160,64);

	Cancel.Manager = Self;
	Cancel.Style = 5;

	Cancel.bBurnable = true;
	Cancel.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Cancel.UpTexture =   texture'cntrl_cancl_up';
	Cancel.DownTexture = texture'cntrl_cancl_dn';
	Cancel.OverTexture = texture'cntrl_cancl_ov';
	Cancel.DisabledTexture = None;

// DefaultsButton Button
	DefaultsButton = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	DefaultsButton.TexCoords = NewRegion(0,0,150,64);

	// position and size in designed resolution of 800x600
	DefaultsButton.Template = NewRegion(20,40,150,64);

	DefaultsButton.Manager = Self;
	DefaultsButton.Style = 5;

	DefaultsButton.bBurnable = true;
	DefaultsButton.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	DefaultsButton.UpTexture =   texture'Cntrl_defau_up';
	DefaultsButton.DownTexture = texture'Cntrl_defau_dn';
	DefaultsButton.OverTexture = texture'Cntrl_dafau_ov';
	DefaultsButton.DisabledTexture = None;

// Advanced button
	Advanced = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	Advanced.Template = NewRegion(20,150,160,64);

	Advanced.TexCoords = NewRegion(0,0,160,64);

	Advanced.Manager = Self;
	Advanced.Style = 5;

	Advanced.bBurnable = true;
	Advanced.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Advanced.UpTexture =   texture'video_advan_up';
	Advanced.DownTexture = texture'video_advan_dn';
	Advanced.OverTexture = texture'video_advan_ov';
	Advanced.DisabledTexture = None;





	// CrossHair Button
	CrossHairButton = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	//CrossHairButton.TexCoords = NewRegion(0,0,16,16);
	CrossHairButton.Template = NewRegion(710,510,24,24);

	CrossHairButton.Manager = Self;

	//CrossHairButton.DownSound = Sound(DynamicLoadObject("LevelMechanics.Catacombs.A14_WoodCrk02", class'Sound'));

	CrossHairButton.UpTexture =			None;
	CrossHairButton.DownTexture =		None;
	CrossHairButton.OverTexture =		None;
	CrossHairButton.DisabledTexture =	None;

	// InvertMouse
	InvertMouse = ShellCheckbox(CreateWindow(class'ShellCheckBox', 1,1,1,1));

	InvertMouse.TexCoords = NewRegion(0,0,39,37);
	InvertMouse.Template = NewRegion(313,465,39,37);

	InvertMouse.Manager = Self;
	InvertMouse.Text = "";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	InvertMouse.SetTextColor(TextColor);
	InvertMouse.Font = 0;

	InvertMouse.UpTexture =   None;
	InvertMouse.DownTexture = texture'audio_x';
	InvertMouse.OverTexture = None;
	InvertMouse.DisabledTexture = None;


	// Sensitivy Slider
	SensitivitySlider = ShellSlider(CreateWindow(class'ShellSlider', 393*RootScaleX, 456*RootScaleY, 224*RootScaleX, 24*RootScaleY));

	SensitivitySlider.TexCoords = NewRegion(0,0,32,32);
	SensitivitySlider.Template = NewRegion(393,456,224,24);
	SensitivitySlider.SetSlider(0,0,32,32);

	SensitivitySlider.bNoSlidingNotify = true;

	SensitivitySlider.SetRange(0.5, 8.0, 0.1);
	SensitivitySlider.SetValue(3.0);

	SensitivitySlider.Manager = Self;
	SensitivitySlider.Text = "";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	SensitivitySlider.SetTextColor(TextColor);
	SensitivitySlider.Font = 0;

	SensitivitySlider.UpTexture =   texture'cntrl_slidr';//'cntrl_slider';
	SensitivitySlider.DownTexture = texture'cntrl_slidr';//'cntrl_slider';
	SensitivitySlider.OverTexture = texture'cntrl_slidr';
	SensitivitySlider.DisabledTexture = None;


// end of creation
	bAcceptsFocus = true;
	bleaveonscreen = true;
	Root.Console.bBlackout = True;

	// equivalent of LoadExistingKeys()
	GetCurrentSettings(true);

	Resized();

	bInitialized=True;
}


function GetCurrentSettings(bool bResetOrig)
{
	local int I, J, pos;
	local string KeyName;
	local string Alias;
	local int CrossHair;

	CrossHair = GetPlayerOwner().MyHud.CrossHair;

	CurrentCrossHair = AeonsHUD(GetPlayerOWner().myHUd).CrossHairs[ CrossHair ];
/*	
	if ( CurrentCrossHair != None )
	{
		CrossHairButton.UpTexture = CurrentCrossHair;
		CrossHairButton.DownTexture = CurrentCrossHair;
		CrossHairButton.OverTexture = CurrentCrossHair;
	}
*/
	// get current values and save
	OrigSensitivity = GetPlayerOWner().MouseSensitivity;
	OrigbInvertMouse = GetPlayerOwner().bInvertMouse;

	// link up shell components with variables
	InvertMouse.bChecked = OrigbInvertMouse;
	SensitivitySlider.SetValue( OrigSensitivity );


	for (I=0; I<AliasCount; I++)
	{
		MenuValues1[I] = "";
		MenuValues2[I] = "";
	}

	for (I=0; I<255; I++)
	{
		KeyName = GetPlayerOwner().ConsoleCommand( "KEYNAME "$i );

		if ( KeyName != "" )
		{
			Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING "$KeyName );
			if ( Alias != "" )
			{
				pos = InStr(Alias, " ");
				if ( pos != -1 )
				{
					if( !(Left(Alias, pos) ~= "taunt") &&
						!(Left(Alias, pos) ~= "getweapon") &&
						!(Left(Alias, pos) ~= "viewplayernum"))
						Alias = Left(Alias, pos);
				}
				for (J=0; J<AliasCount; J++)
				{
					if ( AliasNames[J] ~= Alias && AliasNames[J] != "None" )
					{
						if ( MenuValues1[J] == "" )
							MenuValues1[J] = KeyName;
						else if ( MenuValues2[J] == "" )
							MenuValues2[J] = KeyName;
					}
				}
			}
		}
	}

	//ScrolledUp();
	if ( bResetOrig )
	{
		for (I=0; I<AliasCount; I++)
		{
			OrigMenuValues1[I] = MenuValues1[I];
			OrigMenuValues2[I] = MenuValues2[I];
		}

		CurrentRow = 0;
		Up.bDisabled = true;
		Down.bDisabled = false;
		//Up.HideWindow();
		//Down.showWindow();
	}

	RefreshButtons();


	// Will save changes by default
	bSaveChanges = True;
}


function RemoveExistingKey(int KeyNo, string KeyName)
{
	local int I;

	// Remove this key from any existing binding display
	for ( I=0; I<AliasCount; I++ )
	{
		if(I != SelectedRow)
		{
			if ( MenuValues2[I] ~= KeyName )
				MenuValues2[I] = "";

			if ( MenuValues1[I] ~= KeyName )
			{
				MenuValues1[I] = MenuValues2[I];
				MenuValues2[I] = "";
			}
		}
	}
}

function RefreshButtons()
{
	local int i;

	for( i=0; i<VisibleRows; i++ )
	{
		Actions[i].Text = LabelList[CurrentRow + i];
		Commands[i].Text = MenuValues1[CurrentRow + i];
		AltCommands[i].Text = MenuValues2[CurrentRow + i];
	}

}


function SetKey(int KeyNo, string KeyName)
{
	
	if ( bSelecting )
	{
		if ( SelectedButton != None ) 
		{
			switch( SelectedCol )
			{
				case 0:
					if ( KeyName == MenuValues2[SelectedRow] )
					{
						MenuValues2[SelectedRow] = "";
					}
					GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues1[SelectedRow]);
					MenuValues1[SelectedRow] = KeyName;
					SelectedButton.Text = MenuValues1[SelectedRow];
					
					if ( KeyName ~= "RightMouse" )
						GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames[SelectedRow] $ " | SetFavorite" );		
					else
						GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames[SelectedRow]);					
					
					break;
					
				case 1:
					if ( KeyName == MenuValues1[SelectedRow] )
					{
						MenuValues1[SelectedRow] = "";
					}
					GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues2[SelectedRow]);
					MenuValues2[SelectedRow] = KeyName;
					SelectedButton.Text = MenuValues2[SelectedRow];

					if ( KeyName ~= "RightMouse" )
						GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames[SelectedRow] $ " | SetFavorite" );		
					else
						GetPlayerOwner().ConsoleCommand("SET Input"@KeyName@AliasNames[SelectedRow]);
					
					break;					
			}
		}

		bSelecting = false;
		SelectedButton = None;
		SelectedCol = -1;
		SelectedRow = -1;

		RefreshButtons();
	}	
}


function UndoChanges()
{
	local int i;
	
	GetPlayerOwner().bInvertMouse = OrigbInvertMouse;
	GetPlayerOwner().MouseSensitivity = OrigSensitivity;

	// Wipe out existing key bindings
	for ( i=0; i<AliasCount; i++ )
	{
		if ( MenuValues1[i] != "" )
			if ( MenuValues1[i] ~= "RightMouse" )
				GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues1[i] $ " | SetFavorite" );
			else
				GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues1[i] $ " ");

		if ( MenuValues2[i] != "" )
			if ( MenuValues1[i] ~= "RightMouse" )
				GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues2[i] $ " | SetFavorite" );
			else
				GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues2[i] $ " ");
	}

	// Restore original key bindings
	for ( i=0; i<AliasCount; i++ )
	{
		if ( OrigMenuValues1[i] != "" )
			if ( OrigMenuValues1[i] ~= "RightMouse" )
				GetPlayerOwner().ConsoleCommand("SET Input"@OrigMenuValues1[i]@AliasNames[i] $ " | SetFavorite" );
			else
				GetPlayerOwner().ConsoleCommand("SET Input"@OrigMenuValues1[i]@AliasNames[i]);

		if ( OrigMenuValues2[i] != "" )
			if ( OrigMenuValues2[i] ~= "RightMouse" )
				GetPlayerOwner().ConsoleCommand("SET Input"@OrigMenuValues2[i]@AliasNames[i] $ " | SetFavorite" );
			else
				GetPlayerOwner().ConsoleCommand("SET Input"@OrigMenuValues2[i]@AliasNames[i]);
	}

	// ? GetPlayerOwner().SaveConfig();
}

function SaveChanges()
{
	GetPlayerOwner().SaveConfig();
}

// Ideally Key would be a EInputKey but I can't see that class here.
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{


	switch(Msg)
	{
		case WM_LMouseDown:
			LMouseDown(X, Y);

			if (bSelecting)
			{
				ProcessMenuKey( 1, mid(string(GetEnum(enum'EInputKey', 1)),3) );
				bSelecting = False;
				return;
			}

			break;	

		case WM_LMouseUp:
			LMouseUp(X, Y);
			break;	

		case WM_RMouseDown:
			if (bSelecting)
			{
				ProcessMenuKey( 2, mid(string(GetEnum(enum'EInputKey', 2)),3) );
				bSelecting = False;
			}
			RMouseDown(X, Y);
			break;	

		case WM_RMouseUp:
			RMouseUp(X, Y);
			break;	

		case WM_MMouseDown:

			if (bSelecting)
			{
				ProcessMenuKey( 4, mid(string(GetEnum(enum'EInputKey', 4)),3) );
				bSelecting = False;
			}
		
			MMouseDown(X, Y);
			
			break;

		case WM_MMouseUp:
			MMouseUp(X, Y);
			break;	

		case WM_KeyDown:
			KeyDown(Key, X, Y);
			break;	

		case WM_KeyUp:
			KeyUp(Key, X, Y);
			break;	

		case WM_KeyType:
			KeyType(Key, X, Y);
			break;	

		default:
			break;
	}

	Super.WindowEvent(Msg, C, X, Y, Key);
}


function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:

			if ( ShellButton(B).bDisabled ) 
				return;

			switch (B)
			{
				case Commands[0]:
					ClickedButton( B, 0, 0  );
					break;
				case Commands[1]:
					ClickedButton( B, 1, 0  );
					break;
				case Commands[2]:
					ClickedButton( B, 2, 0  );
					break;
				case Commands[3]:
					ClickedButton( B, 3, 0  );
					break;
				case Commands[4]:
					ClickedButton( B, 4, 0  );
					break;
				case Commands[5]:
					ClickedButton( B, 5, 0  );
					break;
				case Commands[6]:
					ClickedButton( B, 6, 0  );
					break;
				case AltCommands[0]:
					ClickedButton( B, 0, 1  );
					break;
				case AltCommands[1]:
					ClickedButton( B, 1, 1  );
					break;
				case AltCommands[2]:
					ClickedButton( B, 2, 1  );
					break;
				case AltCommands[3]:
					ClickedButton( B, 3, 1  );
					break;
				case AltCommands[4]:
					ClickedButton( B, 4, 1  );
					break;
				case AltCommands[5]:
					ClickedButton( B, 5, 1  );
					break;
				case AltCommands[6]:
					ClickedButton( B, 6, 1  );
					break;

				case CrossHairButton:
					CrossHairChanged();
					break;

				case Up:
					ScrolledUp();
					break;

				case Down:
					ScrolledDown();
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

				case Advanced:
					AdvancedPressed();
					break;
					
				case DefaultsButton:
					ResetDefaults();
					//GetPlayerOwner().ResetKeyboard();
					//GetCurrentSettings();
					break;
			}
			break;

		case DE_Change:
			switch (B)
			{
				case InvertMouse:
					InvertMouseChanged();
					break;

				case SensitivitySlider:
					SensitivityChanged();
					break;

			}
			break;

		case DE_MouseEnter:
			OverEffect(ShellButton(B));
			break;
	}
}

function AdvancedPressed()
{
	PlayNewScreenSound();

	if (AdvControls == None ) 
		AdvControls = ManagerWindow(Root.CreateWindow(class'AdvControlWindow', 100, 100, 200, 200, Root, True));
	else
		AdvControls.ShowWindow();		
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
	
		case DefaultsButton:
			SmokingWindows[2] = 1;
			SmokingTimers[2] = 90;
			break;

		case Advanced:
			SmokingWindows[3] = 1;
			SmokingTimers[3] = 90;
			break;
	}
}

function ResetDefaults()
{
	local int i;

	PlayNewScreenSound();

	// Wipe out existing key bindings
	for ( i=0; i<AliasCount; i++ )
	{
		if ( MenuValues1[i] != "" )
			if ( MenuValues1[i] ~= "RightMouse" )
				GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues1[i] $ " | SetFavorite" );
			else
				GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues1[i] $ " ");

		if ( MenuValues2[i] != "" )
			if ( MenuValues1[i] ~= "RightMouse" )
				GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues2[i] $ " | SetFavorite" );
			else
				GetPlayerOwner().ConsoleCommand("SET Input"@MenuValues2[i] $ " ");
	}

	GetPlayerOwner().ResetKeyboard();
	GetCurrentSettings(false);
}


function CrossHairChanged()
{
	local int CrossHair;


	GetPlayerOWner().ChangeCrossHair();

	CrossHair = GetPlayerOwner().MyHud.CrossHair;
	
	CurrentCrossHair = AeonsHUD(GetPlayerOWner().myHUd).CrossHairs[ CrossHair ];

	if ( (ChangeSound != none) && bInitialized ) 
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

//	GetPlayerOwner().ConsoleCommand("testSaveShot");

/*	
	if ( CurrentCrossHair != None )
	{
		CrossHairButton.UpTexture = CurrentCrossHair;
		CrossHairButton.DownTexture = CurrentCrossHair;
		CrossHairButton.OverTexture = CurrentCrossHair;
	}
*/
}

function RestoreButton()
{
	if ( SelectedRow == 0 ) 
	{
		SelectedButton.Text = MenuValues1[SelectedRow];
	}
	else
	{
		SelectedButton.Text = MenuValues2[SelectedRow];
	}

	bSelecting = false;
	SelectedButton = None;
	SelectedRow = -1;
	SelectedCol = -1;
}


function ClickedButton( UWindowWindow B, int Row, int Col ) 
{
	
	if ( bSelecting == true )
	{
	}
	else
	{
		if ( !bWasSelecting )
		{
			bSelecting = true;

			SelectedButton = ShellButton(B);
			SelectedButton.Text = "?";
			
			SelectedCol = Col;
			SelectedRow = Row+CurrentRow;
		}			
	}
}


function KeyDown( int Key, float X, float Y )
{

	if (bSelecting)
	{
		ProcessMenuKey( Key, mid(string(GetEnum(enum'EInputKey',Key)),3) );
		bSelecting = False;
		bWasSelecting = True;
	}
}


function ProcessMenuKey( int KeyNo, string KeyName )
{
	if ( KeyName == "Escape" )
	{
		if ( bSelecting )
		{ 
			bSelecting = false;
			SelectedCol = -1;
			SelectedRow = -1;
		}
	}
	
	if ( (KeyName == "") || (KeyName == "Escape") || (KeyName == "Pause") )
//		|| ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) // function keys
//		|| ((KeyNo >= 0x30 ) && (KeyNo <= 0x39))) // number keys
		return;

	RemoveExistingKey(KeyNo, KeyName);
	SetKey(KeyNo, KeyName);
}


function ScrolledUp()
{
	local int i;

//	changedsound = Sound(DynamicLoadObject("LevelMechanics.Catacombs.A14_WoodCrk02", class'Sound'));

	if ( (ChangeSound != none) && bInitialized ) 
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

	CurrentRow--;

	if ( CurrentRow <= 0 ) 
	{
		CurrentRow = 0;

		Up.bDisabled = true;
		//Up.HideWindow();
	}

	if ( CurrentRow < AliasCount - VisibleRows )
	{
		Down.bDisabled = false;
		//Down.showWindow();
	}

	RefreshButtons();

}


function ScrolledDown()
{
	local int i;
//	local sound changedsound;

//	if ( changedsound == None )
//		changedsound = Sound(DynamicLoadObject("LevelMechanics.Catacombs.A14_WoodCrk02", class'Sound'));

	if ( (ChangeSound != none) && bInitialized ) 
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

	CurrentRow++;

	if ( CurrentRow + VisibleRows >= AliasCount ) 
	{
		Down.bDisabled = true;
		//Down.HideWindow();	
	}

	if ( CurrentRow > 0 ) 
	{
		Up.bDisabled = false;
		//Up.ShowWindow();
	}

	RefreshButtons();
}


function InvertMouseChanged()
{
//	local sound changedsound;

//	changedsound = Sound(DynamicLoadObject("LevelMechanics.Catacombs.A14_WoodCrk02", class'Sound'));

	if ( (CheckboxSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( CheckboxSound,, 0.25, [Flags]482 );

	GetPlayerOwner().bInvertMouse = InvertMouse.bChecked;
}

function SensitivityChanged()
{
//	local sound changedsound;

//	changedsound = Sound(DynamicLoadObject("LevelMechanics.Catacombs.A14_WoodCrk02", class'Sound'));

	if ( (ChangeSound != none ) && bInitialized )
		GetPlayerOwner().PlaySound( ChangeSound, SLOT_Misc, 0.25,,,1.0, [Flags]482 );
	
	GetPlayerOwner().MouseSensitivity = SensitivitySlider.Value;
}

function Resized()
{
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;
	local int i;

	Super.Resized();

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}

	if ( AdvControls != None )
		AdvControls.Resized();

	Advanced.ManagerResized(RootScaleX, RootScaleY);

	if ( OK != None )
		OK.ManagerResized(RootScaleX, RootScaleY);

	if ( Cancel != None )
		Cancel.ManagerResized(RootScaleX, RootScaleY);

	if ( DefaultsButton != None )
		DefaultsButton.ManagerResized(RootScaleX, RootScaleY);

	if ( Up != None ) 
		Up.ManagerResized(RootScaleX, RootScaleY);

	if ( Down != None ) 
		Down.ManagerResized(RootScaleX, RootScaleY);

	if ( SensitivitySlider != None )
		SensitivitySlider.ManagerResized(RootScaleX, RootScaleY);

	if ( InvertMouse != None ) 
		InvertMouse.ManagerResized(RootScaleX, RootScaleY);

	if ( CrossHairButton != None )
		CrossHairButton.ManagerResized(RootScaleX, RootScaleY);

	for( i=0; i<7; i++ )
	{
		if ( AltCommands[i]!= None )
			AltCommands[i].ManagerResized(RootScaleX, RootScaleY);

		if ( Commands[i]!= None )
			Commands[i].ManagerResized(RootScaleX, RootScaleY);
		
		if ( Actions[i]!= None )
			Actions[i].ManagerResized(RootScaleX, RootScaleY);
	}


}

function Paint(Canvas C, float X, float Y)
{
	local int W, H;
	local color col;

	Super.Paint(C, X, Y);

	Super.PaintSmoke(C, OK, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, Cancel, SmokingWindows[1], SmokingTimers[1]);
	Super.PaintSmoke(C, DefaultsButton, SmokingWindows[2], SmokingTimers[2]);
	Super.PaintSmoke(C, Advanced, SmokingWindows[3], SmokingTimers[3]);

	if ( bWasSelecting )
		bWasSelecting = False;

	col = GetPlayerOwner().CrossHairColor;

	C.DrawColor = col;

	//C.DrawColor.r = 201;
	//C.DrawColor.g = 47;
	//C.DrawColor.b = 0;	

	C.Style = 3;
	
	DrawStretchedTexture(C, CrossHairButton.WinLeft, CrossHairButton.WinTop, CrossHairButton.WinWidth, CrossHairButton.WinHeight, CurrentCrossHair);

	if ( SelectedRow >= 0 )
	{
		C.DrawColor.r = 255;
		C.DrawColor.g = 0;
		C.DrawColor.b = 0;

		W = AltCommands[SelectedROw-CurrentRow].WinLeft + AltCommands[SelectedROw-CurrentRow].WinWidth - Actions[SelectedROw-CurrentRow].WinLeft;
		H = Actions[SelectedROw-CurrentRow].WinHeight;

		DrawStretchedTexture(C, Actions[SelectedROw-CurrentRow].WinLeft, Actions[SelectedROw-CurrentRow].WinTop, W, H, texture'Aeons.cntrl_selec');
	} 

	C.DrawColor.r = 255;
	C.DrawColor.g = 255;
	C.DrawColor.b = 255;	

	C.Style = 1;	


/*
	C.DrawColor.r = 201;
	C.DrawColor.g = 47;
	C.DrawColor.b = 0;	

	C.SetPos(706*Scale, 506*Scale );
	C.Style = 3;

	C.DrawIcon(Texture'Aeons.Crosshair1', Scale);

	C.DrawColor = C.Default.DrawColor;
*/
}


function Close(optional bool bByParent)
{

	if ( bSelecting )
	{
		RestoreButton();
		return;
	}

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

	GetCurrentSettings(true);
}


function HideWindow()
{
	Root.Console.bBlackOut = False;
	Super.HideWindow();
}

defaultproperties
{
     ChangeSound=Sound'Shell_HUD.Shell.SHELL_SliderClick'
     CheckboxSound=Sound'Shell_HUD.Shell.SHELL_CheckBox'
     VisibleRows=7
     AliasNames(0)="Fire"
     AliasNames(1)="SelectWeapon"
     AliasNames(2)="FireAttSpell"
     AliasNames(3)="SelectAttSpell"
     AliasNames(4)="WeaponAction"
     AliasNames(5)="MoveForward"
     AliasNames(6)="MoveBackward"
     AliasNames(7)="StrafeLeft"
     AliasNames(8)="StrafeRight"
     AliasNames(9)="TurnLeft"
     AliasNames(10)="TurnRight"
     AliasNames(11)="LookUp"
     AliasNames(12)="LookDown"
     AliasNames(13)="Duck"
     AliasNames(14)="Jump"
     AliasNames(15)="Look"
     AliasNames(16)="Sneak"
     AliasNames(17)="Strafe"
     AliasNames(18)="InventoryPrevious"
     AliasNames(19)="InventoryNext"
     AliasNames(20)="InventoryActivate"
     AliasNames(21)="PrevWeapon"
     AliasNames(22)="NextWeapon"
     AliasNames(23)="PrevAttSpell"
     AliasNames(24)="NextAttSpell"
     AliasNames(25)="CenterView"
     AliasNames(26)="QuickSave"
     AliasNames(27)="QuickLoad"
     AliasNames(28)="Revolver"
     AliasNames(29)="Gelziabar"
     AliasNames(30)="Scythe"
     AliasNames(31)="WarCannon"
     AliasNames(32)="Shotgun"
     AliasNames(33)="Speargun"
     AliasNames(34)="Phoenix"
     AliasNames(35)="Molotov"
     AliasNames(36)="Ectoplasm"
     AliasNames(37)="DispelMagic"
     AliasNames(38)="Lightning"
     AliasNames(39)="Haste"
     AliasNames(40)="SkullStorm"
     AliasNames(41)="Scrye"
     AliasNames(42)="Shield"
     AliasNames(43)="Invoke"
     AliasNames(44)="PickDynamite"
     AliasNames(45)="PickSilverBullet"
     AliasNames(46)="PickPhosphorusShell"
     AliasNames(47)="PickAmplifier"
     AliasNames(48)="PickEtherTrap"
     AliasNames(49)="ShowBook"
     AliasCount=50
     LabelList(0)="Weapon Fire"
     LabelList(1)="Weapon Select"
     LabelList(2)="Spell Fire"
     LabelList(3)="Spell Select"
     LabelList(4)="Weapon Action"
     LabelList(5)="Forward"
     LabelList(6)="Backward"
     LabelList(7)="Step Left"
     LabelList(8)="Step Right"
     LabelList(9)="Turn Left"
     LabelList(10)="Turn Right"
     LabelList(11)="Look Up"
     LabelList(12)="Look Down"
     LabelList(13)="Duck"
     LabelList(14)="Jump"
     LabelList(15)="Mouse Look"
     LabelList(16)="Sneak (toggle)"
     LabelList(17)="Strafe Modifier"
     LabelList(18)="Previous Inventory"
     LabelList(19)="Next Inventory"
     LabelList(20)="Use Inventory"
     LabelList(21)="Previous Weapon"
     LabelList(22)="Next Weapon"
     LabelList(23)="Previous Spell"
     LabelList(24)="Next Spell"
     LabelList(25)="Center View"
     LabelList(26)="Quick Save"
     LabelList(27)="Quick Load"
     LabelList(28)="Revolver"
     LabelList(29)="Gel'ziabar Stone"
     LabelList(30)="Scythe"
     LabelList(31)="War Cannon"
     LabelList(32)="Shotgun"
     LabelList(33)="Speargun"
     LabelList(34)="Phoenix"
     LabelList(35)="Molotov"
     LabelList(36)="Ectoplasm"
     LabelList(37)="Dispel Magic"
     LabelList(38)="Lightning"
     LabelList(39)="Haste"
     LabelList(40)="Skull Storm"
     LabelList(41)="Scrye"
     LabelList(42)="Shield"
     LabelList(43)="Invoke"
     LabelList(44)="Dynamite"
     LabelList(45)="Silver Bullets"
     LabelList(46)="Phosphorus Shells"
     LabelList(47)="Amplifier"
     LabelList(48)="Ether Trap"
     LabelList(49)="Show Journal"
     BackNames(0)="UndyingShellPC.Controls_0"
     BackNames(1)="UndyingShellPC.Controls_1"
     BackNames(2)="UndyingShellPC.Controls_2"
     BackNames(3)="UndyingShellPC.Controls_3"
     BackNames(4)="UndyingShellPC.Controls_4"
     BackNames(5)="UndyingShellPC.Controls_5"
}
