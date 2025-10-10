class RenewalSettingsGraphicsPage extends UMenuRenewalBasePage;

var UWindowCheckbox AnimatedMenuCheck;
var UWindowCheckbox SaveThumbnailsCheck;
var UWindowComboControl AntiAliasCombo;
var UWindowComboControl LightModeCombo;
var UWindowCheckbox HdrCheck;
var UWindowCheckbox PrecachingCheck;

var localized string AnimatedMenuText;
var localized string AnimatedMenuHelp;
var localized string SaveThumbnailsText;
var localized string SaveThumbnailsHelp;
var localized string AntiAliasText;
var localized string AntiAliasHelp;
var localized string LightModeText;
var localized string LightModeHelp;
var localized string LightModeOption1;
var localized string LightModeOption2;
var localized string LightModeOption3;
var localized string HdrText;
var localized string HdrHelp;
var localized string PrecachingText;
var localized string PrecachingHelp;

function Created()
{
	Super.Created();

	AnimatedMenuCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AnimatedMenuText, AnimatedMenuHelp));

	SaveThumbnailsCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', SaveThumbnailsText, SaveThumbnailsHelp));
	
	if (DoesRenderDevicePropertyExist('AntialiasMode'))
	{
		AntiAliasCombo = UWindowComboControl(AddControl(class'UWindowComboControl', AntiAliasText, AntiAliasHelp));
		AntiAliasCombo.EditBoxWidth = 100;
		AntiAliasCombo.SetFont(F_Normal);
		AntiAliasCombo.SetEditable(False);
		AntiAliasCombo.AddItem("None",		"Off");
		AntiAliasCombo.AddItem("MSAA 2x",	"MSAA_2x");
		AntiAliasCombo.AddItem("MSAA 4x",	"MSAA_4x");
	}
	
	if (DoesRenderDevicePropertyExist('LightMode'))
	{
		LightModeCombo = UWindowComboControl(AddControl(class'UWindowComboControl', LightModeText, LightModeHelp));
		LightModeCombo.EditBoxWidth = 100;
		LightModeCombo.SetFont(F_Normal);
		LightModeCombo.SetEditable(False);
		LightModeCombo.AddItem(LightModeOption1, "OneXBlending");
		LightModeCombo.AddItem(LightModeOption2, "Normal");
		LightModeCombo.AddItem(LightModeOption3, "BrighterActors");
	}

	if (DoesRenderDevicePropertyExist('Hdr'))
		HdrCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', HdrText, HdrHelp));

	if (DoesRenderDevicePropertyExist('UsePrecache'))
		PrecachingCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', PrecachingText, PrecachingHelp));

	// add vsync and fps limit settings?
	
	GetSettings();
}

function GetSettings()
{
	local string AntiAliasString;
	local string LightModeString;

	Super.GetSettings();

	AnimatedMenuCheck.bChecked = RenewalConfig.bAnimatedMenu;

	SaveThumbnailsCheck.bChecked = RenewalConfig.bSaveThumbnails;

	if (AntiAliasCombo != None)
	{
		AntiAliasString = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice AntialiasMode");
	
		if (AntiAliasString ~= "MSAA_2x")
			AntiAliasCombo.SetSelectedIndex(1);
		else if (AntiAliasString ~= "MSAA_4x")
			AntiAliasCombo.SetSelectedIndex(2);
		else
			AntiAliasCombo.SetSelectedIndex(0);
	}

	if (LightModeCombo != None)
	{
		LightModeString = GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice LightMode");

		if (LightModeString ~= "Normal")
			LightModeCombo.SetSelectedIndex(1);
		else if (LightModeString ~= "BrighterActors")
			LightModeCombo.SetSelectedIndex(2);
		else
			LightModeCombo.SetSelectedIndex(0);
	}

	if (HdrCheck != None)
		HdrCheck.bChecked = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice Hdr"));

	if (PrecachingCheck != None)
		PrecachingCheck.bChecked = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice UsePrecache"));
}

function Notify(UWindowDialogControl C, byte E)
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig(); // don't cache this, otherwise changes only apply on map change
	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case AnimatedMenuCheck:
			RenewalConfig.bAnimatedMenu = AnimatedMenuCheck.bChecked;
			break;
		case SaveThumbnailsCheck:
			RenewalConfig.bSaveThumbnails = SaveThumbnailsCheck.bChecked;
			break;
		case AntiAliasCombo:
			//RenewalConfig.HudScale = float(AntiAliasCombo.GetValue2());
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice AntialiasMode "$ AntiAliasCombo.GetValue2());
			//GetPlayerOwner().ConsoleCommand("flush");
			break;
		case LightModeCombo:
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice LightMode "$ LightModeCombo.GetValue2());
			break;
		case HdrCheck:
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice Hdr "$ HdrCheck.bChecked);
			break;
		case PrecachingCheck:
			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.GameRenderDevice UsePrecache "$ PrecachingCheck.bChecked);
			break;
		}
		break;
	}

	Super.Notify(C, E);
}

function bool DoesRenderDevicePropertyExist(name Property)
{
	return Left(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.GameRenderDevice " $ Property), 21) != "Unrecognized property";
}

defaultproperties
{
}
