class RenewalSettingsPage extends UMenuPageWindow;

var int ControlOffset;
var bool bInitialized;

var UWindowEditControl ServerNameEdit;
var UWindowCheckbox GameplayChangesCheck;
var UWindowCheckbox GoreCheck;
var UWindowCheckbox AutoUseHealthVialsCheck;
var UWindowCheckbox NewHudCheck;
var UWindowCheckbox AutoShowObjectivesCheck;
var UWindowCheckbox ShowUsedManaCheck;
var UWindowHSliderControl DamageScreenShakeScaleSlider;
var UWindowCheckbox MoreSkippableCutscenesCheck;

var UWindowLabelControl ExperimentalLabel;

var string ServerNameText;
var string ServerNameHelp;
var string GameplayChangesText;
var string GameplayChangesHelp;
var string GoreText;
var string GoreHelp;
var string AutoUseHealthVialsText;
var string AutoUseHealthVialsHelp;
var string NewHudText;
var string NewHudHelp;
var string AutoShowObjectivesText;
var string AutoShowObjectivesHelp;
var string ShowUsedManaText;
var string ShowUsedManaHelp;
var string DamageScreenShakeScaleText;
var string DamageScreenShakeScaleHelp;
var string MoreSkippableCutscenesText;
var string MoreSkippableCutscenesHelp;

var RenewalConfig RenewalConfig;

struct ControlInfo
{
	var UWindowDialogControl Control;
	var float WinTop;
};

var ControlInfo Controls[32];
var int NumControls;

function UWindowDialogControl AddControl(class<UWindowDialogControl> ClassRef, string Text, string HelpText)
{
	local ControlInfo option;

	option.Control = CreateControl(ClassRef, 1, 1, 1, 1);
	option.WinTop = ControlOffset;

	option.Control.SetText(Text);
	option.Control.SetHelpText(HelpText);
	option.Control.SetFont(F_Normal);
	option.Control.Align = TA_Left;
	ControlOffset += 20;

	Controls[NumControls++] = option;

	return option.Control;
}

function Created()
{
	local Color ExperimentalColor;

	ServerNameText = Localize(string(class), "ServerNameText", "Renewal");
	ServerNameHelp = Localize(string(class), "ServerNameHelp", "Renewal");
	GameplayChangesText = Localize(string(class), "GameplayChangesText", "Renewal");
	GameplayChangesHelp = Localize(string(class), "GameplayChangesHelp", "Renewal");
	GoreText = Localize(string(class), "GoreText", "Renewal");
	GoreHelp = Localize(string(class), "GoreHelp", "Renewal");
	AutoUseHealthVialsText = Localize(string(class), "AutoUseHealthVialsText", "Renewal");
	AutoUseHealthVialsHelp = Localize(string(class), "AutoUseHealthVialsHelp", "Renewal");
	NewHudText = Localize(string(class), "NewHudText", "Renewal");
	NewHudHelp = Localize(string(class), "NewHudHelp", "Renewal");
	AutoShowObjectivesText = Localize(string(class), "AutoShowObjectivesText", "Renewal");
	AutoShowObjectivesHelp = Localize(string(class), "AutoShowObjectivesHelp", "Renewal");
	ShowUsedManaText = Localize(string(class), "ShowUsedManaText", "Renewal");
	ShowUsedManaHelp = Localize(string(class), "ShowUsedManaHelp", "Renewal");
	DamageScreenShakeScaleText = Localize(string(class), "DamageScreenShakeScaleText", "Renewal");
	DamageScreenShakeScaleHelp = Localize(string(class), "DamageScreenShakeScaleHelp", "Renewal");
	MoreSkippableCutscenesText = Localize(string(class), "MoreSkippableCutscenesText", "Renewal");
	MoreSkippableCutscenesHelp = Localize(string(class), "MoreSkippableCutscenesHelp", "Renewal");

	Cursor = Root.DefaultNormalCursor;

	ControlOffset = 10;
	bInitialized = False;

	Super.Created();

	/*
	ServerNameEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', CenterPos, ControlOffset, CenterWidth, 1));
	ServerNameEdit.SetText(ServerNameText);
	ServerNameEdit.SetHelpText(ServerNameHelp);
	ServerNameEdit.SetFont(F_Normal);
	ServerNameEdit.SetNumericOnly(False);
	ServerNameEdit.SetMaxLength(205);
	ServerNameEdit.SetDelayedNotify(True);
	ControlOffset += 20 * Root.ScaleY;
	*/

	GameplayChangesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', GameplayChangesText, GameplayChangesHelp));

	GoreCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', GoreText, GoreHelp));

	AutoUseHealthVialsCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AutoUseHealthVialsText, AutoUseHealthVialsHelp));

	DamageScreenShakeScaleSlider = UWindowHSliderControl(AddControl(class'UWindowHSliderControl', DamageScreenShakeScaleText, DamageScreenShakeScaleHelp));
	DamageScreenShakeScaleSlider.SetRange(0.0, 1.0, 0.1);
	DamageScreenShakeScaleSlider.SliderWidth = 90;
	
	AutoUseHealthVialsCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', ShowUsedManaText, ShowUsedManaHelp));
	
	// Experimental settings
	ExperimentalColor.R = 15;
	ExperimentalColor.G = 90;
	ExperimentalColor.B = 5;
	ExperimentalLabel = UWindowLabelControl(AddControl(class'UWindowLabelControl', "Experimental settings", ""));
	ExperimentalLabel.SetTextColor(ExperimentalColor);
	
	NewHudCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', NewHudText, NewHudHelp));

	AutoShowObjectivesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AutoShowObjectivesText, AutoShowObjectivesHelp));

	MoreSkippableCutscenesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', MoreSkippableCutscenesText, MoreSkippableCutscenesHelp));
	
	//ControlOffset += 20;
	GetSettings();
}

function GetSettings()
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig();

	//ServerNameEdit.SetValue(class'Engine.GameReplicationInfo'.default.ServerName);
	GameplayChangesCheck.bChecked = RenewalConfig.bGameplayChanges;
	GoreCheck.bChecked = RenewalConfig.bGore;
	AutoUseHealthVialsCheck.bChecked = RenewalConfig.bAutoUseHealthVials;
	NewHudCheck.bChecked = RenewalConfig.bAltHud;
	AutoShowObjectivesCheck.bChecked = RenewalConfig.bAutoShowObjectives;
	ShowUsedManaCheck.bChecked = RenewalConfig.bShowUsedMana;
	DamageScreenShakeScaleSlider.SetValue(RenewalConfig.DamageScreenShakeScale);
	MoreSkippableCutscenesCheck.bChecked = RenewalConfig.bMoreSkippableCutscenes;
}

function ShowWindow()
{
	Super.ShowWindow();
	GetSettings();
}

function Notify(UWindowDialogControl C, byte E)
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig(); // don't cache this, otherwise changes only apply on map change
	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case ServerNameEdit:
			//class'Engine.GameReplicationInfo'.default.ServerName = ServerNameEdit.GetValue();
			break;
		case GameplayChangesCheck:
			RenewalConfig.bGameplayChanges = GameplayChangesCheck.bChecked;
			break;
		case GoreCheck:
			RenewalConfig.bGore = GoreCheck.bChecked;
			break;
		case AutoUseHealthVialsCheck:
			RenewalConfig.bAutoUseHealthVials = AutoUseHealthVialsCheck.bChecked;
			break;
		case NewHudCheck:
			RenewalConfig.bAltHud = NewHudCheck.bChecked;
			break;
		case AutoShowObjectivesCheck:
			RenewalConfig.bAutoShowObjectives = AutoShowObjectivesCheck.bChecked;
			break;
		case ShowUsedManaCheck:
			RenewalConfig.bShowUsedMana = ShowUsedManaCheck.bChecked;
			break;
		case DamageScreenShakeScaleSlider:
			RenewalConfig.DamageScreenShakeScale = DamageScreenShakeScaleSlider.GetValue();
			break;
		case MoreSkippableCutscenesCheck:
			RenewalConfig.bMoreSkippableCutscenes = MoreSkippableCutscenesCheck.bChecked;
			break;
		}
		break;
	case DE_MouseMove:
		if (Root.WinHeight <= 1080)
			ParentWindow.ToolTip(C.HelpText);
		break;
	case DE_MouseLeave:
		ParentWindow.ToolTip("");
		break;
	}

	Super.Notify(C, E);
	RenewalConfig.SaveConfig();
}

function SaveConfigs()
{
	// this is called on Close but we use Hide(), might as well save on change
	//SaveConfig();
	//Super.SaveConfigs();
	//class'Engine.GameReplicationInfo'.static.StaticSaveConfig();
}

function AfterCreate()
{
	Super.AfterCreate();

	DesiredWidth = 220;
	DesiredHeight = ControlOffset * Root.ScaleY;

	bInitialized = True;
}

function ResolutionChanged(float W, float H)
{
	DesiredHeight = ControlOffset * Root.ScaleY;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int CenterPos, ControlPadding;
	local int i;
	local UWindowDialogControl Control;

	Super.BeforePaint(C, X, Y);

	//ControlOffset = 10 * Root.ScaleY;
	
	ControlPadding = 16;
	CenterPos = WinWidth/2 + ControlPadding;
	
	for (i = 0; i < NumControls; i++)
	{
		Control = Controls[i].Control;
		Control.WinLeft = ControlPadding;
		Control.WinTop = Controls[i].WinTop * Root.ScaleY;
		Control.SetSize(WinWidth-(ControlPadding*2+LookAndFeel.Size_ScrollbarWidth), 1);
		//Control.WinTop = ControlOffset;
		//ControlOffset += 20 * Root.ScaleY;
	}
}

defaultproperties
{
}
