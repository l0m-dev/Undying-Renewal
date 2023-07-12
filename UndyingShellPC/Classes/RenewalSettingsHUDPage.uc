class RenewalSettingsHUDPage extends RenewalSettingsBasePage;

var UWindowCheckbox AltHudCheck;
var UWindowCheckbox AutoShowObjectivesCheck;
var UWindowCheckbox ShowUsedManaCheck;

function Created()
{
	Super.Created();

	ShowUsedManaCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', ShowUsedManaText, ShowUsedManaHelp));
	
	AltHudCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AltHudText, AltHudHelp));

	AutoShowObjectivesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AutoShowObjectivesText, AutoShowObjectivesHelp));
	
	GetSettings();
}

function GetSettings()
{
	Super.GetSettings();

	AltHudCheck.bChecked = RenewalConfig.bAltHud;
	AutoShowObjectivesCheck.bChecked = RenewalConfig.bAutoShowObjectives;
	ShowUsedManaCheck.bChecked = RenewalConfig.bShowUsedMana;
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
		}
		break;
	}

	Super.Notify(C, E);
}

defaultproperties
{
}
