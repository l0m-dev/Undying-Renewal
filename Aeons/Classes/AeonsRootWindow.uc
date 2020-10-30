//=============================================================================
// AeonsRootWindow - root window subclass for Aeons Shell 
//=============================================================================
class AeonsRootWindow extends UWindowRootWindow;

//#exec AUDIO IMPORT FILE="Shell_Blacken01.WAV" GROUP="Shell"
//#exec AUDIO IMPORT FILE="Shell_FlameLoop01.WAV" GROUP="Shell"
//#exec AUDIO IMPORT FILE="Shell_Mvmt01.WAV" GROUP="Shell"
//#exec AUDIO IMPORT FILE="Shell_Select01.WAV" GROUP="Shell"

var float ScaleX;
var float ScaleY;

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
	local class<UWindowWindow> BookWindowClass;

	Super.Created();

	//Scale = (WinHeight - WinTop) / 600.0;
	ScaleX = WinWidth / 800.0;
	ScaleY = WinHeight / 600.0;

	MainWindowClass = Class<UWindowWindow>(DynamicLoadObject("UndyingShellPC.MainMenuWindow", class'Class'));
	if ( MainWindowClass != None ) 
		MainMenu = CreateWindow(MainWindowClass,5,5,400,300);

	if ( AeonsConsole(Console).bRequestedBook )
		MainMenu.HideWindow();
	
	Resized();
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

function SetupFonts()
{
}

function Resized()
{
	Super.Resized();

//	if ( WinWidth > 1024 )
//		Scale = 768.0 / 600.0;
//	else
		ScaleX = WinWidth / 800.0;
		ScaleY = WinHeight / 600.0;

	
	if ( MainMenu != None )
		MainMenu.Resized();

	if ( Book != None ) 
		Book.Resized();
	
}

function ResolutionChanged(float WinWidth, float WinHeight)
{
	//GetPlayerOwner().ConsoleCommand("Quit");
	
	Fonts[F_Normal] = None;
}

function Font GetSmallFont()
{
	local font Font;
	
	if (WinHeight < 720)
		Font = Font(DynamicLoadObject("Comic.Comic10", class'Font'));
	else if (WinHeight < 800)
		Font = Font(DynamicLoadObject("Comic.Comic12", class'Font'));
	else
		Font = Font(DynamicLoadObject("Comic.Comic18", class'Font'));
	
	return Font;
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{
	Console.GetVersion(C);
	
	if (Fonts[F_Normal] == None && Fonts[F_Normal] != C.SmallFont)
	{
		C.LargeFont = Font(DynamicLoadObject("Aeons.MorpheusFont",class'Font'));
		C.MedFont = Font(DynamicLoadObject("Aeons.Dauphin_Grey",class'Font'));
		C.SmallFont = GetSmallFont();
		
		if (!Console.bEnglish)
			C.MedFont = Font(DynamicLoadObject("dauphin.dauphin16",class'Font'));
		
		Fonts[F_Normal] =	C.SmallFont;
		Fonts[F_Bold] =		C.SmallFont;
		Fonts[F_Large] =	C.LargeFont;
		Fonts[F_LargeBold]= C.LargeFont;
		Fonts[4] =			C.MedFont;
		
		if (!Console.bEnglish)
			Fonts[5] = Font(DynamicLoadObject("dauphin.dauphin16",class'Font'));
		else
			Fonts[5] = Font(DynamicLoadObject("Aeons.Dauphin16_Skinny",class'Font'));
	}
	
	switch(Msg) {

	case WM_KeyDown:
		if (Key == 114) //fix hardcoded for IK_F3 since EInputKey isn't visible here
		{
			if ( (Book != None) && (Book.bWindowVisible) )
				Book.Close();
		}

		if(HotKeyDown(Key, X, Y))
			return;
		break;
	case WM_KeyUp:
		if(HotKeyUp(Key, X, Y))
			return;
		break;
	}

	Super.WindowEvent(Msg, C, X, Y, Key);
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
	
	Super.DrawMouse(C);

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
		lightscale = FClamp(CursorFX.ParticlesPerSec.Base / 20.0, 1.0, 2.5);
		C.SetPos(MouseX * GUIScale - MouseWindow.Cursor.HotX - LightScale*32.0 , MouseY * GUIScale - MouseWindow.Cursor.HotY - LightScale*32.0);
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

		C.DrawActor(CursorFX, false, true);
	}

}

defaultproperties
{
     LookAndFeelClass="UMenu.UMenuMetalLookAndFeel"
}
