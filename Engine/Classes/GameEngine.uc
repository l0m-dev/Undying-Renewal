//=============================================================================
// GameEngine
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
Class GameEngine extends Engine
	native
	noexport
	transient;

struct ReplayStruct
{
	var string			FileName;
	var native private const pointer FileAr;
	var string			URLStr;
	var byte			bRecording;
	var byte			bInReplay;
	var byte			bPaused;
	var int				PauseCount;			// Frames to run until pausing.
	var int				FrameNum;
	var float			NextTick;
};

var Level								GLevel;
var Level								GEntry;
var PendingLevel						GPendingLevel;
var URL									LastURL;
var(Settings) config array<string>		ServerActors; // Actors that should spawn along with starting up a server.
var(Settings) config array<string>		ServerPackages; // Packages that will be forced to be downloaded by clients and should remain network syncronized on the server.
var const viewport 						GViewport;
var ReplayStruct 						Replay;
