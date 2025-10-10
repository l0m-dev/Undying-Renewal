class AdvCreateGameCoopPage extends UMenuRenewalBasePage;

var UWindowCheckbox AllowRespawnCheck;
var UWindowCheckbox FriendlyFireCheck;

var localized string AllowRespawnText;
var localized string AllowRespawnHelp;
var localized string FriendlyFireText;
var localized string FriendlyFireHelp;

function Created()
{
	Super.Created();

	AllowRespawnCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', AllowRespawnText, AllowRespawnHelp));

	FriendlyFireCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', FriendlyFireText, FriendlyFireHelp));

	GetSettings();
}

function GetSettings()
{
	Super.GetSettings();

	AllowRespawnCheck.bChecked = class'Coop'.default.bAllowRespawn;
	FriendlyFireCheck.bChecked = !class'Coop'.default.bNoFriendlyFire;
}

function Notify(UWindowDialogControl C, byte E)
{
	switch(E)
	{
	case DE_Change:
		switch(C)
		{
		case AllowRespawnCheck:
			class'Coop'.default.bAllowRespawn = AllowRespawnCheck.bChecked;
			break;
		case FriendlyFireCheck:
			class'Coop'.default.bNoFriendlyFire = !FriendlyFireCheck.bChecked;
			break;
		}
		break;
	}

	class'Coop'.static.StaticSaveConfig();

	Super.Notify(C, E);
}

defaultproperties
{
     AllowRespawnText="Allow respawn"
     AllowRespawnHelp="Allow respawning"
     FriendlyFireText="Friendly fire"
     FriendlyFireHelp="Enable friendly fire"
}
