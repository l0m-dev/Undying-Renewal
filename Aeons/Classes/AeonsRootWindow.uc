//=============================================================================
// AeonsRootWindow - root window subclass for Aeons Shell 
//=============================================================================
class AeonsRootWindow extends UWindowRootWindow;

//#exec AUDIO IMPORT FILE="Shell_Blacken01.WAV" GROUP="Shell"
//#exec AUDIO IMPORT FILE="Shell_FlameLoop01.WAV" GROUP="Shell"
//#exec AUDIO IMPORT FILE="Shell_Mvmt01.WAV" GROUP="Shell"
//#exec AUDIO IMPORT FILE="Shell_Select01.WAV" GROUP="Shell"

// needed to compile, otherwise throws missing audio_x
var float ScaleX, ScaleY;

var UWindowWindow MainMenu;
var UWindowWindow Book;

var texture			Light;
var ParticleFX		CursorFX;

var vector ScreenPosition, LastScreenPosition;
var float FlameSoundTimer;

var UWindowWindow ActiveWindow;

function Created() 
{
	local color TextColor;
	local class<UWindowWindow> MainWindowClass;
	local class<UWindowWindow> FindWindowClass;
	local class<UWindowWindow> BookWindowClass;
	
	local int i;
	local string KeyName;
	local bool bFoundBookKey;
	local int MouseOffsetX;
	local float InnerWidth, MouseXPosScale;
	
	if (LookAndFeelClass ~= "UMenu.UMenuMetalLookAndFeel")
	{
		LookAndFeelClass = "UndyingShellPC.UndyingLookAndFeel";
		SaveConfig();
	}

	Super.Created();

	MainWindowClass = Class<UWindowWindow>(DynamicLoadObject("UndyingShellPC.MainMenuWindow", class'Class'));
	if ( MainWindowClass != None ) 
		MainMenu = CreateWindow(MainWindowClass,5,5,400,300);

	if ( AeonsConsole(Console).bRequestedBook )
		MainMenu.HideWindow();
	
	Resized();
	
	// set mouse position
	
	if (Root.WinHeight / Root.WinWidth < 0.75 )
	{
		InnerWidth = Root.WinHeight / 0.75;
		MouseOffsetX = (Root.WinWidth - InnerWidth) / 2;
		MouseXPosScale = InnerWidth / Root.OriginalWidth;
	}
	else
	{
		MouseXPosScale = Root.ScaleX;
	}

	Root.SetMousePos(290*MouseXPosScale + MouseOffsetX, 250 * Root.ScaleY);
	
	// since F3 is no longer hard coded for the book we need to bind it	
	for (i=0; i<255; i++)
	{
		KeyName = GetPlayerOwner().ConsoleCommand( "KEYNAME "$i );

		if ( KeyName != "" )
		{
			if ( GetPlayerOwner().ConsoleCommand( "KEYBINDING "$KeyName ) == "ShowBook" )
			{
				bFoundBookKey = true;
				break;
			}
		}
	}

	if ( !bFoundBookKey )
		GetPlayerOwner().ConsoleCommand("SET Input"@"F3"@"ShowBook");
}

function NotifyBeforeLevelChange()
{
	Super.NotifyBeforeLevelChange();	
	
	// pass this message to the book window
	if (Book != None)
	{
		Book.NotifyBeforeLevelChange();
	}
}


function Resized()
{
	Super.Resized();
	
	if ( MainMenu != None )
		MainMenu.Resized();

	if ( Book != None ) 
		Book.Resized();
}

function Tick( float DeltaTime )
{
	local class<UWindowWindow> BookWindowClass;

	Super.Tick(DeltaTime);
	
	FlameSoundTimer -= DeltaTime;

	if ( FlameSoundTimer < 0.0 ) 
		FlameSoundTimer = 0.0;

	if ( AeonsConsole(Console).bRequestedBook ) 
	{

		Console.LaunchUWindow();

		MainMenu.HideWindow();

		if ( Book == None )
		{
			BookWindowClass = Class<UWindowWindow>(DynamicLoadObject("UndyingShellPC.BookWindow", class'Class'));
	
			if ( BookWindowClass != None ) 
				Book = CreateWindow(BookWindowClass,5,5,400,300);
		}
		
		// BookWindow calls this in it's Create()
		//Book.Resized();
	 
		if ( Book != None )
			Book.ShowWindow();
		else
			MainMenu.ShowWindow();

		AeonsConsole(Console).bRequestedBook = false;
	}
}

function DoQuitGame()
{
//rb	MenuBar.SaveConfig();
	if ( GetLevel().Game != None )
	{
		GetLevel().Game.SaveConfig();
		GetLevel().Game.GameReplicationInfo.SaveConfig();
	}
	Super.DoQuitGame();
}

function DrawMouse(Canvas C) 
{
	local float X, Y;
	local byte Brightness;
	local vector Loc;
	local float lightscale;
	local float Distance;

	if(Console.Viewport.bWindowsMouseAvailable)
	{
		// Set the windows cursor...
		Console.Viewport.SelectedCursor = MouseWindow.Cursor.WindowsCursor;
	}
	else
	{
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		C.DrawColor.A = 255;
		C.bNoSmooth = True;

		C.SetPos(MouseX * GUIScale - MouseWindow.Cursor.HotX, MouseY * GUIScale - MouseWindow.Cursor.HotY);
		
		if ( MouseWindow.Cursor.tex == Texture'UWindow.Icons.ShellCursor' )
			C.Style = 5;

		C.DrawIcon(MouseWindow.Cursor.tex, Root.ScaleY);
	}

	if ( CursorFX == None )
	{
		CursorFX = GetPlayerOwner().Spawn(class'Aeons.ShellFX');
	}
	else
	{
		ScreenPosition.X = MouseX;
		ScreenPosition.Y = MouseY;
		ScreenPosition.Z = 0;

		Distance = VSize( ScreenPosition - LastScreenPosition );
		CursorFX.ParticlesPerSec.Base += Distance;

		CursorFX.ParticlesPerSec.Base -= 5.0;

		CursorFX.ParticlesPerSec.Base = FClamp(CursorFX.ParticlesPerSec.Base , 2.0, 32.0 );

		CursorFX.SizeEndScale.Rand = 4 * Root.ScaleY;
		CursorFX.Chaos = 8 * Root.ScaleY;
		
		LastScreenPosition = ScreenPosition; 

		if (( Distance > 75 )&&(FlameSoundTimer == 0.0))
		{
			GetPlayerOwner().PlaySound( sound'Shell_Mvmt01', SLOT_Misc, 0.25,,,1.0, 482);
			FlameSoundTimer = 0.5;
		}
	}
	
	C.DrawColor.R = 192;
	C.DrawColor.G = 192;
	C.DrawColor.B = 192;
	C.bNoSmooth = True;
	C.Style = 4;

	if (Light == None )
		Light = Texture(DynamicLoadObject("UndyingShellPC.Light", Class'Texture'));

	if ( Light != None )
	{
		lightscale = FClamp(CursorFX.ParticlesPerSec.Base / 20.0, 1.0, 2.5) * Root.ScaleY;
		C.SetPos(MouseX * GUIScale - MouseWindow.Cursor.HotX - LightScale*32.0 , MouseY * GUIScale - MouseWindow.Cursor.HotY - LightScale*32.0);
		if (MouseWindow.Cursor == NormalCursor)
			C.DrawIcon(Light, lightscale); 
	}

	if ( CursorFX != None )
	{
		CursorFX.bShellOnly = true;

		Loc.X = Root.MouseX;
		Loc.Y = Root.MouseY;
		Loc.Z = 10.0; 
		
		CursorFx.SetRotation( rot(16400,0,0));
		CursorFX.SetLocation( Loc );

		// only DrawClippedActor calls ComputeRenderSize which calls SetSceneNode where we correct the fov
		// ex. with ScreenFlashes=False main menu cursor would be in the wrong position
		if (MouseWindow.Cursor == NormalCursor)
			C.DrawClippedActorFixedFov(CursorFX, 90, false, C.SizeX/GUIScale, C.SizeY/GUIScale, 0, 0, true);
	}

}

defaultproperties
{
     LookAndFeelClass="UndyingShellPC.UndyingLookAndFeel"
}
