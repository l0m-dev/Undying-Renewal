//=============================================================================
// Multiplayerindow.
//=============================================================================
class MultiplayerWindow expands ShellWindow;

#exec Texture Import File=Multiplayer_0.bmp Mips=Off
#exec Texture Import File=Multiplayer_1.bmp Mips=Off
#exec Texture Import File=Multiplayer_2.bmp Mips=Off
#exec Texture Import File=Multiplayer_3.bmp Mips=Off
#exec Texture Import File=Multiplayer_4.bmp Mips=Off
#exec Texture Import File=Multiplayer_5.bmp Mips=Off

//#exec Texture Import File=audio_ok_ov.BMP	Mips=Off Flags=2
//#exec Texture Import File=audio_ok_up.BMP	Mips=Off Flags=2
//#exec Texture Import File=audio_ok_dn.BMP	Mips=Off Flags=2

#exec Texture Import File=player_setup_ov.bmp	Mips=Off Flags=2
#exec Texture Import File=player_setup_up.bmp	Mips=Off Flags=2
#exec Texture Import File=player_setup_dn.bmp	Mips=Off Flags=2

#exec Texture Import File=find_game_ov.bmp	Mips=Off Flags=2
#exec Texture Import File=find_game_up.bmp	Mips=Off Flags=2
#exec Texture Import File=find_game_dn.bmp	Mips=Off Flags=2

#exec Texture Import File=create_game_ov.bmp	Mips=Off Flags=2
#exec Texture Import File=create_game_up.bmp	Mips=Off Flags=2
#exec Texture Import File=create_game_dn.bmp	Mips=Off Flags=2

var UWindowWindow PlayerSetupWindow;
var UWindowWindow FindGameWindow;
var UWindowWindow CreateGameWindow;

var ShellButton FindGame, CreateGame, PlayerSetup, Back;

var int		SmokingWindows[4];
var float	SmokingTimers[4];

function Created()
{
	local int i;
	local color TextColor;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Created();
	
	AeonsRoot = AeonsRootWindow(Root);

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}

	RootScaleX = AeonsRoot.ScaleX;
	RootScaleY = AeonsRoot.ScaleY;
	
	SmokingWindows[0] = -1;
	SmokingWindows[1] = -1;
	SmokingWindows[2] = -1;
	SmokingWindows[3] = -1;

	// create window items here

//	Temporarily commented out since Multiplayer is not going out with our CD

//  FindGame Button 405 240 140 44
	FindGame = ShellButton(CreateWindow(class'ShellButton', 405*RootScaleX, 240*RootScaleY, 142*RootScaleX, 64*RootScaleY));

	FindGame.TexCoords = NewRegion(0,0,142,64);
	FindGame.Template = NewRegion(405,240,142,64);
	
	FindGame.Manager = Self;
	FindGame.Text = "";
	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;
	FindGame.SetTextColor(TextColor);
	FindGame.Font = 0;

	FindGame.bBurnable = true;
	FindGame.OverSound=sound'Aeons.Shell_Blacken01';

	FindGame.UpTexture =   texture'find_game_up';
	FindGame.DownTexture = texture'find_game_dn';
	FindGame.OverTexture = texture'find_game_ov';
	FindGame.DisabledTexture = None;

//  CreateGame Button 210 70 160 48
	CreateGame = ShellButton(CreateWindow(class'ShellButton', 210*RootScaleX, 70*RootScaleY, 154*RootScaleX, 74*RootScaleY));

	CreateGame.TexCoords = NewRegion(0,0,154,74);
	CreateGame.Template = NewRegion(210,70,154,74);

	CreateGame.Manager = Self;
	CreateGame.Text = "";
	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;
	CreateGame.SetTextColor(TextColor);
	CreateGame.Font = 0;

	CreateGame.bBurnable = true;
	CreateGame.OverSound=sound'Aeons.Shell_Blacken01';

	CreateGame.UpTexture =   texture'create_game_up';
	CreateGame.DownTexture = texture'create_game_dn';
	CreateGame.OverTexture = texture'create_game_ov';
	CreateGame.DisabledTexture = None;

//  PlayerSetup Button 56 228 146 56
	PlayerSetup = ShellButton(CreateWindow(class'ShellButton', 56*RootScaleX, 228*RootScaleY, 164*RootScaleX, 64*RootScaleY));

	PlayerSetup.TexCoords = NewRegion(0,0,164,64);
	PlayerSetup.Template = NewRegion(56,228,164,64);

	PlayerSetup.Manager = Self;
	PlayerSetup.Text = "";
	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;
	PlayerSetup.SetTextColor(TextColor); 
	PlayerSetup.Font = 0;

	PlayerSetup.bBurnable = true;
	PlayerSetup.OverSound=sound'Aeons.Shell_Blacken01';

	PlayerSetup.UpTexture =   texture'player_setup_up';
	PlayerSetup.DownTexture = texture'player_setup_dn';
	PlayerSetup.OverTexture = texture'player_setup_ov';
	PlayerSetup.DisabledTexture = None;


//  Back Button 216 384 156 70
	Back = ShellButton(CreateWindow(class'ShellButton', 216*RootScaleX, 384*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	Back.TexCoords = NewRegion(0,0,160,64);
	Back.Template = NewRegion(216,384,160,64);

	Back.Manager = Self;
	Back.Style=5;

	Back.UpTexture =   texture'sload_cancel_up';
	Back.DownTexture = texture'sload_cancel_dn';
	Back.OverTexture = texture'sload_cancel_ov';
	
	Back.bBurnable = true;
	Back.OverSound=sound'Aeons.Shell_Blacken01';

	//Root.Console.bBlackout = True;

	Resized();
}

//----------------------------------------------------------------------------

function Paint(Canvas C, float X, float Y)
{
	local vector SoundLocation;

	Super.Paint(C, X, Y);

	Super.PaintSmoke(C, FindGame, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, CreateGame, SmokingWindows[1], SmokingTimers[1]);
	Super.PaintSmoke(C, PlayerSetup, SmokingWindows[2], SmokingTimers[2]);
	Super.PaintSmoke(C, Back, SmokingWindows[3], SmokingTimers[3]);
}

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case FindGame: 
					FindGamePressed();
					break;

				case CreateGame: 
					CreateGamePressed();
					break;

				case PlayerSetup: 
					PlayerSetupPressed();
					break;

				case Back:
					BackPressed();
					break;
			}
			break;

		case DE_Change:
			switch (B)
			{
			}
			break;
		case DE_MouseEnter:
			OverEffect(ShellButton(B));
			break;
	}
}

function OverEffect(ShellButton B)
{
	switch (B) 
	{
		case FindGame:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case CreateGame:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;
			
		case PlayerSetup:
			SmokingWindows[2] = 1;
			SmokingTimers[2] = 90;
			break;
			
		case Back:
			SmokingWindows[3] = 1;
			SmokingTimers[3] = 90;
			break;
	}
}


//----------------------------------------------------------------------------

function CreateGamePressed()
{
	if ( CreateGameWindow == None )
		CreateGameWindow = ManagerWindow(Root.CreateWindow(class'CreateGameWindow', 100, 100, 200, 200, Root, True));
	else
		CreateGameWindow.ShowWindow();
		
		
	PlayNewScreenSound();
}
//----------------------------------------------------------------------------

function FindGamePressed()
{
	// 50, 30, 500, 300 from ut
	if ( FindGameWindow == None )
		FindGameWindow = ManagerWindow(Root.CreateWindow(class'UBrowser.UBrowserMainWindow', 100, 100, 200, 200, Root, True));
	else
		FindGameWindow.ShowWindow();
	
	FindGameWindow.BringToFront();
		
	PlayNewScreenSound();
	//HideWindow();
	//GetPlayerOwner().ConsoleCommand("start 127.0.0.1");	
}

//----------------------------------------------------------------------------

function PlayerSetupPressed()
{
	if ( PlayerSetupWindow == None )
		PlayerSetupWindow = ManagerWindow(Root.CreateWindow(class'PlayerSetupWindow', 100, 100, 200, 200, Root, True));
	else
		PlayerSetupWindow.ShowWindow();
		
	PlayNewScreenSound();
}

//----------------------------------------------------------------------------

function BackPressed()
{
	PlayNewScreenSound(); //PlayExitSound();
	Close(); 
}

function Resized()
{
	local int W, H, XMod, YMod, i;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}
		
	if ( FindGameWindow != None )
		FindGameWindow.Resized();
		
	if ( CreateGameWindow != None )
		CreateGameWindow.Resized();
		
	if ( PlayerSetupWindow != None )
		PlayerSetupWindow.Resized();
		
	FindGame.ManagerResized(RootScaleX, RootScaleY);
	CreateGame.ManagerResized(RootScaleX, RootScaleY);
	PlayerSetup.ManagerResized(RootScaleX, RootScaleY);
	Back.ManagerResized(RootScaleX, RootScaleY);
}


function Close(optional bool bByParent)
{
	HideWindow();
}


function HideWindow()
{
	Root.Console.bBlackOut = False;
	Super.HideWindow();
}

defaultproperties
{
     BackNames(0)="UndyingShellPC.Multiplayer_0"
     BackNames(1)="UndyingShellPC.Multiplayer_1"
     BackNames(2)="UndyingShellPC.Multiplayer_2"
     BackNames(3)="UndyingShellPC.Multiplayer_3"
     BackNames(4)="UndyingShellPC.Multiplayer_4"
     BackNames(5)="UndyingShellPC.Multiplayer_5"
}
