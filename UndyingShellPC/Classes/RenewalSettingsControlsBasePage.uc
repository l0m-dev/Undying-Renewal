class RenewalSettingsControlsBasePage extends RenewalSettingsBasePage;

var string RealKeyName[255];
var int BoundKey1[100];
var int BoundKey2[100];
var UMenuLabelControl KeyNames[100];
var UMenuRaisedButton KeyButtons[100];
var UMenuRaisedButton SelectedButton;
var string LabelList[100];
var string AliasNames[100];
var int Selection;
var bool bPolling;
var localized string OrString;
var localized string CustomizeHelp;

var UWindowSmallButton DefaultsButton;
var localized string DefaultsText;
var localized string DefaultsHelp;

/*
var UMenuLabelControl JoystickHeading;
var localized string JoystickText;

var UWindowComboControl JoyXCombo;
var localized string JoyXText;
var localized string JoyXHelp;
var localized string JoyXOptions[2];
var string JoyXBinding[2];

var UWindowComboControl JoyYCombo;
var localized string JoyYText;
var localized string JoyYHelp;
var localized string JoyYOptions[2];
var string JoyYBinding[2];
*/

var int AliasCount;
var bool bLoadedExisting;
var bool bJoystick;
var float JoyDesiredHeight, NoJoyDesiredHeight;

var UMenuLabelControl Headings[100];

function Created()
{
	local int ButtonWidth, ButtonLeft, ButtonTop, I, J, pos;
	local int LabelWidth, LabelLeft;
	local UMenuLabelControl Heading;
	local bool bTop;
	local bool bShowUndyingControls;

	bIgnoreLDoubleClick = True;
	bIgnoreMDoubleClick = True;
	bIgnoreRDoubleClick = True;

	bJoystick =	bool(GetPlayerOwner().ConsoleCommand("get windrv.windowsclient usejoystick"));

	Super.Created();

	SetAcceptsFocus();

	ButtonWidth = WinWidth - 140;
	ButtonLeft = WinWidth - ButtonWidth - 40;

	LabelWidth = WinWidth - 100;
	LabelLeft = 20;

	// Defaults Button
	DefaultsButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 30, 10, 48, 16));
	DefaultsButton.SetText(DefaultsText);
	DefaultsButton.SetFont(F_Normal);
	DefaultsButton.SetHelpText(DefaultsHelp);
	
	ButtonTop = 25;
	bTop = True;
	bShowUndyingControls = AliasNames[0] == "";
	
	for (I=0; I<ArrayCount(class'ControlsWindow'.default.AliasNames); I++)
	{
		if (bShowUndyingControls)
		{
			AliasNames[I] = class'ControlsWindow'.default.AliasNames[I];
			LabelList[I] = class'ControlsWindow'.default.LabelList[I];
		}

		if(AliasNames[I] == "")
			break;

		j = InStr(LabelList[I], ",");
		if(j != -1)
		{
			if(!bTop)
				ButtonTop += 10;
			Heading = UMenuLabelControl(CreateControl(class'UMenuLabelControl', LabelLeft-10, ButtonTop+3, WinWidth, 1));
			Heading.SetText("----"@Left(LabelList[I], j)@"----");
			Heading.SetFont(F_Normal); // 5 is almost good enough
			LabelList[I] = Mid(LabelList[I], j+1);
			Headings[I] = Heading;
			ButtonTop += 19;
		}
		bTop = False;

		KeyNames[I] = UMenuLabelControl(CreateControl(class'UMenuLabelControl', LabelLeft, ButtonTop+3, LabelWidth, 1));
		KeyNames[I].SetText(LabelList[I]);
		KeyNames[I].SetHelpText(CustomizeHelp);
		KeyNames[I].SetFont(F_Normal);
		KeyButtons[I] = UMenuRaisedButton(CreateControl(class'UMenuRaisedButton', ButtonLeft, ButtonTop, ButtonWidth, 1));
		KeyButtons[I].SetHelpText(CustomizeHelp);
		KeyButtons[I].bAcceptsFocus = False;
		KeyButtons[I].bIgnoreLDoubleClick = True;
		KeyButtons[I].bIgnoreMDoubleClick = True;
		KeyButtons[I].bIgnoreRDoubleClick = True;
		ButtonTop += 19;
	}
	AliasCount = I;

	NoJoyDesiredHeight = ButtonTop + 10;

	// Joystick
	/*
	ButtonTop += 10;
	JoystickHeading = UMenuLabelControl(CreateControl(class'UMenuLabelControl', LabelLeft-10, ButtonTop+3, WinWidth, 1));
	JoystickHeading.SetText(JoystickText);
	JoystickHeading.SetFont(F_Bold);
	LabelList[I] = Mid(LabelList[I], j+1);
	ButtonTop += 19;

	JoyXCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', 20, ButtonTop, WinWidth - 40, 1));
	JoyXCombo.CancelAcceptsFocus();
	JoyXCombo.SetText(JoyXText);
	JoyXCombo.SetHelpText(JoyXHelp);
	JoyXCombo.SetFont(F_Normal);
	JoyXCombo.SetEditable(False);
	JoyXCombo.AddItem(JoyXOptions[0]);
	JoyXCombo.AddItem(JoyXOptions[1]);
	JoyXCombo.EditBoxWidth = ButtonWidth;
	ButtonTop += 20;

	JoyYCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', 20, ButtonTop, WinWidth - 40, 1));
	JoyYCombo.CancelAcceptsFocus();
	JoyYCombo.SetText(JoyYText);
	JoyYCombo.SetHelpText(JoyYHelp);
	JoyYCombo.SetFont(F_Normal);
	JoyYCombo.SetEditable(False);
	JoyYCombo.AddItem(JoyYOptions[0]);
	JoyYCombo.AddItem(JoyYOptions[1]);
	JoyYCombo.EditBoxWidth = ButtonWidth;
	ButtonTop += 20;
	*/

	LoadExistingKeys();

	DesiredWidth = 220;
	JoyDesiredHeight = ButtonTop + 10;
	DesiredHeight = JoyDesiredHeight;
}

function WindowShown()
{
	Super.WindowShown();
	bJoystick =	bool(GetPlayerOwner().ConsoleCommand("get windrv.windowsclient usejoystick"));
	bPolling = False;
	if (SelectedButton != None)
		SelectedButton.bDisabled = False;
	LoadExistingKeys();
}

function LoadExistingKeys()
{
	local int I, J, pos;
	local string KeyName;
	local string Alias;

	for (I=0; I<AliasCount; I++)
	{
		BoundKey1[I] = 0;
		BoundKey2[I] = 0;
	}

	for (I=0; I<255; I++)
	{
		KeyName = GetPlayerOwner().ConsoleCommand( "KEYNAME "$i );
		RealKeyName[i] = KeyName;
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
						!(Left(Alias, pos) ~= "viewplayernum") &&
						!(Left(Alias, pos) ~= "button") &&
						!(Left(Alias, pos) ~= "savegame") &&
						!(Left(Alias, pos) ~= "loadgame"))
						Alias = Left(Alias, pos);
				}
				for (J=0; J<AliasCount; J++)
				{
					if ( AliasNames[J] ~= Alias && AliasNames[J] != "None" )
					{
						if ( BoundKey1[J] == 0 )
							BoundKey1[J] = i;
						else
						if ( BoundKey2[J] == 0)
							BoundKey2[J] = i;
					}
				}
			}
		}
	}

	bLoadedExisting = False;
	/*
	Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING JoyX" );
	if(Alias ~= JoyXBinding[0])
		JoyXCombo.SetSelectedIndex(0);
	if(Alias ~= JoyXBinding[1])
		JoyXCombo.SetSelectedIndex(1);

	Alias = GetPlayerOwner().ConsoleCommand( "KEYBINDING JoyY" );
	if(Alias ~= JoyYBinding[0])
		JoyYCombo.SetSelectedIndex(0);
	if(Alias ~= JoyYBinding[1])
		JoyYCombo.SetSelectedIndex(1);
	*/
	bLoadedExisting = True;
}

function string GetKeyName(int Key)
{
	return mid(string(GetEnum(enum'EInputKey', Key)),3);
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int ButtonWidth, ButtonLeft, ButtonTop, I;
	local int LabelWidth, LabelLeft;

	ButtonWidth = WinWidth - 155*Root.ScaleY;
	ButtonLeft = WinWidth - ButtonWidth - 20*Root.ScaleY;
	ButtonTop = 25 * Root.ScaleY;

	DefaultsButton.AutoWidth(C);
	DefaultsButton.WinLeft = ButtonLeft + ButtonWidth - DefaultsButton.WinWidth;

	LabelWidth = WinWidth - 100*Root.ScaleY;
	LabelLeft = 20*Root.ScaleY;

	/*
	if(bJoystick)
	{
		DesiredHeight = JoyDesiredHeight;

		JoystickHeading.ShowWindow();
		JoyXCombo.ShowWindow();
		JoyYCombo.ShowWindow();

		JoyXCombo.SetSize(WinWidth - 40*Root.ScaleY, 1*Root.ScaleY);
		JoyXCombo.EditBoxWidth = ButtonWidth;

		JoyYCombo.SetSize(WinWidth - 40*Root.ScaleY, 1*Root.ScaleY);
		JoyYCombo.EditBoxWidth = ButtonWidth;
	}
	else
	{
		DesiredHeight = NoJoyDesiredHeight;

		JoystickHeading.HideWindow();
		JoyXCombo.HideWindow();
		JoyYCombo.HideWindow();
	}
	*/

	for (I=0; I<AliasCount; I++)
	{
		if (Headings[I] != None)
		{
			if (I != 0)
				ButtonTop += 12 * Root.ScaleY;
			Headings[I].WinTop = ButtonTop;
			ButtonTop += 24 * Root.ScaleY;
		}

		KeyButtons[I].SetSize(ButtonWidth, 1);
		KeyButtons[I].WinLeft = ButtonLeft;
		KeyButtons[I].WinTop = ButtonTop;

		KeyNames[I].SetSize(LabelWidth, 1);
		KeyNames[I].WinLeft = LabelLeft;
		KeyNames[I].WinTop = ButtonTop;

		ButtonTop += 19 * Root.ScaleY;
	}

	ButtonTop += 5 * Root.ScaleY;

	DesiredHeight = ButtonTop;

	for (I=0; I<AliasCount; I++ )
	{
		if ( BoundKey1[I] == 0 )
			KeyButtons[I].SetText("");
		else
		if ( BoundKey2[I] == 0 )
			KeyButtons[I].SetText(GetKeyName(BoundKey1[I]));
		else
			KeyButtons[I].SetText(GetKeyName(BoundKey1[I])$OrString$GetKeyName(BoundKey2[I]));
	}
}

function KeyDown( int Key, float X, float Y )
{
	if (bPolling)
	{
		ProcessMenuKey(Key, RealKeyName[Key]);
		bPolling = False;
		SelectedButton.bDisabled = False;
	}
}

function RemoveExistingKey(int KeyNo, string KeyName)
{
	local int I;

	// Remove this key from any existing binding display
	for ( I=0; I<AliasCount; I++ )
	{
		if(I != Selection)
		{
			if ( BoundKey2[I] == KeyNo )
				BoundKey2[I] = 0;

			if ( BoundKey1[I] == KeyNo )
			{
				BoundKey1[I] = BoundKey2[I];
				BoundKey2[I] = 0;
			}
		}
	}
}

function BindKey(string Bind, optional bool bBindFavorite)
{
	Bind = "SET Input"@Bind;
	if (bBindFavorite)
		Bind = Bind @ "| SetFavorite";
	
	GetPlayerOwner().ConsoleCommand(Bind);
}

function SetKey(int KeyNo, string KeyName)
{
	if ( BoundKey1[Selection] != 0 )
	{
		// if this key is already chosen, just clear out other slot
		if(KeyNo == BoundKey1[Selection])
		{
			// if 2 exists, remove it it.
			if(BoundKey2[Selection] != 0)
			{
				BindKey(RealKeyName[BoundKey2[Selection]]);
				BoundKey2[Selection] = 0;
			}
		}
		else 
		if(KeyNo == BoundKey2[Selection])
		{
			// Remove slot 1
			BindKey(RealKeyName[BoundKey1[Selection]]);
			BoundKey1[Selection] = BoundKey2[Selection];
			BoundKey2[Selection] = 0;
		}
		else
		{
			// Clear out old slot 2 if it exists
			if(BoundKey2[Selection] != 0)
			{
				BindKey(RealKeyName[BoundKey2[Selection]]);
				BoundKey2[Selection] = 0;
			}

			// move key 1 to key 2, and set ourselves in 1.
			BoundKey2[Selection] = BoundKey1[Selection];
			BoundKey1[Selection] = KeyNo;
			BindKey(KeyName@AliasNames[Selection], KeyName ~= "RightMouse");
		}
	}
	else
	{
		BoundKey1[Selection] = KeyNo;	
		BindKey(KeyName@AliasNames[Selection], KeyName ~= "RightMouse");
	}
}

function ProcessMenuKey( int KeyNo, string KeyName )
{
/*
	if ( KeyName == "Escape" )
		{
			if ( bSelecting )
			{ 
				bSelecting = false;
				SelectedCol = -1;
				SelectedRow = -1;
			}
		}
*/

	if ( (KeyName == "") || (KeyName == "Escape") || (KeyName == "Pause") )
//		|| ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) // function keys
//		|| ((KeyNo >= 0x30 ) && (KeyNo <= 0x39))) // number keys
		return;
			
	RemoveExistingKey(KeyNo, KeyName);
	SetKey(KeyNo, KeyName);
}

function bool AllowScroll()
{
	return !bPolling;
}

function Notify(UWindowDialogControl C, byte E)
{
	local int I;

	Super.Notify(C, E);

	if(C == DefaultsButton && E == DE_Click)
	{
		GetPlayerOwner().ResetKeyboard();
		LoadExistingKeys();
		return;
	} 

	switch(E)
	{
	case DE_Change:
		/*
		switch(C)
		{
		case JoyXCombo:
			if(bLoadedExisting)
				BindKey("JoyX"@JoyXBinding[JoyXCombo.GetSelectedIndex()]);
			break;
		case JoyYCombo:
			if(bLoadedExisting)
				BindKey("JoyY"@JoyYBinding[JoyYCombo.GetSelectedIndex()]);
			break;
		}
		break;
		*/
	case DE_Click:
		if (bPolling)
		{
			bPolling = False;
			SelectedButton.bDisabled = False;

			if(C == SelectedButton)
			{
				ProcessMenuKey(1, RealKeyName[1]);
				return;
			}
		}

		if (UMenuRaisedButton(C) != None)
		{
			SelectedButton = UMenuRaisedButton(C);
			for ( I=0; I<AliasCount; I++ )
			{
				if (KeyButtons[I] == C)
					Selection = I;
			}
			bPolling = True;
			SelectedButton.bDisabled = True;
		}
		break;
	case DE_RClick:
		if (bPolling)
			{
				bPolling = False;
				SelectedButton.bDisabled = False;

				if(C == SelectedButton)
				{
					ProcessMenuKey(2, RealKeyName[2]);
					return;
				}
			}
		break;
	case DE_MClick:
		if (bPolling)
			{
				bPolling = False;
				SelectedButton.bDisabled = False;

				if(C == SelectedButton)
				{
					ProcessMenuKey(4, RealKeyName[4]);
					return;
				}			
			}
		break;
	case DE_MouseMove:
		ParentWindow.ToolTip(C.HelpText);
		break;
	case DE_MouseLeave:
		ParentWindow.ToolTip("");
		break;
	}
}

function GetDesiredDimensions(out float W, out float H)
{	
	Super.GetDesiredDimensions(W, H);
	H = 200*Root.ScaleY;
}

defaultproperties
{
     OrString=" or "
     CustomizeHelp="Click the rectangle and then press the key to bind."
     DefaultsText="Reset"
     DefaultsHelp="Reset all controls to their default settings."
}

/*
     JoystickText="Joystick"
     JoyXText="X Axis"
     JoyXHelp="Select the behavior for the left-right axis of your joystick."
     JoyXOptions(0)="Strafe Left/Right"
     JoyXOptions(1)="Turn Left/Right"
     JoyXBinding(0)="Axis aStrafe speed=2"
     JoyXBinding(1)="Axis aBaseX speed=0.7"
     JoyYText="Y Axis"
     JoyYHelp="Select the behavior for the up-down axis of your joystick."
     JoyYOptions(0)="Move Forward/Back"
     JoyYOptions(1)="Look Up/Down"
     JoyYBinding(0)="Axis aBaseY speed=2"
     JoyYBinding(1)="Axis aLookup speed=-0.4"
*/