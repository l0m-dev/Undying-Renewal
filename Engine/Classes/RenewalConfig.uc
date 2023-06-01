//=============================================================================
// RenewalConfig.
//=============================================================================
class RenewalConfig expands Info config(RenewalSettings) transient;

var config bool bAutoUseHealthVials;
var config bool bNewHud;

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
     bAutoUseHealthVials=True
     bNewHud=False
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
