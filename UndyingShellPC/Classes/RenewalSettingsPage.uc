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

var float ScaleX;
var float ScaleY;

var RenewalConfig RenewalConfig;

function Created()
{
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;
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
	
	ScaleX = Root.WinWidth / 800.0;
	ScaleY = Root.WinHeight / 600.0;

	ControlOffset = 10 * ScaleY;
	bInitialized = False;

	Super.Created();

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;

	/*
	ServerNameEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', CenterPos, ControlOffset, CenterWidth, 1));
	ServerNameEdit.SetText(ServerNameText);
	ServerNameEdit.SetHelpText(ServerNameHelp);
	ServerNameEdit.SetFont(F_Normal);
	ServerNameEdit.SetNumericOnly(False);
	ServerNameEdit.SetMaxLength(205);
	ServerNameEdit.SetDelayedNotify(True);
	ControlOffset += 20 * ScaleY;
	*/

	GameplayChangesCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	GameplayChangesCheck.SetText(GameplayChangesText);
	GameplayChangesCheck.SetHelpText(GameplayChangesHelp);
	GameplayChangesCheck.SetFont(F_Normal);
	GameplayChangesCheck.Align = TA_Left;
	ControlOffset += 20 * ScaleY;
	
	GoreCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	GoreCheck.SetText(GoreText);
	GoreCheck.SetHelpText(GoreHelp);
	GoreCheck.SetFont(F_Normal);
	GoreCheck.Align = TA_Left;
	ControlOffset += 20 * ScaleY;

	AutoUseHealthVialsCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	AutoUseHealthVialsCheck.SetText(AutoUseHealthVialsText);
	AutoUseHealthVialsCheck.SetHelpText(AutoUseHealthVialsHelp);
	AutoUseHealthVialsCheck.SetFont(F_Normal);
	AutoUseHealthVialsCheck.Align = TA_Left;
	ControlOffset += 20 * ScaleY;
	
	DamageScreenShakeScaleSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
	DamageScreenShakeScaleSlider.SetText(DamageScreenShakeScaleText);
	DamageScreenShakeScaleSlider.SetHelpText(DamageScreenShakeScaleHelp);
	DamageScreenShakeScaleSlider.SetFont(F_Normal);
	DamageScreenShakeScaleSlider.SetRange(0.0, 1.0, 0.1);
	ControlOffset += 20 * ScaleY;
	
	ShowUsedManaCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	ShowUsedManaCheck.SetText(ShowUsedManaText);
	ShowUsedManaCheck.SetHelpText(ShowUsedManaHelp);
	ShowUsedManaCheck.SetFont(F_Normal);
	ShowUsedManaCheck.Align = TA_Left;
	ControlOffset += 20 * ScaleY;
	
	// Experimental settings
	
	ExperimentalColor.R = 15;
	ExperimentalColor.G = 90;
	ExperimentalColor.B = 5;
	ExperimentalLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', CenterPos, ControlOffset, CenterWidth, 1));
	ExperimentalLabel.SetText("Experimental settings");
	ExperimentalLabel.SetTextColor(ExperimentalColor);
	ControlOffset += 20 * ScaleY;
	
	NewHudCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	NewHudCheck.SetText(NewHudText);
	NewHudCheck.SetHelpText(NewHudHelp);
	NewHudCheck.SetFont(F_Normal);
	NewHudCheck.Align = TA_Left;
	ControlOffset += 20 * ScaleY;
	
	AutoShowObjectivesCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	AutoShowObjectivesCheck.SetText(AutoShowObjectivesText);
	AutoShowObjectivesCheck.SetHelpText(AutoShowObjectivesHelp);
	AutoShowObjectivesCheck.SetFont(F_Normal);
	AutoShowObjectivesCheck.Align = TA_Left;
	ControlOffset += 20 * ScaleY;
	
	MoreSkippableCutscenesCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	MoreSkippableCutscenesCheck.SetText(MoreSkippableCutscenesText);
	MoreSkippableCutscenesCheck.SetHelpText(MoreSkippableCutscenesHelp);
	MoreSkippableCutscenesCheck.SetFont(F_Normal);
	MoreSkippableCutscenesCheck.Align = TA_Left;
	ControlOffset += 20 * ScaleY;
	
	GetSettings();
}

function GetSettings()
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig();

	//ServerNameEdit.SetValue(class'Engine.GameReplicationInfo'.default.ServerName);
	GameplayChangesCheck.bChecked = RenewalConfig.bGameplayChanges;
	GoreCheck.bChecked = RenewalConfig.bGore;
	AutoUseHealthVialsCheck.bChecked = RenewalConfig.bAutoUseHealthVials;
	NewHudCheck.bChecked = RenewalConfig.bNewHud;
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
			RenewalConfig.bNewHud = NewHudCheck.bChecked;
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

	DesiredWidth = 270;
	DesiredHeight = ControlOffset + 5;

	bInitialized = True;
}

function Resized()
{
	Super.Resized();

	ScaleX = Root.WinWidth / 800.0;
	ScaleY = Root.WinHeight / 600.0;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;
	local int EditWidth;

	Super.BeforePaint(C, X, Y);

	ControlWidth = WinWidth/2;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = WinWidth * 0.95;
	
	CenterPos = (WinWidth - CenterWidth)/2;
	
	EditWidth = ControlRight;

	//ServerNameEdit.SetSize(CenterWidth, 1);
	//ServerNameEdit.WinLeft = CenterPos;
	//ServerNameEdit.EditBoxWidth = EditWidth;

	GameplayChangesCheck.SetSize(CenterWidth-EditWidth+16, 1);
	GameplayChangesCheck.WinLeft = CenterPos;

	GoreCheck.SetSize(CenterWidth-EditWidth+16, 1);
	GoreCheck.WinLeft = CenterPos;

	AutoUseHealthVialsCheck.SetSize(CenterWidth-EditWidth+16, 1);
	AutoUseHealthVialsCheck.WinLeft = CenterPos;

	NewHudCheck.SetSize(CenterWidth-EditWidth+16, 1);
	NewHudCheck.WinLeft = CenterPos;

	AutoShowObjectivesCheck.SetSize(CenterWidth-EditWidth+16, 1);
	AutoShowObjectivesCheck.WinLeft = CenterPos;

	ShowUsedManaCheck.SetSize(CenterWidth-EditWidth+16, 1);
	ShowUsedManaCheck.WinLeft = CenterPos;

	DamageScreenShakeScaleSlider.SetSize(CenterWidth, 1);
	DamageScreenShakeScaleSlider.WinLeft = CenterPos;

	MoreSkippableCutscenesCheck.SetSize(CenterWidth-EditWidth+16, 1);
	MoreSkippableCutscenesCheck.WinLeft = CenterPos;
}

defaultproperties
{
}
