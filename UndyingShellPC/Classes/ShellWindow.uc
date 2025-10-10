//=============================================================================
// ShellWindow.
//=============================================================================
class ShellWindow expands ManagerWindow;

#exec OBJ LOAD FILE=..\textures\FX.utx PACKAGE=FX

var() texture Back[6];
var() BinkTexture AnimatedBack;

var sound NewScreenSound;

var() Color BackColor;	
var() localized string  BackNames[6];	

var Texture SmokeTexture;

// Confirm window stuff
//var int Answer;
//var UWindowWindow QuestionWindow;

function Created()
{
	local int i;
	local string TexName;

	Super.Created();

	bLeaveOnScreen = false;
	//bAlwaysOnTop = True;
	bAlwaysBehind = True;

	Cursor = Root.NormalCursor;
	
	if ( AnimatedBack == None )
	{
		AnimatedBack = class'BinkTexture'.static.LoadBinkFromFile(GetPlayerOwner().GetItemName(string(class))$".bik", true);
		if ( AnimatedBack != None )
			AnimatedBack.bLoop = true;
	}
}

function Paint(Canvas C, float X, float Y)
{
	local int XOffset, YOffset, W, H;
	local float TileWidth, TileHeight;
	local int NumTilesX, NumTilesY, i;
	local Texture Tex;
	local bool Is4x3, bAnimatedMenu;

	//if (Back[6] != None)
	//	Is4x3 = True;
	
	if (Is4x3)
	{
		// not supported right now
		NumTilesX = 4;
		NumTilesY = 3;
	}
	else
	{
		NumTilesX = 3;
		NumTilesY = 2;

		for ( i=0; i<6; i++ )
		{
			if (Back[i] == None ) 
				Back[i]=texture(DynamicLoadObject(BackNames[i], class'texture'));

			// probably unnecessary, but if any texture is missing, just return ( this frame )
			if (Back[i] == None )
				return;
		}
	}
	
	TileWidth = InnerWidth / NumTilesX;
	TileHeight = InnerHeight / NumTilesY;

	C.DrawColor = BackColor;
	
	// Direct3D and Glide have issues with seamless tiling when applying bilinear filtering, bNoSmooth = true completely disables that filtering
	// to get the bilinear filtering back, we need to reimport textures with bilinear filtering preapplied
	// originally, textures were drawn from 1, 1 to Tex.USize-2, Tex.VSize-2 to hide the borders caused by bilinear filtering
	C.bNoSmooth = true;

	//if (Root.ActiveWindow != Self)
	//	return;

	DrawStretchedTextureSegment( C, WinLeft, WinTop, WinWidth, WinHeight, 0, 0, 256, 256, texture'Engine.BlackTexture' );

	bAnimatedMenu = GetPlayerOwner().GetRenewalConfig().bAnimatedMenu && AnimatedBack != None;

	// brighten it?
	//C.DrawColor.R = 255;
	//C.DrawColor.G = 255;
	//C.DrawColor.B = 255;
	//C.DrawColor.A = 255;
	
	if (bAnimatedMenu)
	{
		//AnimatedBack.bCentered = true;
		//AnimatedBack.DrawGrid(C, 0, 0, Root.WinWidth, Root.WinHeight);
		AnimatedBack.DrawGrid(C, InnerLeft, InnerTop, InnerWidth, InnerHeight);
	}
	else
	{
		for (w = 0; w < NumTilesX; w++)
		{
			for (h = 0; h < NumTilesY; h++)
			{
				Tex = Back[w+h*NumTilesX];
				DrawStretchedTextureSegment( C, InnerLeft + TileWidth*w, InnerTop + TileHeight*h, TileWidth, TileHeight, 0, 0, Tex.USize, Tex.VSize, Tex );
			}
		}
	}

	C.DrawColor = C.Default.DrawColor;
	
	C.bNoSmooth = false;
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
		C.SetPos(B.WinLeft+8*Root.ScaleX, B.WinTop - 50*Root.ScaleY);
		//Smoke = Texture(DynamicLoadObject("FX.Smoke", Class'Texture'));
		if ( SmokeTexture != None )
			C.DrawTile( SmokeTexture, B.WinWidth-24*Root.ScaleX, 70*Root.ScaleY, 0, 0, 64, 32 );
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
		{
			GetPlayerOwner().UnloadTexture( Back[i] );
			Back[i] = None;
		}
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

function AnimEnd(MeshActor MyMesh)
{

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
