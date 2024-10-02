//=============================================================================
// RenewalConfig.
//=============================================================================
class RenewalConfig expands Info config(RenewalSettings) transient;

var config bool bGameplayChanges;
var config bool bGore;

var config bool bAutoUseHealthVials;
var config bool bLimitHealth;
var config bool bAltHud;
var config bool bAutoShowObjectives;
var config bool bShowUsedMana;
var config float HudScale;

var config string LargeFont;
var config string MediumFont;
var config string SmallFont;
var config string SaveNameFont;
var config string JournalFont;

var config string SaveNameColor;
var config string JournalColor;

var config float DamageScreenShakeScale;

var config bool bMoreSkippableCutscenes;

var config bool bAnimatedMenu;
var config bool bSaveThumbnails;

// things that are not configurable
var config bool bShowScryeHint;
var config bool bShowQuickSelectHint;

// for live tweaking/debugging
var bool bDebug;
var bool bDebug2;
var float fDebug;
var float fDebug2;

simulated function PostBeginPlay()
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
     bLimitHealth=True
	 bSaveThumbnails=True
     bAltHud=False
	 bShowUsedMana=False
	 HudScale=1.0
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
	 bShowScryeHint=True
	 bShowQuickSelectHint=True
	 fDebug=1.0
	 fDebug2=1.0
     bAlwaysRelevant=True
     bSavable=False
     RemoteRole=ROLE_None
}
