class RenewalSettingsGamePage extends RenewalSettingsBasePage;

var UWindowCheckbox GameplayChangesCheck;
var UWindowCheckbox GoreCheck;
var UWindowCheckbox AutoUseHealthVialsCheck;
var UWindowHSliderControl DamageScreenShakeScaleSlider;
var UWindowCheckbox MoreSkippableCutscenesCheck;

function Created()
{
	Super.Created();

	GameplayChangesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', GameplayChangesText, GameplayChangesHelp));

	GoreCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', GoreText, GoreHelp));

	AutoUseHealthVialsCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AutoUseHealthVialsText, AutoUseHealthVialsHelp));

	DamageScreenShakeScaleSlider = UWindowHSliderControl(AddControl(class'UWindowHSliderControl', DamageScreenShakeScaleText, DamageScreenShakeScaleHelp));
	DamageScreenShakeScaleSlider.SetRange(0.0, 1.0, 0.1);
	DamageScreenShakeScaleSlider.SliderWidth = 90; // scaled in code
	
	MoreSkippableCutscenesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', MoreSkippableCutscenesText, MoreSkippableCutscenesHelp));
	
	GetSettings();
}

function GetSettings()
{
	Super.GetSettings();

	GameplayChangesCheck.bChecked = RenewalConfig.bGameplayChanges;
	GoreCheck.bChecked = RenewalConfig.bGore;
	AutoUseHealthVialsCheck.bChecked = RenewalConfig.bAutoUseHealthVials;
	DamageScreenShakeScaleSlider.SetValue(RenewalConfig.DamageScreenShakeScale);
	MoreSkippableCutscenesCheck.bChecked = RenewalConfig.bMoreSkippableCutscenes;
}

function Notify(UWindowDialogControl C, byte E)
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig(); // don't cache this, otherwise changes only apply on map change
	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case GameplayChangesCheck:
			RenewalConfig.bGameplayChanges = GameplayChangesCheck.bChecked;
			break;
		case GoreCheck:
			RenewalConfig.bGore = GoreCheck.bChecked;
			break;
		case AutoUseHealthVialsCheck:
			RenewalConfig.bAutoUseHealthVials = AutoUseHealthVialsCheck.bChecked;
			break;
		case DamageScreenShakeScaleSlider:
			RenewalConfig.DamageScreenShakeScale = DamageScreenShakeScaleSlider.GetValue();
			break;
		case MoreSkippableCutscenesCheck:
			RenewalConfig.bMoreSkippableCutscenes = MoreSkippableCutscenesCheck.bChecked;
			break;
		}
		break;
	}

	Super.Notify(C, E);
}

defaultproperties
{
}
