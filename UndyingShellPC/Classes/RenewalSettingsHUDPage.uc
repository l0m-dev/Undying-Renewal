class RenewalSettingsHUDPage extends UMenuRenewalBasePage;

var UWindowCheckbox AltHudCheck;
var UWindowCheckbox AutoShowObjectivesCheck;
var UWindowCheckbox ShowUsedManaCheck;
//var UWindowHSliderControl HudScaleSlider;
var UWindowComboControl HudSizeCombo;
var UWindowCheckbox ShowBossHealthBarsCheck;

var localized string AltHudText;
var localized string AltHudHelp;
var localized string AutoShowObjectivesText;
var localized string AutoShowObjectivesHelp;
var localized string ShowUsedManaText;
var localized string ShowUsedManaHelp;
var localized string HudSizeText;
var localized string HudSizeHelp;
var localized string HudSizeSmall;
var localized string HudSizeNormal;
var localized string HudSizeBig;
var localized string ShowBossHealthBarsText;
var localized string ShowBossHealthBarsHelp;

function Created()
{
	Super.Created();

	ShowUsedManaCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', ShowUsedManaText, ShowUsedManaHelp));
	
	AltHudCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AltHudText, AltHudHelp));

	AutoShowObjectivesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AutoShowObjectivesText, AutoShowObjectivesHelp));

	//HudScaleSlider = UWindowHSliderControl(AddControl(class'UWindowHSliderControl', HudScaleText, HudScaleHelp));
	//HudScaleSlider.SetRange(0.75, 1.25, 0.05);
	//HudScaleSlider.SliderWidth = 90;
	
	HudSizeCombo = UWindowComboControl(AddControl(class'UWindowComboControl', HudSizeText, HudSizeHelp));
	HudSizeCombo.EditBoxWidth = 90;
	HudSizeCombo.SetFont(F_Normal);
	HudSizeCombo.SetEditable(False);
	HudSizeCombo.AddItem(HudSizeSmall, "0.9");
	HudSizeCombo.AddItem(HudSizeNormal, "1.0");
	HudSizeCombo.AddItem(HudSizeBig, "1.1");

	ShowBossHealthBarsCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', ShowBossHealthBarsText, ShowBossHealthBarsHelp));
	
	GetSettings();
}

function GetSettings()
{
	Super.GetSettings();

	AltHudCheck.bChecked = class'RenewalConfig'.default.bAltHud;
	AutoShowObjectivesCheck.bChecked = class'RenewalConfig'.default.bAutoShowObjectives;
	ShowUsedManaCheck.bChecked = class'RenewalConfig'.default.bShowUsedMana;
	//HudScaleSlider.SetValue(class'RenewalConfig'.default.HudScale);

	if (class'RenewalConfig'.default.HudScale == 1.0)
		HudSizeCombo.SetSelectedIndex(1);
	else if (class'RenewalConfig'.default.HudScale < 1.0)
		HudSizeCombo.SetSelectedIndex(0);
	else
		HudSizeCombo.SetSelectedIndex(2);
	
	ShowBossHealthBarsCheck.bChecked = class'RenewalConfig'.default.bShowBossHealthBars;
}

function Notify(UWindowDialogControl C, byte E)
{
	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case AltHudCheck:
			class'RenewalConfig'.default.bAltHud = AltHudCheck.bChecked;
			break;
		case AutoShowObjectivesCheck:
			class'RenewalConfig'.default.bAutoShowObjectives = AutoShowObjectivesCheck.bChecked;
			break;
		case ShowUsedManaCheck:
			class'RenewalConfig'.default.bShowUsedMana = ShowUsedManaCheck.bChecked;
			break;
		//case HudScaleSlider:
		//	class'RenewalConfig'.default.HudScale = HudScaleSlider.GetValue();
		//	break;
		case HudSizeCombo:
			class'RenewalConfig'.default.HudScale = float(HudSizeCombo.GetValue2());
			break;
		case ShowBossHealthBarsCheck:
			class'RenewalConfig'.default.bShowBossHealthBars = ShowBossHealthBarsCheck.bChecked;
			break;
		}
		break;
	}

	Super.Notify(C, E);
}

defaultproperties
{
     ShowBossHealthBarsText="Show boss health bars"
     ShowBossHealthBarsHelp="Show boss health bars on the HUD"
}
