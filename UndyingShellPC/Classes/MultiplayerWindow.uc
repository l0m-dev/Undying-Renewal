//=============================================================================
// Multiplayerindow.
//=============================================================================
class MultiplayerWindow expands ShellWindow;

//#exec Texture Import File=Multiplayer_0.bmp Mips=Off
//#exec Texture Import File=Multiplayer_1.bmp Mips=Off
//#exec Texture Import File=Multiplayer_2.bmp Mips=Off
//#exec Texture Import File=Multiplayer_3.bmp Mips=Off
//#exec Texture Import File=Multiplayer_4.bmp Mips=Off
//#exec Texture Import File=Multiplayer_5.bmp Mips=Off

/*
//#exec Texture Import File=multi_ok_ov.BMP	Mips=Off Flags=2
//#exec Texture Import File=multi_ok_up.BMP	Mips=Off Flags=2
//#exec Texture Import File=multi_ok_dn.BMP	Mips=Off Flags=2
*/

var UWindowWindow PlayerSetupWindow;

var ShellButton FindGame, CreateGame, PlayerSetup, Back;

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

	// create window items here

/*	Temporarily commented out since Multiplayer is not going out with our CD

//  FindGame Button 405 240 140 44
	FindGame = ShellButton(CreateWindow(class'ShellButton', 405*RootScaleX, 240*RootScaleY, 140*RootScaleX, 44*RootScaleY));

	FindGame.TexCoords = NewRegion(0,0,140,44);
	FindGame.Template = NewRegion(405,240,140,44);

	FindGame.Manager = Self;
	FindGame.Text = "";
	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;
	FindGame.SetTextColor(TextColor);
	FindGame.Font = 0;

	FindGame.bBurnable = true;

	FindGame.UpTexture =   texture'Gen1_up';
	FindGame.DownTexture = texture'Gen1_up';
	FindGame.OverTexture = texture'Gen1_up';
	FindGame.DisabledTexture = None;

//  CreateGame Button 210 70 160 48
	CreateGame = ShellButton(CreateWindow(class'ShellButton', 210*RootScaleX, 70*RootScaleY, 160*RootScaleX, 48*RootScaleY));

	CreateGame.TexCoords = NewRegion(0,0,160,48);
	CreateGame.Template = NewRegion(210,70,160,48);

	CreateGame.Manager = Self;
	CreateGame.Text = "";
	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;
	CreateGame.SetTextColor(TextColor);
	CreateGame.Font = 0;

	CreateGame.bBurnable = true;

	CreateGame.UpTexture =   texture'Gen1_up';
	CreateGame.DownTexture = texture'Gen1_up';
	CreateGame.OverTexture = texture'Gen1_up';
	CreateGame.DisabledTexture = None;

//  PlayerSetup Button 56 228 146 56
	PlayerSetup = ShellButton(CreateWindow(class'ShellButton', 56*RootScaleX, 228*RootScaleY, 146*RootScaleX, 56*RootScaleY));

	PlayerSetup.TexCoords = NewRegion(0,0,146,56);
	PlayerSetup.Template = NewRegion(56,228,146,56);

	PlayerSetup.Manager = Self;
	PlayerSetup.Text = "";
	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;
	PlayerSetup.SetTextColor(TextColor); 
	PlayerSetup.Font = 0;

	PlayerSetup.bBurnable = true;

	PlayerSetup.UpTexture =   texture'Gen1_up';
	PlayerSetup.DownTexture = texture'Gen1_up';
	PlayerSetup.OverTexture = texture'Gen1_up';
	PlayerSetup.DisabledTexture = None;


//  Back Button 216 384 156 70
	Back = ShellButton(CreateWindow(class'ShellButton', 216*RootScaleX, 384*RootScaleY, 156*RootScaleX, 70*RootScaleY));

	Back.TexCoords = NewRegion(0,0,156,70);
	Back.Template = NewRegion(216,384,156,70);

	Back.Manager = Self;
	Back.Text = "";
	TextColor.R = 0;
	TextColor.G = 0;
	TextColor.B = 0;
	Back.SetTextColor(TextColor); 
	Back.Font = 0;

	Back.bBurnable = true;

	Back.UpTexture =   texture'Gen1_up';
	Back.DownTexture = texture'Gen1_up';
	Back.OverTexture = texture'Gen1_up';
	Back.DisabledTexture = None;
*/

	Root.Console.bBlackout = True;

	Resized();
}

//----------------------------------------------------------------------------

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
					break;
			}
			break;

		case DE_Change:
			switch (B)
			{
			}
			break;
	}
}

//----------------------------------------------------------------------------

function CreateGamePressed()
{
//	PlayExitSound();
/*
	if ( CreateGameWindow == None )
		CreateGameWindow = ManagerWindow(Root.CreateWindow(class'CreateGameWindow', 100, 100, 200, 200, Root, True));
	else
		CreateGameWindow.ShowWindow();
*/		
}

//----------------------------------------------------------------------------

function FindGamePressed()
{
//	PlayExitSound();
/*
	if ( FindGameWindow == None )
		FindGameWindow = ManagerWindow(Root.CreateWindow(class'FindGameWindow', 100, 100, 200, 200, Root, True));
	else
		FindGameWindow.ShowWindow();
*/		
}

//----------------------------------------------------------------------------

function PlayerSetupPressed()
{
//	PlayExitSound();

	if ( PlayerSetupWindow == None )
		PlayerSetupWindow = ManagerWindow(Root.CreateWindow(class'PlayerSetupWindow', 100, 100, 200, 200, Root, True));
	else
		PlayerSetupWindow.ShowWindow();
		
}

//----------------------------------------------------------------------------

function Resized()
{
	Super.Resized();
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
