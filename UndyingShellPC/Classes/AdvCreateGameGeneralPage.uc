class AdvCreateGameGeneralPage extends UMenuRenewalBasePage;

var UWindowCheckbox GameplayChangesCheck;
var UWindowCheckbox AutoUseHealthVialsCheck;
var UWindowCheckbox LimitHealthCheck;
var UWindowCheckbox MoreSkippableCutscenesCheck;
var UWindowComboControl GameCombo;
var UWindowComboControl MapCombo;

var localized string GameTypeText;
var localized string GameTypeHelp;
var localized string MapText;
var localized string MapHelp;

var string Games[256];
var int MaxGames;

function Created()
{
	local int i;
	local class<GameInfo> TempClass;
	local string NextGame;
	local string TempGames[256];

	Super.Created();

	GameplayChangesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', class'RenewalSettingsGamePage'.default.GameplayChangesText, class'RenewalSettingsGamePage'.default.GameplayChangesHelp));

	AutoUseHealthVialsCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', class'RenewalSettingsGamePage'.default.AutoUseHealthVialsText, class'RenewalSettingsGamePage'.default.AutoUseHealthVialsHelp));

	LimitHealthCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', class'RenewalSettingsGamePage'.default.LimitHealthText, class'RenewalSettingsGamePage'.default.LimitHealthHelp));
	
	MoreSkippableCutscenesCheck = UWindowCheckbox(AddControl(class'UWindowCheckbox', class'RenewalSettingsGamePage'.default.MoreSkippableCutscenesText, class'RenewalSettingsGamePage'.default.MoreSkippableCutscenesHelp));

    GameCombo = UWindowComboControl(AddControl(class'UWindowComboControl', GameTypeText, GameTypeHelp));
	GameCombo.EditBoxWidth = 200;
	GameCombo.SetFont(F_Normal);
	GameCombo.SetEditable(False);
	GameCombo.SetButtons(True);

    MapCombo = UWindowComboControl(AddControl(class'UWindowComboControl', MapText, MapHelp));
	MapCombo.EditBoxWidth = 200;
	MapCombo.SetFont(F_Normal);
	MapCombo.SetEditable(False);
	MapCombo.SetButtons(True);

	// Compile a list of all gametypes.
	NextGame = GetPlayerOwner().GetNextInt("AeonsGameInfo", 0); 
	while (NextGame != "")
	{
		TempGames[i] = NextGame;
		i++;
		NextGame = GetPlayerOwner().GetNextInt("AeonsGameInfo", i);
	}

	// Fill the control.
	for (i=0; i<256; i++)
	{
		if (TempGames[i] != "")
		{
			Games[MaxGames] = TempGames[i];
			TempClass = Class<AeonsGameInfo>(DynamicLoadObject(Games[MaxGames], class'Class'));
			if( TempClass != None )
			{
				GameCombo.AddItem(TempClass.Default.GameName);
				MaxGames++;
			}
		}
	}

	GameCombo.SetSelectedIndex(0);

	IterateMaps("");
	
	GetSettings();
}

function GetSettings()
{
	Super.GetSettings();

	GameplayChangesCheck.bChecked = RenewalConfig.bGameplayChanges;
	AutoUseHealthVialsCheck.bChecked = RenewalConfig.bAutoUseHealthVials;
	LimitHealthCheck.bChecked = RenewalConfig.bLimitHealth;
	MoreSkippableCutscenesCheck.bChecked = RenewalConfig.bMoreSkippableCutscenes;

	MapCombo.SetSelectedIndex(Max(MapCombo.FindItemIndex(class'CreateGameWindow'.default.Map, True), 0));
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
		case AutoUseHealthVialsCheck:
			RenewalConfig.bAutoUseHealthVials = AutoUseHealthVialsCheck.bChecked;
			break;
		case LimitHealthCheck:
			RenewalConfig.bLimitHealth = LimitHealthCheck.bChecked;
			break;
		case MoreSkippableCutscenesCheck:
			RenewalConfig.bMoreSkippableCutscenes = MoreSkippableCutscenesCheck.bChecked;
			break;
        case GameCombo:
			class'CreateGameWindow'.default.GameType = Games[GameCombo.GetSelectedIndex()];
			class'CreateGameWindow'.default.GameTypeName = GameCombo.GetValue();
			break;
        case MapCombo:
			class'CreateGameWindow'.default.Map = MapCombo.GetValue();
			break;
		}
		break;
	}

	class'CreateGameWindow'.default.bAdvancedSettingsUpdated = true;

	Super.Notify(C, E);
}

function IterateMaps(string MapPrefix)
{
	local string FirstMap, NextMap, TestMap;
	local int RemoveItemIndex;

	FirstMap = GetPlayerOwner().GetMapName(MapPrefix, "", 0);

	MapCombo.Clear();
	NextMap = FirstMap;

	while (!(FirstMap ~= TestMap))
	{
		// Add the map.
		MapCombo.AddItem(Left(NextMap, InStr(NextMap, ".")), NextMap);

		// Get the map.
		NextMap = GetPlayerOwner().GetMapName(MapPrefix, NextMap, 1);

		// Test to see if this is the last.
		TestMap = NextMap;
	}

	RemoveItemIndex = MapCombo.FindItemIndex("Aeons", true);
	if (RemoveItemIndex != -1)
		MapCombo.RemoveItem(RemoveItemIndex);

	MapCombo.Sort();
}

defaultproperties
{
     GameTypeText="Game type"
     GameTypeHelp="Select game type"
     MapText="Map"
     MapHelp="Select map"
}
