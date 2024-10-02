class UMenuRenewalBasePage extends UMenuPageWindow;

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
	Cursor = Root.DefaultNormalCursor;

	ControlOffset = 10;

	bHasScrollBar = ParentWindow.IsA('UWindowScrollingDialogClient');

	Super.Created();
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

function WindowShown()
{
	Super.WindowShown();
	GetSettings();
}

function Notify(UWindowDialogControl C, byte E)
{
	switch(E)
	{
	case DE_MouseMove:
		if (ParentWindow != None && C.HelpText != "")
			ParentWindow.ToolTip(C.HelpText);
		break;
	case DE_MouseLeave:
		if (ParentWindow != None && C.HelpText != "")
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
