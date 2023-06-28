//=============================================================================
// RenewalConfig.
//=============================================================================
class RenewalConfig expands Info config(RenewalSettings) transient;

var config bool bGameplayChanges;
var config bool bGore;

var config bool bAutoUseHealthVials;
var config bool bNewHud;
var config bool bShowUsedMana;

var config string LargeFont;
var config string MediumFont;
var config string SmallFont;
var config string SaveNameFont;
var config string JournalFont;

var config string SaveNameColor;
var config string JournalColor;

var config float DamageScreenShakeScale;

var config bool bMoreSkippableCutscenes;

function PostBeginPlay()
{
	// creates config file if there is none
	SaveConfig();
	
	Super.PostBeginPlay();
}

defaultproperties
{
     bGameplayChanges=True
     bGore=True
     bAutoUseHealthVials=True
     bNewHud=False
	 bShowUsedMana=False
	 JournalFont="Aeons.Dauphin16_Skinny"
	 LargeFont="Aeons.MorpheusFont"
	 MediumFont="Aeons.Dauphin_Grey"
	 SmallFont="Comic.Comic10"
	 SaveNameFont="Aeons.Dauphin16_Skinny"
	 JournalFont="Aeons.Dauphin16_Skinny"
	 SaveNameColor="#ffffff"
	 JournalColor="#ffffff"
	 DamageScreenShakeScale=1.0
	 bMoreSkippableCutscenes=False
     bAlwaysRelevant=True
     bSavable=False
}