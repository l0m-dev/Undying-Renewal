class RenewalSettingsBasePage extends UMenuPageWindow;

var int ControlOffset;

var RenewalConfig RenewalConfig;

struct ControlInfo
{
	var UWindowDialogControl Control;
	var float WinTop;
};

var ControlInfo Controls[32];
var int NumControls;

var bool bHasScrollBar;

var localized string ServerNameText;
var localized string ServerNameHelp;
var localized string GameplayChangesText;
var localized string GameplayChangesHelp;
var localized string GoreText;
var localized string GoreHelp;
var localized string AutoUseHealthVialsText;
var localized string AutoUseHealthVialsHelp;
var localized string AltHudText;
var localized string AltHudHelp;
var localized string AutoShowObjectivesText;
var localized string AutoShowObjectivesHelp;
var localized string ShowUsedManaText;
var localized string ShowUsedManaHelp;
var localized string HudSizeText;
var localized string HudSizeHelp;
var localized string DamageScreenShakeScaleText;
var localized string DamageScreenShakeScaleHelp;
var localized string MoreSkippableCutscenesText;
var localized string MoreSkippableCutscenesHelp;

var string ExperimentalText;

function UWindowDialogControl AddControl(class<UWindowDialogControl> ClassRef, optional string Text, optional string HelpText)
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
	local string SectionName;
	Cursor = Root.DefaultNormalCursor;

	ControlOffset = 10;

	bHasScrollBar = ParentWindow.IsA('UWindowScrollingDialogClient');

	Super.Created();

	//SectionName = string(class);
	/*
	SectionName = "UndyingShellPC.RenewalSettingsBasePage";

	ServerNameText = Localize(SectionName, "ServerNameText", "Renewal");
	ServerNameHelp = Localize(SectionName, "ServerNameHelp", "Renewal");
	GameplayChangesText = Localize(SectionName, "GameplayChangesText", "Renewal");
	GameplayChangesHelp = Localize(SectionName, "GameplayChangesHelp", "Renewal");
	GoreText = Localize(SectionName, "GoreText", "Renewal");
	GoreHelp = Localize(SectionName, "GoreHelp", "Renewal");
	AutoUseHealthVialsText = Localize(SectionName, "AutoUseHealthVialsText", "Renewal");
	AutoUseHealthVialsHelp = Localize(SectionName, "AutoUseHealthVialsHelp", "Renewal");
	AltHudText = Localize(SectionName, "AltHudText", "Renewal");
	AltHudHelp = Localize(SectionName, "AltHudHelp", "Renewal");
	AutoShowObjectivesText = Localize(SectionName, "AutoShowObjectivesText", "Renewal");
	AutoShowObjectivesHelp = Localize(SectionName, "AutoShowObjectivesHelp", "Renewal");
	ShowUsedManaText = Localize(SectionName, "ShowUsedManaText", "Renewal");
	ShowUsedManaHelp = Localize(SectionName, "ShowUsedManaHelp", "Renewal");
	DamageScreenShakeScaleText = Localize(SectionName, "DamageScreenShakeScaleText", "Renewal");
	DamageScreenShakeScaleHelp = Localize(SectionName, "DamageScreenShakeScaleHelp", "Renewal");
	MoreSkippableCutscenesText = Localize(SectionName, "MoreSkippableCutscenesText", "Renewal");
	MoreSkippableCutscenesHelp = Localize(SectionName, "MoreSkippableCutscenesHelp", "Renewal");
	*/
}

static function bool LocalizationExists(String SectionName, String KeyName, String PackageName, optional out String resultStr) {
	local String notFoundStr;
	
	notFoundStr = "<?int?"$PackageName$"."$SectionName$"."$KeyName$"?>";
	resultStr = Localize(SectionName, KeyName, PackageName);
	
	return resultStr != notFoundStr;
}

function GetSettings()
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig();
}

function ShowWindow()
{
	Super.ShowWindow();
	GetSettings();
}

function Notify(UWindowDialogControl C, byte E)
{
	switch(E)
	{
	case DE_MouseMove:
		ParentWindow.ToolTip(C.HelpText);
		break;
	case DE_MouseLeave:
		ParentWindow.ToolTip("");
		break;
	}
	if (RenewalConfig != None)
		RenewalConfig.SaveConfig();
	Super.Notify(C, E);
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
}

function ResolutionChanged(float W, float H)
{
	DesiredHeight = ControlOffset * Root.ScaleY;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int CenterPos, ControlPadding, ScrollBarWidth;
	local int i;
	local UWindowDialogControl Control;
	local float SizeX;

	Super.BeforePaint(C, X, Y);

	//ControlOffset = 10 * Root.ScaleY;

	if (bHasScrollBar && UWindowScrollingDialogClient(ParentWindow).bShowVertSB)
		ScrollBarWidth = LookAndFeel.Size_ScrollbarWidth;
	
	ControlPadding = 16;
	CenterPos = WinWidth/2 + ControlPadding;
	SizeX = WinWidth-(ControlPadding*2+ScrollBarWidth);
	
	for (i = 0; i < NumControls; i++)
	{
		Control = Controls[i].Control;
		Control.WinLeft = ControlPadding;
		Control.WinTop = Controls[i].WinTop * Root.ScaleY;
		Control.SetSize(SizeX, 1);
		//Control.WinTop = ControlOffset;
		//ControlOffset += 20 * Root.ScaleY;
	}
}

defaultproperties
{
}
