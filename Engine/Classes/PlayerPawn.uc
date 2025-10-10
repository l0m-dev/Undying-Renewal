//=============================================================================
// PlayerPawn.
// player controlled pawns
// Note that Pawns which implement functions for the PlayerTick messages
// must handle player control in these functions
//=============================================================================
class PlayerPawn extends Pawn
	config(user)
	native
	nativereplication;

// Player info.
var const player Player;
var	globalconfig string Password;	// for restarting coop savegames

var globalconfig color InvokeColor;
var globalconfig color CrossHairColor;
var globalconfig color LitCrossHairColor;
var globalConfig float CrossHairAlpha;
var globalconfig color CrossHairInvokeColor;

var	travel PlayerModifier	SpeedMod;			// Speed Modifier

var(Movement) globalconfig float Bob;
var			  float				LandBob, AppliedBob;
var float bobtime;

var bool	bCanRestart;				// player can click fire after dying - this is set on a timer in the dying state to force
												// the player to sit there for a few sceonds before allowing them to restart.
var bool	bRenderSelf;				// used only for cutscenes to display and hide the player for a cleaner visual effect.
var bool	bAmplifySpell;
// (new) crouching vars
var() float		CrouchCollisionHeight;	// final CollisionHeight when crouching
var() float		CrouchEyeHeight;		// final BaseEyeHeight when crouching
var() float		CrouchRate;				// time it takes to get to fully crouched
var() float		CrouchSpeedScale;		// speed scale when crouched
var float		CrouchTime;				// internal transition timer [0.0, 1.0] (0.0 is no crouch, 1.0 is fully crouched)

var() float		WalkingSpeedScale;		// Speed scale when walking

var bool		bAllowMove;

// Icons of Shame
var StatManager IconsofShame;

// Camera info.
var int ShowFlags;
var int RendMap;
var int Misc1;
var int Misc2;

var actor ViewTarget;
var vector FlashScale, FlashFog;
var HUD	myHUD;
var ScoreBoard Scoring;
var class<hud> HUDType;
var class<scoreboard> ScoringType;

var float DesiredFlashScale, ConstantGlowScale, InstantFlash;
var vector DesiredFlashFog, ConstantGlowFog, InstantFog;
var travel globalconfig float DesiredFOV;
var globalconfig float DefaultFOV;
var globalConfig float ZoomFOV;

// EyeTrace Info

var vector EyeTraceLoc, EyeTraceNormal;
var int EyeTraceJoint; 
var Actor EyeTraceActor;

// Music info.
var music Song;
var byte  SongSection;
var byte  CdTrack;
var EMusicTransition Transition;

var float shaketimer; // player uses this for shaking view
var int shakemag;	// max magnitude in degrees of shaking
var float shakevert; // max vertical shake magnitude
var float maxshake;
var float verttimer;
var travel float ScryeTimer;
var() float ScryeFullTime;
var() float ScryeRampTime;
var(Pawn) class<carcass> CarcassType;
var travel globalconfig float MyAutoAim;
var travel globalconfig float Handedness;
var(Sounds) sound JumpSound[2];

// Player control flags
var bool		bAdmin;
var() globalconfig bool 		bLookUpStairs;	// look up/down stairs (player)
var() globalconfig bool		bSnapToLevel;	// Snap to level eyeheight when not mouselooking
var() globalconfig bool		bAlwaysMouseLook;
var globalconfig bool 		bKeyboardLook;	// no snapping when true
var bool		bWasForward;	// used for dodge move 
var bool		bWasBack;
var bool		bWasLeft;
var bool		bWasRight;
var bool		bEdgeForward;
var bool		bEdgeBack;
var bool		bEdgeLeft;
var bool 		bEdgeRight;
var bool		bIsCrouching;
var	bool		bShakeDir;			
var bool		bAnimTransition;
var bool		bIsTurning;
var bool		bFrozen;
var bool        bBadConnectionAlert;
var globalconfig bool	bInvertMouse;
var bool		bShowScores;
var bool		bShowMenu;
var bool		bSpecialMenu;
var bool		bWokeUp;
var bool		bPressedJump;
var bool		bUpdatePosition;
var bool		bDelayedCommand;
var bool		bRising;
var bool		bReducedVis;
var bool		bCenterView;
var() globalconfig bool bMouseDecel;
var() globalconfig bool bMouseSmoothing;
var() globalconfig bool bMaxMouseSmoothing;
var bool		bMouseZeroed;
var bool		bReadyToPlay;
var globalconfig bool bNoFlash;
var globalconfig bool bNoVoices;
var globalconfig bool bMessageBeep;
var bool		bZooming;
var() bool		bSinglePlayer;		// this class allowed in single player
var bool		bJustFired;
var bool		bJustFiredAttSpell;
var bool		bJustFiredDefSpell;
var bool		bIsTyping;
var bool		bFixedCamera;
var globalconfig bool	bNeverAutoSwitch;	// if true, don't automatically switch to picked up weapon
var bool		bJumpStatus;	// used in net games
var	bool		bUpdating;
var bool		bCheatsEnabled;
var bool		bHaveTarget;
var bool		bUsingAutoAim;
var bool		bCanExitSpecialState;
var bool		bUpdateInventorySelect;
var float		ZoomLevel;

var class<menu> SpecialMenu;
var string DelayedCommand;
var globalconfig float	MouseSensitivity;
var globalconfig float 	GoreLevel;

var bool bReloading;		// player is reloading their weapon right now.
var globalconfig name	WeaponPriority[50]; //weapon class priorities (9 is highest)
var(Display) texture MultiSkins[8];

var float SmoothMouseX, SmoothMouseY, BorrowedMouseX, BorrowedMouseY;
var() globalconfig float MouseSmoothThreshold;
var float MouseZeroTime;

// Input axes.
var input float 
	aBaseX, aBaseY, aBaseZ,
	aMouseX, aMouseY,
	aForward, aTurn, aStrafe, aUp, 
	aLookUp, aExtra4, aExtra3, aExtra2,
	aExtra1, aExtra0;

var input byte
    bCtrl, bSelectWeapon, bSelectAttSpell, bSelectDefSpell;

// these are for scrolling thru weapons/spells on PS2
var input byte
    bScrollWeapon, bScrollAttSpell, bScrollDefSpell,
	bAxisLeft, bAxisRight, bAxisUp, bAxisDown;

// Controller values.
var bool bDigitalStickPSX2;
var float
	cJoyX, cJoyY, cJoyZ, cJoyR;

/////////////////////////////////////
// Actuator support (PSX2).

// struct used for each actuator
struct ActData
{
	var float timer;
	var float stamp;
	var int directdata;
	var int func;
	var int subfunc;
	var int directdatasize;
	var int	effect;
};

// error control
enum EActError
{
	ACT_NoError,
	ACT_ContError,
	ACT_ContBusy,
	ACT_AllocError,
	ACT_InvalidCombo,
	ACT_InvalidActuator,
	ACT_InvalidOption,
	ACT_AlignReset,
	ACT_TransmitError
};

// support variables
var int			Port;				// port to which the controller is plugged
var int			Slot;				// slot connection on the multi-tap
var float		Time;				// time at last run of Tick
var int			NoActuators;		// total number of actuators
var int			MaxActuators;		// maximum number of actuators in array (set in default)
var ActData		ActuatorData[5];	// array of ActData structs (default max)
var int			NoComboLists;		// total number of combolists
var int			MaxCombo;			// maximum number of combolists allowed (set in default)
var int			ComboData[100];		// array storing data about combo lists (default_act * default_combo)
var int			ActiveList;			// flags indicating whether or not an actuator is active
var byte		ActiveActuators;	// number of active actuators
var bool		bModeFlag;			// has the controller mode changed
var() bool		bVibrateOn;			// is vibration active?

// Move Buffering.
var SavedMove SavedMoves;
var SavedMove FreeMoves;
var SavedMove PendingMove;
var float CurrentTimeStamp,LastUpdateTime,ServerTimeStamp,TimeMargin, ClientUpdateTime;
var globalconfig float MaxTimeMargin;

// Progess Indicator.
var string ProgressMessage[8];
var color ProgressColor[8];
var float ProgressTimeOut;

// Localized strings
var localized string QuickSaveString;
var localized string NoPauseMessage;
var localized string ViewingFrom;
var localized string OwnCamera;
var localized string FailedView;

// SpecialKill
var Pawn Killer;

// ReplicationInfo
var GameReplicationInfo GameReplicationInfo;

// ngWorldStats Logging
var() globalconfig private string ngWorldSecret;
var() globalconfig bool ngSecretSet;
var bool ReceivedSecretChecksum;

// Remote Pawn ViewTargets
var rotator TargetViewRotation; 
var float TargetEyeHeight;
var vector TargetWeaponViewOffset;

// Demo recording view rotation
var int DemoViewPitch;
var int DemoViewYaw;

var float LastPlaySound;

var globalconfig bool bEnableSubtitles;

var float MaxResponseTime;		 // how long server will wait for client move update before setting position

// Clientside smoothing of position adjustment.
var transient vector PreAdjustLocation;
var transient vector AdjustLocationOffset;
var transient float AdjustLocationAlpha;

// Serverside buffering of position adjustment.
var transient float LastClientTimestamp;
var transient vector LastClientLocation;

var() globalconfig bool bDisableMovementBuffering;
const SmoothAdjustLocationTime = 0.35f;

replication
{
	// Things the server should send to the client.
	reliable if( bNetOwner && Role==ROLE_Authority )
		ViewTarget, ScoringType, HUDType, GameReplicationInfo, bFixedCamera, bCheatsEnabled, ScryeTimer, ScryeFullTime, bAmplifySpell, bAllowMove; // ScryeFullTime and bAmplifySpell are not replicated natively
	unreliable if ( bNetOwner && Role==ROLE_Authority )
		TargetViewRotation, TargetEyeHeight, TargetWeaponViewOffset;
	reliable if( bDemoRecording && Role==ROLE_Authority )
		DemoViewPitch, DemoViewYaw;

	// Things the client should send to the server
	reliable if ( Role<ROLE_Authority )
		Password, bReadyToPlay, bNeverAutoSwitch;

	// Functions client can call.
	unreliable if( Role<ROLE_Authority )
		CallForHelp;
	reliable if( Role<ROLE_Authority )
		ShowPath, RememberSpot, Speech, Say, TeamSay, RestartLevel, SwitchWeapon, Pause, SetPause, ServerSetHandedness,
		PrevItem, ActivateItem, ShowInventory, Grab, ServerFeignDeath, ServerSetWeaponPriority,
		ChangeName, ChangeTeam, Eh, ViewClass, ViewPlayerNum, ViewSelf, ViewPlayer, ServerSetSloMo, ServerAddBots,
		PlayersOnly, ThrowWeapon, ServerRestartPlayer, NeverSwitchOnPickup, BehindView, ServerNeverSwitchOnPickup, 
		PrevWeapon, NextWeapon, Arm, ServerReStartGame, ServerUpdateWeapons, ServerTaunt, ServerChangeSkin,
		SwitchLevel, SwitchCoopLevel, Kick, KickBan, Bring, Admin, AdminLogin, AdminLogout, Typing, ServerMutate,
		NextAttSpell, CheckGameEvent, GetSaveGameListMultiplayer, Woo, ActivateInventoryItem, ActivateInventoryItemInGroup,
		Map;

	unreliable if( Role<ROLE_Authority )
		ServerMove, Aerial, Walk, Astral;

	// Functions server can call.
	reliable if( Role==ROLE_Authority && !bDemoRecording )
		ClientTravel;
	reliable if( Role==ROLE_Authority )
		LetterBox, LetterboxAspect, LetterBoxRate, ShowMOTD;
	
	//reliable if( Role==ROLE_Authority )
	//	TriggerLevelBegin;
	
	reliable if( Role==ROLE_Authority )
		ClientReliablePlaySound, ClientReplicateSkins, ClientAdjustGlow, ClientChangeTeam, ClientSetMusic, StartZoom, ToggleZoom, StopZoom, EndZoom, SetDesiredFOV, ClearProgressMessages, SetProgressColor, SetProgressMessage, SetProgressTime, ClientWeaponEvent,
		ClientSetLocalAnims,
		ClientReplicateMesh;//, ClientPlayAnim;
	unreliable if( Role==ROLE_Authority )
		SetFOVAngle, ClientShake, ClientFlash, ClientInstantFlash, bRenderSelf;//, bRenderSelf//fix bRenderSelf should just be coded in a special game type for CutScenes or in a subclassed player
	unreliable if( Role==ROLE_Authority && !bDemoRecording )
		ClientPlaySound;
	unreliable if( RemoteRole==ROLE_AutonomousProxy )//***
		ClientAdjustPosition;

	// Rendering.
	unreliable if( DrawType==DT_Mesh && Role==ROLE_Authority )
		MultiSkins;
}

//
// native client-side functions.
//
native event ClientTravel( string URL, ETravelType TravelType, bool bItems );
native(544) final function ResetKeyboard();
native(546) final function UpdateURL(string NewOption, string NewValue, bool bSaveDefault);
native final function string GetDefaultURL(string Option);
native final function LevelInfo GetEntryLevel();
native final function string GetPlayerNetworkAddress();
// Execute a console command in the context of this player, then forward to Actor.ConsoleCommand.
native function string ConsoleCommand( string Command );
native function CopyToClipboard( string Text );
native function string PasteFromClipboard();
// Actuator functions.
native(2008) final function int InitAct (int Port, int Slot);
native(2009) final function int ResetAct ();
native(2010) final function int GetNoActuators ();
native(2011) final function int ActivateActuator (int ActIndex, int Effect, float Intensity, float Timer);
native(2012) final function int RunActuator ();

// Called when a GUI window is opened or closed.
native(2033) final function GUIEnter(viewport v);
native(2034) final function GUIExit(viewport v);

simulated final function LevelInfo GetEntryLevelSafe()
{
	if (GameEngine(XLevel.Engine).GEntry == None)
		return None;
	return GetEntryLevel();
}

function PressedEscape(); // Player Pressed the Spacebar
function PressedSpaceBar(); // Player Pressed the Spacebar
function PressedEnter(); // Player Pressed the Enter Key

exec function WeaponAction(){}

function InitPlayerReplicationInfo()
{
	Super.InitPlayerReplicationInfo();

	PlayerReplicationInfo.bAdmin = bAdmin;
}

event PreClientTravel()
{
}

event ClientTravelCleanupServer()
{
}

function DisableSaveGame();
function EnableSaveGame();

exec function Ping()
{
	ClientMessage("Current ping is"@PlayerReplicationInfo.Ping);
}

function ClientWeaponEvent(name EventType)
{
	if ( Weapon != None )
		Weapon.ClientWeaponEvent(EventType);
}

simulated event RenderOverlays( canvas Canvas )
{
	if ( Weapon != None )
		Weapon.RenderOverlays(Canvas);

	if ( myHUD != None )
		myHUD.RenderOverlays(Canvas);
}

function ClientReplicateSkins(texture Skin1, optional texture Skin2, optional texture Skin3, optional texture Skin4)
{
	// do nothing (just loading other player skins onto client)
	//log("Getting "$Skin1$", "$Skin2$", "$Skin3$", "$Skin4);
	return;
}

function ClientReplicateMesh(name MeshName)
{
	// do nothing (just loading other player mesh onto client)
	//log("Getting "$MeshName);
	return;
}

function CheckBob(float DeltaTime, float Speed2D, vector Y)
{
	local float OldBobTime;

	OldBobTime = BobTime;
	if ( Speed2D < 10 || GroundSpeed < 10 )
		BobTime += 0.2 * DeltaTime;
	else
		BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
	WalkBob = Y * 0.65 * Bob * Speed2D * sin(6 * BobTime);
	AppliedBob = AppliedBob * (1 - FMin(1, 16 * deltatime));
	if ( LandBob > 0.01 )
	{
		AppliedBob += FMin(1, 16 * deltatime) * LandBob;
		LandBob *= (1 - 8*Deltatime);
	}
	if ( Speed2D < 10 )
		WalkBob.Z = AppliedBob + Bob * 30 * sin(12 * BobTime);
	else
		WalkBob.Z = AppliedBob + Bob * Speed2D * sin(12 * BobTime);
}

exec function ViewPlayerNum(optional int num)
{
	local Pawn P;

	if ( !PlayerReplicationInfo.bIsSpectator && !Level.Game.bTeamGame )
		return;
	if ( num >= 0 )
	{
		P = Pawn(ViewTarget);
		if ( (P != None) && P.bIsPlayer && (P.PlayerReplicationInfo.TeamID == num) )
		{
			ViewTarget = None;
			bBehindView = false;
			return;
		}
		for ( P=Level.PawnList; P!=None; P=P.NextPawn )
			if ( (P.PlayerReplicationInfo != None) && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
				&& !P.PlayerReplicationInfo.bIsSpectator
				&& (P.PlayerReplicationInfo.TeamID == num) )
			{
				if ( P != self )
				{
					ViewTarget = P;
					bBehindView = true;
				}
				return;
			}
		return;
	}
	if ( Role == ROLE_Authority )
	{
		ViewClass(class'Pawn', true);
		While ( (ViewTarget != None) 
				&& (!Pawn(ViewTarget).bIsPlayer || Pawn(ViewTarget).PlayerReplicationInfo.bIsSpectator) )
			ViewClass(class'Pawn', true);

		if ( ViewTarget != None )
			ClientMessage(ViewingFrom@Pawn(ViewTarget).PlayerReplicationInfo.PlayerName, 'Event', true);
		else
			ClientMessage(ViewingFrom@OwnCamera, 'Event', true);
	}
}

exec function Profile()
{
	//TEMP for performance measurement

	log("Average AI Time"@Level.AvgAITime);
	log(" < 5% "$Level.AIProfile[0]);
	log(" < 10% "$Level.AIProfile[1]);
	log(" < 15% "$Level.AIProfile[2]);
	log(" < 20% "$Level.AIProfile[3]);
	log(" < 25% "$Level.AIProfile[4]);
	log(" < 30% "$Level.AIProfile[5]);
	log(" < 35% "$Level.AIProfile[6]);
	log(" > 35% "$Level.AIProfile[7]);
}

// Execute an administrative console command on the server.
exec function Admin( string CommandLine )
{
	local string Result;
	if( bAdmin )
		Result = ConsoleCommand( CommandLine );
	if( Result!="" )
		ClientMessage( Result );
}

// Login as the administrator.
exec function AdminLogin( string Password )
{
	Level.Game.AdminLogin( Self, Password );
}

// Logout as the administrator.
exec function AdminLogout()
{
	Level.Game.AdminLogout( Self );
}

exec function SShot()
{
	local float b;
	b = float(ConsoleCommand("get ini:Engine.Engine.ViewportManager Brightness"));
	ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness 1");
	ConsoleCommand("flush");
	ConsoleCommand("shot");
	ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$string(B));
	ConsoleCommand("flush");
}

function DoEyeTrace()
{
	local float Range;
	
	Range = 8192;
	EyeTraceActor = none;

	EyeTraceActor = EyeTrace(EyeTraceLoc, EyeTraceNormal, EyeTraceJoint, Range, true);
	//if ( EyeTraceActor != none )
	//	EyeTraceActor = EyeTrace(EyeTraceLoc, EyeTraceNormal, Range, false);
}

exec function PlayerList()
{
	local PlayerReplicationInfo PRI;

	log("Player List:");
	ForEach AllActors(class'PlayerReplicationInfo', PRI)
		log(PRI.PlayerName@"( ping"@PRI.Ping$")");
}

//
// Native ClientSide Functions
//

event ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	Message.Static.ClientReceive( Self, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

event ClientMessage( coerce string S, optional Name Type, optional bool bBeep )
{
	if ( Level.bDebugMessaging || (Type == 'Pickup'))
	{
		if (Player == None)
			return;

		if (Type == '')
			Type = 'Event';

		if (Player.Console != None)
			Player.Console.Message( PlayerReplicationInfo, S, Type );
		if (bBeep && bMessageBeep)
			PlayBeepSound();
		if ( myHUD != None )
			myHUD.Message( PlayerReplicationInfo, S, Type );
	}
}

event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type, optional bool bBeep  )
{
	if (Player.Console != None)
		Player.Console.Message ( PRI, S, Type );
	if (bBeep && bMessageBeep && S != "")
		PlayBeepSound();
	if ( myHUD != None )
		myHUD.Message( PRI, S, Type );
}

event ChatMessage( PlayerReplicationInfo PRI, coerce string S, name Type, optional color Color  )
{
	if ( myHUD != None )
		myHUD.ChatMessage( PRI, S, Type, Color );
}

function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID)
{
	local VoicePack V;

	if ( (Sender == None) || (Sender.voicetype == None) || (Player.Console == None) )
		return;
		
	V = Spawn(Sender.voicetype, self);
	if ( V != None )
		V.ClientInitialize(Sender, Recipient, messagetype, messageID);
}

simulated function PlayBeepSound();

/*-------------------------------------------------------------------------
                        Movement replication code.
-------------------------------------------------------------------------*/

function SendServerMove( SavedMove Move, optional SavedMove OldMove)
{
	local byte ClientRoll;
	local float OldTimeDelta;
	local int OldAccel;
	local byte MoveFlags;
	local int View;

	ClientRoll = (Rotation.Roll >> 8) & 255;
	View = (32767 & (Move.SavedViewRotation.Pitch/2)) * 32768 + (32767 & (Move.SavedViewRotation.Yaw/2));
	
	// check if need to redundantly send previous move
	if ( OldMove != None )
	{
		// log("Redundant send timestamp "$OldMove.TimeStamp$" accel "$OldMove.Acceleration$" at "$Level.Timeseconds$" New accel "$NewAccel);
		// old move important to replicate redundantly
		OldTimeDelta = FMin(255, (Level.TimeSeconds - OldMove.TimeStamp) * 500);
		OldAccel = OldMove.Compress();
	}
	
	ServerMove
	(
		Move.TimeStamp,
		Move.Acceleration * 10,
		Location,
		Move.bRun,
		Move.bDuck,
		bJumpStatus,
		Move.bFire,
		Move.bForceFire,
		Move.bFireAttSpell, 
		Move.bForceFireAttSpell, 
		Move.bFireDefSpell, 
		Move.bForceFireDefSpell,
		ClientRoll,
		View,
		OldTimeDelta,
		OldAccel
	);
}

//
// Send movement to the server.
//
function ServerMove
(
	float TimeStamp, 
	vector InAccel, 
	vector ClientLoc,
	bool NewbRun,
	bool NewbDuck,
	bool NewbJumpStatus, 
	bool bFired,
	bool bForceFire,
	bool bFiredAttSpell,
	bool bForceFireAttSpell,
    bool bFiredDefSpell,
	bool bForceFireDefSpell,
	byte ClientRoll, 
	int View,
	optional byte OldTimeDelta,
	optional int OldAccel
)
{
	local float DeltaTime, clientErr, OldTimeStamp;
	local rotator DeltaRot, Rot;
	local vector Accel, LocDiff;
	local float maxPitch;
	local int ViewPitch, ViewYaw;
	local actor OldBase;
	local bool NewbPressedJump, OldbRun, OldbDuck;

	// If this move is outdated, discard it.
	if ( CurrentTimeStamp >= TimeStamp )
		return;
	
	// if OldTimeDelta corresponds to a lost packet, process it first
	if (  OldTimeDelta != 0 )
		OldServerMove( TimeStamp, NewbJumpStatus, OldTimeDelta, OldAccel );	

	// View components
	ViewPitch = View/32768;
	ViewYaw = 2 * (View - 32768 * ViewPitch);
	ViewPitch *= 2;
	// Make acceleration.
	Accel = InAccel/10;

	NewbPressedJump = (bJumpStatus != NewbJumpStatus);
	bJumpStatus = NewbJumpStatus;

	if ( bFired )
	{
		if ( bForceFire && (Weapon != None) )
		{
			Weapon.ForceFire();
		}
		else if ( bFire == 0 )
		{
			//log("ServerMove: calling Fire");
			Fire(0);
		}
		bFire = 1;
	}
	else
		bFire = 0;

	if ( NewbDuck )
		bDuck = 1;
	else
		bDuck = 0;

    //only one allow to be true at a time
    if ( bFiredAttSpell && bFiredDefSpell )
    {
		//we keep the currently down key
        if ( bFireAttSpell == 1)
            bFiredDefSpell = false;
        else if ( bFireDefSpell == 1)
            bFiredAttSpell = false;
        else
            bFiredDefSpell = false;

		//Log("bFiredAttSpell and bFiredDefSpell were both TRUE in ServerMove:  Att="$bFiredAttSpell$" Def="$bFiredDefSpell);
    }

//	Log("PlayerPawn: ServerMove: before check for bFiredAttSpell");
// AttSpell firing
    if ( bFiredAttSpell )
	{
//		Log("PlayerPawn: ServerMove: bFiredAttSpell is TRUE");
		if ( bForceFireAttSpell && (AttSpell != None ))
		{
			//Log("PlayerPawn: ServerMove: bForceFireAttSpell");
			AttSpell.ForceFire();
		}
		else if ( bFireAttSpell == 0 )
		{
//			Log("PlayerPawn: ServerMove: FireAttSpell");
			FireAttSpell(0);			
		}
//		Log("PlayerPawn: ServerMove: bFireAttSpell getting set to 1");
		bFireAttSpell = 1;
	}
	else
//		Log("PlayerPawn: ServerMove: bFireAttSpell getting set to 0");
		bFireAttSpell = 0;

// DefSpell firing
    if ( bFiredDefSpell )
	{
		if ( bForceFireDefSpell && (DefSpell != None ))
		{
			DefSpell.ForceFire();
		}
		else if ( bFireDefSpell == 0 )
		{
			FireDefSpell(0);			
		}
		bFireDefSpell = 1;
	}
	else
		bFireDefSpell = 0;

/*
    if ( bFiredAttSpell )
	{
		if ( bFireAttSpell == 0 )
		{
			FireAttSpell(0);
			bFireAttSpell = 1;
		}
	}
	else
		bFireAttSpell = 0;

	if ( bFiredDefSpell )
	{
		if ( bFireDefSpell == 0 )
		{
			FireDefSpell(0);
			bFireDefSpell = 1;
		}
	}
	else
		bFireDefSpell = 0;
*/
	// Save move parameters.
	DeltaTime = FMin(MaxResponseTime,TimeStamp - CurrentTimeStamp);
	if ( ServerTimeStamp > 0 )
	{
		// allow 1% error
		TimeMargin = FMax(0, TimeMargin + DeltaTime - 1.01 * (Level.TimeSeconds - ServerTimeStamp));
		if ( TimeMargin > MaxTimeMargin )
		{
			// player is too far ahead
			TimeMargin -= DeltaTime;
			if ( TimeMargin < 0.5 )
				MaxTimeMargin = Default.MaxTimeMargin;
			else
				MaxTimeMargin = 0.5;
			DeltaTime = 0;
		}
	}

	CurrentTimeStamp = TimeStamp;
	ServerTimeStamp = Level.TimeSeconds;
	ViewRotation.Pitch = ViewPitch;
	ViewRotation.Yaw = ViewYaw;
	ViewRotation.Roll = 0;
	
	Rot.Roll = 256 * ClientRoll;
	Rot.Yaw = ViewYaw;
	if ( (Physics == PHYS_Swimming) || (Physics == PHYS_Flying) )
		maxPitch = 2.0;
	else
		// Do not allow actor pitch in normal walking. 
		maxPitch = 0.01; // doesn't work if 0.0
	If ( (ViewPitch > maxPitch * RotationRate.Pitch) && (ViewPitch < 65536 - maxPitch * RotationRate.Pitch) )
	{
		If (ViewPitch < 32768) 
			Rot.Pitch = maxPitch * RotationRate.Pitch;
		else
			Rot.Pitch = 65536 - maxPitch * RotationRate.Pitch;
	}
	else
		Rot.Pitch = ViewPitch;
	DeltaRot = (Rotation - Rot);
	SetRotation(Rot);

	OldBase = Base;

	// Perform actual movement.
	if ( (Level.Pauser == "") && (DeltaTime > 0) )
		MoveAutonomous(DeltaTime, NewbRun, NewbDuck, NewbPressedJump, Accel, DeltaRot);

	LastClientTimestamp = TimeStamp;
	LastClientLocation = ClientLoc;

	if ( LastClientTimestamp == 0 )
		return;

	// Accumulate movement error.
	if ( Level.TimeSeconds - LastUpdateTime > 500.0/Player.CurrentNetSpeed )
		ClientErr = 10000;
	else if ( Level.TimeSeconds - LastUpdateTime > 180.0/Player.CurrentNetSpeed )
	{
		LocDiff = Location - ClientLoc;
		ClientErr = LocDiff Dot LocDiff;
	}

	// If client has accumulated a noticeable positional error, correct him.
	if ( ClientErr > 3 )
	{
		if ( Mover(Base) != None )
			ClientLoc = Location - Base.Location;
		else
			ClientLoc = Location;
		
		// Make sure Z is rounded up.
		if ( Base != None && Base != Level )
			ClientLoc.Z += float(int(Base.Location.Z + 0.9)) - Base.Location.Z;
		
		//log("Client Error at "$TimeStamp$" is "$ClientErr$" with acceleration "$Accel$" LocDiff "$LocDiff$" Physics "$Physics);
		LastUpdateTime = Level.TimeSeconds;
		ClientAdjustPosition
		(
			TimeStamp, 
			GetStateName(), 
			Physics, 
			ClientLoc.X, 
			ClientLoc.Y, 
			ClientLoc.Z, 
			Velocity.X, 
			Velocity.Y, 
			Velocity.Z,
			Base,
			BaseJoint
		);
	}
	LastClientTimestamp = 0;
	//log("Server "$Role$" moved "$self$" stamp "$TimeStamp$" location "$Location$" Acceleration "$Acceleration$" Velocity "$Velocity);
}

//
// Process a lost move.
//
final function OldServerMove( float TimeStamp, bool NewbJumpStatus, byte OldTimeDelta, int OldAccel)
{
	local float OldTimeStamp;
	local bool OldbRun, OldbDuck, NewbPressedJump;
	local vector Accel;
	
	OldTimeStamp = TimeStamp - float(OldTimeDelta)/500 - 0.001;
	if ( CurrentTimeStamp < OldTimeStamp - 0.001 )
	{
		// split out components of lost move (approx)
		Accel.X = DecompressAccel( OldAccel >>> 23);
		Accel.Y = DecompressAccel((OldAccel >>> 15) & 255);
		Accel.Z = DecompressAccel((OldAccel >>> 7) & 255);
		Accel *= 20;

		OldbRun = ( (OldAccel & 64) != 0 );
		OldbDuck = ( (OldAccel & 32) != 0 );
		NewbPressedJump = ( (OldAccel & 16) != 0 );
		if ( NewbPressedJump )
			bJumpStatus = NewbJumpStatus;

//		log("Recovered move from "$OldTimeStamp$" acceleration "$Accel$" from "$OldAccel);
		OldTimeStamp = FMin(OldTimeStamp, CurrentTimeStamp + MaxResponseTime);
		MoveAutonomous(OldTimeStamp - CurrentTimeStamp, OldbRun, OldbDuck, NewbPressedJump, Accel, rot(0,0,0));
		CurrentTimeStamp = OldTimeStamp;
	}
}

function ProcessMove ( float DeltaTime, vector newAccel, rotator DeltaRot)
{
	Acceleration = newAccel;
}

final function MoveAutonomous
(	
	float DeltaTime, 	
	bool NewbRun,
	bool NewbDuck,
	bool NewbPressedJump, 
	vector newAccel, 
	rotator DeltaRot
)
{
	if ( NewbRun )
		bRun = 1;
	else
		bRun = 0;

	if ( NewbDuck )
		bDuck = 1;
	else
		bDuck = 0;

	bPressedJump = NewbPressedJump;

	HandleWalking();
	ProcessMove(DeltaTime, newAccel, DeltaRot);	
	AutonomousPhysics(DeltaTime);
	//log("Role "$Role$" moveauto time "$100 * DeltaTime$" ("$Level.TimeDilation$")");
}

// ClientAdjustPosition - pass newloc and newvel in components so they don't get rounded

function ClientAdjustPosition
(
	float TimeStamp, 
	name newState, 
	EPhysics newPhysics,
	float NewLocX, 
	float NewLocY, 
	float NewLocZ, 
	float NewVelX, 
	float NewVelY, 
	float NewVelZ,
	Actor NewBase,
	int NewBaseJoint
)
{
	local Decoration Carried;
	local vector OldLoc, NewLocation, NewVelocity;
	local SavedMove CurrentMove;
	local name CurrentState;

	if ( CurrentTimeStamp > TimeStamp )
		return;
	CurrentTimeStamp = TimeStamp;

	NewLocation.X = NewLocX;
	NewLocation.Y = NewLocY;
	NewLocation.Z = NewLocZ;
	NewVelocity.X = NewVelX;
	NewVelocity.Y = NewVelY;
	NewVelocity.Z = NewVelZ;

	// Higor: keep track of Position prior to adjustment
	// and stop current smoothed adjustment (if in progress).
	PreAdjustLocation = Location;
	if ( AdjustLocationAlpha > 0 )
	{
		AdjustLocationAlpha = 0;
		AdjustLocationOffset = vect(0,0,0);
	}

	// stijn: Remove acknowledged moves from the savedmoves list
	CurrentMove = SavedMoves;
	while (CurrentMove != None)
	{
		if (CurrentMove.TimeStamp <= CurrentTimeStamp)
		{
			SavedMoves = CurrentMove.NextMove;
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			FreeMoves.Clear();
			CurrentMove = SavedMoves;
		}
		else
		{
			// not yet acknowledged. break out of the loop
			CurrentMove = None;
		}
	}

//	log("ClientAdjustPosition: NewBaseJoint=" $ NewBaseJoint $ " JointName=" $ JointName(NewBaseJoint));
	SetBase(NewBase, JointName(NewBaseJoint));
	if ( Mover(NewBase) != None )
		NewLocation += NewBase.Location;

	//log("Client "$Role$" adjust "$self$" stamp "$TimeStamp$" location "$Location);
	Carried = CarriedDecoration;
	OldLoc = Location;
	bCanTeleport = false;
	SetLocation(NewLocation);
	bCanTeleport = true;
	Velocity = NewVelocity;

	if ( Carried != None )
	{
		CarriedDecoration = Carried;
		CarriedDecoration.SetLocation(NewLocation + CarriedDecoration.Location - OldLoc);
		CarriedDecoration.SetPhysics(PHYS_None);
		CarriedDecoration.SetBase(self);
	}
	SetPhysics(newPhysics);

	CurrentState = GetStateName();
	if (CurrentState == 'SelectObject')
		CurrentState = 'PlayerWalking';
	if ( CurrentState != newState ) // !IsInState(newState)
		GotoState(newState);

	bUpdatePosition = true;
}

function ClientReplayMove( SavedMove Move )
{
	local int i;
	local float DeltaTime;
	
	SetRotation( Move.Rotation) ;	
	ViewRotation = Move.SavedViewRotation;

	// Replay the move in the same amount of ticks they were created+merged.
	// Important input needs to be processed last (as it's usually the cause of buffer breakup)
	DeltaTime = Move.Delta;
	DeltaTime /= float(Move.MergeCount) + 1;
	for ( i=0; i<Move.MergeCount; i++ )
		MoveAutonomous( DeltaTime, Move.bRun, Move.bDuck, false, Move.Acceleration, rot(0,0,0) );
	MoveAutonomous( DeltaTime, Move.bRun, Move.bDuck, Move.bPressedJump, Move.Acceleration, rot(0,0,0) );
	Move.SavedLocation = Location;
	Move.SavedVelocity = Velocity;
}

function ClientUpdatePosition()
{
	local SavedMove CurrentMove;
	local int realbRun, realbDuck;
	local bool bRealJump;
	local rotator RealViewRotation, RealRotation;

	local float TotalTime;
	local Pawn P;
	local vector Dir;
	
	local float AdjustDistance;
	local vector PostAdjustLocation;	

	bUpdatePosition = false;
	realbRun = bRun;
	realbDuck = bDuck;
	bRealJump = bPressedJump;
	RealRotation = Rotation;
	RealViewRotation = ViewRotation;
	CurrentMove = SavedMoves;
	bUpdating = true;
	while ( CurrentMove != None )
	{
		if ( CurrentMove.TimeStamp <= CurrentTimeStamp )
		{
			SavedMoves = CurrentMove.NextMove;
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			FreeMoves.Clear();
			CurrentMove = SavedMoves;
		}
		else
		{
			// adjust radius of nearby players with uncertain location
			if ( TotalTime > 0 )
				ForEach AllActors(class'Pawn', P)
					if ( (P != self) && (P.Velocity != vect(0,0,0)) && P.bBlockPlayers )
					{
						Dir = Normal(P.Location - Location);
						if ( (Velocity Dot Dir > 0) && (P.Velocity Dot Dir > 0) )
						{
							// if other pawn moving away from player, push it away if its close
							// since the client-side position is behind the server side position
							if ( VSize(P.Location - Location) < P.CollisionRadius + CollisionRadius + CurrentMove.Delta * GroundSpeed )
								P.MoveSmooth(P.Velocity * 0.5 * PlayerReplicationInfo.Ping);
						}
					}
			TotalTime += CurrentMove.Delta;
			ClientReplayMove(CurrentMove);
			CurrentMove = CurrentMove.NextMove;
		}
	}	
	// stijn: The original code was not replaying the pending move
	// here. This was a huge oversight and caused non-stop resynchronizations
	// because the playerpawn position would be off constantly until the player
	// stopped moving!
	if ( PendingMove != none )
		ClientReplayMove(PendingMove);

	// Higor: evaluate location adjustment and see if we should either
	// - Discard it
	// - Negate and process over a certain amount of time.
	// - Keep adjustment as is (instant relocation)
	AdjustLocationOffset = (Location - PreAdjustLocation);
	AdjustDistance = VSize(AdjustLocationOffset);
	AdjustLocationAlpha = 0;
	if ( AdjustDistance < VSize(Acceleration) ) //Only do this if player is trying to move
	{
		if ( AdjustDistance < 2 )
		{
			// Discard
			MoveSmooth( -AdjustLocationOffset);
		}
		else if ( (AdjustDistance < 50) && FastTrace(Location,PreAdjustLocation) )
		{
			// Undo adjustment and re-enact smoothly
			PostAdjustLocation = Location;
			MoveSmooth( -AdjustLocationOffset);
			AdjustLocationOffset = PostAdjustLocation - Location;
			AdjustLocationAlpha = 1;
		}
	}
	// Keep as is.

	bUpdating = false;
	bDuck = realbDuck;
	bRun = realbRun;
	bPressedJump = bRealJump;
	SetRotation( RealRotation);
	ViewRotation = RealViewRotation;
	//log("Client adjusted "$self$" stamp "$CurrentTimeStamp$" location "$Location); 
}

final function SavedMove GetFreeMove()
{
	local SavedMove s;

	if ( FreeMoves == None )
		return Spawn(class'SavedMove',self);
	else
	{
		s = FreeMoves;
		FreeMoves = FreeMoves.NextMove;
		s.NextMove = None;
		if ( s.Owner != self )
			s.SetOwner(self);
		return s;
	}
}

final function CleanOutSavedMoves()
{
    local SavedMove Next;

	// clean out saved moves
	while ( SavedMoves != None )
	{
		Next = SavedMoves.NextMove;
		SavedMoves.Destroy();
		SavedMoves = Next;
	}
	if ( PendingMove != None )
	{
		PendingMove.Destroy();
		PendingMove = None;
	}
}

function int CompressAccel(int C)
{
	if ( C >= 0 )
		C = Min(C, 127);
	else
		C = Min(abs(C), 127) + 128;
	return C;
}

final function float DecompressAccel( int C)
{
	if ( C > 127 )
		C = -1 * (C - 128);
	return C;
}

//
// Replicate this client's desired movement to the server.
//
/*
function ReplicateMoveOld
(
	float DeltaTime, 
	vector NewAccel, 
	rotator DeltaRot
)
{
	local SavedMove NewMove, OldMove, LastMove;
	local byte ClientRoll;
	local int i;
	local float OldTimeDelta, TotalTime, NetMoveDelta;
	local int OldAccel;
	local vector BuildAccel, AccelNorm;

	local float AdjPCol, SavedRadius;
	local pawn SavedPawn, P;
	local vector Dist;

	MaxResponseTime = Default.MaxResponseTime * Level.TimeDilation;
	DeltaTime = FMin(DeltaTime, MaxResponseTime);

	// Get a SavedMove actor to store the movement in.
	if ( PendingMove != None )
	{
		//add this move to the pending move
		PendingMove.TimeStamp = Level.TimeSeconds; 
		if ( VSize(NewAccel) > 3072 )
			NewAccel = 3072 * Normal(NewAccel);
		TotalTime = PendingMove.Delta + DeltaTime;
		PendingMove.Acceleration = (DeltaTime * NewAccel + PendingMove.Delta * PendingMove.Acceleration)/TotalTime;

		// Set this move's data.
		PendingMove.bRun = (bRun > 0);
		PendingMove.bDuck = (bDuck > 0);
		PendingMove.bPressedJump = bPressedJump || PendingMove.bPressedJump;
		
		PendingMove.bFire = PendingMove.bFire || bJustFired || (bFire != 0);
		PendingMove.bForceFire = PendingMove.bForceFire || bJustFired;

		PendingMove.bFireAttSpell = PendingMove.bFireAttSpell || bJustFiredAttSpell || (bFireAttSpell != 0);
		PendingMove.bForceFireAttSpell = PendingMove.bForceFireAttSpell || bJustFiredAttSpell;

		PendingMove.bFireDefSpell = PendingMove.bFireDefSpell || bJustFiredDefSpell || (bFireDefSpell != 0);
		PendingMove.bForceFireDefSpell = PendingMove.bForceFireDefSpell || bJustFiredDefSpell;

		PendingMove.Delta = TotalTime;
	}
	if ( SavedMoves != None )
	{
		NewMove = SavedMoves;
		AccelNorm = Normal(NewAccel);
		while ( NewMove.NextMove != None )
		{
			// find most recent interesting move to send redundantly
			if ( NewMove.bPressedJump 
				|| ((NewMove.Acceleration != NewAccel) && ((normal(NewMove.Acceleration) Dot AccelNorm) < 0.95)) )
				OldMove = NewMove;
			NewMove = NewMove.NextMove;
		}
		if ( NewMove.bPressedJump 
			|| ((NewMove.Acceleration != NewAccel) && ((normal(NewMove.Acceleration) Dot AccelNorm) < 0.95)) )
			OldMove = NewMove;
	}

	LastMove = NewMove;
	NewMove = GetFreeMove();
	NewMove.Delta = DeltaTime;
	if ( VSize(NewAccel) > 3072 )
		NewAccel = 3072 * Normal(NewAccel);
	NewMove.Acceleration = NewAccel;

	// Set this move's data.
	NewMove.TimeStamp = Level.TimeSeconds;
	NewMove.bRun = (bRun > 0);
	NewMove.bDuck = (bDuck > 0);
	NewMove.bPressedJump = bPressedJump;
	NewMove.bFire = (bJustFired || (bFire != 0));
	NewMove.bForceFire = bJustFired;
	if ( Weapon != None ) // approximate pointing so don't have to replicate
		Weapon.bPointing = (bFire != 0);
	bJustFired = false;
	
	NewMove.bFireAttSpell = (bJustFiredAttSpell || ( bFireAttSpell != 0));
	NewMove.bForceFireAttSpell = bJustFiredAttSpell;
	if ( AttSpell != None )
		AttSpell.bPointing = (bFireAttSpell != 0);
	bJustFiredAttSpell = false;

	NewMove.bFireDefSpell = (bJustFiredDefSpell || ( bFireDefSpell != 0));
	NewMove.bForceFireDefSpell = bJustFiredDefSpell;
	if ( DefSpell != None )
		DefSpell.bPointing = (bFireDefSpell != 0);
	bJustFiredDefSpell = false;

	// adjust radius of nearby players with uncertain location
	if (PlayerReplicationInfo != None)
	{
		ForEach AllActors(class'Pawn', P)
			if ( (P != self) && (P.Velocity != vect(0,0,0)) && P.bBlockPlayers )
			{
				Dist = P.Location - Location;
				AdjPCol = 0.0004 * PlayerReplicationInfo.Ping * ((P.Velocity - Velocity) Dot Normal(Dist));
				if ( VSize(Dist) < AdjPCol + P.CollisionRadius + CollisionRadius + NewMove.Delta * GroundSpeed * (Normal(Velocity) Dot Normal(Dist)) )
				{
					SavedPawn = P;
					SavedRadius = P.CollisionRadius;
					Dist.Z = 0;
					P.SetCollisionSize(FClamp(AdjPCol + P.CollisionRadius, 0.5 * P.CollisionRadius, VSize(Dist) - CollisionRadius - P.CollisionRadius), P.CollisionHeight);
					break;
				}
			}
	}
	// Simulate the movement locally.
	ProcessMove(NewMove.Delta, NewMove.Acceleration, DeltaRot);
	AutonomousPhysics(NewMove.Delta);
	if ( SavedPawn != None )
		SavedPawn.SetCollisionSize(SavedRadius, P.CollisionHeight);

	//log("Role "$Role$" repmove at "$Level.TimeSeconds$" Move time "$100 * DeltaTime$" ("$Level.TimeDilation$")");

	// Decide whether to hold off on move
	// send if dodge, jump, or fire unless really too soon, or if newmove.delta big enough
	// on client side, save extra buffered time in LastUpdateTime
	if ( PendingMove == None )
		PendingMove = NewMove;
	else
	{
		NewMove.NextMove = FreeMoves;
		FreeMoves = NewMove;
		FreeMoves.Clear();
		NewMove = PendingMove;
	}
	NetMoveDelta = FMax(64.0/Player.CurrentNetSpeed, 0.011);
	
	if(	
		!PendingMove.bForceFire && 
		!PendingMove.bPressedJump && 
		!PendingMove.bForceFireAttSpell && 
		!PendingMove.bForceFireDefSpell &&
		(PendingMove.Delta < NetMoveDelta - ClientUpdateTime) )
	{
		// save as pending move
		return;
	}
	else if ( (ClientUpdateTime < 0) && (PendingMove.Delta < NetMoveDelta - ClientUpdateTime) )
		return;
	else
	{
		ClientUpdateTime = PendingMove.Delta - NetMoveDelta;
		if ( SavedMoves == None )
			SavedMoves = PendingMove;
		else
			LastMove.NextMove = PendingMove;
		PendingMove = None;
	}

	// check if need to redundantly send previous move
	if ( OldMove != None )
	{
		// log("Redundant send timestamp "$OldMove.TimeStamp$" accel "$OldMove.Acceleration$" at "$Level.Timeseconds$" New accel "$NewAccel);
		// old move important to replicate redundantly
		OldTimeDelta = FMin(255, (Level.TimeSeconds - OldMove.TimeStamp) * 500);
		BuildAccel = 0.05 * OldMove.Acceleration + vect(0.5, 0.5, 0.5);
		OldAccel = (CompressAccel(BuildAccel.X) << 23) 
					+ (CompressAccel(BuildAccel.Y) << 15) 
					+ (CompressAccel(BuildAccel.Z) << 7);
		if ( OldMove.bRun )
			OldAccel += 64;
		if ( OldMove.bDuck )
			OldAccel += 32;
		if ( OldMove.bPressedJump )
			OldAccel += 16;
	}
	//else
	//	log("No redundant timestamp at "$Level.TimeSeconds$" with accel "$NewAccel);

	// Send to the server
	ClientRoll = (Rotation.Roll >> 8) & 255;
	if ( NewMove.bPressedJump )
		bJumpStatus = !bJumpStatus;
	ServerMove
	(
		NewMove.TimeStamp, 
		NewMove.Acceleration * 10, 
		Location, 
		NewMove.bRun,
		NewMove.bDuck,
		bJumpStatus, 
		NewMove.bFire,
		NewMove.bForceFire,
		NewMove.bFireAttSpell, 
		NewMove.bForceFireAttSpell, 
		NewMove.bFireDefSpell, 
		NewMove.bForceFireDefSpell,
//		(bJustFiredAttSpell || (bFireAttSpell != 0)),
//      (bJustFiredDefSpell || (bFireDefSpell != 0)),
		ClientRoll,
		(32767 & (ViewRotation.Pitch/2)) * 32768 + (32767 & (ViewRotation.Yaw/2)),
		OldTimeDelta,
		OldAccel 
	);
//rb	bJustFiredAttSpell = false;
//rb	bJustFiredDefSpell = false;
	//log("Replicated "$self$" stamp "$NewMove.TimeStamp$" location "$Location$" dodge "$NewMove.DodgeMove$" to "$DodgeDir);
}
*/

function ReplicateMove
(
	float DeltaTime,
	vector NewAccel,
	rotator DeltaRot
)
{
	local SavedMove NewMove, OldMove, LastMove;
	local float TotalTime;
	local float NetMoveDelta;

	local Pawn P;
	local vector Dir;
	
	local float AdjustAlpha;

	MaxResponseTime = Default.MaxResponseTime * Level.TimeDilation;
	DeltaTime = FMin(DeltaTime, MaxResponseTime);

	// Higor: process smooth adjustment.
	if ( AdjustLocationAlpha > 0 )
	{
		AdjustAlpha = fMin( AdjustLocationAlpha, DeltaTime/SmoothAdjustLocationTime);
		MoveSmooth( AdjustLocationOffset * AdjustAlpha );
		AdjustLocationAlpha -= AdjustAlpha;
	}
	
	NetMoveDelta = FMax(64.0/Player.CurrentNetSpeed, 0.011);

	// Get a SavedMove actor to store the movement in.
	if ( PendingMove != None )
	{
		//
		// stijn: a lot of the movement glitching in UT99 stems from this
		// calculation. In essence, this code tries to merge multiple moves
		// into one "pending" move. The server will only see the pending
		// move and thus assume that the client has accelerated uniformly
		// during a period of PendingMove.Delta seconds. Unfortunately,
		// the assumption that the acceleration was uniform means the
		// server cannot possibly reconstruct the correct position AND
		// the correct velocity at the end of the PendingMove.Delta period.
		// The calculation below will yield the correct velocity on the
		// server side but _NOT_ the correct position. This means the
		// server will constantly correct players that send merged moves
		// (because they quickly accumulate large movement errors).
		//
		// Higor: burst previous move if accel is significantly different.
		//
		if ( PendingMove.CanMergeAccel(NewAccel) )
		{
			//add this move to the pending move
			PendingMove.TimeStamp = Level.TimeSeconds;
			if ( VSize(NewAccel) > 3072 )
				NewAccel = 3072 * Normal(NewAccel);
			TotalTime = DeltaTime + PendingMove.Delta;

			// Set this move's data.
			PendingMove.Acceleration = (DeltaTime * NewAccel + PendingMove.Delta * PendingMove.Acceleration) / TotalTime;
			PendingMove.SetRotation( Rotation );
			PendingMove.SavedViewRotation = ViewRotation;
			PendingMove.bRun = (bRun > 0);
			PendingMove.bDuck = (bDuck > 0);
			PendingMove.bPressedJump = bPressedJump || PendingMove.bPressedJump;
			PendingMove.bFire = PendingMove.bFire || bJustFired || (bFire != 0);
			PendingMove.bForceFire = PendingMove.bForceFire || bJustFired;
			PendingMove.bFireAttSpell = PendingMove.bFireAttSpell || bJustFiredAttSpell || (bFireAttSpell != 0);
			PendingMove.bForceFireAttSpell = PendingMove.bForceFireAttSpell || bJustFiredAttSpell;
			PendingMove.bFireDefSpell = PendingMove.bFireDefSpell || bJustFiredDefSpell || (bFireDefSpell != 0);
			PendingMove.bForceFireDefSpell = PendingMove.bForceFireDefSpell || bJustFiredDefSpell;
			PendingMove.Delta = TotalTime;
			// todo: investigate
			//PendingMove.MergeCount++;
		}
		else
		{
			// Burst old move and remove from Pending
//			Log("Bursting move"@Level.TimeSeconds);
			SendServerMove(PendingMove);
			ClientUpdateTime = PendingMove.Delta - NetMoveDelta;
			if ( SavedMoves == None )
				SavedMoves = PendingMove;
			else
			{
				for ( LastMove=SavedMoves ; LastMove.NextMove!=None ; LastMove=LastMove.NextMove );
				LastMove.NextMove = PendingMove;
			}
			PendingMove = None;
		}
	}

	if ( SavedMoves != None )
	{
		NewMove = SavedMoves;
		while ( NewMove.NextMove != None )
		{
			// find most recent interesting (and unacknowledged) move to send redundantly
			if ( NewMove.CanSendRedundantly(NewAccel) )
				OldMove = NewMove;
			NewMove = NewMove.NextMove;
		}
 		if ( NewMove.CanSendRedundantly(NewAccel) )
		    OldMove = NewMove;
	}

	LastMove = NewMove;	
	NewMove = GetFreeMove();
	NewMove.Delta = DeltaTime;
	if ( VSize(NewAccel) > 3072 )
		NewAccel = 3072 * Normal(NewAccel);
	NewMove.Acceleration = NewAccel;
	NewAccel = Acceleration;

	// Set this move's data.
	NewMove.TimeStamp = Level.TimeSeconds;
	NewMove.bRun = (bRun > 0);
	NewMove.bDuck = (bDuck > 0);
	NewMove.bPressedJump = bPressedJump;
	NewMove.bFire = bJustFired || (bFire != 0);
	NewMove.bForceFire = bJustFired;
	NewMove.bFireAttSpell = (bJustFiredAttSpell || ( bFireAttSpell != 0));
	NewMove.bForceFireAttSpell = bJustFiredAttSpell;
	NewMove.bFireDefSpell = (bJustFiredDefSpell || ( bFireDefSpell != 0));
	NewMove.bForceFireDefSpell = bJustFiredDefSpell;
	if ( Weapon != None ) // approximate pointing so don't have to replicate
		Weapon.bPointing = (bFire != 0);
	bJustFired = false;
	
	if ( AttSpell != None )
		AttSpell.bPointing = (bFireAttSpell != 0);
	bJustFiredAttSpell = false;

	if ( DefSpell != None )
		DefSpell.bPointing = (bFireDefSpell != 0);
	bJustFiredDefSpell = false;

	// adjust radius of nearby players with uncertain location
	ForEach AllActors(class'Pawn', P)
		if ( (P != self) && (P.Velocity != vect(0,0,0)) && P.bBlockPlayers )
		{
			Dir = Normal(P.Location - Location);
			if ( (Velocity Dot Dir > 0) && (P.Velocity Dot Dir > 0) )
			{
				// if other pawn moving away from player, push it away if its close
				// since the client-side position is behind the server side position
				if ( VSize(P.Location - Location) < P.CollisionRadius + CollisionRadius + NewMove.Delta * GroundSpeed )
					P.MoveSmooth(P.Velocity * 0.5 * PlayerReplicationInfo.Ping);
			}
		}

	// Simulate the movement locally.
	ProcessMove(NewMove.Delta, NewMove.Acceleration, DeltaRot);
	AutonomousPhysics(NewMove.Delta);

	// Decide whether to hold off on move
	// send if dodge, jump, or fire unless really too soon, or if newmove.delta big enough
	// on client side, save extra buffered time in LastUpdateTime
	if ( PendingMove == None )
	{
		PendingMove = NewMove;
	}
	else
	{
		NewMove.NextMove = FreeMoves;
		FreeMoves = NewMove;
		FreeMoves.Clear();
		NewMove = PendingMove;

		// stijn: This would be an ideal place to calculate a uniform
		// acceleration that yields the correct server-side position.
		// Unfortunately, there are way too many factors to take into
		// account (e.g., zone friction, braking, air control, initial
		// velocity and position, ...)
	}
	NewMove.SetRotation( Rotation );
	NewMove.SavedViewRotation = ViewRotation;
	NewMove.SavedLocation = Location;
	NewMove.SavedVelocity = Velocity;

	if ( !bDisableMovementBuffering &&
		PendingMove.CanBuffer(NewAccel) &&
		(PendingMove.Delta < NetMoveDelta - ClientUpdateTime) )
	{
		// save as pending move
		return;
	}
	else
	{
		ClientUpdateTime = PendingMove.Delta - NetMoveDelta;
		if ( SavedMoves == None )
			SavedMoves = PendingMove;
		else
			LastMove.NextMove = PendingMove;
		PendingMove = None;
	}

	// Send to the server
	if ( NewMove.bPressedJump )
		bJumpStatus = !bJumpStatus;

	SendServerMove( NewMove, OldMove);
	//log("Replicated "$self$" stamp "$NewMove.TimeStamp$" location "$Location$" dodge "$NewMove.DodgeMove$" to "$DodgeDir);
}

function HandleWalking()
{
	local rotator carried;

	bIsWalking = ( !bRunMode || (bDuck != 0)) && !Region.Zone.IsA('WarpZoneInfo'); 
	bIsCreeping = true;
	if ( CarriedDecoration != None )
	{
		if ( (Role == ROLE_Authority) && (standingcount == 0) ) 
			CarriedDecoration = None;
		if ( CarriedDecoration != None ) //verify its still in front
		{
			bIsWalking = true;
			/*
			if ( Role == ROLE_Authority )
			{
				carried = Rotator(CarriedDecoration.Location - Location);
				carried.Yaw = ((carried.Yaw & 65535) - (Rotation.Yaw & 65535)) & 65535;
				if ( (carried.Yaw > 3072) && (carried.Yaw < 62463) )
					DropDecoration();
			}
			*/
		}
	}
}

//----------------------------------------------

simulated event Destroyed()
{
	local SavedMove NextMove;

	Super.Destroyed();
	
	if ( myHud != None )
		myHud.Destroy();
	if ( Scoring != None )
		Scoring.Destroy();

	While ( FreeMoves != None )
	{
		NextMove = FreeMoves.NextMove;
		FreeMoves.Destroy();
		FreeMoves = NextMove;
	}

	While ( SavedMoves != None )
	{
		NextMove = SavedMoves.NextMove;
		SavedMoves.Destroy();
		SavedMoves = NextMove;
	}
}

function ServerReStartGame()
{
}

function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	Level.Game.SpecialDamageString = "";
}

function SetFOVAngle(float newFOV)
{
	FOVAngle = newFOV;
}
	 
function ClientFlash( float scale, vector fog )
{
	DesiredFlashScale = scale;
	DesiredFlashFog = 0.001 * fog;
}

function ClientInstantFlash( float scale, vector fog )
{
	InstantFlash = scale;
	InstantFog = 0.001 * fog;
}

//Play a sound client side (so only client will hear it
simulated function ClientPlaySound(sound ASound, optional bool bInterrupt, optional bool bVolumeControl )
{	
	local actor SoundPlayer;

	LastPlaySound = Level.TimeSeconds;	// so voice messages won't overlap
	if ( ViewTarget != None )
		SoundPlayer = ViewTarget;
	else
		SoundPlayer = self;

	SoundPlayer.PlaySound(ASound, SLOT_None, 		16.0 * VolumeMultiplier, bInterrupt);
	SoundPlayer.PlaySound(ASound, SLOT_Interface, 	16.0 * VolumeMultiplier, bInterrupt);
	SoundPlayer.PlaySound(ASound, SLOT_Misc, 		16.0 * VolumeMultiplier, bInterrupt);
	SoundPlayer.PlaySound(ASound, SLOT_Talk, 		16.0 * VolumeMultiplier, bInterrupt);
}

simulated function ClientReliablePlaySound(sound ASound, optional bool bInterrupt, optional bool bVolumeControl )
{
	ClientPlaySound(ASound, bInterrupt, bVolumeControl);
}
   
function ClientAdjustGlow( float scale, vector fog )
{
	ConstantGlowScale += scale;
	ConstantGlowFog += 0.001 * fog;
}

function ClientShake(vector shake)
{
	if ( (shakemag < shake.X) || (shaketimer <= 0.01 * shake.Y) )
	{
		shakemag = shake.X;
		shaketimer = 0.01 * shake.Y;	
		maxshake = 0.01 * shake.Z;
		verttimer = 0;
		ShakeVert = -1.1 * maxshake;
	}
}

function ShakeView( float shaketime, float RollMag, float vertmag)
{
	local vector shake;

	shake.X = RollMag;
	shake.Y = 100 * shaketime;
	shake.Z = 100 * vertmag;
	ClientShake(shake);
}

function ClientSetMusic( music NewSong, byte NewSection, byte NewCdTrack, EMusicTransition NewTransition )
{
	Song        = NewSong;
	SongSection = NewSection;
	CdTrack     = NewCdTrack;
	Transition  = NewTransition;
}

function ClientSetLocalAnims()
{
	// locally change bClientAnim so we have smooth animations from ourselves
	bClientAnim = Level.NetMode == NM_Client;
}

function ServerFeignDeath()
{
}

function ServerSetHandedness( float hand)
{
	Handedness = hand;
	if ( Weapon != None )
		Weapon.SetHand(Handedness);
}

function ServerReStartPlayer()
{
}

function ServerChangeSkin( coerce string SkinName, coerce string FaceName, byte TeamNum )
{
	local string MeshName;

	MeshName = GetItemName(string(Mesh));
	if ( Level.Game.bCanChangeSkin )
	{
		Self.static.SetMultiSkin(Self, SkinName, FaceName, TeamNum );
	}
}

//*************************************************************************************
// Normal gameplay execs
// Type the name of the exec function at the console to execute it

exec function ShowSpecialMenu( string ClassName )
{
	local class<menu> aMenuClass;

	aMenuClass = class<menu>( DynamicLoadObject( ClassName, class'Class' ) );
	if( aMenuClass!=None )
	{
		bSpecialMenu = true;
		SpecialMenu = aMenuClass;
		ShowMenu();
	}
}
	
exec function Jump( optional float F )
{
	if ( !bShowMenu && (PlayerReplicationInfo != None && Level.Pauser == PlayerReplicationInfo.PlayerName) )
		SetPause(False);
	else
	{
		bPressedJump = true;
	}
}

exec function CauseEvent( name N )
{
	local actor A;
	if( !bCheatsEnabled )
		return;
	if( (bAdmin || (Level.Netmode == NM_Standalone)) && (N != '') )
		foreach AllActors( class 'Actor', A, N )
			A.Trigger( Self, Self );
}

exec function Taunt( name Sequence )
{
	if ( GetAnimGroup(Sequence) == 'Gesture' ) 
	{
		ServerTaunt(Sequence);
		PlayAnim(Sequence, 0.7);
	}
}

function ServerTaunt(name Sequence )
{
	PlayAnim(Sequence, 0.7);
}

exec function FeignDeath()
{
}

exec function CallForHelp()
{
	local Pawn P;

	if ( !Level.Game.bTeamGame || (Enemy == None) || (Enemy.Health <= 0) )
		return;

	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		if ( P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
			P.HandleHelpMessageFrom(self);
}

function damageAttitudeTo(pawn Other)
{
	if ( Other != Self )
		Enemy = Other;
}

exec function Grab()
{
	if (CarriedDecoration == None)
		GrabDecoration();
	else
		DropDecoration();
}

// Send a voice message of a certain type to a certain player.
exec function Speech( int Type, int Index, int Callsign )
{
	local VoicePack V;

	V = Spawn( PlayerReplicationInfo.VoiceType, Self );
	if (V != None)
		V.PlayerSpeech( Type, Index, Callsign );
}

function PlayChatting();

function Typing( bool bTyping )
{
	bIsTyping = bTyping;
	if (bTyping)
	{
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogTypingEvent(True, Self);
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogTypingEvent(True, Self);
		PlayChatting();
	} 
	else 
	{
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogTypingEvent(False, Self);
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogTypingEvent(False, Self);
	}
}

// Send a message to all players.
exec function Say( string Msg )
{
	local Pawn P;

	Msg = Trim(Left(Msg, Min(Len(Msg), 64)));
	if ( Msg == "" || PlayerReplicationInfo == None || PlayerReplicationInfo.PlayerName == "" )
	{
		return;
	}

	if ( Level.Game.AllowsBroadcast(self, Len(Msg)) )
		for( P=Level.PawnList; P!=None; P=P.nextPawn )
			if( P.bIsPlayer || P.IsA('MessagingSpectator') )
			{
				if ( (Level.Game != None) && (Level.Game.MessageMutator != None) )
				{
					if ( Level.Game.MessageMutator.MutatorTeamMessage(Self, P, PlayerReplicationInfo, Msg, 'Say', true) )
						P.ChatMessage( PlayerReplicationInfo, Msg, 'Say' );
				} else
					P.ChatMessage( PlayerReplicationInfo, Msg, 'Say' );
			}
}

exec function TeamSay( string Msg )
{
	local Pawn P;

	if ( !Level.Game.bTeamGame )
	{
		Say(Msg);
		return;
	}

	if ( Msg ~= "Help" )
	{
		CallForHelp();
		return;
	}

	Msg = Trim(Left(Msg, Min(Len(Msg), 64)));
	if ( Msg == "" || PlayerReplicationInfo == None || PlayerReplicationInfo.PlayerName == "" )
	{
		return;
	}
			
	if ( Level.Game.AllowsBroadcast(self, Len(Msg)) )
		for( P=Level.PawnList; P!=None; P=P.nextPawn )
			if( P.bIsPlayer && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) )
			{
				if ( P.IsA('PlayerPawn') )
				{
					if ( (Level.Game != None) && (Level.Game.MessageMutator != None) )
					{
						if ( Level.Game.MessageMutator.MutatorTeamMessage(Self, P, PlayerReplicationInfo, Msg, 'TeamSay', true) )
							P.ChatMessage( PlayerReplicationInfo, Msg, 'TeamSay' );
					} else
						P.ChatMessage( PlayerReplicationInfo, Msg, 'TeamSay' );
				}
			}
}

exec function RestartLevel()
{
	if( bAdmin || Level.Netmode==NM_Standalone )
		Level.ServerTravel( "?restart", false );
}

exec function LocalTravel( string URL )
{
	if( bAdmin || Level.Netmode==NM_Standalone )
		ClientTravel( URL, TRAVEL_Relative, true );
}

exec function Map( string Cmd )
{
	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	
	if (Cmd ~= "Restart")
	{
		Level.Game.RestartGame();
	}
	else
	{
		Level.Game.SendPlayer(self, Cmd);
	}
}

exec function ThrowWeapon()
{
	if( Level.NetMode == NM_Client || Level.NetMode == NM_Standalone )
		return;
	if( Weapon==None || (Weapon.Class==Level.Game.BaseMutator.MutatedDefaultWeapon()) ) // || !Weapon.bCanThrow
		return;
	Weapon.Velocity = Vector(ViewRotation) * 500 + vect(0,0,220);
	Weapon.bTossedOut = true;
	TossWeapon();
	if ( Weapon == None )
		SwitchToBestWeapon();
}

function ToggleZoom()
{
	if ( DefaultFOV != DesiredFOV )
		EndZoom();
	else
		StartZoom();
}
	
function StartZoom()
{
	ZoomLevel = 0.0;
	bZooming = true;
}

function StopZoom()
{
	bZooming = false;
}

function EndZoom()
{
	bZooming = false;
	DesiredFOV = DefaultFOV;
}

exec function FOV(float F)
{
	SetDesiredFOV(F);
}
	
exec function SetDesiredFOV(float F)
{
	if( (F >= 80.0) || Level.bAllowFOV || bAdmin || (Level.Netmode==NM_Standalone) )
	{
		DefaultFOV = FClamp(F, 1, 170);
		DesiredFOV = DefaultFOV;
		SaveConfig();
	}
}

exec function SetZoomFOV(float F)
{
	ZoomFOV = F;
	SaveConfig();
}

/* PrevWeapon()
- switch to previous inventory group weapon
*/
exec function PrevWeapon()
{
	local int prevGroup;
	local Inventory inv;
	local Weapon realWeapon, w, Prev;
	local bool bFoundWeapon;

	if( bShowMenu || Level.Pauser!="" )
		return;
	if ( Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}
	prevGroup = 0;
	realWeapon = Weapon;
	if ( PendingWeapon != None )
		Weapon = PendingWeapon;
	PendingWeapon = None;
	
	for (inv=Inventory; inv!=None; inv=inv.Inventory)
	{
		w = Weapon(inv);
		if ( w != None )
		{
			if ( w.InventoryGroup == Weapon.InventoryGroup )
			{
				if ( w == Weapon )
				{
					bFoundWeapon = true;
					if ( Prev != None )
					{
						PendingWeapon = Prev;
						break;
					}
				}
				else if ( !bFoundWeapon && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
					Prev = W;
			}
			else if ( (w.InventoryGroup < Weapon.InventoryGroup) 
					&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) 
					&& (w.InventoryGroup >= prevGroup) )
			{
				prevGroup = w.InventoryGroup;
				PendingWeapon = w;
			}
		}
	}
	bFoundWeapon = false;
	prevGroup = Weapon.InventoryGroup;
	if ( PendingWeapon == None )
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			w = Weapon(inv);
			if ( w != None )
			{
				if ( w.InventoryGroup == Weapon.InventoryGroup )
				{
					if ( w == Weapon )
						bFoundWeapon = true;
					else if ( bFoundWeapon && (PendingWeapon == None) && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
						PendingWeapon = W;
				}
				else if ( (w.InventoryGroup > PrevGroup) 
						&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) ) 
				{
					prevGroup = w.InventoryGroup;
					PendingWeapon = w;
				}
			}
		}

	Weapon = realWeapon;
	if ( PendingWeapon == None )
		return;

	Weapon.PutDown();
}

/* NextWeapon()
- switch to next inventory group weapon
*/
exec function NextWeapon()
{
	local int nextGroup;
	local Inventory inv;
	local Weapon realWeapon, w, Prev;
	local bool bFoundWeapon;

	if( bShowMenu || Level.Pauser!="" )
		return;
	if ( Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}
	nextGroup = 100;
	realWeapon = Weapon;
	if ( PendingWeapon != None )
		Weapon = PendingWeapon;
	PendingWeapon = None;

	for (inv=Inventory; inv!=None; inv=inv.Inventory)
	{
		w = Weapon(inv);
		if ( w != None )
		{
			if ( w.InventoryGroup == Weapon.InventoryGroup )
			{
				if ( w == Weapon )
					bFoundWeapon = true;
				else if ( bFoundWeapon && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
				{
					PendingWeapon = W;
					break;
				}
			}
			else if ( (w.InventoryGroup > Weapon.InventoryGroup) 
					&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) 
					&& (w.InventoryGroup < nextGroup) )
			{
				nextGroup = w.InventoryGroup;
				PendingWeapon = w;
			}
		}
	}

	bFoundWeapon = false;
	nextGroup = Weapon.InventoryGroup;
	if ( PendingWeapon == None )
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			w = Weapon(Inv);
			if ( w != None )
			{
				if ( w.InventoryGroup == Weapon.InventoryGroup )
				{
					if ( w == Weapon )
					{
						bFoundWeapon = true;
						if ( Prev != None )
							PendingWeapon = Prev;
					}
					else if ( !bFoundWeapon && (PendingWeapon == None) && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
						Prev = W;
				}
				else if ( (w.InventoryGroup < nextGroup) 
					&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) ) 
				{
					nextGroup = w.InventoryGroup;
					PendingWeapon = w;
				}
			}
		}

	Weapon = realWeapon;
	if ( PendingWeapon == None )
		return;

	Weapon.PutDown();
}

// for renewal backwards compatibility
exec function NextAttSpell();

exec function Mutate(string MutateString)
{
	ServerMutate(MutateString);
}

function ServerMutate(string MutateString)
{
	if( Level.NetMode == NM_Client )
		return;
	Level.Game.BaseMutator.Mutate(MutateString, Self);
}

exec function QuickSave()
{
	if ( (Health > 0) 
		&& (Level.NetMode == NM_Standalone)
		&& !Level.Game.bDeathMatch )
	{
		ClientMessage(QuickSaveString);
		ConsoleCommand("SaveGame 0");
	}
}

exec function QuickLoad()
{
	if ( (Level.NetMode == NM_Standalone)
		&& !Level.Game.bDeathMatch )
			ConsoleCommand("LoadGame 0");
		//ClientTravel( "?load=9", TRAVEL_Absolute, false);
}



exec function Kick( string S ) 
{
	local Pawn aPawn;
	if( !bAdmin )
		return;
	for( aPawn=Level.PawnList; aPawn!=None; aPawn=aPawn.NextPawn )
		if
		(	aPawn.bIsPlayer
			&&	aPawn.PlayerReplicationInfo.PlayerName~=S 
			&&	(PlayerPawn(aPawn)==None || NetConnection(PlayerPawn(aPawn).Player)!=None ) )
		{
			aPawn.Destroy();
			return;
		}
}

exec function KickBan( string S ) 
{
	local Pawn aPawn;
	local string IP;
	local int j;
	if( !bAdmin )
		return;
	for( aPawn=Level.PawnList; aPawn!=None; aPawn=aPawn.NextPawn )
		if
		(	aPawn.bIsPlayer
			&&	aPawn.PlayerReplicationInfo.PlayerName~=S 
			&&	(PlayerPawn(aPawn)==None || NetConnection(PlayerPawn(aPawn).Player)!=None ) )
		{
			IP = PlayerPawn(aPawn).GetPlayerNetworkAddress();
			if(Level.Game.CheckIPPolicy(IP))
			{
				IP = Left(IP, InStr(IP, ":"));
				Log("Adding IP Ban for: "$IP);
				for(j=0;j<50;j++)
					if(Level.Game.IPPolicies[j] == "")
						break;
				if(j < 50)
					Level.Game.IPPolicies[j] = "DENY,"$IP;
				Level.Game.SaveConfig();
			}
			aPawn.Destroy();
			return;
		}
}

function GetSaveGameListMultiplayer();

// Try to set the pause state; returns success indicator.
function bool SetPause( BOOL bPause )
{
	return Level.Game.SetPause(bPause, self);
}

exec function SetMouseSmoothThreshold( float F )
{
	MouseSmoothThreshold = FClamp(F, 0, 0.1);
	SaveConfig();
}

exec function SetMouseDecel( bool B )
{
	bMouseDecel = B;
	SaveConfig();
}

exec function SetMouseSmoothing( bool B )
{
	bMouseSmoothing = B;
	SaveConfig();
}

exec function SetMaxMouseSmoothing( bool B )
{
	bMaxMouseSmoothing = B;
	SaveConfig();
}

// Try to pause the game.
exec function Pause()
{
	if ( bShowMenu )
		return;
	if( !SetPause(Level.Pauser=="") )
		ClientMessage(NoPauseMessage);
}

// Activate specific inventory item
exec function ActivateInventoryItem( class InvItem )
{
	local Inventory Inv;

	Inv = FindInventoryType(InvItem);
	if ( Inv != None )
		Inv.Activate();
}

exec function ActivateInventoryItemInGroup( int Group )
{
	local Inventory Inv;

	Inv = Inventory.FindItemInGroup(Group);
	if ( Inv != none )
		Inv.Activate();
}

// HUD
exec function ChangeHud()
{
	if ( myHud != None )
		myHUD.ChangeHud(1);
	myHUD.SaveConfig();
}

// Crosshair
exec function ChangeCrosshair(int d)
{
	if ( myHud != None ) 
		myHUD.ChangeCrosshair(d);
	myHUD.SaveConfig();
}

// Letterbox control
exec function Letterbox( bool B )
{
	if ( myHUD != none )
		myHUD.SetLetterbox( B );
}

// Letterbox aspect ratio control
exec function LetterboxAspect( float aspect )
{
	if ( myHUD != none )
		myHUD.SetLetterboxAspectRatio( aspect );
}

// Letterbox fade rate control
exec function LetterboxRate( float rate )
{
	if ( myHUD != none )
		myHUD.SetLetterboxFadeRate( rate );
}
exec function ShowMOTD();

event PreRender( canvas Canvas )
{
	if ( myHud != None )
	{
		myHUD.LetterboxCanvas( Canvas );
		myHUD.PreRender(Canvas);
	}
	else if ( (Viewport(Player) != None) && (HUDType != None) )
		myHUD = spawn(HUDType, self);
}

event PostRender( canvas Canvas )
{
	if ( myHud != None )
	{
		// if ( !myHUD.IsLetterboxed() )	// don't draw HUD elements when letterboxed (?)
		myHUD.PostRender(Canvas);
	}
	else if ( (Viewport(Player) != None) && (HUDType != None) )
		myHUD = spawn(HUDType, self);
}

//=============================================================================
// Inventory-related input notifications.

// Handle function keypress for F1-F10.
exec function FunctionKey( byte Num )
{
}

// The player wants to switch to weapon group numer I.
exec function SwitchWeapon( byte F )
{
	local weapon newWeapon;

	if ( bShowMenu || Level.Pauser!="" )
	{
		if ( myHud != None )
			myHud.InputNumber(F);
		return;
	}
	if ( Inventory == None )
		return;
	if ( (Weapon != None) && (Weapon.Inventory != None) )
		newWeapon = Weapon(Weapon.Inventory.FindItemInGroup(F));
	else
		newWeapon = None;	
	if ( newWeapon == None )
		newWeapon = Weapon(Inventory.FindItemInGroup(F));
	if ( newWeapon == None )
		return;

	if ( Weapon == None )
	{
		PendingWeapon = newWeapon;
		ChangedWeapon();
	}
	else if ( Weapon != newWeapon )
	{
		PendingWeapon = newWeapon;
		if ( !Weapon.PutDown() )
			PendingWeapon = None;
	}	
}

exec function Arm(class<Weapon> NewWeaponClass )
{
	local Inventory Inv;

	if ( (Inventory == None) || (NewWeaponClass == None)
		|| ((Weapon != None) && (Weapon.Class == NewWeaponClass)) )
		return;

	for ( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
		if ( Inv.Class == NewWeaponClass )
		{
			PendingWeapon = Weapon(Inv);
			if ( (PendingWeapon.AmmoType != None) && (PendingWeapon.AmmoType.AmmoAmount <= 0) )
			{
				Pawn(Owner).ClientMessage( PendingWeapon.ItemName$PendingWeapon.MessageNoAmmo );
				PendingWeapon = None;
				return;
			}
			Weapon.PutDown();
			return;
		}
}
	
// The player wants to select previous item
exec function PrevItem()
{
	local Inventory Inv, LastItem;

	if ( bShowMenu || Level.Pauser!="" )
		return;
	
	if (SelectedItem==None) {
		SelectedItem = Inventory.SelectNext();
		Return;
	}
	
	if (SelectedItem.Inventory!=None) 
		for( Inv=SelectedItem.Inventory; Inv!=None; Inv=Inv.Inventory ) {
			if (Inv==None) Break;
			if (Inv.bActivatable)
			{
				if ( Inv.IsA('Ammo') )
				{
					if ( Ammo(Inv).AmmoAmount > 0 )
						LastItem=Inv;
				} else {
					LastItem=Inv;
				}
			}
		}
	
	for( Inv=Inventory; Inv!=SelectedItem; Inv=Inv.Inventory ) {
		if (Inv==None) Break;
		
		if ( Inv.bActivatable )
		{
			if ( Inv.IsA('Ammo') )
			{
				if ( Ammo(Inv).AmmoAmount > 0 )
					LastItem=Inv;
			} else {
				LastItem=Inv;
			}
		}
	}
	
	if (LastItem!=None) {
		SelectedItem = LastItem;
		//ClientMessage(SelectedItem.ItemName$SelectedItem.M_Selected);
	}
}

// The player wants to active selected item
exec function ActivateItem()
{
	if( bShowMenu || Level.Pauser!="" )
		return;
	if (SelectedItem!=None) 
		SelectedItem.Activate();
}

exec function StopCutScene();

// The player wants to fire.
exec function Fire( optional float F )
{
	if ( Region.Zone.bNeutralZone )
		return;
	
	bJustFired = true;
	if( bShowMenu || (Level.Pauser!="") || (Role < ROLE_Authority) )
	{
		if( (Role < ROLE_Authority) && (Weapon!=None) )
		{
			bJustFired = Weapon.ClientFire(F);
		}
		if ( !bShowMenu && (PlayerReplicationInfo != None && Level.Pauser == PlayerReplicationInfo.PlayerName)  )
			SetPause(False);
		return;
	}
	if( Weapon!=None )
	{
		Weapon.bPointing = true;
		PlayFiring();
		Weapon.Fire(F);
	}
}

// The player wants to fire an attack spell
exec function FireAttSpell( optional float F )
{
//	Log("PlayerPawn: FireAttSpell: This is empty");
}

// The player wants to fire a defense spell
exec function FireDefSpell( optional float F );

// The player wants to select a weapon
exec function SelectWeapon( optional float F );

// The player wants to select an attack spell
exec function SelectAttSpell( optional float F );

// The player wants to select a defense spell
exec function SelectDefSpell( optional float F );

// check if "really" crouched (because AeonsPlayer can be crouching [e.g. stuck in a tunnel] when bIsCrouched is false)
function bool InCrouch()
{
	return bIsCrouching;
}

//Player Jumped
function DoJump( optional float F )
{
	local texture HitTexture, WaterTexture;
	local int flags;
	local float JumpMult;
	local float Vol;

	JumpMult = 1.0;

	if ( CarriedDecoration != None )
		return;
	if ( !InCrouch() && (Physics == PHYS_Walking) )
	{
		// don't bother tracing unless we have a FootSoundClass
		if ( FootSoundClass != None ) 
		{
			C_BackRight();
			C_BackLeft();

			HitTexture = TraceTexture( location + vect(0,0,-1)*CollisionHeight*2, location, flags );

			if ( HitTexture != None )
			{
				// 0 footstep, 1 land, 2 scuff 	//fix make enum, slot should be constant ?
				PlayFootSound( 3, HitTexture, 2, Location, 1.0 * VolumeMultiplier);
				JumpMult = HitTexture.JumpMultiplier;
				// log("DoJump() Jump Multiplier = "$JumpMult, 'Misc');
			} else {
				// log("DoJump() HitTexture = NONE", 'Misc');
			}

		}
		
		Vol = 1.0 * VolumeMultiplier;
		if (Vol > 0)
			PlaySound(JumpSound[Rand(2)],,Vol,[Pitch]FRand()*0.1 + 0.95);

		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			MakePlayerNoise(0.5 * Level.Game.Difficulty);
		PlayInAir();
		if ( bCountJumps && (Role == ROLE_Authority) && (Inventory != None) )
			Inventory.OwnerJumped();
		Velocity.Z = JumpZ * JumpMult;
		if ( (Base != Level) && (Base != None) )
			Velocity.Z += Base.Velocity.Z; 
		SetPhysics(PHYS_Falling);
	}
}

exec function AlwaysMouseLook( Bool B )
{
	ChangeAlwaysMouseLook(B);
	SaveConfig();
}

function ChangeAlwaysMouseLook(Bool B)
{
	bAlwaysMouseLook = B;
	if ( bAlwaysMouseLook )
		bLookUpStairs = false;
}
	
exec function SnapView( bool B )
{
	ChangeSnapView(B);
	SaveConfig();
}

function ChangeSnapView( bool B )
{
	bSnapToLevel = B;
}
	
exec function StairLook( bool B )
{
	ChangeStairLook(B);
	SaveConfig();
}

function ChangeStairLook( bool B )
{
	bLookUpStairs = B;
	if ( bLookUpStairs )
	{
		aLookUp = 0;
		bAlwaysMouseLook = false;
	}
}

final function ReplaceText(out string Text, string Replace, string With)
{
	local int i;
	local string Input;
		
	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	while(i != -1)
	{	
		Text = Text $ Left(Input, i) $ With;
		Input = Mid(Input, i + Len(Replace));	
		i = InStr(Input, Replace);
	}
	Text = Text $ Input;
}

exec function SetName( coerce string S )
{
	if ( Len(S) > 28 )
		S = left(S,28);
	ReplaceText(S, " ", "_");
	ChangeName(S);
	UpdateURL("Name", S, true);
	SaveConfig();
}

exec function Name( coerce string S )
{
	SetName(S);
}

function ChangeName( coerce string S )
{
	Level.Game.ChangeName( self, S, false );
}

function ChangeTeam( int N )
{
	local int OldTeam;
	local DamageInfo DInfo;

	OldTeam = PlayerReplicationInfo.Team;
	Level.Game.ChangeTeam(self, N);
	if ( Level.Game.bTeamGame && (PlayerReplicationInfo.Team != OldTeam) )
		Died( None, '', Location, DInfo);
}

function ClientChangeTeam( int N )
{
	local Pawn P;
		
	if ( PlayerReplicationInfo != None )
		PlayerReplicationInfo.Team = N;

	// if listen server, this may be called for non-local players that are logging in
	// if so, don't update URL
	if ( (Level.NetMode == NM_ListenServer) && (Player == None) )
	{
		// check if any other players exist
		for ( P=Level.PawnList; P!=None; P=P.NextPawn )
			if ( P.IsA('PlayerPawn') && (ViewPort(PlayerPawn(P).Player) != None) )
				return;
	}
		
	UpdateURL("Team",string(N), true);	
}

/*
simulated function ClientPlayAnim(name Sequence, optional float Rate, optional EMovement move, optional ECombine combine, optional float TweenTime, optional name JointName, optional bool AboveJoint, optional bool OverrideTarget )
//native(259) exec final function bool PlayAnim( name Sequence, optional float Rate, optional EMovement move, optional ECombine combine, optional float TweenTime, optional name JointName, optional bool AboveJoint, optional bool OverrideTarget );
{
	PlayAnim( Sequence, Rate, move, combine, TweenTime, JointName, AboveJoint, OverrideTarget );
}
*/

exec function SetAutoAim( float F )
{
	ChangeAutoAim(F);
	SaveConfig();
}

function ChangeAutoAim( float F )
{
	MyAutoAim = FMax(Level.Game.AutoAim, F);
}

exec function PlayersOnly()
{
	if ( Level.Netmode != NM_Standalone )
		return;

	Level.bPlayersOnly = !Level.bPlayersOnly;
}

exec function SetHand( string S )
{
	ChangeSetHand(S);
	SaveConfig();
}

function ChangeSetHand( string S )
{
	if ( S ~= "Left" )
		Handedness = 1;
	else if ( S~= "Right" )
		Handedness = -1;
	else if ( S ~= "Center" )
		Handedness = 0;
	else if ( S ~= "Hidden" )
		Handedness = 2;
	ServerSetHandedness(Handedness);
}

exec function ViewPlayer( string S )
{
	local pawn P;

	for ( P=Level.pawnList; P!=None; P= P.NextPawn )
		if ( P.bIsPlayer && (P.PlayerReplicationInfo.PlayerName ~= S) )
			break;

	if ( (P != None) && Level.Game.CanSpectate(self, P) )
	{
		ClientMessage(ViewingFrom@P.PlayerReplicationInfo.PlayerName, 'Event', true);
		if ( P == self)
			ViewTarget = None;
		else
			ViewTarget = P;
	}
	else
		ClientMessage(FailedView);

	bBehindView = ( ViewTarget != None );
	if ( bBehindView )
		ViewTarget.BecomeViewTarget();
}

exec function CheatView( class<actor> aClass )
{
	local actor other, first;
	local bool bFound;

	if( !bCheatsEnabled )
		return;

	if( !bAdmin && Level.NetMode!=NM_Standalone )
		return;

	first = None;
	ForEach AllActors( aClass, other )
	{
		if ( (first == None) && (other != self) )
		{
			first = other;
			bFound = true;
		}
		if ( other == ViewTarget ) 
			first = None;
	}  

	if ( first != None )
	{
		if ( first.IsA('Pawn') && Pawn(first).bIsPlayer && (Pawn(first).PlayerReplicationInfo.PlayerName != "") )
			ClientMessage(ViewingFrom@Pawn(first).PlayerReplicationInfo.PlayerName, 'Event', true);
		else
			ClientMessage(ViewingFrom@first, 'Event', true);
		ViewTarget = first;
	}
	else
	{
		if ( bFound )
			ClientMessage(ViewingFrom@OwnCamera, 'Event', true);
		else
			ClientMessage(FailedView, 'Event', true);
		ViewTarget = None;
	}

	bBehindView = ( ViewTarget != None );
	if ( bBehindView )
		ViewTarget.BecomeViewTarget();
}

exec function ViewSelf()
{
	bBehindView = false;
	Viewtarget = None;
	ClientMessage(ViewingFrom@OwnCamera, 'Event', true);
}

exec function ViewClass( class<actor> aClass, optional bool bQuiet )
{
	local actor other, first;
	local bool bFound;

	if ( (Level.Game != None) && !Level.Game.bCanViewOthers )
		return;

	first = None;
	ForEach AllActors( aClass, other )
	{
		if ( (first == None) && (other != self)
			 && ( (bAdmin && Level.Game==None) || Level.Game.CanSpectate(self, other) ) )
		{
			first = other;
			bFound = true;
		}
		if ( other == ViewTarget ) 
			first = None;
	}  

	if ( first != None )
	{
		if ( !bQuiet )
		{
			if ( first.IsA('Pawn') && Pawn(first).bIsPlayer && (Pawn(first).PlayerReplicationInfo.PlayerName != "") )
				ClientMessage(ViewingFrom@Pawn(first).PlayerReplicationInfo.PlayerName, 'Event', true);
			else
				ClientMessage(ViewingFrom@first, 'Event', true);
		}
		ViewTarget = first;
	}
	else
	{
		if ( !bQuiet )
		{
			if ( bFound )
				ClientMessage(ViewingFrom@OwnCamera, 'Event', true);
			else
				ClientMessage(FailedView, 'Event', true);
		}
		ViewTarget = None;
	}

	bBehindView = ( ViewTarget != None );
	if ( bBehindView )
		ViewTarget.BecomeViewTarget();
}

exec function ShowDebugInfo( class<actor> aClass, bool bShow )
{
	local actor other;

	ForEach AllActors( aClass, other )
	{
		other.bShowDebugInfo = bShow;
	}


}

exec function NeverSwitchOnPickup( bool B )
{
	bNeverAutoSwitch = B;
	bNeverSwitchOnPickup = B;
	ServerNeverSwitchOnPickup(B);
	SaveConfig();
}
	
function ServerNeverSwitchOnPickup(bool B)
{
	bNeverSwitchOnPickup = B;
}

exec function InvertMouse( bool B )
{
	bInvertMouse = B;
	SaveConfig();
}

exec function SwitchLevel( string URL )
{
	if( bAdmin || Player.IsA('ViewPort') )
		Level.ServerTravel( URL, false );
}

exec function SwitchCoopLevel( string URL )
{
	if( bAdmin || Player.IsA('ViewPort') )
		Level.ServerTravel( URL, true );
}

exec function ShowScores()
{
	bShowScores = !bShowScores;
}
 
exec function ShowMenu()
{
	WalkBob = vect(0,0,0);
	bShowMenu = true; // menu is responsible for turning this off
	Player.Console.GotoState('Menuing');
		
	if( Level.Netmode == NM_Standalone )
		SetPause(true);
}

exec function ShowLoadMenu()
{
	ShowMenu();
}

exec function AddBots(int N)
{
	ServerAddBots(N);
}

function ServerAddBots(int N)
{
	local int i;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	//if ( !Level.Game.bDeathMatch )
	//	return;

	for ( i=0; i<N; i++ )
		Level.Game.ForceAddBot();
}

	
//*************************************************************************************
// Special purpose/cheat execs

exec function ClearProgressMessages()
{
	local int i;

	for (i=0; i<8; i++)
	{
		ProgressMessage[i] = "";
		ProgressColor[i].R = 255;
		ProgressColor[i].G = 255;
		ProgressColor[i].B = 255;
	}
}

exec function SetProgressMessage( string S, int Index )
{
	if (Index < 8)
		ProgressMessage[Index] = S;
}

exec function SetProgressColor( color C, int Index )
{
	if (Index < 8)
		ProgressColor[Index] = C;
}

exec function SetProgressTime( float T )
{
	ProgressTimeOut = T + Level.TimeSeconds;
}

exec event ShowUpgradeMenu();

exec function Amphibious()
{
	if( !bCheatsEnabled )
		return;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	UnderwaterTime = +999999.0;
}
	
exec function Aerial()
{
	if( !bCheatsEnabled )
		return;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
		
	UnderWaterTime = Default.UnderWaterTime;	
	ClientMessage("You feel much lighter");
	SetCollision(true, true , true);
	bCollideWorld = true;
	GotoState('CheatFlying');
}

exec function SetWeaponStay( bool B)
{
	local Weapon W;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	Level.Game.bCoopWeaponMode = B;
	ForEach AllActors(class'Weapon', W)
	{
		W.bWeaponStay = false;
		W.SetWeaponStay();
	}
}

exec function Walk()
{	
	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	StartWalk();
}

function StartWalk()
{
	UnderWaterTime = Default.UnderWaterTime;	
	SetCollision(true, true , true);
	SetPhysics(PHYS_Walking);
	bCollideWorld = true;
	ClientReStart();	
}

function ClientReStart()
{
	CleanOutSavedMoves();
	ConstantGlowScale = 0;

	Super.ClientReStart();
}

exec function Astral()
{
	if( !bCheatsEnabled )
		return;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	
	UnderWaterTime = -1.0;	
	ClientMessage("You feel ethereal");
	SetCollision(false, false, false);
	bCollideWorld = false;
	GotoState('CheatFlying');
}

exec function ShowInventory()
{
	local Inventory Inv;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	
	if( Weapon!=None )
		log( "   Weapon: " $ Weapon.Class );
	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory ) 
		log( "Inv: "$Inv $ " state "$Inv.GetStateName());
	if ( SelectedItem != None )
		log( "Selected Item"@SelectedItem@"Charge"@SelectedItem.Charge );
}

exec function Woo()
{
	// aka "AllAmmo".
	local Inventory Inv;

	if( !bCheatsEnabled )
		return;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory ) 
		if (Ammo(Inv)!=None) 
		{
			Ammo(Inv).AmmoAmount  = Ammo(Inv).MaxAmmo;
			// Ammo(Inv).MaxAmmo  = 99;
		}
}	

exec function Invisible(bool B)
{
	if( !bCheatsEnabled )
		return;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	if (B)
	{
		bHidden = true;
		Visibility = 0;
	}
	else
	{
		bHidden = false;
		Visibility = Default.Visibility;
	}	
}

exec function NoDetect( bool B )
{
	if( !bCheatsEnabled )
		return;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	
	// used in native code, works
	bNoDetect = B;
}

exec function GenNoise( float Radius )
{
	MakePlayerNoise( 1.0 * VolumeMultiplier, Radius * VolumeMultiplier);
}

exec function Eh()
{
	if( !bCheatsEnabled )
		return;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	if ( !bAcceptDamage || !bAcceptMagicDamage )
	{
//		ReducedDamageType = '';
		bAcceptDamage = true;
		bAcceptMagicDamage = true;
		ClientMessage("Clive mode off");
		return;
	}

//	ReducedDamageType = 'All'; 
	bAcceptDamage = false;
	bAcceptMagicDamage = false;
	ClientMessage("Clive Mode on");
}

exec function BehindView( Bool B )
{
	bBehindView = B;
}

exec function SetBob(float F)
{
	UpdateBob(F);
	SaveConfig();
}

function UpdateBob(float F)
{
	Bob = FClamp(F,0,0.032);
}

exec function SetSensitivity(float F)
{
	UpdateSensitivity(F);
	SaveConfig();
}

function UpdateSensitivity(float F)
{
	MouseSensitivity = FMax(0,F);
}

exec function SloMo( float T )
{
	ServerSetSloMo(T);
}

exec function Tele(bool b)
{
	bCanTeleport = b;
}
	
function ServerSetSloMo(float T)
{
	if ( bAdmin || (Level.Netmode == NM_Standalone) )
	{
		Level.Game.SetGameSpeed(T);
		Level.Game.SaveConfig(); 
		Level.Game.GameReplicationInfo.SaveConfig();
	}
}

exec function SetJumpZ( float F )
{
	if( !bCheatsEnabled )
		return;
	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	JumpZ = F;
}

exec function SetFriction( float F )
{
	local ZoneInfo Z;
	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	ForEach AllActors(class'ZoneInfo', Z)
		Z.ZoneGroundFriction = F;
}

exec function SetSpeed( float F )
{
	if( !bCheatsEnabled )
		return;
	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	GroundSpeed = Default.GroundSpeed * f;
	WaterSpeed = Default.WaterSpeed * f;
}

exec function SnuffAll(class<actor> aClass)
{
	local Actor A;

	if( !bCheatsEnabled )
		return;
	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	ForEach AllActors(class 'Actor', A)
		if ( ClassIsChildOf(A.class, aClass) )
			A.Destroy();
}

exec function SnuffPawns()
{
	local Pawn P;
	
	if( !bCheatsEnabled )
		return;
	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	ForEach AllActors(class 'Pawn', P)
		if (PlayerPawn(P) == None)
			P.Destroy();
}

exec function Bring( name ClassName, optional int SpawnCount )
{
	local class<actor> NewClass;
	local int i;

	if( !bCheatsEnabled )
		return;
	if( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;
	log( "Fabricate " $ ClassName );
	
	NewClass = class<actor>( DynamicLoadObject( string(ClassName), class'Class', true ) );
	
	// if it class didn't load, try forcing the aeons. prefix
	if ( (NewClass == None) && (InStr(ClassName, "Aeons.") < 0) )
	{		
		NewClass = class<actor>( DynamicLoadObject( "Aeons." $ string(ClassName), class'Class' ) );
	}
	
	if( NewClass!=None )
		if (SpawnCount > 0)
		{
			for (i=0; i<SpawnCount; i++)
				Spawn( NewClass,,,Location + 96 * Vector(Rotation) + vect(0,0,1) * 15 + VRand() * 32);
		} else {
			Spawn( NewClass,,,Location + FMax( NewClass.default.CollisionRadius + CollisionRadius + 50, 72 ) * Vector(Rotation) + vect(0,0,1) * 15 );
		}


}


//==============
// Navigation Aids
exec function ShowPath()
{
	//find next path to remembered spot
	local Actor node;

	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	node = FindPathTo(Destination);
	if (node != None)
	{
		log("found path");
		Spawn(class 'WayBeacon', self, '', node.location);
	}
	else
		log("didn't find path");
}

exec function RememberSpot()
{
	//remember spot
	Destination = Location;
}
	
//=============================================================================
// Input related functions.

// Postprocess the player's input.

event PlayerInput( float DeltaTime )
{
	local float FOVScale, MouseScale, AbsSmoothX, AbsSmoothY, MouseTime;
	local int error;

	if ( bShowMenu && (myHud != None) ) 
	{
		if ( myHud.MainMenu != None )
			myHud.MainMenu.MenuTick( DeltaTime );
		// clear inputs
		bEdgeForward = false;
		bEdgeBack = false;
		bEdgeLeft = false;
		bEdgeRight = false;
		bWasForward = false;
		bWasBack = false;
		bWasLeft = false;
		bWasRight = false;
		aStrafe = 0;
		aTurn = 0;
		aForward = 0;
		aLookUp = 0;
		return;
	}
	else if ( bDelayedCommand )
	{
		bDelayedCommand = false;
		ConsoleCommand(DelayedCommand);
	}
				
	// Check for Dodge move //dodge  ??
	// flag transitions
	bEdgeForward = (bWasForward ^^ (aBaseY > 0));
	bEdgeBack = (bWasBack ^^ (aBaseY < 0));
	bEdgeLeft = (bWasLeft ^^ (aStrafe > 0));
	bEdgeRight = (bWasRight ^^ (aStrafe < 0));
	bWasForward = (aBaseY > 0);
	bWasBack = (aBaseY < 0);
	bWasLeft = (aStrafe > 0);
	bWasRight = (aStrafe < 0);
	
	// Amplify mouse movement
	FOVScale = DesiredFOV * 0.01111; 
	MouseScale = MouseSensitivity * FOVScale;

	aMouseX *= MouseScale;
	aMouseY *= MouseScale;

//************************************************************************

	//log("X "$aMouseX$" Smooth "$SmoothMouseX$" Borrowed "$BorrowedMouseX$" zero time "$(Level.TimeSeconds - MouseZeroTime)$" vs "$MouseSmoothThreshold);
	AbsSmoothX = SmoothMouseX;
	AbsSmoothY = SmoothMouseY;
	MouseTime = (Level.TimeSeconds - MouseZeroTime)/Level.TimeDilation;
	if (bMouseSmoothing)
	{
		if ( bMaxMouseSmoothing && (aMouseX == 0) && (MouseTime < MouseSmoothThreshold) )
		{
			SmoothMouseX = 0.5 * (MouseSmoothThreshold - MouseTime) * AbsSmoothX/MouseSmoothThreshold;
			BorrowedMouseX += SmoothMouseX;
		}
		else
		{
			if ( (SmoothMouseX == 0) || (aMouseX == 0) 
					|| ((SmoothMouseX > 0) != (aMouseX > 0)) )
			{
				SmoothMouseX = aMouseX;
				BorrowedMouseX = 0;
			}
			else
			{
				SmoothMouseX = 0.5 * (SmoothMouseX + aMouseX - BorrowedMouseX);
				if ( (SmoothMouseX > 0) != (aMouseX > 0) )
				{
					if ( AMouseX > 0 )
						SmoothMouseX = 1;
					else
						SmoothMouseX = -1;
				} 
				BorrowedMouseX = SmoothMouseX - aMouseX;
			}
			AbsSmoothX = SmoothMouseX;
		}
		if ( bMaxMouseSmoothing && (aMouseY == 0) && (MouseTime < MouseSmoothThreshold) )
		{
			SmoothMouseY = 0.5 * (MouseSmoothThreshold - MouseTime) * AbsSmoothY/MouseSmoothThreshold;
			BorrowedMouseY += SmoothMouseY;
		}
		else
		{
			if ( (SmoothMouseY == 0) || (aMouseY == 0) 
					|| ((SmoothMouseY > 0) != (aMouseY > 0)) )
			{
				SmoothMouseY = aMouseY;
				BorrowedMouseY = 0;
			}
			else
			{
				SmoothMouseY = 0.5 * (SmoothMouseY + aMouseY - BorrowedMouseY);
				if ( (SmoothMouseY > 0) != (aMouseY > 0) )
				{
					if ( AMouseY > 0 )
						SmoothMouseY = 1;
					else
						SmoothMouseY = -1;
				} 
				BorrowedMouseY = SmoothMouseY - aMouseY;
			}
			AbsSmoothY = SmoothMouseY;
		}
	}
	else
	{
		SmoothMouseX = aMouseX;		AbsSmoothX = SmoothMouseX;
		SmoothMouseY = aMouseY;		AbsSmoothY = SmoothMouseY;
	}

	if ( (aMouseX != 0) || (aMouseY != 0) )
		MouseZeroTime = Level.TimeSeconds;

	// adjust keyboard and joystick movements
	aLookUp *= FOVScale;
	aTurn   *= FOVScale;

	// Remap raw x-axis movement.
	if( bStrafe!=0 )
	{
		// Strafe.
		aStrafe += aBaseX + SmoothMouseX;
		aBaseX   = 0;
	}
	else
	{
		// Forward.
		aTurn  += aBaseX * FOVScale + SmoothMouseX;
		aBaseX  = 0;
	}

	// Remap mouse y-axis movement.
	if( (bStrafe == 0) && (bAlwaysMouseLook || (bLook!=0)) )
	{
		// Look up/down.
		if ( bInvertMouse )
			aLookUp -= SmoothMouseY;
		else
			aLookUp += SmoothMouseY;
	}
	else if ( GetStateName() != 'SelectObject' )
	{
		// Move forward/backward.
		aForward += SmoothMouseY;
	}
	SmoothMouseX = AbsSmoothX;
	SmoothMouseY = AbsSmoothY;

	if ( bSnapLevel != 0 )
	{
		bCenterView = true;
		bKeyboardLook = false;
	}
	else if (aLookUp != 0)
	{
		bCenterView = false;
		bKeyboardLook = true;
	}
	else if ( bSnapToLevel && !bAlwaysMouseLook )
	{
		bCenterView = true;
		bKeyboardLook = false;
	}

	// Remap other y-axis movement.
	if ( bFreeLook != 0 )
	{
		bKeyboardLook = true;
		aLookUp += 0.5 * aBaseY * FOVScale;
	}
	else
		aForward += aBaseY;

	aBaseY = 0;

	// Handle walking.
	HandleWalking();

	// Handle actuator
	error = RunActuator ();
	if (error == EActError.ACT_AlignReset)
		ResetAct ();
}


//=============================================================================
// functions.

event UpdateEyeHeight(float DeltaTime)
{
	local float smooth, bound;
	
	// smooth up/down stairs
	If( (Physics==PHYS_Walking) && !bJustLanded )
	{
		smooth = FMin(1.0, 10.0 * DeltaTime/Level.TimeDilation);
		EyeHeight = (EyeHeight - Location.Z + OldLocation.Z) * (1 - smooth) + ( ShakeVert + BaseEyeHeight) * smooth;
		bound = -CollisionHeight;
		if (EyeHeight < bound)
			EyeHeight = bound;
		else
		{
			bound = CollisionHeight + FClamp((OldLocation.Z - Location.Z), 0.0, MaxStepHeight); 
			if ( EyeHeight > bound )
				EyeHeight = bound;
		}
	}
	else
	{
		smooth = FClamp(10.0 * DeltaTime/Level.TimeDilation, 0.35,1.0);
		bJustLanded = false;
		EyeHeight = EyeHeight * ( 1 - smooth) + (BaseEyeHeight + ShakeVert) * smooth;
	}

	// teleporters affect your FOV, so adjust it back down
	if ( FOVAngle != DesiredFOV )
	{
		if ( FOVAngle > DesiredFOV )
			FOVAngle = FOVAngle - FMax(7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV)); 
		else 
			FOVAngle = FOVAngle - FMin(-7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV)); 
		if ( Abs(FOVAngle - DesiredFOV) <= 10 )
			FOVAngle = DesiredFOV;
	}

	// adjust FOV for weapon zooming
	if ( bZooming )
	{	
		ZoomLevel += DeltaTime * 1.0;
		if (ZoomLevel > 0.9)
			ZoomLevel = 0.9;
		DesiredFOV = FClamp(90.0 - (ZoomLevel * 88.0), 1, 170);
	} 
}

event PlayerTimeOut()
{
	local DamageInfo DInfo;

	if (Health > 0)
		Died(None, 'Suicided', Location, DInfo);
}

// Just changed to pendingWeapon
function ChangedWeapon()
{
	Super.ChangedWeapon();
	if ( PendingWeapon != None )
		PendingWeapon.SetHand(Handedness);
}

function JumpOffPawn()
{
	Velocity += 60 * VRand();
	Velocity.Z = 120;
	SetPhysics(PHYS_Falling);
}

event TravelPostAccept()
{
	if ( Health <= 0 )
	{
		Health = Default.Health;
		bBehindView = false; // bBehindView is set in Dying state, but EndState won't get called when switching levels 
	}
}

// This pawn was possessed by a player.
event Possess()
{
	CurrentTimeStamp = 0.0;
	ServerTimeStamp = 0.0;
	TimeMargin = 0.0;
	MaxTimeMargin = Default.MaxTimeMargin;
	CleanOutSavedMoves();

	if ( Level.Netmode == NM_Client )
	{
		// replicate client weapon preferences to server
		ServerNeverSwitchOnPickup(bNeverAutoSwitch);
		ServerSetHandedness(Handedness);
		UpdateWeaponPriorities();
	}
	ServerUpdateWeapons();
	
	bIsPlayer = true;
	EyeHeight = BaseEyeHeight;
	TargetEyeHeight = BaseEyeheight;
	DesiredFOV = DefaultFOV;
	FOVAngle = DefaultFOV;
	bBehindView = false;
	Viewtarget = None;
	NetPriority = 3;
	StartWalk();
	UnFreeze();
	ReleasePos();
}

function UpdateWeaponPriorities()
{
	local byte i;

	// send new priorities to server
	if ( Level.Netmode == NM_Client )
		for ( i=0; i<ArrayCount(WeaponPriority); i++ )
			ServerSetWeaponPriority(i, WeaponPriority[i]);
}

function ServerSetWeaponPriority(byte i, name WeaponName )
{
	local inventory inv;

	WeaponPriority[i] = WeaponName;

	for ( inv=Inventory; inv!=None; inv=inv.inventory )
		if ( inv.class.name == WeaponName )
			Weapon(inv).SetSwitchPriority(self);
}

// This pawn was unpossessed by a player.
event UnPossess()
{
	log(Self$" being unpossessed");
	if ( myHUD != None )
		myHUD.Destroy();
	bIsPlayer = false;
	EyeHeight = 0.8 * CollisionHeight;
}

function Carcass SpawnCarcass()
{
	local carcass carc;

	carc = Spawn(CarcassType);
	if ( carc == None )
		return None;
	carc.Initfor(self);
	if (Player != None)
		carc.bPlayerCarcass = true;
	if ( !Level.Game.bGameEnded && (Carcass(ViewTarget) == None) )
		ViewTarget = carc; //for Player 3rd person views
	return carc;
}

function bool Gibbed(name damageType)
{
	if ( (damageType == 'decapitated') || (damageType == 'shot') )
		return false; 	
	if ( (Health < -80) || ((Health < -40) && (FRand() < 0.6)) )
		return true;
	return false;
}

function SpawnGibbedCarcass(vector Dir)
{
	local carcass carc;

	carc = Spawn(CarcassType);
	if ( carc != None )
	{
		carc.Initfor(self);
		carc.ChunkUp(-1 * Health);
	}
}


Event PlayerTick( float DeltaTime );
/*
{
	local float DeltaOpacity;
	
	// player cutscene fade in/out
	DeltaOpacity = deltaTime * 2.0;
	if ( bRenderSelf )
		Opacity = FClamp(Opacity + DeltaOpacity, 0, 1);
	else
		Opacity = FClamp(Opacity - DeltaOpacity, 0, 1);
}
*/

//
// Called immediately before gameplay begins.
//
event PreBeginPlay()
{
	bIsPlayer = true;
	bRenderSelf = true;
	bAllowMove = true;

	bRotateToDesired = Level.NetMode == NM_Standalone; // caused jittery rotation in multiplayer since DesiredRotation isn't updated
	
	// log("-------------------Player Pawn PreBeginPlay "$self, 'Misc');
	if ( IconsofShame == None && GetPlatform() == PLATFORM_WinPC ) 
	{
		// Log("Initializing Icons of Shame...");
	
		//IconsofShame = spawn(class'StatManager', self);
	}	

	Super.PreBeginPlay();
}

event PostBeginPlay()
{
	local Actor A;
	
	Super.PostBeginPlay();
	
	// Notify all the actors in the level that the player is ready.
	ForEach AllActors(class 'Actor', A)
	{
		A.PlayerReady(self);
	}

	// Trigger any LevelBegin actors
	TriggerLevelBegin();

	// Set skin. Moved here from Pawn.
	if ( bIsMultiSkinned )
	{
		if ( MultiSkins[1] == None )
		{
			if ( bIsPlayer )
				SetMultiSkin(self, "","", PlayerReplicationInfo.team);
			else
				SetMultiSkin(self, "","", 0);
		}
	}
	else if ( Skin == None )
		Skin = Default.Skin;

	if (Level.LevelEnterText != "" )
		ClientMessage(Level.LevelEnterText);

	if ( Level.NetMode != NM_Client )
	{
		HUDType = Level.Game.HUDType;
		ScoringType = Level.Game.ScoreboardType;
		MyAutoAim = FMax(MyAutoAim, Level.Game.AutoAim);
	}
	
	bIsPlayer = true;
	DesiredFOV = DefaultFOV;
	EyeHeight = BaseEyeHeight;
	if ( Level.Game.IsA('SinglePlayer') && (Level.NetMode == NM_Standalone) )
		FlashScale = vect(0,0,0);

	// set up the actuator (PSX2)
	InitAct (0, 0);

	MaxTimeMargin = Default.MaxTimeMargin;
	MaxResponseTime = Default.MaxResponseTime * Level.TimeDilation;
}

function TriggerLevelBegin()
{
	local Actor A;
	
	ForEach AllActors(class 'Actor', A, 'LevelBegin')
	{
		if ( A.IsA('Trigger') )
		{
			if ( Trigger(A).bPassThru )
			{
				Trigger(A).PassThru(self);
			}
		}
		A.Trigger(none, self);
	}
}

function StartLevel()
{
/*
	local Actor A;
	

	// Notify all the actors in the level that the player is ready.
	ForEach AllActors(class 'Actor', A)
	{
		A.PlayerReady(self);
	}

	// Trigger any LevelBegin actors
	ForEach AllActors(class 'Actor', A, 'LevelBegin')
	{
		if ( A.IsA('Trigger') )
		{
			if ( Trigger(A).bPassThru )
			{
				Trigger(A).PassThru(self);
			}
		}
		A.Trigger(none, self);
	}
*/
}

function ServerUpdateWeapons()
{
	local inventory Inv;

	For ( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
		if ( Inv.IsA('Weapon') )
			Weapon(Inv).SetSwitchPriority(self); 
}

//=============================================================================
// Animation playing - should be implemented in subclass, 
//
function PlayTurning();

function PlaySwimming()
{
	PlayLocomotion( vect(1,0,0) );
}

function PlayFeignDeath();
function PlayRising();


/* AdjustAim()
Calls this version for player aiming help.
Aimerror not used in this version.
Only adjusts aiming at pawns
*/

function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
	local vector FireDir, AimSpot, HitNormal, HitLocation;
	local actor BestTarget;
	local float bestAim, bestDist;
	local actor HitActor;
	local int HitJoint;
	
	FireDir = vector(ViewRotation);
	HitActor = Trace(HitLocation, HitNormal, HitJoint, projStart + 4000 * FireDir, projStart, true);
	if ( (HitActor != None) && HitActor.bProjTarget )
	{
		if ( bWarnTarget && HitActor.IsA('Pawn') )
			Pawn(HitActor).WarnTarget(self, projSpeed, FireDir);
		return ViewRotation;
	}

	bestAim = FMin(0.93, MyAutoAim);
	BestTarget = PickTarget(bestAim, bestDist, FireDir, projStart);

	if ( bWarnTarget && (Pawn(BestTarget) != None) )
		Pawn(BestTarget).WarnTarget(self, projSpeed, FireDir);	

	if ( (Level.NetMode != NM_Standalone) || (Level.Game.Difficulty > 2) 
		|| bAlwaysMouseLook || ((BestTarget != None) && (bestAim < MyAutoAim)) || (MyAutoAim >= 1) )
		return ViewRotation;
	
	if ( BestTarget == None )
	{
		bestAim = MyAutoAim;
		BestTarget = PickAnyTarget(bestAim, bestDist, FireDir, projStart);
		if ( BestTarget == None )
			return ViewRotation;
	}

	AimSpot = projStart + FireDir * bestDist;
	AimSpot.Z = BestTarget.Location.Z + 0.3 * BestTarget.CollisionHeight;

	return rotator(AimSpot - projStart);
}

function CheckLanded( vector HitNormal )
{
	local Texture HitTexture;
	local int Flags;
	local DamageInfo DInfo;

	HitTexture = TraceTexture(Location + (vect(0,0,-128)), Location, Flags );

	if ( (128 & Flags) != 0 )
	{
		Died( None, '', Location, DInfo);
	}
}

function Landed(vector HitNormal)
{
	if (Role == ROLE_Authority)
		CheckLanded( HitNormal );

	//Note - physics changes type to PHYS_Walking by default for landed pawns
	if ( bUpdating )
		return;
	PlayLanded(Velocity.Z);
	C_BackRight();
	C_BackLeft();
	//LandBob = FMin(50, 0.055 * Velocity.Z); // disabled
	TakeFallingDamage();
	bJustLanded = true;
	// log("PlayerPawn Landed()", 'Misc');
}

function Died(pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo)
{
	StopZoom();

	Super.Died(Killer, damageType, HitLocation, DInfo);
}

function eAttitude AttitudeTo(Pawn Other)
{
	if (Other.bIsPlayer)
		return AttitudeToPlayer;
	else 
		return Other.AttitudeToPlayer;
}


function string KillMessage( name damageType, pawn Other )
{
	return ( Level.Game.PlayerKillMessage(damageType, Other.PlayerReplicationInfo)$PlayerReplicationInfo.PlayerName );
}
	
//=============================================================================
// Player Control

function KilledBy( pawn EventInstigator )
{
	local DamageInfo DInfo;
	
	Health = 0;
	Died( EventInstigator, 'Suicided', Location, DInfo );
}

// Player view.
// Compute the rendering viewpoint for the player.
//

function CalcBehindView(out vector CameraLocation, out rotator CameraRotation, float Dist)
{
	local vector View,HitLocation,HitNormal;
	local float ViewDist;
	local int HitJoint;

	CameraRotation = ViewRotation;
	CameraRotation.Yaw += BehindViewOffset.Yaw;
	CameraRotation.Pitch += BehindViewOffset.Pitch;

	View = vect(1,0,0) >> CameraRotation;
	if( Trace( HitLocation, HitNormal, HitJoint, CameraLocation - (Dist + 30) * vector(CameraRotation), CameraLocation, false ) != None )
		ViewDist = FMin( (CameraLocation - HitLocation) Dot View, Dist );
	else
		ViewDist = Dist;
	CameraLocation -= (ViewDist - 30) * View; 
}

event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local Pawn PTarget;

	// a way to remove black fog from PaintProgress when changing levels
	//FlashScale = vect(1,1,1);
	//FlashFog = vect(0,0,0);

	if ( ViewTarget != None )
	{
		ViewActor = ViewTarget;
		CameraLocation = ViewTarget.Location;
		CameraRotation = ViewTarget.Rotation;
		PTarget = Pawn(ViewTarget);
		if ( PTarget != None )
		{
			if ( Level.NetMode == NM_Client )
			{
				if ( PTarget.bIsPlayer )
					PTarget.ViewRotation = TargetViewRotation;
				PTarget.EyeHeight = TargetEyeHeight;
				if ( PTarget.Weapon != None )
					PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
			}
			if ( PTarget.bIsPlayer )
				CameraRotation = PTarget.ViewRotation;
			if ( !bBehindView )
				CameraLocation.Z += PTarget.EyeHeight;
		}
		if ( bBehindView )
			CalcBehindView(CameraLocation, CameraRotation, FMax( ViewTarget.CollisionHeight * 3.0, 200.0 ));
		// log("ViewTarget is "$ ViewTarget$" ViewTarget Location: "$ViewTarget.Location$" Camera Location: "$CameraLocation,'Misc');
		return;
	}

	ViewActor = Self;
	CameraLocation = Location;

	if( bBehindView ) //up and behind
	{
		CameraLocation.Z += EyeHeight;
		CalcBehindView(CameraLocation, CameraRotation, CollisionHeight * 5.0);
	}
	else
	{
		// First-person view.
		CameraRotation = ViewRotation;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
	}
}

exec function SetViewFlash(bool B)
{
	bNoFlash = !B;
}

function ViewFlash(float DeltaTime)
{
	local vector goalFog;
	local float goalscale, delta;

	if ( bNoFlash )
	{
		InstantFlash = 0;
		InstantFog = vect(0,0,0);
	}

	delta = FMin(0.1, DeltaTime);
	goalScale = 1 + DesiredFlashScale + ConstantGlowScale + HeadRegion.Zone.ViewFlash.X; 
	goalFog = DesiredFlashFog + ConstantGlowFog + HeadRegion.Zone.ViewFog;
	DesiredFlashScale -= DesiredFlashScale * 2 * delta;  
	DesiredFlashFog -= DesiredFlashFog * 2 * delta;
	FlashScale.X += (goalScale - FlashScale.X + InstantFlash) * 10 * delta;
	FlashFog += (goalFog - FlashFog + InstantFog) * 10 * delta;
	InstantFlash = 0;
	InstantFog = vect(0,0,0);

	if ( FlashScale.X > 0.981 )
		FlashScale.X = 1;
	FlashScale = FlashScale.X * vect(1,1,1);

	if ( FlashFog.X < 0.0 )
		FlashFog.X = 0;
	if ( FlashFog.Y < 0.0 )
		FlashFog.Y = 0;
	if ( FlashFog.Z < 0.0 )
		FlashFog.Z = 0;
}

function ViewShake(float DeltaTime)
{
	if (shaketimer > 0.0) //shake view
	{
		shaketimer -= DeltaTime;
		if ( verttimer == 0 )
		{
			verttimer = 0.1;
			ShakeVert = -1.1 * maxshake;
		}
		else
		{
			verttimer -= DeltaTime;
			if ( verttimer < 0 )
			{
				verttimer = 0.2 * FRand();
				shakeVert = (2 * FRand() - 1) * maxshake;  
			}
		}
		ViewRotation.Roll = ViewRotation.Roll & 65535;
		if (bShakeDir)
		{
			ViewRotation.Roll += Int( 10 * shakemag * FMin(0.1, DeltaTime));
			bShakeDir = (ViewRotation.Roll > 32768) || (ViewRotation.Roll < (0.5 + FRand()) * shakemag);
			if ( (ViewRotation.Roll < 32768) && (ViewRotation.Roll > 1.3 * shakemag) )
			{
				ViewRotation.Roll = 1.3 * shakemag;
				bShakeDir = false;
			}
			else if (FRand() < 3 * DeltaTime)
				bShakeDir = !bShakeDir;
		}
		else
		{
			ViewRotation.Roll -= Int( 10 * shakemag * FMin(0.1, DeltaTime));
			bShakeDir = (ViewRotation.Roll > 32768) && (ViewRotation.Roll < 65535 - (0.5 + FRand()) * shakemag);
			if ( (ViewRotation.Roll > 32768) && (ViewRotation.Roll < 65535 - 1.3 * shakemag) )
			{
				ViewRotation.Roll = 65535 - 1.3 * shakemag;
				bShakeDir = true;
			}
			else if (FRand() < 3 * DeltaTime)
				bShakeDir = !bShakeDir;
		}
	}
	else
	{
		ShakeVert = 0;
		ViewRotation.Roll = ViewRotation.Roll & 65535;
		if (ViewRotation.Roll < 32768)
		{
			if ( ViewRotation.Roll > 0 )
				ViewRotation.Roll = Max(0, ViewRotation.Roll - (Max(ViewRotation.Roll,500) * 10 * FMin(0.1,DeltaTime)));
		}
		else
		{
			ViewRotation.Roll += ((65536 - Max(500,ViewRotation.Roll)) * 10 * FMin(0.1,DeltaTime));
			if ( ViewRotation.Roll > 65534 )
				ViewRotation.Roll = 0;
		}
	} 
}

/*
function UpdateRotation(float DeltaTime)
{
	local int multfactor;
	DesiredRotation = ViewRotation; //save old rotation

	ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
	ViewRotation.Pitch = ViewRotation.Pitch & 65535;
	If ((ViewRotation.Pitch > 99*DEGREES) && (ViewRotation.Pitch < 270*DEGREES))
	{
		If (aLookUp > 0) 
			ViewRotation.Pitch = 99*DEGREES;
		else
			ViewRotation.Pitch = 270*DEGREES;
	}

	ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
	ViewShake(deltaTime);
	ViewFlash(deltaTime);
		
	RotateToView();
}
*/

function UpdateRotation(float DeltaTime, float maxPitch)
{
	local rotator newRotation;
	
	DesiredRotation = ViewRotation; //save old rotation
	ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
	ViewRotation.Pitch = ViewRotation.Pitch & 65535;
	If ((ViewRotation.Pitch > 99*DEGREES) && (ViewRotation.Pitch < 270*DEGREES))
	{
		If (aLookUp > 0) 
			ViewRotation.Pitch = 99*DEGREES;
		else
			ViewRotation.Pitch = 270*DEGREES;
	}
	ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
	ViewShake(deltaTime);
	ViewFlash(deltaTime);
		
	newRotation = Rotation;
	newRotation.Yaw = ViewRotation.Yaw;
	newRotation.Pitch = ViewRotation.Pitch;
	If ( (newRotation.Pitch > maxPitch * RotationRate.Pitch) && (newRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
	{
		If (ViewRotation.Pitch < 32768) 
			newRotation.Pitch = maxPitch * RotationRate.Pitch;
		else
			newRotation.Pitch = 65536 - maxPitch * RotationRate.Pitch;
	}

	if (Level.NetMode == NM_Standalone)
	{
		newRotation.Yaw = Rotation.Yaw;
		RotateToView(); // not working well on clients
	}
	setRotation(newRotation);
}

function SwimAnimUpdate(bool bNotForward)
{
	if ( !bAnimTransition && (GetAnimGroup(AnimSequence) != 'Gesture') )
	{
		if ( bNotForward )
	 	{
		 	 if ( GetAnimGroup(AnimSequence) != 'Waiting' )
				TweenToWaiting(0.1);
		}
		else if ( GetAnimGroup(AnimSequence) == 'Waiting' )
			TweenToSwimming(0.1);
	}
}

auto state InvalidState
{
	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		log(self$" invalid state");
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove( float DeltaTime )
	{
		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, vect(0,0,0), rot(0,0,0));
	}
}

// Player movement.
// Player Standing, walking, running, falling.

state PlayerWalking
{
//	MJG: removed all functionality as some functions in this state were being called
//	even though the state was overridden in subclass AeonsPlayer.
}


state FeigningDeath
{
ignores SeePlayer, HearNoise, Bump;

	function ZoneChange( ZoneInfo NewZone )
	{
		if (NewZone.bWaterZone)
		{
			setPhysics(PHYS_Swimming);
			GotoState('PlayerSwimming');
		}
	}

	exec function Fire( optional float F )
	{
		bJustFired = true;
	}

	function PlayChatting()
	{
	}

	exec function Taunt( name Sequence )
	{
	}

	function AnimEnd()
	{
		if ( Role < ROLE_Authority )
			return;
		if ( Health <= 0 )
		{
			PlayerDied('Dying');
			return;
		}
		GotoState('PlayerWalking');
	}
	
	function Landed(vector HitNormal)
	{
		CheckLanded( HitNormal );
		if ( Role == ROLE_Authority ) {
			PlaySound(Land, SLOT_Interact, 0.3 * VolumeMultiplier, false, 800, 1.0);
			MakePlayerNoise(0.5 * VolumeMultiplier, 640 * VolumeMultiplier);
		}
		if ( bUpdating )
			return;
		TakeFallingDamage();
		bJustLanded = true;				
	}

	function Rise()
	{
		if ( (Role == ROLE_Authority) && (Health <= 0) )
		{
			PlayerDied('Dying');
			return;
		}
		if ( !bRising )
		{
			Enable('AnimEnd');
			BaseEyeHeight = Default.BaseEyeHeight;
			bRising = true;
			PlayRising();
		}
	}

	function ProcessMove(float DeltaTime, vector NewAccel, rotator DeltaRot)	
	{
		if ( bJustFired || bPressedJump || (NewAccel.Z > 0) )
			Rise();
		Acceleration = vect(0,0,0);
	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		//Weapon = None; // in case client confused because of weapon switch just before feign death
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
	}

	function ServerMove
	(
		float TimeStamp, 
		vector Accel, 
		vector ClientLoc,
		bool NewbRun,
		bool NewbDuck,
		bool NewbJumpStatus, 
		bool bFired,
		bool bForceFire,
        bool bFiredAttSpell,
		bool bForceFireAttSpell, 
        bool bFiredDefSpell,
		bool bForceFireDefSpell,
		byte ClientRoll, 
		int View,
		optional byte OldTimeDelta,
		optional int OldAccel
	)
	{
		Global.ServerMove(TimeStamp, Accel, ClientLoc, NewbRun, NewbDuck, NewbJumpStatus,
							bFired, bForceFire, bFiredAttSpell, bForceFireAttSpell, bFiredDefSpell, bForceFireDefSpell,
							ClientRoll, (32767 & (Rotation.Pitch/2)) * 32768 + (32767 & (Rotation.Yaw/2)));
	}

	function PlayerMove( float DeltaTime)
	{
		local rotator currentRot;
		local vector NewAccel;

		aLookup  *= 0.24;
		aTurn    *= 0.24;

		// Update acceleration.
		if ( !IsAnimating() && (aForward != 0) || (aStrafe != 0) )
			NewAccel = vect(0,0,1);
		else
			NewAccel = vect(0,0,0);

		// Update view rotation.
		currentRot = Rotation;
		UpdateRotation(DeltaTime, 0.0);
		SetRotation(currentRot);

		if (bAllowMove)
		{
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, NewAccel, Rot(0,0,0));
			else
				ProcessMove(DeltaTime, NewAccel, Rot(0,0,0));
		}
		bPressedJump = false;
	}

	function PlayTakeHit(float tweentime, vector HitLoc, int Damage)
	{
		if ( IsAnimating() )
		{
			Enable('AnimEnd');
			Global.PlayTakeHit(tweentime, HitLoc, Damage);
		}
	}
	
	function PlayDying(name DamageType, vector HitLocation, DamageInfo DInfo)
	{
		BaseEyeHeight = Default.BaseEyeHeight;
		if ( bRising || IsAnimating() )
			Global.PlayDying(DamageType, HitLocation, DInfo);
	}
	
	function ChangedWeapon()
	{
		Weapon = None;
		Inventory.ChangedWeapon();
	}

	function EndState()
	{
		bJustFired = false;
		PlayerReplicationInfo.bFeigningDeath = false;
		BaseEyeHeight = Default.BaseEyeHeight;

		if (PendingWeapon != None)
			PendingWeapon.SetDefaultDisplayProperties();
		if (Level.NetMode != NM_Standalone) // keep old singleplayer behavior for speedrunning
			Global.ChangedWeapon(); // crashes the client if the map is changed while in FeigningDeath state
	}

	function BeginState()
	{
		local rotator NewRot;
		if ( carriedDecoration != None )
			DropDecoration();
		NewRot = Rotation;
		NewRot.Pitch = 0;
		SetRotation(NewRot);
		BaseEyeHeight = -0.5 * CollisionHeight;
		bIsCrouching = false;
		bPressedJump = false;
		bJustFired = false;
		bRising = false;
		Disable('AnimEnd');
		PlayFeignDeath();
		PlayerReplicationInfo.bFeigningDeath = true;
	}
}

// Player movement.
// Player Swimming
state PlayerSwimming
{
	//	JCJ: Moved this to AeonsPlayer to accomodate swimming sounds.
}

state PlayerFlying
{
ignores SeePlayer, HearNoise, Bump;
		
	function AnimEnd()
	{
		PlaySwimming();
	}
	
	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();
	
		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator newRotation;
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.2;
		aStrafe  *= 0.2;
		aLookup  *= 0.24;
		aTurn    *= 0.24;

		Acceleration = aForward*X + aStrafe*Y;  
		// Update rotation.
		UpdateRotation(DeltaTime, 2.0);

		if (bAllowMove)
		{
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, Acceleration, rot(0,0,0));
			else
				ProcessMove(DeltaTime, Acceleration, rot(0,0,0));
		}
	}
	
	function BeginState()
	{
		SetPhysics(PHYS_Flying);
		if  ( !IsAnimating() )
			PlayLocomotion( vect(0.5,0,0) );
		//log("player flying");
	}
}

state CheatFlying
{
ignores SeePlayer, HearNoise, Bump, TakeDamage;
		
	function AnimEnd()
	{
		PlaySwimming();
	}
	
	function ProcessMove(float DeltaTime, vector NewAccel, rotator DeltaRot)	
	{
		Acceleration = Normal(NewAccel);
		Velocity = Normal(NewAccel) * GroundSpeed;
		AutonomousPhysics(DeltaTime);
//		MoveSmooth(Acceleration * DeltaTime);

	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator newRotation;
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;
	
		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);  

		UpdateRotation(DeltaTime, 2.0);

		if (bAllowMove)
		{
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, Acceleration, rot(0,0,0));
			else
				ProcessMove(DeltaTime, Acceleration, rot(0,0,0));
		}
	}

	function BeginState()
	{
		EyeHeight = BaseEyeHeight;
		AirSpeed = 9999.0;
		SetPhysics(PHYS_Flying);
		if  ( !IsAnimating() ) PlaySwimming();
		bCanFly = true;
		// log("cheat flying");
	}

	function EndState()
	{
		SetCollision(true, true, true);
		bCollideWorld = true;
		AirSpeed = default.AirSpeed;
		bCanFly = false;
	}
}

state PlayerWaiting
{
ignores SeePlayer, HearNoise, Bump, TakeDamage, Died, ZoneChange, FootZoneChange;

	exec function Jump( optional float F )
	{
	}

	function ChangeTeam( int N )
	{
		Level.Game.ChangeTeam(self, N);
	}

	exec function Fire(optional float F)
	{
		bReadyToPlay = true;
	}

	function ProcessMove(float DeltaTime, vector NewAccel, rotator DeltaRot)	
	{
		Acceleration = NewAccel;
		MoveSmooth(Acceleration * DeltaTime);
	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator newRotation;
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;
	
		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);  

		UpdateRotation(DeltaTime, 0.0);

		if (bAllowMove)
		{
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, Acceleration, rot(0,0,0));
			else
				ProcessMove(DeltaTime, Acceleration, rot(0,0,0));
		}
	}

	function EndState()
	{
		SetMesh();
		PlayerReplicationInfo.bIsSpectator = false;
		PlayerReplicationInfo.bWaitingPlayer = false;
		SetCollision(true,true,true);
	}

	function BeginState()
	{
		Mesh = None;
		if ( PlayerReplicationInfo != None )
		{
			PlayerReplicationInfo.bIsSpectator = true;
			PlayerReplicationInfo.bWaitingPlayer = true;
		}
		SetCollision(false,false,false);
		EyeHeight = Default.BaseEyeHeight;
		SetPhysics(PHYS_None);
	}
}

state PlayerSpectating
{
ignores SeePlayer, HearNoise, Bump, TakeDamage, Died, ZoneChange, FootZoneChange;

	function SendVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID, name broadcasttype)
	{
	}

	function ChangeTeam( int N )
	{
		Level.Game.ChangeTeam(self, N);
	}

	exec function Fire( optional float F )
	{
		if ( Role == ROLE_Authority )
		{
			ViewPlayerNum(-1);
			bBehindView = true;
		}
	} 

	function ProcessMove(float DeltaTime, vector NewAccel, rotator DeltaRot)	
	{
		Acceleration = NewAccel;
		MoveSmooth(Acceleration * DeltaTime);
	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator newRotation;
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;
	
		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);  

		UpdateRotation(DeltaTime, 0.5);

		if (bAllowMove)
		{
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, Acceleration, rot(0,0,0));
			else
				ProcessMove(DeltaTime, Acceleration, rot(0,0,0));
		}
	}

	function EndState()
	{
		PlayerReplicationInfo.bIsSpectator = false;
		PlayerReplicationInfo.bWaitingPlayer = false;
		SetMesh();
		SetCollision(true,true,true);
	}

	function BeginState()
	{
		PlayerReplicationInfo.bIsSpectator = true;
		PlayerReplicationInfo.bWaitingPlayer = true;
		Mesh = None;
		SetCollision(false,false,false);
		EyeHeight = Default.BaseEyeHeight;
		SetPhysics(PHYS_None);
	}
}
//===============================================================================
state PlayerWaking
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling;

	function Timer()
	{
		BaseEyeHeight = Default.BaseEyeHeight;
	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove(Float DeltaTime)
	{
		ViewFlash(deltaTime * 0.5);
		if ( TimerRate == 0 )
		{
			ViewRotation.Pitch -= DeltaTime * 12000;
			if ( ViewRotation.Pitch < 0 )
			{
				ViewRotation.Pitch = 0;
				GotoState('PlayerWalking');
			}
		}

		if (bAllowMove)
		{
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, vect(0,0,0), rot(0,0,0));
			else
				ProcessMove(DeltaTime, vect(0,0,0), rot(0,0,0));
		}
	}

	function BeginState()
	{
		if ( bWokeUp )
		{
			ViewRotation.Pitch = 0;
			SetTimer(0, false);
			return;
		}
		BaseEyeHeight = 0;
		EyeHeight = 0;
		SetTimer(3.0, false);
		bWokeUp = true;
	}
}

state Dying
{
ignores Landed, SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling, PainTimer, ActivateItem;

	function ServerReStartPlayer()
	{
		//log("calling restartplayer in dying with netmode "$Level.NetMode);
		if ( Level.NetMode == NM_Client || !Level.Game.PlayerCanRestart(Self) )
			return;
		if( Level.Game.RestartPlayer(self) )
		{
			ServerTimeStamp = 0;
			TimeMargin = 0;
			Enemy = None;
			Level.Game.StartPlayer(self);
			if ( Mesh != None )
				PlayLocomotion( vect(0,0,0) );	//PlayWaiting();
			ClientReStart();
		}
		//else
		//	log("Restartplayer failed");
	}

	function HidePlayer()
	{
		SetCollision(false, false, false);
		TweenToFighter(0.01);
		bHidden = true;
	}

	exec function SelectWeapon( optional float F );
	exec function SelectAttSpell( optional float F );
	exec function SelectDefSpell( optional float F );

	exec function Fire( optional float F )
	{
		if (bCanRestart)
		{
			if ( (Level.NetMode == NM_Standalone) && !Level.Game.bDeathMatch )
			{
				//E3 hack.. should go back to shell, to load menu? 
				ServerRestartPlayer();
					return;

				if ( bFrozen )
					return;
				ShowLoadMenu();
			}
			else if ( !bFrozen || (FRand() < 0.2) )
				ServerReStartPlayer();
		}
	}

	
	function PlayChatting();
	exec function Taunt( name Sequence );

	function ServerMove
	(
		float TimeStamp, 
		vector Accel, 
		vector ClientLoc,
		bool NewbRun,
		bool NewbDuck,
		bool NewbJumpStatus, 
		bool bFired,
		bool bForceFire,
        bool bFiredAttSpell,
		bool bForceFireAttSpell, 
        bool bFiredDefSpell,
		bool bForceFireDefSpell,
		byte ClientRoll, 
		int View,
		optional byte OldTimeDelta,
		optional int OldAccel
	)
	{
		Global.ServerMove(
					TimeStamp,
					Accel, 
					ClientLoc,
					false,
					false,
					NewbJumpStatus, // fixes jumping after dying
					false,
					false,
					false, //bFiredAttSpell,	// false?
					false, //bFiredDefSpell,	// false?
					false, 
					false, 
					ClientRoll, 
					View);
	}

	function PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
	{
		local vector View,HitLocation,HitNormal, FirstHit, spot;
		local float DesiredDist, ViewDist, WallOutDist;
		local actor HitActor;
		local Pawn PTarget;
		local int HitJoint;

		if ( ViewTarget != None )
		{
			ViewActor = ViewTarget;
			CameraLocation = ViewTarget.Location;
			CameraRotation = ViewTarget.Rotation;
			PTarget = Pawn(ViewTarget);
			if ( PTarget != None )
			{
				if ( Level.NetMode == NM_Client )
				{
					if ( PTarget.bIsPlayer )
						PTarget.ViewRotation = TargetViewRotation;
					PTarget.EyeHeight = TargetEyeHeight;
					if ( PTarget.Weapon != None )
						PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
				}
				if ( PTarget.bIsPlayer )
					CameraRotation = PTarget.ViewRotation;
				CameraLocation.Z += PTarget.EyeHeight;
			}

			if ( Carcass(ViewTarget) != None )
			{
				if ( bBehindView || (ViewTarget.Physics == PHYS_None) )
					CameraRotation = ViewRotation;
				else 
					ViewRotation = CameraRotation;
				if ( bBehindView )
					CalcBehindView(CameraLocation, CameraRotation, CollisionHeight * 3.1);
			}
			else if ( bBehindView )
				CalcBehindView(CameraLocation, CameraRotation, FMax( ViewTarget.CollisionHeight * 3.0, 200.0 ));

			return;
		}

		// View rotation.
		CameraRotation = ViewRotation;
		DesiredFOV = DefaultFOV;		
		ViewActor = self;
		if( bBehindView ) //up and behind (for death scene)
			CalcBehindView(CameraLocation, CameraRotation, CollisionHeight * 3.0);
		else
		{
			// First-person view.
			CameraLocation = Location;
			CameraLocation.Z += Default.BaseEyeHeight;
		}
	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		if ( !bFrozen )
		{
			if ( bPressedJump )
			{
				Fire(0);
				bPressedJump = false;
			}
			GetAxes(ViewRotation,X,Y,Z);
			// Update view rotation.
			aLookup  *= 0.24;
			aTurn    *= 0.24;
			ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
			ViewRotation.Pitch = ViewRotation.Pitch & 65535;
			If ((ViewRotation.Pitch > 99*DEGREES) && (ViewRotation.Pitch < 270*DEGREES))
			{
				If (aLookUp > 0) 
					ViewRotation.Pitch = 99*DEGREES;
				else
					ViewRotation.Pitch = 270*DEGREES;
			}
			if (bAllowMove)
			{
				if ( Role < ROLE_Authority ) // then save this move and replicate it
					ReplicateMove(DeltaTime, vect(0,0,0), rot(0,0,0));
			}
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
	}

	function FindGoodView()
	{
		local vector cameraLoc;
		local rotator cameraRot;
		local int tries, besttry;
		local float bestdist, newdist;
		local int startYaw;
		local actor ViewActor;
		
		//fixme - try to pick view with killer visible
		//fixme - also try varying starting pitch
		////log("Find good death scene view");
		ViewRotation.Pitch = 308*DEGREES;
		tries = 0;
		besttry = 0;
		bestdist = 0.0;
		startYaw = ViewRotation.Yaw;
		
		for (tries=0; tries<16; tries++)
		{
			cameraLoc = Location;
			PlayerCalcView(ViewActor, cameraLoc, cameraRot);
			newdist = VSize(cameraLoc - Location);
			if (newdist > bestdist)
			{
				bestdist = newdist;	
				besttry = tries;
			}
			ViewRotation.Yaw += 4096;
		}
			
		ViewRotation.Yaw = startYaw + besttry * 4096;
	}
	
	function TakeDamage( Pawn instigatedBy, Vector hitlocation,  Vector momentum, DamageInfo DInfo)
	{
		if ( !bHidden )
			Super.TakeDamage(instigatedBy, hitlocation, momentum, DInfo);
	}
	
	function Timer()
	{
		bFrozen = false;
		bShowScores = true;
		bPressedJump = false;
	}
	
	function BeginState()
	{
		BaseEyeheight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
		if ( Carcass(ViewTarget) == None )
			bBehindView = true;
		bFrozen = true;
		bPressedJump = false;
		bJustFired = false;
		FindGoodView();
		if ( (Role == ROLE_Authority) && !bHidden )
			Super.Timer(); 
		SetTimer(1.0, false);

		CleanOutSavedMoves();

		PlayActuator (self, EActEffects.ACTFX_FadeOut, 5.0f);
	}
	
	function EndState()
	{
		CleanOutSavedMoves();
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		bBehindView = false;
		bShowScores = false;
		bJustFired = false;
		bPressedJump = false;
		if ( Carcass(ViewTarget) != None )
			ViewTarget = None;
		//Log(self$" exiting dying with remote role "$RemoteRole$" and role "$Role);

		PlayActuator (self, EActEffects.ACTFX_FadeOut, 0.0f);
	}

	Begin:
		Sleep(2.0);
		bCanRestart = true;
}

state GameEnded
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, TakeDamage, PainTimer, Died;

	exec function Taunt( name Sequence )
	{
		if ( Health > 0 )
			Global.Taunt(Sequence);
	}

	exec function ViewClass( class<actor> aClass, optional bool bQuiet )
	{
	}
	exec function ViewPlayer( string S )
	{
	}
	
	function ServerReStartGame()
	{
		if (Level.Game.PlayerCanRestartGame(Self))
			Level.Game.RestartGame();
	}

	exec function Fire( optional float F )
	{
		if ( Role < ROLE_Authority)
			return;
		if ( !bFrozen )
			ServerReStartGame();
		else if ( TimerRate <= 0 )
			SetTimer(1.5, false);
	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;
		
		GetAxes(ViewRotation,X,Y,Z);
		// Update view rotation.

		if ( !bFixedCamera )
		{
			aLookup  *= 0.24;
			aTurn    *= 0.24;
			ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
			ViewRotation.Pitch = ViewRotation.Pitch & 65535;
			If ((ViewRotation.Pitch > 99*DEGREES) && (ViewRotation.Pitch < 270*DEGREES))
			{
				If (aLookUp > 0) 
					ViewRotation.Pitch = 99*DEGREES;
				else
					ViewRotation.Pitch = 270*DEGREES;
			}
		}
		else if ( ViewTarget != None )
			ViewRotation = ViewTarget.Rotation;

		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);

		if (bAllowMove)
		{
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, vect(0,0,0), rot(0,0,0));
			else
				ProcessMove(DeltaTime, vect(0,0,0), rot(0,0,0));
		}
		bPressedJump = false;
	}

	function ServerMove
	(
		float TimeStamp, 
		vector Accel, 
		vector ClientLoc,
		bool NewbRun,
		bool NewbDuck,
		bool NewbJumpStatus, 
		bool bFired,
		bool bForceFire,
        bool bFiredAttSpell,
		bool bForceFireAttSpell, 
        bool bFiredDefSpell,
		bool bForceFireDefSpell,
		byte ClientRoll, 
		int View,
		optional byte OldTimeDelta,
		optional int OldAccel
	)
	{
		Global.ServerMove(TimeStamp, Accel, ClientLoc, NewbRun, NewbDuck, NewbJumpStatus,
							bFired, bForceFire, bFiredAttSpell, bForceFireAttSpell, bFiredDefSpell, bForceFireDefSpell,
							ClientRoll, (32767 & (ViewRotation.Pitch/2)) * 32768 + (32767 & (ViewRotation.Yaw/2)) );

	}

	function FindGoodView()
	{
		local vector cameraLoc;
		local rotator cameraRot;
		local int tries, besttry;
		local float bestdist, newdist;
		local int startYaw;
		local actor ViewActor;
		
		ViewRotation.Pitch = 308*DEGREES;
		tries = 0;
		besttry = 0;
		bestdist = 0.0;
		startYaw = ViewRotation.Yaw;
		
		for (tries=0; tries<16; tries++)
		{
			if ( ViewTarget != None )
				cameraLoc = ViewTarget.Location;
			else
				cameraLoc = Location;
			PlayerCalcView(ViewActor, cameraLoc, cameraRot);
			newdist = VSize(cameraLoc - Location);
			if (newdist > bestdist)
			{
				bestdist = newdist;	
				besttry = tries;
			}
			ViewRotation.Yaw += 4096;
		}
			
		ViewRotation.Yaw = startYaw + besttry * 4096;
	}
	
	function Timer()
	{
		bFrozen = false;
	}
	
	function BeginState()
	{
		local Pawn P;

		EndZoom();
		bFire = 0;
		SetCollision(false,false,false);
		bShowScores = true;
		bFrozen = true;
		if ( !bFixedCamera )
		{
			FindGoodView();
			bBehindView = true;
		}
		SetTimer(1.5, false);
		SetPhysics(PHYS_None);
		ForEach AllActors(class'Pawn', P)
		{
			P.Velocity = vect(0,0,0);
			P.SetPhysics(PHYS_None);
		}
	}
}

state SpecialKill
{
	ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling, PainTimer, FireAttSpell, FireDefSpell, ActivateItem, WeaponAction;

	function ServerReStartPlayer()
	{
		//log("calling restartplayer in dying with netmode "$Level.NetMode);
		if ( Level.NetMode == NM_Client || !Level.Game.PlayerCanRestart(Self) )
			return;
		if( Level.Game.RestartPlayer(self) )
		{
			ServerTimeStamp = 0;
			TimeMargin = 0;
			Enemy = None;
			Level.Game.StartPlayer(self);
			if ( Mesh != None )
				PlayLocomotion( vect(0,0,0) );	//PlayWaiting();
			ClientReStart();
		}
		//else
		//	log("Restartplayer failed");
	}

	function HidePlayer()
	{
		SetCollision(false, false, false);
		//TweenToFighter(0.01);
		//bHidden = true;
	}

	exec function SelectWeapon( optional float F );
	exec function SelectAttSpell( optional float F );
	exec function SelectDefSpell( optional float F );

	exec function Fire( optional float F )
	{
		if( bCanExitSpecialState )
			EndSpecialKill();
	}

	function EndSpecialKill()
	{
		if ( (Level.NetMode == NM_Standalone) && !Level.Game.bDeathMatch )
		{
			//E3 hack.. should go back to shell, to load menu? 
			ServerRestartPlayer();
				return;

			if ( bFrozen )
				return;
			ShowLoadMenu();
		}
		else if ( !bFrozen || (FRand() < 0.2) )
			ServerReStartPlayer();
	}
	
	function PressedEnter()
	{
		if( bCanExitSpecialState )
			EndSpecialKill();
	}
	
	function PressedSpaceBar()
	{
		if( bCanExitSpecialState )
			EndSpecialKill();
	}

	function PressedEscape()
	{
		if( bCanExitSpecialState )
			EndSpecialKill();
	}

	function PlayChatting();
	exec function Taunt( name Sequence );

	function ServerMove
	(
		float TimeStamp, 
		vector Accel, 
		vector ClientLoc,
		bool NewbRun,
		bool NewbDuck,
		bool NewbJumpStatus, 
		bool bFired,
		bool bForceFire,
        bool bFiredAttSpell,
		bool bForceFireAttSpell, 
        bool bFiredDefSpell,
		bool bForceFireDefSpell,
		byte ClientRoll, 
		int View,
		optional byte OldTimeDelta,
		optional int OldAccel
	)
	{
		Global.ServerMove(
					TimeStamp,
					Accel, 
					ClientLoc,
					false,
					false,
					NewbJumpStatus,
					false,
					false,
					false, //bFiredAttSpell,	// false?
					false, //bFiredDefSpell,	// false?
					false, 
					false, 
					ClientRoll, 
					View);
	}

	function PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
	{
		local vector View,HitLocation,HitNormal, FirstHit, spot;
		local float DesiredDist, ViewDist, WallOutDist;
		local actor HitActor;
		local Pawn PTarget;
		local int HitJoint;

		if ( ViewTarget != None )
		{
			ViewActor = ViewTarget;
			CameraLocation = ViewTarget.Location;
			CameraRotation = ViewTarget.Rotation;
			PTarget = Pawn(ViewTarget);
			if ( PTarget != None )
			{
				if ( Level.NetMode == NM_Client )
				{
					if ( PTarget.bIsPlayer )
						PTarget.ViewRotation = TargetViewRotation;
					PTarget.EyeHeight = TargetEyeHeight;
					if ( PTarget.Weapon != None )
						PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
				}
				if ( PTarget.bIsPlayer )
					CameraRotation = PTarget.ViewRotation;
				CameraLocation.Z += PTarget.EyeHeight;
			}

			if ( Carcass(ViewTarget) != None )
			{
				if ( bBehindView || (ViewTarget.Physics == PHYS_None) )
					CameraRotation = ViewRotation;
				else 
					ViewRotation = CameraRotation;
				if ( bBehindView )
					CalcBehindView(CameraLocation, CameraRotation, CollisionHeight * 3.1);
			}
			else if ( bBehindView )
				CalcBehindView(CameraLocation, CameraRotation, FMax( ViewTarget.default.CollisionHeight * 3.0, 200.0 ));
			return;
		}

		// View rotation.
		CameraRotation = ViewRotation;
		DesiredFOV = DefaultFOV;		
		ViewActor = self;
		if( bBehindView ) //up and behind (for death scene)
			CalcBehindView(CameraLocation, CameraRotation, CollisionHeight * 3.0);
		else
		{
			// First-person view.
			CameraLocation = Location;
			CameraLocation.Z += Default.BaseEyeHeight;
		}
	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
//		Velocity = vect(0,0,0);
		Velocity.X = 0;
		Velocity.Y = 0;
		Acceleration = vect(0,0,0);
		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		if ( !bFrozen )
		{
			if ( bPressedJump )
			{
				Fire(0);
				bPressedJump = false;
			}
			GetAxes(ViewRotation,X,Y,Z);
			// Update view rotation.
			aLookup  *= 0.24;
			aTurn    *= 0.24;
			ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
			ViewRotation.Pitch = ViewRotation.Pitch & 65535;
			If ((ViewRotation.Pitch > 99*DEGREES) && (ViewRotation.Pitch < 270*DEGREES))
			{
				If (aLookUp > 0) 
					ViewRotation.Pitch = 99*DEGREES;
				else
					ViewRotation.Pitch = 270*DEGREES;
			}
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, vect(0,0,0), rot(0,0,0));
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
		VelocityBias = vect(0,0,0);
	}

	function FindGoodView()
	{
		local vector cameraLoc;
		local rotator cameraRot;
		local int tries, besttry;
		local float bestdist, newdist;
		local int startYaw;
		local actor ViewActor;
		
		//fixme - try to pick view with killer visible
		//fixme - also try varying starting pitch
		////log("Find good death scene view");
		ViewRotation.Pitch = 308*DEGREES;
		tries = 0;
		besttry = 0;
		bestdist = 0.0;
		// startYaw = ViewRotation.Yaw;
		startYaw = Rotation.Yaw;

		for (tries=0; tries<16; tries++)
		{
			cameraLoc = Location;
			PlayerCalcView(ViewActor, cameraLoc, cameraRot);
			newdist = VSize(cameraLoc - Location);
			if (newdist > bestdist)
			{
				bestdist = newdist;	
				besttry = tries;
			}
			ViewRotation.Yaw += 4096;
		}

		ViewRotation.Yaw = startYaw + besttry * 4096;
	}

	singular event BaseChange()
	{
	}


	function FindView(Pawn P, Pawn E)
	{
		local vector ViewDir, PE, C;
		local vector X, Y, Z;
		
		GetAxes(P.Rotation, X, Y, Z);

		if ( E.ViewSKFrom() == self )
		{
			ViewTarget = self;
			ViewRotation = rotator(X);
			return;
		}
		ViewTarget = E;
		/*
		C = (P.Location + E.Location) * 0.5;
		PE = Normal(P.Location-E.Location);

		ViewDir = PE cross vect(0,0,1);
*/
		// ViewRotation = Rotator(ViewDir);
		ViewRotation = Rotator(-X);
	}

	function TakeDamage( Pawn instigatedBy, Vector hitlocation,  Vector momentum, DamageInfo DInfo);

	function Timer()
	{
		bFrozen = false;
		bShowScores = true;
		bPressedJump = false;
	}
	
	function BeginState()
	{
		DisableSaveGame();

		// set the player's fov back (they may be zoomed in)
		DesiredFOV = DefaultFOV;
		FOVAngle = DefaultFOV;
		bFire = 0;
		bFireAttSpell = 0;
		bCanExitSpecialState = false;
		bHidden = false;
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);

		LetterBox(true);
		BaseEyeheight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
		if ( Carcass(ViewTarget) == None )
			bBehindView = true;
		bFrozen = true;
		bPressedJump = false;
		bJustFired = false;

		if ( Killer != none )
			FindView(self, Killer);
		else
			FindGoodView();

		if ( (Role == ROLE_Authority) && !bHidden )
			Super.Timer(); 
		SetTimer(1.0, false);

		CleanOutSavedMoves();
	}
	
	function EndState()
	{
		CleanOutSavedMoves();
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		bBehindView = false;
		bShowScores = false;
		bJustFired = false;
		bPressedJump = false;
		if ( Carcass(ViewTarget) != None )
			ViewTarget = None;
		//Log(self$" exiting dying with remote role "$RemoteRole$" and role "$Role);
//		EnableSaveGame();
	}

	function Trigger( Actor Other, Pawn EventInstigator )
	{
		// Play my animation	
	}

	SpecialKillComplete:
		bCanExitSpecialState = true;
		Sleep(3);
		ClientAdjustGlow(-1.0,vect(0,0,0));
		SetPhysics(PHYS_None);
		Sleep(2);
		ServerRestartPlayer();

	Begin:
		Velocity = vect(0,0,0);
		LoopAnim('Near_Death');
		Sleep( 2.0 );
		bCanExitSpecialState = true;
		Sleep( 28.0 );
		goto 'SpecialKillComplete';

} // Special Kill State

// ngStats Accessors
function string GetNGSecret()
{
	return ngWorldSecret;
}

function SetNGSecret(string newSecret)
{
	ngWorldSecret = newSecret;
}

function LockPos()
{
	if (SpeedMod != none)
		SpeedModifier(SpeedMod).LockPosition();
}

function ReleasePos()
{
	if (SpeedMod != none)
		SpeedModifier(SpeedMod).ReleasePosition();
}

exec function RenderSelf()
{
	bRenderSelf = !bRenderSelf;
}

exec function ShowBook();

//=============================================================================
// Multiskin support
static function SetMultiSkin( playerpawn SkinActor, string SkinName, string FaceName, byte TeamNum )
{
	local Texture NewSkin;

	if(SkinName != "")
	{
		NewSkin = texture(DynamicLoadObject(SkinName, class'Texture'));
		if ( NewSkin != None )
			SkinActor.Skin = NewSkin;
	}
}

static function GetMultiSkin( playerpawn SkinActor, out string SkinName, out string FaceName )
{
	SkinName = String(SkinActor.Skin);
	FaceName = "";
}

static function bool SetSkinElement(playerpawn SkinActor, int SkinNo, string SkinName, string DefaultSkinName)
{
	local Texture NewSkin;

	NewSkin = Texture(DynamicLoadObject(SkinName, class'Texture'));
	if ( NewSkin != None )
	{
		SkinActor.Multiskins[SkinNo] = NewSkin;
		return True;
	}
	else
	{
		log("Failed to load "$SkinName);
		if(DefaultSkinName != "")
		{
			NewSkin = Texture(DynamicLoadObject(DefaultSkinName, class'Texture'));
			SkinActor.Multiskins[SkinNo] = NewSkin;
		}
		return False;
	}
}

static function SetMultiMesh( playerpawn SkinActor, string MeshName )
{
	local SkelMesh NewMesh;

	if(MeshName != "")
	{
		NewMesh = SkelMesh(DynamicLoadObject(MeshName, class'SkelMesh'));
		if ( NewMesh != None )
			SkinActor.Mesh = NewMesh;
	}
}

function MakePlayerNoise(float Loudness, optional float Radius)
{
	if (Radius > 0)
		MakeNoise(Loudness * VolumeMultiplier, Radius);
	else
		MakeNoise(Loudness * VolumeMultiplier);
}

//----------------------------------------------------------------------------

function Freeze()
{
	bAllowMove = false;
	// ClientMessage("AllowMove = "$bAllowMove);
}

function Unfreeze()
{
	bAllowMove = true;
	// ClientMessage("AllowMove = "$bAllowMove);
}

function bool CheckGameEvent(name EventName, optional bool bSet)
{
	return false;
}

// called after PostBeginPlay on net client
/*
simulated event PostNetBeginPlay()
{
	//TriggerLevelBegin();
	Super.PostNetBeginPlay();
}
*/

function vector GetTotalPhysicalEffect( float DeltaTime );

defaultproperties
{
     InvokeColor=(R=100,G=100,B=255,A=255)
     CrossHairColor=(R=201,G=47,A=255)
     LitCrossHairColor=(G=255,A=255)
     CrossHairAlpha=0.5
     CrossHairInvokeColor=(R=100,G=100,B=255,A=255)
     bRenderSelf=True
     CrouchCollisionHeight=32
     CrouchEyeHeight=30
     CrouchRate=0.25
     CrouchSpeedScale=0.25
     WalkingSpeedScale=0.5
     FlashScale=(X=1,Y=1,Z=1)
     DesiredFOV=90
     DefaultFOV=90
     ZoomFOV=30
     CdTrack=255
     ScryeFullTime=10
     ScryeRampTime=0.5
     MyAutoAim=1
     Handedness=-1
     bAlwaysMouseLook=True
     bKeyboardLook=True
     bMouseDecel=True
     bEnableSubtitles=True
     bMessageBeep=True
     bCheatsEnabled=True
     bUpdateInventorySelect=True
     MouseSensitivity=1
     GoreLevel=1
     WeaponPriority(1)=Phoenix
     WeaponPriority(2)=Molotov
     WeaponPriority(3)=GhelziabahrStone
     WeaponPriority(4)=Scythe
     WeaponPriority(5)=TibetianWarCannon
     WeaponPriority(6)=Speargun
     WeaponPriority(7)=Shotgun
     WeaponPriority(8)=Revolver
     MouseSmoothThreshold=0.16
     MaxActuators=5
     MaxCombo=20
     bVibrateOn=True
     MaxTimeMargin=3
     QuickSaveString="Quick Saving"
     NoPauseMessage="Game is not pauseable"
     ViewingFrom="Now viewing from "
     OwnCamera="own camera"
     FailedView="Failed to change view."
     bIsPlayer=True
     bCanJump=True
     bViewTarget=True
     DesiredSpeed=1
     SightRadius=4100
     PI_StabSound=(Radius=512,MaxPitch=1,MinPitch=1)
     PI_BiteSound=(Radius=512,MaxPitch=1,MinPitch=1)
     PI_BluntSound=(Radius=512,MaxPitch=1,MinPitch=1)
     PI_BulletSound=(Radius=512,MaxPitch=1,MinPitch=1)
     PI_RipSliceSound=(Radius=512,MaxPitch=1,MinPitch=1)
     PI_GenLargeSound=(Radius=512,MaxPitch=1,MinPitch=1)
     PI_GenMediumSound=(Radius=512,MaxPitch=1,MinPitch=1)
     PI_GenSmallSound=(Radius=512,MaxPitch=1,MinPitch=1)
     bStasis=False
     bTravel=True
     NetPriority=3
     MaxResponseTime=0.125
     bDisableMovementBuffering=False
}
