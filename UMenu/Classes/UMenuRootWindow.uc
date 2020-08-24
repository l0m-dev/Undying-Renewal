//=============================================================================
// UMenuRootWindow - root window subclass for Unreal Menu System
//=============================================================================
class UMenuRootWindow extends UWindowRootWindow;

//#exec TEXTURE IMPORT NAME=MenuBlack FILE=Textures\MenuBlack.bmp GROUP="Icons" MIPS=OFF

function Created() 
{
	Resized();
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'MenuBlack');
}

function Resized()
{
	Super.Resized();
}

function DoQuitGame()
{
	if ( GetLevel().Game != None )
	{
		GetLevel().Game.SaveConfig();
		GetLevel().Game.GameReplicationInfo.SaveConfig();
	}
	Super.DoQuitGame();
}

defaultproperties
{
     LookAndFeelClass="UMenu.UMenuMetalLookAndFeel"
}
