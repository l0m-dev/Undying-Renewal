//=============================================================================
// ChallengeBotInfo.
//=============================================================================
class ChallengeBotInfo extends Info
	config(User);

var() config string VoiceType[32];
var() config bool	bAdjustSkill;
var() config bool	bRandomOrder;
var   config byte	Difficulty;

var() config string BotNames[32];
var() config int BotTeams[32];
var() config float BotSkills[32];
var() config float BotAccuracy[32];
var() config float Alertness[32];
var() config float Camping[32];
var() config float StrafingAbility[32];
var	  byte ConfigUsed[32];
var() config byte BotJumpy[32];
var localized string Skills[8];
var string DesiredName;

var int PlayerKills, PlayerDeaths;
var float AdjustedDifficulty;

function PreBeginPlay()
{
	//DON'T Call parent prebeginplay
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
}

function AdjustSkill(Bot B, bool bWinner)
{
	local float BotSkill;

	BotSkill = B.Skill;
	if ( !b.bNovice )
		BotSkill += 4;

	if ( bWinner )
	{
		PlayerKills += 1;
		AdjustedDifficulty = FMax(0, AdjustedDifficulty - 2/Min(PlayerKills, 10));
		if ( BotSkill > AdjustedDifficulty )
			B.Skill = AdjustedDifficulty;
		if ( B.Skill < 4 )
		{
			B.bNovice = true;
			if ( B.Skill > 3 )
			{
				B.Skill = 3;
				B.bThreePlus = true;
			}
		}
		else
		{
			B.Skill -= 4;
			B.bNovice = false;
		}
	}
	else
	{
		PlayerDeaths += 1;
		AdjustedDifficulty += FMin(7,2/Min(PlayerDeaths, 10));
		if ( BotSkill < AdjustedDifficulty )
			B.Skill = AdjustedDifficulty;
		if ( B.Skill < 4 )
		{
			B.bNovice = true;
			if ( B.Skill > 3 )
			{
				B.Skill = 3;
				B.bThreePlus = true;
			}
		}
		else
		{
			B.Skill -= 4;
			B.bNovice = false;
		}
	}
	if ( abs(AdjustedDifficulty - Difficulty) >= 1 )
	{
		Difficulty = AdjustedDifficulty;
		SaveConfig();
	}
}

function SetBotName( coerce string NewName, int n )
{
	BotNames[n] = NewName;
}

function String GetBotName(int n)
{
	return BotNames[n];
}

function int GetBotTeam(int num)
{
	return BotTeams[Num];
}

function SetBotTeam(int NewTeam, int n)
{
	BotTeams[n] = NewTeam;
}

function CHIndividualize(bot NewBot, int n, int NumBots)
{
	n = Clamp(n,0,31);

	// Set bot's name.
	if ( (BotNames[n] == "") || (ConfigUsed[n] == 1) )
		BotNames[n] = "Bot";

	Level.Game.ChangeName( NewBot, BotNames[n], false );
	if ( BotNames[n] != NewBot.PlayerReplicationInfo.PlayerName )
		Level.Game.ChangeName( NewBot, ("Bot"$NumBots), false);

	ConfigUsed[n] = 1;

	// adjust bot skill
	NewBot.InitializeSkill(Difficulty + BotSkills[n]);

	NewBot.Accuracy = BotAccuracy[n];
	NewBot.BaseAggressiveness = 0.5 * (NewBot.Default.Aggressiveness + NewBot.CombatStyle);
	NewBot.BaseAlertness = Alertness[n];
	NewBot.CampingRate = Camping[n];
	NewBot.bJumpy = ( BotJumpy[n] != 0 );
	NewBot.StrafingAbility = StrafingAbility[n];

	if ( VoiceType[n] != "" && VoiceType[n] != "None" )
		NewBot.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(VoiceType[n], class'Class'));
	
	if(NewBot.PlayerReplicationInfo.VoiceType == None)
		NewBot.PlayerReplicationInfo.VoiceType = class<VoicePack>(DynamicLoadObject(NewBot.VoiceType, class'Class'));
}

function int ChooseBotInfo()
{
	local int n, start;

	if ( DesiredName != "" )
	{
		for ( n=0; n<32; n++ )
			if ( BotNames[n] ~= DesiredName )
			{
				DesiredName = "";
				return n;
			}
		DesiredName = "";
	}

	if ( bRandomOrder )
		n = Rand(32);
	else 
		n = 0;

	start = n;
	while ( (n < 32) && (ConfigUsed[n] == 1) )
		n++;

	if ( (n == 32) && bRandomOrder )
	{
		n = 0;
		while ( (n < start) && (ConfigUsed[n] == 1) )
			n++;
	}

	if ( n > 31 )
		n = 31;

	return n;
}

function int GetBotIndex( coerce string BotName )
{
	local int i;
	local bool found;

	found = false;
	for (i=0; i<ArrayCount(BotNames)-1; i++)
		if (BotNames[i] == BotName)
		{
			found = true;
			break;
		}

	if (!found)
		i = -1;

	return i;
}

defaultproperties
{
     bRandomOrder=True
     Difficulty=1
     BotNames(0)="Archon"
     BotNames(1)="Aryss"
     BotNames(2)="Alarik"
     BotNames(3)="Dessloch"
     BotNames(4)="Cryss"
     BotNames(5)="Nikita"
     BotNames(6)="Drimacus"
     BotNames(7)="Rhea"
     BotNames(8)="Raynor"
     BotNames(9)="Kira"
     BotNames(10)="Karag"
     BotNames(11)="Zenith"
     BotNames(12)="Cali"
     BotNames(13)="Alys"
     BotNames(14)="Kosak"
     BotNames(15)="Illana"
     BotNames(16)="Barak"
     BotNames(17)="Kara"
     BotNames(18)="Tamerlane"
     BotNames(19)="Arachne"
     BotNames(20)="Liche"
     BotNames(21)="Jared"
     BotNames(22)="Ichthys"
     BotNames(23)="Tamara"
     BotNames(24)="Loque"
     BotNames(25)="Athena"
     BotNames(26)="Cilia"
     BotNames(27)="Sarena"
     BotNames(28)="Malakai"
     BotNames(29)="Visse"
     BotNames(30)="Necroth"
     BotNames(31)="Kragoth"
     BotTeams(0)=255
     BotTeams(2)=255
     BotTeams(3)=1
     BotTeams(4)=255
     BotTeams(5)=2
     BotTeams(6)=255
     BotTeams(7)=3
     BotTeams(8)=255
     BotTeams(10)=255
     BotTeams(11)=1
     BotTeams(12)=255
     BotTeams(13)=2
     BotTeams(14)=255
     BotTeams(15)=3
     BotTeams(16)=255
     BotTeams(18)=255
     BotTeams(19)=1
     BotTeams(20)=255
     BotTeams(21)=2
     BotTeams(22)=255
     BotTeams(23)=3
     BotTeams(24)=255
     BotTeams(26)=255
     BotTeams(27)=1
     BotTeams(28)=255
     BotTeams(29)=2
     BotTeams(30)=255
     BotTeams(31)=3
     BotAccuracy(17)=0.200000
     BotAccuracy(18)=0.900000
     BotAccuracy(19)=0.600000
     BotAccuracy(20)=0.500000
     BotAccuracy(24)=1.000000
     BotAccuracy(27)=0.500000
     BotAccuracy(28)=0.500000
     BotAccuracy(29)=0.600000
     Alertness(18)=-0.300000
     Alertness(20)=0.300000
     Alertness(22)=0.300000
     Alertness(24)=0.300000
     Alertness(29)=0.400000
     Camping(18)=1.000000
     Camping(28)=0.500000
     StrafingAbility(17)=0.500000
     StrafingAbility(20)=0.500000
     StrafingAbility(21)=1.000000
     StrafingAbility(22)=0.500000
     StrafingAbility(23)=0.500000
     StrafingAbility(24)=0.500000
     StrafingAbility(25)=0.500000
     StrafingAbility(26)=0.500000
     StrafingAbility(29)=1.000000
     BotJumpy(30)=1
     BotJumpy(31)=1
     Skills(0)="Novice"
     Skills(1)="Average"
     Skills(2)="Experienced"
     Skills(3)="Skilled"
     Skills(4)="Adept"
     Skills(5)="Masterful"
     Skills(6)="Inhuman"
     Skills(7)="Godlike"
}
