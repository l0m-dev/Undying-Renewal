//=============================================================================
// ShellWindow.
//=============================================================================
class ShellWindow expands ManagerWindow;

//#exec OBJ LOAD FILE=\aeons\textures\FX.utx PACKAGE=FX

var() texture Back[6];

var sound NewScreenSound;

var() Color BackColor;	
var() localized string  BackNames[6];	

var Texture SmokeTexture;

// Confirm window stuff
//var int Answer;
//var UWindowWindow QuestionWindow;

function Created()
{
	Super.Created();

	bLeaveOnScreen = false;
	bAlwaysOnTop = True;
}

function Paint(Canvas C, float X, float Y)
{
	local int XOffset, YOffset, W, H;
	local float TileWidth, TileHeight;
	local int i;

	for ( i=0; i<6; i++ )
	{
		if (Back[i] == None ) 
			Back[i]=texture(DynamicLoadObject(BackNames[i], class'texture'));

		// probably unnecessary, but if any texture is missing, just return ( this frame )
		if (Back[i] == None )
			return;
	}
	
	TileWidth = InnerWidth / 3;
	TileHeight = InnerHeight / 2;

	C.DrawColor = BackColor;
	
	C.bNoSmooth = false;

	DrawStretchedTextureSegment( C, WinLeft, WinTop, WinWidth, WinHeight, 1, 1, 254, 254, texture'Engine.BlackTexture' );

	DrawStretchedTextureSegment( C, InnerLeft, InnerTop, TileWidth, TileHeight, 1, 1, 254, 254, Back[0] );
	DrawStretchedTextureSegment( C, InnerLeft + TileWidth, InnerTop, TileWidth, TileHeight, 1, 1, 254, 254, Back[1] );
	DrawStretchedTextureSegment( C, InnerLeft + TileWidth*2, InnerTop,	TileWidth, TileHeight, 1, 1, 254, 254, Back[2] );

	DrawStretchedTextureSegment( C, InnerLeft, InnerTop + TileHeight, TileWidth, TileHeight, 1, 1, 254, 254, Back[3] );
	DrawStretchedTextureSegment( C, InnerLeft + TileWidth, InnerTop + TileHeight, TileWidth, TileHeight, 1, 1, 254, 254, Back[4] );
	DrawStretchedTextureSegment( C, InnerLeft + TileWidth*2, InnerTop + TileHeight, TileWidth, TileHeight, 1, 1, 254, 254, Back[5] );

	C.DrawColor = C.Default.DrawColor;
}

function PaintSmoke(Canvas C, ShellButton B, out int SmokingWindow, out float SmokingTimer)
{
	local int Brightness;

	if ( SmokingWindow >= 0 )
	{
		SmokingTimer -= 1.0;

		if ( SmokingTimer <= 0.0 ) 
		{
			SmokingWindow = -1;
		}

		if ( SmokingTimer < 45 ) 
		{
			Brightness = 255 * (SmokingTimer / 45.0);
		}
		else
		{
			Brightness = 255;
		}
		
		C.DrawColor.r = Brightness;
		C.DrawColor.g = Brightness;
		C.DrawColor.b = Brightness;

		C.Style = 3;
		C.SetPos(B.WinLeft+8*AeonsRootWindow(Root).ScaleX, B.WinTop - 50*AeonsRootWindow(Root).ScaleY);
		//Smoke = Texture(DynamicLoadObject("FX.Smoke", Class'Texture'));
		if ( SmokeTexture != None )
			C.DrawTile( SmokeTexture, B.WinWidth-24*AeonsRootWindow(Root).ScaleX, 70*AeonsRootWindow(Root).ScaleY, 0, 0, 64, 32 );
		else
			Log("SmokeTexture = None!  We have a problem...");
	}
}

function Close(optional bool bByParent)
{
	Root.Console.CloseUWindow();
}


function HideWindow()
{
	
	local int i;

	Root.Console.bBlackOut = False;
	
	Super.HideWindow();

	for ( i=0; i<6; i++ )
	{
		if ( Back[i] != None )
			GetPlayerOwner().UnloadTexture( Back[i] );
	}
	
	//fix be smarter about this, use some sort of cache scheme
	Log("Unloaded Textures for " $ self );

}


function Resized()
{
	if (Root.WinWidth == 0) return;
	WinWidth = Root.WinWidth;
	WinHeight = Root.WinHeight;
	WinTop = 0;
	WinLeft = 0;
	if (Root.WinHeight / Root.WinWidth < 0.75 ) {
		InnerWidth = Root.WinHeight / 0.75;
		InnerLeft = (Root.WinWidth - InnerWidth) / 2;
		InnerHeight = Root.WinHeight;
		InnerTop = 0;
	} else {
		InnerWidth = Root.WinWidth;
		InnerLeft = 0;
		InnerHeight = Root.WinWidth * 0.75;
		InnerTop = (Root.WinHeight - InnerHeight) / 2;
	}
}

//----------------------------------------------------------------------------

// used for Multiplayer - Player Model viewing
function AnimEnd(MeshActor MyMesh)
{
/* should be subclassed in PlayerSetup window
	if ( MyMesh.AnimSequence == 'Breath3' )
		MyMesh.TweenAnim('All', 0.4);
	else
		MyMesh.PlayAnim('Breath3', 0.4);
*/
}

//----------------------------------------------------------------------------

function PlayNewScreenSound()
{
	if ( NewScreenSound != None )
		GetPlayerOwner().PlaySound( NewScreenSound, [Flags]482  );
}

//----------------------------------------------------------------------------

function QuestionAnswered( UWindowWindow W, int Answer )
{
	log("ShellWindow: QuestionAnswered: Child didn't catch message...  W=" $ W $ " Answer=" $ Answer);
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     NewScreenSound=Sound'Shell_HUD.Shell.SHELL_Select01a'
     BackColor=(R=192,G=192,B=192)
     SmokeTexture=FireTexture'FX.Smoke'
}
