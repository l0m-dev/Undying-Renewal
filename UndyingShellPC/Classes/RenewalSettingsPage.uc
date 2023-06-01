class RenewalSettingsPage extends UMenuPageWindow;

var int ControlOffset;
var bool bInitialized;

var UWindowEditControl ServerNameEdit;
var UWindowCheckbox AutoUseHealthVialsCheck;
var UWindowCheckbox NewHudCheck;
var UWindowHSliderControl DamageScreenShakeScaleSlider;
var UWindowCheckbox MoreSkippableCutscenesCheck;

var UWindowLabelControl ExperimentalLabel;

var localized string ServerNameText;
var localized string ServerNameHelp;
var localized string AutoUseHealthVialsText;
var localized string AutoUseHealthVialsHelp;
var localized string NewHudText;
var localized string NewHudHelp;
var localized string DamageScreenShakeScaleText;
var localized string DamageScreenShakeScaleHelp;
var localized string MoreSkippableCutscenesText;
var localized string MoreSkippableCutscenesHelp;

var float ScaleX;
var float ScaleY;

var RenewalConfig RenewalConfig;

function Created()
{
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;
	local Color ExperimentalColor;
	
	ScaleX = Root.WinWidth / 800.0;
	ScaleY = Root.WinHeight / 600.0;

	ControlOffset = 20 * ScaleY;
	bInitialized = False;

	Super.Created();

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;

	ServerNameEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', CenterPos, ControlOffset, CenterWidth, 1));
	ServerNameEdit.SetText(ServerNameText);
	ServerNameEdit.SetHelpText(ServerNameHelp);
	ServerNameEdit.SetFont(F_Normal);
	ServerNameEdit.SetNumericOnly(False);
	ServerNameEdit.SetMaxLength(205);
	ServerNameEdit.SetDelayedNotify(True);
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
	
	MoreSkippableCutscenesCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', CenterPos, ControlOffset, CenterWidth, 1));
	MoreSkippableCutscenesCheck.SetText(MoreSkippableCutscenesText);
	MoreSkippableCutscenesCheck.SetHelpText(MoreSkippableCutscenesHelp);
	MoreSkippableCutscenesCheck.SetFont(F_Normal);
	MoreSkippableCutscenesCheck.Align = TA_Left;
	ControlOffset += 20 * ScaleY;
	
	RenewalConfig = GetPlayerOwner().GetRenewalConfig();
	GetSettings();
}

function GetSettings()
{
	ServerNameEdit.SetValue(class'Engine.GameReplicationInfo'.default.ServerName);
	AutoUseHealthVialsCheck.bChecked = RenewalConfig.bAutoUseHealthVials;
	NewHudCheck.bChecked = RenewalConfig.bNewHud;
	DamageScreenShakeScaleSlider.SetValue(RenewalConfig.DamageScreenShakeScale);
	MoreSkippableCutscenesCheck.bChecked = RenewalConfig.bMoreSkippableCutscenes;
}

function ShowWindow()
{
	Super.ShowWindow();
	//RenewalConfig = GetPlayerOwner().GetRenewalConfig();
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
			class'Engine.GameReplicationInfo'.default.ServerName = ServerNameEdit.GetValue();
			break;
		case AutoUseHealthVialsCheck:
			RenewalConfig.bAutoUseHealthVials = AutoUseHealthVialsCheck.bChecked;
			break;
		case NewHudCheck:
			RenewalConfig.bNewHud = NewHudCheck.bChecked;
			break;
		case DamageScreenShakeScaleSlider:
			RenewalConfig.DamageScreenShakeScale = DamageScreenShakeScaleSlider.GetValue();
			break;
		case MoreSkippableCutscenesCheck:
			RenewalConfig.bMoreSkippableCutscenes = MoreSkippableCutscenesCheck.bChecked;
			break;
		}
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

	ServerNameEdit.SetSize(CenterWidth, 1);
	ServerNameEdit.WinLeft = CenterPos;
	ServerNameEdit.EditBoxWidth = EditWidth;

	AutoUseHealthVialsCheck.SetSize(CenterWidth-EditWidth+16, 1);
	AutoUseHealthVialsCheck.WinLeft = CenterPos;

	NewHudCheck.SetSize(CenterWidth-EditWidth+16, 1);
	NewHudCheck.WinLeft = CenterPos;
	
	DamageScreenShakeScaleSlider.SetSize(CenterWidth, 1);
	DamageScreenShakeScaleSlider.WinLeft = CenterPos;
	
	MoreSkippableCutscenesCheck.SetSize(CenterWidth-EditWidth+16, 1);
	MoreSkippableCutscenesCheck.WinLeft = CenterPos;
}

defaultproperties
{
     ServerNameText="Server Name"
     ServerNameHelp="Enter the full description for your server, to appear in query tools such as UBrowser or GameSpy."
     AutoUseHealthVialsText="Auto use health vials"
     AutoUseHealthVialsHelp="If checked, you won't be able to carry health vials."
	 NewHudText="Use new HUD"
     NewHudHelp="If checked, use the new HUD"
	 DamageScreenShakeScaleText="Damage Screen Shake Scale"
	 DamageScreenShakeScaleHelp="Scales screenshake that happens when you take damage"
	 MoreSkippableCutscenesText="Skip More Cutscenes"
	 MoreSkippableCutscenesHelp="Makes more cutscenes skippable"
}
