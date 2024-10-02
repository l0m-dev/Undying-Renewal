//=============================================================================
// BinkTexture. (NJS)
//=============================================================================
class BinkTexture expands TextureCanvas
	noexport
	native;

var () string filename;			// Flic's filename (should be in ..\textures)
var () float  time;				// Current time into this frame.
var () float  frameDelay;		// Seconds to delay between frames. 0 = Use Flic settings
var () int	  currentFrame;		// Current frame index the flic is on
var () bool   bRestartOnLoad;
var () bool	  bSpool;			// Spool from disk when true
var () bool	  bLoop;				// Loop flic when true
var () bool	  bPause;			// Pause flic when true
//var () bool   bInterlaced;
//var () bool   bDoubled;
var () bool   bCentered;
var () actor  eventSource;		// Actor the event will come from.
var () name	  newFrameEvent;	// Triggered whenever a new frame is decoded.

// Transients:
var transient string oldFilename;
var transient int   previousFrame;
var transient float frameDuration;
var transient int   handle;

var transient int   flags;
var transient int   TexGrid;

native final function int GetFrameCount();

// Loads a Bink file and optionally allows Bink files with resolutions higher than 256x256, by creating a grid of textures.
// If bLoadAsGrid is true, it creates a grid of textures, each sized 256x256.
// Use DrawGrid if bLoadAsGrid is set; otherwise, use standard texture drawing methods.
native static final function BinkTexture LoadBinkFromFile(string Filename, bool bLoadAsGrid);
native final function DrawGrid(Canvas Canvas, float X, float Y, float XL, float YL); 

defaultproperties
{
	bRestartOnLoad=True
	bCentered=True
	bLoop=True
	bSpool=True
}