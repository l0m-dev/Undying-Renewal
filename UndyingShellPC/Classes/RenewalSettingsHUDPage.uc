class RenewalSettingsHUDPage extends RenewalSettingsBasePage;

var UWindowCheckbox AltHudCheck;
var UWindowCheckbox AutoShowObjectivesCheck;
var UWindowCheckbox ShowUsedManaCheck;
//var UWindowHSliderControl HudScaleSlider;
var UWindowComboControl HudSizeCombo;

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
	HudSizeCombo.AddItem("Small", "0.9");
	HudSizeCombo.AddItem("Normal", "1.0");
	HudSizeCombo.AddItem("Big", "1.1");
	
	GetSettings();
}

function GetSettings()
{
	Super.GetSettings();

	AltHudCheck.bChecked = RenewalConfig.bAltHud;
	AutoShowObjectivesCheck.bChecked = RenewalConfig.bAutoShowObjectives;
	ShowUsedManaCheck.bChecked = RenewalConfig.bShowUsedMana;
	//HudScaleSlider.SetValue(RenewalConfig.HudScale);

	if (RenewalConfig.HudScale == 1.0)
		HudSizeCombo.SetSelectedIndex(1);
	else if (RenewalConfig.HudScale < 1.0)
		HudSizeCombo.SetSelectedIndex(0);
	else
		HudSizeCombo.SetSelectedIndex(2);
}

function Notify(UWindowDialogControl C, byte E)
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig(); // don't cache this, otherwise changes only apply on map change
	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case AltHudCheck:
			RenewalConfig.bAltHud = AltHudCheck.bChecked;
			break;
		case AutoShowObjectivesCheck:
			RenewalConfig.bAutoShowObjectives = AutoShowObjectivesCheck.bChecked;
			break;
		case ShowUsedManaCheck:
			RenewalConfig.bShowUsedMana = ShowUsedManaCheck.bChecked;
			break;
		//case HudScaleSlider:
		//	RenewalConfig.HudScale = HudScaleSlider.GetValue();
		//	break;
		case HudSizeCombo:
			RenewalConfig.HudScale = float(HudSizeCombo.GetValue2());
			break;
		}
		break;
	}

	Super.Notify(C, E);
}

defaultproperties
{
}
