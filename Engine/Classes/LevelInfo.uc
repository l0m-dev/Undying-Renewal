//=============================================================================
// LevelInfo contains information about the current level. There should 
// be one per level and it should be actor 0. UnrealEd creates each level's 
// LevelInfo automatically so you should never have to place one
// manually.
//
// The ZoneInfo properties in the LevelInfo are used to define
// the properties of all zones which don't themselves have ZoneInfo.
//=============================================================================
class LevelInfo extends ZoneInfo
	config(user)
	native
	nativereplication;

// Textures.
#exec Texture Import File=Textures\DefaultTexture.pcx

//-----------------------------------------------------------------------------
// Level time.

// Time passage.
var() float TimeDilation;          // Normally 1 - scales real time passage.
var() bool  bRealTickTime;		   // Do not clamp tick times.

// Current time.
var           float	TimeSeconds;   // Time in seconds since level began play.
var transient int   Year;          // Year.
var transient int   Month;         // Month.
var transient int   Day;           // Day of month.
var transient int   DayOfWeek;     // Day of week.
var transient int   Hour;          // Hour.
var transient int   Minute;        // Minute.
var transient int   Second;        // Second.
var transient int   Millisecond;   // Millisecond.


//-----------------------------------------------------------------------------
// Text info about level.

var() localized string Title;
var()           string Author;		    // Who built it.
var() localized string IdealPlayerCount;// Ideal number of players for this level. I.E.: 6-8
var() int	RecommendedEnemies;			// number of enemy bots recommended (used by rated games)
var() int	RecommendedTeammates;		// number of friendly bots recommended (used by rated games)
var() localized string LevelEnterText;  // Message to tell players when they enter.
var()           string LocalizedPkg;    // Package to look in for localizations.
var() int			   LevelIndex;		// Index this level is in the set of all levels (for saved games)
var             string Pauser;          // If paused, name of person pausing the game.
var levelsummary Summary;
var DecalManager		DMan;			// Decal Manager Actor

//-----------------------------------------------------------------------------
// Flags affecting the level.

var() bool           bLonePlayer;     // No multiplayer coordination, i.e. for entranceways.
var bool             bBegunPlay;      // Whether gameplay has begun.
var bool             bPlayersOnly;    // Only update players.
var bool             bHighDetailMode; // Client high-detail mode.
var bool			 bDropDetail;	  // frame rate is below DesiredFrameRate, so drop high detail actors
var bool			 bAggressiveLOD;  // frame rate is well below DesiredFrameRate, so make LOD more aggressive
var bool             bStartup;        // Starting gameplay.
var() bool			 bHumansOnly;	  // Only allow "human" player pawns in this level
var bool			 bNoCheating;	  
var bool			 bAllowFOV;
var config bool		 bLowRes;		  // optimize for low resolution (e.g. TV)
var() bool			 bAllowFlight;
var globalconfig bool bDebugMessaging;
var transient bool	 bDontAllowSavegame;
var() bool bSepiaOverlay;
var() bool bIsCutsceneLevel;
var() bool bSoftWeatherTransitions;
//-----------------------------------------------------------------------------
// Audio properties.

var(Audio) const music  Song;          // Default song for level.
var(Audio) const byte   SongSection;   // Default song order for level.
var(Audio) const byte   CdTrack;       // Default CD track for level.
var(Audio) float        PlayerDoppler; // Player doppler shift, 0=none, 1=full.

//-----------------------------------------------------------------------------
// Miscellaneous information.

var() bool bPSX2Level;
var() float UnitsPerMeter;				// Real-world scale of level.
var() float Brightness;
var() texture Screenshot;
var texture DefaultTexture;
var int HubStackLevel;
var transient enum ELevelAction
{
	LEVACT_None,
	LEVACT_Loading,
	LEVACT_Saving,
	LEVACT_DoneSave,
	LEVACT_Connecting,
	LEVACT_Precaching
} LevelAction;

//-----------------------------------------------------------------------------
// Renderer Management.
var() bool bNeverPrecache;

//-----------------------------------------------------------------------------
// Networking.

var enum ENetMode
{
	NM_Standalone,        // Standalone game.
	NM_DedicatedServer,   // Dedicated server, no local client.
	NM_ListenServer,      // Listen server.
	NM_Client             // Client only, no local server.
} NetMode;
var string ComputerName;  // Machine's name according to the OS.
var string EngineVersion; // Engine version.
var string MinNetVersion; // Min engine version that is net compatible.

//-----------------------------------------------------------------------------
// Gameplay rules

var() class<gameinfo> DefaultGameType;
var GameInfo Game;

//-----------------------------------------------------------------------------
// Navigation point and Pawn lists (chained using nextNavigationPoint and nextPawn).

var const NavigationPoint NavigationPointList;
var const Pawn PawnList;

//-----------------------------------------------------------------------------
// Server related.

var string NextURL;
var bool bNextItems;
var float NextSwitchCountdown;

//-----------------------------------------------------------------------------
// Actor Performance Management

var int AIProfile[8]; // TEMP statistics
var float AvgAITime;	//moving average of Actor time

//-----------------------------------------------------------------------------
// Physics control
var() bool bCheckWalkSurfaces; // enable texture-specific physics code for Pawns.

//-----------------------------------------------------------------------------
// Spawn notification list
var SpawnNotify SpawnNotify;

// A dynamic list of classes per level to load on startup
var() array<class> PreloadClasses;

// PS2 -- indicates if boot shell should be loaded on startup
var() bool bLoadBootShellPSX2;

//-----------------------------------------------------------------------------
// Functions.


// Returns the index of the zone Loc is in.
native(2000) final function int GetZone(vector Loc);

// Get the total wind velocity from all winds.
native(2001) final function vector GetTotalWind(vector Loc);


//
// Return the URL of this level on the local machine.
//
native simulated function string GetLocalURL();

//
// Return the URL of this level, which may possibly
// exist on a remote machine.
//
native simulated function string GetAddressURL();

//-----------------------------------------------------------------------------
// Network replication.

replication
{
	reliable if( Role==ROLE_Authority )
		Pauser, TimeDilation, bNoCheating, bAllowFOV;
}

//
// Jump the server to a new level.
//
event ServerTravel( string URL, bool bItems )
{
	if( NextURL=="" )
	{
		bNextItems          = bItems;
		NextURL             = URL;
		if( Game!=None )
			Game.ProcessServerTravel( URL, bItems );
		else
			NextSwitchCountdown = 0;
	}
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	DMan = spawn(class 'DecalManager',,,Location);
}

function AddDecal()
{
	DMan.NumDecals ++;
}

function RemoveDecal()
{
	DMan.NumDecals --;
}

defaultproperties
{
     TimeDilation=1
     Title="Untitled"
     bHighDetailMode=True
     CdTrack=255
     UnitsPerMeter=70
     Brightness=1
     DefaultTexture=Texture'Engine.DefaultTexture'
     bCheckWalkSurfaces=True
     bStatic=False
     bHiddenEd=True
}
