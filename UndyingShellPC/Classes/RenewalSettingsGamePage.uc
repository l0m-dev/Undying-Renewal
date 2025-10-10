class RenewalSettingsGamePage extends UMenuRenewalBasePage;

var UWindowCheckbox GameplayChangesCheck;
var UWindowCheckbox GoreCheck;
var UWindowCheckbox AutoUseHealthVialsCheck;
var UWindowCheckbox LimitHealthCheck;
var UWindowHSliderControl DamageScreenShakeScaleSlider;
var UWindowCheckbox MoreSkippableCutscenesCheck;
var UWindowCheckbox SlomoSelectionCheck;

var UWindowSmallButton GameplayChangesInfoButton;

var localized string GameplayChangesText;
var localized string GameplayChangesHelp;
var localized string GameplayChangesInfoText;
var localized string GameplayChangesInfoHelp;
var localized string GoreText;
var localized string GoreHelp;
var localized string AutoUseHealthVialsText;
var localized string AutoUseHealthVialsHelp;
var localized string LimitHealthText;
var localized string LimitHealthHelp;
var localized string DamageScreenShakeScaleText;
var localized string DamageScreenShakeScaleHelp;
var localized string MoreSkippableCutscenesText;
var localized string MoreSkippableCutscenesHelp;
var localized string SlomoSelectionText;
var localized string SlomoSelectionHelp;

function Created()
{
	Super.Created();

	GameplayChangesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', GameplayChangesText, GameplayChangesHelp));
	GameplayChangesCheck.bAlwaysBehind = true;

	GameplayChangesInfoButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 1, 1, 1, 1));
	GameplayChangesInfoButton.SetText(GameplayChangesInfoText);
	GameplayChangesInfoButton.SetFont(F_Normal);
	GameplayChangesInfoButton.SetHelpText(GameplayChangesInfoHelp);

	GoreCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', GoreText, GoreHelp));

	AutoUseHealthVialsCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AutoUseHealthVialsText, AutoUseHealthVialsHelp));

	LimitHealthCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', LimitHealthText, LimitHealthHelp));

	DamageScreenShakeScaleSlider = UWindowHSliderControl(AddControl(class'UWindowHSliderControl', DamageScreenShakeScaleText, DamageScreenShakeScaleHelp));
	DamageScreenShakeScaleSlider.SetRange(0.0, 1.0, 0.1);
	DamageScreenShakeScaleSlider.SliderWidth = 90; // scaled in code
	
	MoreSkippableCutscenesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', MoreSkippableCutscenesText, MoreSkippableCutscenesHelp));

	SlomoSelectionCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', SlomoSelectionText, SlomoSelectionHelp));
	
	GetSettings();
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float TW, TH;

	Super.BeforePaint(C, X, Y);

	GameplayChangesCheck.TextSize(C, GameplayChangesCheck.Text, TW, TH);

	GameplayChangesInfoButton.WinLeft = GameplayChangesCheck.WinLeft + TW + 5 * Root.ScaleY;
	GameplayChangesInfoButton.WinTop = GameplayChangesCheck.WinTop;
	//GameplayChangesInfoButton.SetSize(32 * Root.ScaleY, 16 * Root.ScaleY);
	GameplayChangesInfoButton.AutoWidth(C);
}

function GetSettings()
{
	Super.GetSettings();

	GameplayChangesCheck.bChecked = RenewalConfig.bGameplayChanges;
	GoreCheck.bChecked = RenewalConfig.bGore;
	AutoUseHealthVialsCheck.bChecked = RenewalConfig.bAutoUseHealthVials;
	LimitHealthCheck.bChecked = RenewalConfig.bLimitHealth;
	DamageScreenShakeScaleSlider.SetValue(RenewalConfig.DamageScreenShakeScale);
	MoreSkippableCutscenesCheck.bChecked = RenewalConfig.bMoreSkippableCutscenes;
	SlomoSelectionCheck.bChecked = RenewalConfig.bSlomoSelection;
}

function Notify(UWindowDialogControl C, byte E)
{
	RenewalConfig = GetPlayerOwner().GetRenewalConfig(); // don't cache this, otherwise changes only apply on map change

	if(C == GameplayChangesInfoButton && E == DE_Click)
	{
		class'StatLog'.static.BrowseRelativeLocalURL("../Renewal gameplay changes.pdf");
		return;
	} 

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
		case LimitHealthCheck:
			RenewalConfig.bLimitHealth = LimitHealthCheck.bChecked;
			break;
		case DamageScreenShakeScaleSlider:
			RenewalConfig.DamageScreenShakeScale = DamageScreenShakeScaleSlider.GetValue();
			break;
		case MoreSkippableCutscenesCheck:
			RenewalConfig.bMoreSkippableCutscenes = MoreSkippableCutscenesCheck.bChecked;
			break;
		case SlomoSelectionCheck:
			RenewalConfig.bSlomoSelection = SlomoSelectionCheck.bChecked;
			break;
		}
		break;
	}

	Super.Notify(C, E);
}

defaultproperties
{
}
