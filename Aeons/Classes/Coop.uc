//=============================================================================
// Coop.
//=============================================================================
class Coop expands AeonsGameInfo;

var() config bool	bMultiWeaponStay;
var() config bool	bForceRespawn;
var() config bool	bAllowRespawn;
var() config bool	bNoFriendlyFire;

var() globalconfig int	FragLimit; 
var() globalconfig int	TimeLimit; // time limit in minutes
var() globalconfig bool	bMultiPlayerBots;
var() globalconfig bool bChangeLevels;
var() globalconfig bool bHardCoreMode;
var() globalconfig bool bMegaSpeed;

var		bool	bDontRestart;
var		bool	bGameEnded;
var		bool	bAlreadyChanged;
var	  int RemainingTime;

// Bot related info
var   int			NumBots;
var	  int			RemainingBots;
var() globalconfig int	InitialBots;
var		ChallengeBotInfo		BotConfig;
var class<ChallengeBotInfo> BotConfigType;

var() config string FirstMap;

var string LastPortal;
var transient bool bLastPortalSet;

// called when starting a level, even when it was already started (by loading a save), unlike PreBeginPlay and InitGame
function StartLevel()
{
	Super.StartLevel();

	if ( Level.NetMode == NM_DedicatedServer )
		LastPortal = GameEngine(XLevel.Engine).LastURL.Portal; // LastURL is set right before StartLevel call
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	bClassicDeathMessages = True;

	BotConfig = spawn(BotConfigType);
	if ( (Level.NetMode == NM_Standalone) || bMultiPlayerBots )
		RemainingBots = InitialBots;
}

function int GetIntOption( string Options, string ParseString, int CurrentValue)
{
	if ( !bTeamGame && (ParseString ~= "Team") )
		return 255;

	return Super.GetIntOption(Options, ParseString, CurrentValue);
}

function LogGameParameters(StatLog StatLog)
{
	local bool bTemp;

	if (StatLog == None)
		return;

	// hack to make sure weapon stay logging is correct for multiplayer games
	bTemp = bCoopWeaponMode;
	
	if ( Level.Netmode != NM_Standalone )
		bCoopWeaponMode = bMultiWeaponStay;	

	Super.LogGameParameters(StatLog);

	bCoopWeaponMode = bTemp;

	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"FragLimit"$Chr(9)$FragLimit);
	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"TimeLimit"$Chr(9)$TimeLimit);
	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"MultiPlayerBots"$Chr(9)$bMultiPlayerBots);
	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"HardCore"$Chr(9)$bHardCoreMode);
	StatLog.LogEventString(StatLog.GetTimeStamp()$Chr(9)$"game"$Chr(9)$"MegaSpeed"$Chr(9)$bMegaSpeed);
}

function float PlayerJumpZScaling()
{
	if ( bHardCoreMode )
		return 1.1;
	else
		return 1.0;
}

//
// Set gameplay speed.
//
function SetGameSpeed( Float T )
{
	GameSpeed = FMax(T, 0.1);
	if ( bHardCoreMode )
		Level.TimeDilation = 2.1 * GameSpeed;
	else
		Level.TimeDilation = GameSpeed;
	SetTimer(Level.TimeDilation, true);
}

event InitGame( string Options, out string Error )
{
	local string InOpt;

	Super.InitGame(Options, Error);

	SetGameSpeed(GameSpeed);
	FragLimit = GetIntOption( Options, "FragLimit", FragLimit );
	TimeLimit = GetIntOption( Options, "TimeLimit", TimeLimit );

	InOpt = ParseOption( Options, "CoopWeaponMode");
	if ( InOpt != "" )
	{
		log("CoopWeaponMode "$bool(InOpt));
		bCoopWeaponMode = bool(InOpt);
	}

	if ( Level.bLoadBootShellPSX2 )
	{
		Level.ServerTravel(FirstMap, false);
	}
}

//------------------------------------------------------------------------------
// Game Querying.

function string GetRules()
{
	local string ResultSet;
	ResultSet = Super.GetRules();

	// Timelimit.
	ResultSet = "\\timelimit\\"$TimeLimit;
		
	// Fraglimit
	ResultSet = ResultSet$"\\fraglimit\\"$FragLimit;
		
	// Bots in Multiplay?
	if( bMultiplayerBots )
		Resultset = ResultSet$"\\MultiplayerBots\\"$true;
	else
		Resultset = ResultSet$"\\MultiplayerBots\\"$false;

	// Change levels?
	if( bChangeLevels )
		Resultset = ResultSet$"\\ChangeLevels\\"$true;
	else
		Resultset = ResultSet$"\\ChangeLevels\\"$false;

	return ResultSet;
}

function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if (injured.Region.Zone.bNeutralZone)
		return 0;

	if ( instigatedBy == None)
		return Damage;

	if ( bNoFriendlyFire && instigatedBy.bIsPlayer && injured.bIsPlayer && (instigatedBy != injured) )
		return 0;

	if ( bHardCoreMode )
		Damage *= 1.5;

	//skill level modification
	if ( (instigatedBy.Skill < 1.5) && instigatedBy.IsA('Bots') && injured.IsA('PlayerPawn') )
		Damage = Damage * (0.7 + 0.15 * instigatedBy.skill);

	return (Damage * instigatedBy.DamageScaling);
}

function float PlaySpawnEffect(inventory Inv)
{
	//Playsound(sound'RespawnSound');
	if ( !bCoopWeaponMode || !Inv.IsA('Weapon') )
	{
		//spawn( class 'ReSpawn',,, Inv.Location );
		return 0.3;
	}
	return 0.0;
}

function RestartGame()
{
	local string NextMap;
	local MapList myList;

	// multipurpose don't restart variable
	if ( bDontRestart )
		return;

	log("Restart Game");
	BroadcastMessage("Restarting game...");

	// these server travels should all be relative to the current URL
	if ( bChangeLevels && !bAlreadyChanged && (MapListType != None) )
	{
		// open a the nextmap actor for this game type and get the next map
		bAlreadyChanged = true;
		myList = spawn(MapListType);
		NextMap = myList.GetNextMap();
		myList.Destroy();
		if ( NextMap == "" )
			NextMap = GetMapName(MapPrefix, NextMap,1);
		if ( NextMap != "" )
		{
			log("Changing to "$NextMap);
			Level.ServerTravel(NextMap, false);
			return;
		}
	}

	Level.ServerTravel("?Restart" , false);
}

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local PlayerPawn NewPlayer;

	Log("CoopGame - Login");

	if ( !bLastPortalSet && (Level.NetMode == NM_ListenServer || Level.NetMode == NM_Standalone) )
	{
		// on a listen server Login is called before StartLevel, and if we are loading into a saved level, PreBeginPlay and InitGame won't get called to set LastPortal
		// first login on a listen server is guaranteed to have the correct Portal passed to Login
		LastPortal = Portal;
		bLastPortalSet = true;
	}
	
	NewPlayer = Super.Login(LastPortal, Options, Error, SpawnClass );
	if ( NewPlayer != None )
	{
		if ( Left(NewPlayer.PlayerReplicationInfo.PlayerName, 6) == DefaultPlayerName )
			ChangeName( NewPlayer, (DefaultPlayerName$NumPlayers), false );
		NewPlayer.bAutoActivate = true;
		
		if ( !NewPlayer.IsA('AeonsSpectator') )
		{
			NewPlayer.bHidden = false;
			NewPlayer.SetCollision(true,true,true);
		}
	}
	else
	{
		Log("CoopGame - Super.Login failed");
	}

	//AeonsPlayer(NewPlayer).TriggerLevelBegin();

	return NewPlayer;
}

function NavigationPoint FindPlayerStart( Pawn Player, optional byte InTeam, optional string incomingName )
{
	local byte Team;

	if ( (Player != None) && (Player.PlayerReplicationInfo != None) )
		Team = Player.PlayerReplicationInfo.Team;
	else
		Team = InTeam;

	return Super.FindPlayerStart(Player, Team, LastPortal);
}

function bool ForceAddBot()
{
	AddBot();
}

function bool AddBot()
{
	local NavigationPoint StartSpot;
	local bot NewBot;
	local int BotN;

	Difficulty = BotConfig.Difficulty;
	BotN = BotConfig.ChooseBotInfo();
	
	// Find a start spot.
	StartSpot = FindPlayerStart(None, 255);
	if( StartSpot == None )
	{
		//BroadcastMessage("Could not find starting spot for Bot");
		return false;
	}

	// Try to spawn the player.
	NewBot = Spawn(class'Bot',,,StartSpot.Location,StartSpot.Rotation);
	
	if ( NewBot == None ) {
		//BroadcastMessage("NewBot is none");
		return false;
	}

	if ( (bHumansOnly || Level.bHumansOnly) && !NewBot.bIsHuman )
	{
		NewBot.Destroy();
		//BroadcastMessage("Failed to spawn bot (not human)");
		return false;
	}

	StartSpot.PlayTeleportEffect(NewBot, true);

	// Init player's information.
	BotConfig.CHIndividualize(NewBot, BotN, NumBots);
	NewBot.ViewRotation = StartSpot.Rotation;

	// broadcast a welcome message.
	BroadcastMessage( NewBot.PlayerReplicationInfo.PlayerName$EnteredMessage, true );

	//AddDefaultInventory( NewBot );
	AcceptInventory(NewBot);
	NumBots++;

	NewBot.PlayerReplicationInfo.bIsABot = True;
	NewBot.PlayerReplicationInfo.Team = BotConfig.GetBotTeam(BotN);

	// Set the player's ID.
	NewBot.PlayerReplicationInfo.PlayerID = CurrentID++;

	// Log it.
	if (LocalLog != None)
		LocalLog.LogPlayerConnect(NewBot);
	if (WorldLog != None)
		WorldLog.LogPlayerConnect(NewBot);
	
	return true;
}

function Logout(pawn Exiting)
{
	Super.Logout(Exiting);
}
	
function Timer()
{
	Super.Timer();

	if ( (RemainingBots > 0) && AddBot() )
		RemainingBots--;

	if ( bGameEnded )
	{
		RemainingTime--;
		if ( RemainingTime < -10 )
			RestartGame();
	}
	else if ( TimeLimit > 0 )
	{
		RemainingTime--;

		// switch (RemainingTime)
		// {
			// case 300:
				// BroadcastMessage(TimeMessage[0], True, 'CriticalEvent');
				// break;
			// case 240:
				// BroadcastMessage(TimeMessage[1], True, 'CriticalEvent');
				// break;
			// case 180:
				// BroadcastMessage(TimeMessage[2], True, 'CriticalEvent');
				// break;
			// case 120:
				// BroadcastMessage(TimeMessage[3], True, 'CriticalEvent');
				// break;
			// case 60:
				// BroadcastMessage(TimeMessage[4], True, 'CriticalEvent');
				// break;
			// case 30:
				// BroadcastMessage(TimeMessage[5], True, 'CriticalEvent');
				// break;
			// case 10:
				// BroadcastMessage(TimeMessage[6], True, 'CriticalEvent');
				// break;
			// case 5:
				// BroadcastMessage(TimeMessage[7], True, 'CriticalEvent');
				// break;
			// case 4:
				// BroadcastMessage(TimeMessage[8], True, 'CriticalEvent');
				// break;
			// case 3:
				// BroadcastMessage(TimeMessage[9], True, 'CriticalEvent');
				// break;
			// case 2:
				// BroadcastMessage(TimeMessage[10], True, 'CriticalEvent');
				// break;
			// case 1:
				// BroadcastMessage(TimeMessage[11], True, 'CriticalEvent');
				// break;
			// case 0:
				// BroadcastMessage(TimeMessage[12], True, 'CriticalEvent');
				// break;
		// }

		if ( RemainingTime <= 0 )
			EndGame("timelimit");
	}
}

/* AcceptInventory()
Examine the passed player's inventory, and accept or discard each item
* AcceptInventory needs to gracefully handle the case of some inventory
being accepted but other inventory not being accepted (such as the default
weapon).  There are several things that can go wrong: A weapon's
AmmoType not being accepted but the weapon being accepted -- the weapon
should be killed off. Or the player's selected inventory item, active
weapon, etc. not being accepted, leaving the player weaponless or leaving
the HUD inventory rendering messed up (AcceptInventory should pick another
applicable weapon/item as current).
*/
function AcceptInventory(pawn PlayerPawn)
{
	//PlayerPawn.Weapon = None;
	//PlayerPawn.SelectedItem = None;
	AddDefaultInventory( PlayerPawn );
	//PlayerPawn.ConsoleCommand("SetupInv");
}

//
// Spawn any default inventory for the player.
//
function AddDefaultInventory(pawn PlayerPawn)
{
	local AeonsPlayer AP;
	local Inventory newItem;

	Super.AddDefaultInventory(PlayerPawn);

	if (PlayerPawn.IsA('Spectator'))
		return;

	AP = AeonsPlayer(PlayerPawn);

	if (AP != None)
	{
		if (AP.FindInventoryType(class'Aeons.CoopTranslocator') == none)
		{
			newItem = Spawn(class'Aeons.CoopTranslocator',AP,,AP.Location);
			if( newItem != None )
			{
				newItem.GiveTo(AP);
				newItem.setBase(AP);
			}
		}
	}
}

function ChangeName( Pawn Other, coerce string S, bool bNameChange )
{
	local pawn APlayer;

	if ( S == "" )
		return;

	if (Other.PlayerReplicationInfo.PlayerName~=S)
		return;
	
	APlayer = Level.PawnList;
	
	While ( APlayer != None )
	{	
		if ( APlayer.bIsPlayer && (APlayer.PlayerReplicationInfo.PlayerName~=S) )
		{
			Other.ClientMessage(S$NoNameChange);
			return;
		}
		APlayer = APlayer.NextPawn;
	}

	if (bNameChange)
		BroadcastMessage(Other.PlayerReplicationInfo.PlayerName$GlobalNameChange$S, false);
			
	Other.PlayerReplicationInfo.PlayerName = S;
}

function SendPlayer( PlayerPawn aPlayer, string URL )
{
	if (bGameEnded)
		return;
	Level.ServerTravel( URL, true );
}

function ProcessServerTravel( string URL, bool bItems )
{
	if ( left(URL,5) ~= "start" )
	{
		Level.bNextItems          = false;
		Level.NextURL             = FirstMap;
		Level.NextSwitchCountdown = 0;
	}

	//GameEngine(XLevel.Engine).LastURL.Portal = ""; // needed when changing maps with commands, break restarting level after loading a save
	
	Super.ProcessServerTravel( URL, bItems );
}

function bool ShouldRespawn(Actor Other)
{
	if ( (Weapon(Other) != None || Spell(Other) != None) && (!bCoopWeaponMode) )
		return false;
	return ( (Inventory(Other) != None) && (Inventory(Other).ReSpawnTime!=0.0) );
}

function bool CanSpectate( pawn Viewer, actor ViewTarget )
{
	if (Pawn(ViewTarget).Health <= 0)
		return false;

	return true;
}

function Killed(pawn Killer,pawn Other,name DamageType)
{
    Super.Killed(Killer,Other,DamageType);

	if (Other.bIsPlayer)
	{
		if (!bAllowRespawn && !bGameEnded && !AreAnyPlayersAlive())
		{
			EndGame("All players dead");
		}
	}
}	

function EndGame( string Reason )
{
	local actor A;
	local pawn aPawn;

	Super.EndGame(Reason);

	bGameEnded = true;
	aPawn = Level.PawnList;
	RemainingTime = -1; // use timer to force restart
}

function bool SetEndCams(string Reason)
{
	local pawn aPawn;
	local PlayerPawn Player;
	local NavigationPoint StartSpot;

	StartSpot = FindPlayerStart(None, 255);

	for ( aPawn=Level.PawnList; aPawn!=None; aPawn=aPawn.NextPawn )
	{
		if (aPawn.IsA('ScriptedPawn'))
			aPawn.GotoState('AIWait');
		else
			aPawn.GotoState('GameEnded');
		
		Player = PlayerPawn(aPawn);
		if ( Player != None )
		{
			if ( StartSpot != None )
			{
				Player.bBehindView = true;
				Player.ViewTarget = StartSpot;
			}
			PlayWinMessage(Player, false);
			Player.ClientGameEnded();
		}
	}

	return true;
}

//
// Called when pawn has a chance to pick Item up (i.e. when 
// the pawn touches a weapon pickup). Should return true if 
// he wants to pick it up, false if he does not want it.
//
function bool PickupQuery( Pawn Other, Inventory item )
{
	local Mutator M;
	local byte bAllowPickup;
	local bool ReturnVal;
	local pawn OtherPlayer;
	local Inventory Copy;
	local Weapon CopyWeapon;
	local JournalPickup Journal;

	// if a pickup has been Trigger()-ed, it will already be given to everyone
	// be careful what items you spawn below and who you give them to
	Journal = JournalPickup(Item);
	if (Journal != None)
	{
		for ( OtherPlayer=Level.PawnList; OtherPlayer!=None; OtherPlayer=OtherPlayer.NextPawn)	
		{
			if ( OtherPlayer.bIsPlayer && OtherPlayer != Other && AeonsPlayer(OtherPlayer) != None )
				Journal.GiveJournal(AeonsPlayer(OtherPlayer));
		}
	}
	else if (Item.IsA('Weapon') || Item.IsA('Spell'))
	{
		for ( OtherPlayer=Level.PawnList; OtherPlayer!=None; OtherPlayer=OtherPlayer.NextPawn)	
		{
			if ( OtherPlayer.bIsPlayer && OtherPlayer != Other && OtherPlayer.Inventory.FindItemInGroup(item.InventoryGroup) == none )
			{
				Copy = spawn(Item.Class,OtherPlayer,,,rot(0,0,0));

				Copy.Instigator = OtherPlayer;
				Copy.BecomeItem();
				if (!OtherPlayer.AddInventory(Copy))
				{
					Copy.Destroy();
					continue;
				}

				if( Copy.IsA('Spell') )
				{
					Copy.GotoState('Idle2');
				}
				if( Copy.IsA('Weapon') )
				{
					CopyWeapon = Weapon(Copy);
					CopyWeapon.BringUp();
					CopyWeapon.GiveAmmo(OtherPlayer);
					CopyWeapon.SetSwitchPriority(OtherPlayer);
					CopyWeapon.WeaponSet(OtherPlayer);
				}
			}
		}
	}

	return Super.PickupQuery(Other, Item);
}

function bool AreAnyPlayersAlive()
{
	local Pawn Pawn;

	for ( Pawn=Level.PawnList; Pawn!=None; Pawn=Pawn.NextPawn )	
		if ( Pawn.bIsPlayer && Pawn.Health > 0 )
			return true;

	return false;	
}
//
// Restart a player.
//
function bool RestartPlayer( pawn aPlayer )	
{
	local Actor PrevViewTarget;
	local bool PrevBehindView;

	if (bAllowRespawn)
	{
		return Super.RestartPlayer(aPlayer);
	}

	// spectate
	PrevViewTarget = PlayerPawn(aPlayer).ViewTarget;
	PrevBehindView = PlayerPawn(aPlayer).bBehindView;
	PlayerPawn(aPlayer).ViewPlayerNum(-1);
	if (PlayerPawn(aPlayer).ViewTarget == None)
	{
		PlayerPawn(aPlayer).ViewTarget = PrevViewTarget;
		PlayerPawn(aPlayer).bBehindView = PrevBehindView;
	}
	
	//bBehindView = bChaseCam;
	//if ( ViewTarget == None )
	//	bBehindView = false;

	return false;
}

defaultproperties
{
     BotConfigType=Class'Aeons.ChallengeBotInfo'
     InitialBots=2
     bMultiWeaponStay=True
     FragLimit=0
	 bCoopWeaponMode=True
     bRestartLevel=False
	 bSinglePlayer=False
     bDeathMatch=False
     ScoreBoardType=Class'Aeons.UndyingScoreboard'
     MapPrefix=""
     BeaconName="COOP"
     GameName="Co-op"
     bChangeLevels=True
     FirstMap="Manor_FrontGate"
     bTeamGame=True
     bAllowRespawn=False
     bNoFriendlyFire=True
}
