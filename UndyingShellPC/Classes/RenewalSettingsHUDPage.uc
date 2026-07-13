class RenewalSettingsHUDPage extends UMenuRenewalBasePage;

var UWindowCheckbox AltHudCheck;
var UWindowCheckbox AutoShowObjectivesCheck;
var UWindowCheckbox ShowUsedManaCheck;
//var UWindowHSliderControl HudScaleSlider;
var UWindowComboControl HudSizeCombo;
var UWindowCheckbox ShowBossHealthBarsCheck;

var RenewalColorPicker CrosshairColorPicker;
var RenewalColorPicker LitCrosshairColorPicker;
var RenewalColorPicker InvokeCrosshairColorPicker;
//var UWindowHSliderControl CrosshairOpacitySlider;

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

var localized string CrosshairColorText;
var localized string CrosshairColorHelp;
var localized string LitCrosshairColorText;
var localized string LitCrosshairColorHelp;
var localized string InvokeCrosshairColorText;
var localized string InvokeCrosshairColorHelp;
var localized string CrosshairOpacityText;
var localized string CrosshairOpacityHelp;

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

	CrosshairColorPicker = RenewalColorPicker(AddControl(class'RenewalColorPicker', CrosshairColorText, CrosshairColorHelp));
	LitCrosshairColorPicker = RenewalColorPicker(AddControl(class'RenewalColorPicker', LitCrosshairColorText, LitCrosshairColorHelp));
	InvokeCrosshairColorPicker = RenewalColorPicker(AddControl(class'RenewalColorPicker', InvokeCrosshairColorText, InvokeCrosshairColorHelp));

	// can't add this yet since default opacity is 0.5
	//CrosshairOpacitySlider = UWindowHSliderControl(AddControl(class'UWindowHSliderControl', CrosshairOpacityText, CrosshairOpacityHelp));
	//CrosshairOpacitySlider.SetRange(0.0, 1.0, 0.05);
	//CrosshairOpacitySlider.SliderWidth = 130;
	
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

	CrosshairColorPicker.SetColor(GetPlayerOwner().CrossHairColor);
	LitCrosshairColorPicker.SetColor(GetPlayerOwner().LitCrossHairColor);
	InvokeCrosshairColorPicker.SetColor(GetPlayerOwner().CrossHairInvokeColor);

	//CrosshairOpacitySlider.SetValue(GetPlayerOwner().CrossHairAlpha);
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
		case CrosshairColorPicker:
			GetPlayerOwner().default.CrossHairColor = CrosshairColorPicker.PickedColor;
			GetPlayerOwner().CrossHairColor = CrosshairColorPicker.PickedColor;
			GetPlayerOwner().SaveConfig();
		case LitCrosshairColorPicker:
			GetPlayerOwner().default.LitCrossHairColor = LitCrosshairColorPicker.PickedColor;
			GetPlayerOwner().LitCrossHairColor = LitCrosshairColorPicker.PickedColor;
			GetPlayerOwner().SaveConfig();
		case InvokeCrosshairColorPicker:
			GetPlayerOwner().default.CrossHairInvokeColor = InvokeCrosshairColorPicker.PickedColor;
			GetPlayerOwner().CrossHairInvokeColor = InvokeCrosshairColorPicker.PickedColor;
			GetPlayerOwner().SaveConfig();
			break;
		//case CrosshairOpacitySlider:
		//	GetPlayerOwner().default.CrossHairAlpha = CrosshairOpacitySlider.GetValue();
		//	GetPlayerOwner().CrossHairAlpha = CrosshairOpacitySlider.GetValue();
		//	GetPlayerOwner().SaveConfig();
		//	break;
		}
		break;
	}

	Super.Notify(C, E);
}

defaultproperties
{
     ShowBossHealthBarsText="Show boss health bars"
     ShowBossHealthBarsHelp="Show boss health bars on the HUD"
     CrosshairColorText="Crosshair color"
     CrosshairColorHelp="Default crosshair color"
     LitCrosshairColorText="Lit crosshair color"
     LitCrosshairColorHelp="Crosshair color when aiming at an enemy"
     InvokeCrosshairColorText="Invoke crosshair color"
     InvokeCrosshairColorHelp="Crosshair color when aiming at an enemy with invoke"
     CrosshairOpacityText="Crosshair opacity"
     CrosshairOpacityHelp="Crosshair opacity"
}
