//=============================================================================
// MainMenuWindow.
//=============================================================================
class MainMenuWindow expands ShellWindow;

#exec OBJ LOAD FILE=..\sounds\Shell_HUD.uax PACKAGE=Shell_HUD
#exec OBJ LOAD FILE=..\textures\ShellTextures.utx PACKAGE=ShellTextures

//#exec Texture Import File=Main_0.bmp Mips=Off
//#exec Texture Import File=Main_1.bmp Mips=Off
//#exec Texture Import File=Main_2.bmp Mips=Off
//#exec Texture Import File=Main_3.bmp Mips=Off
//#exec Texture Import File=Main_4.bmp Mips=Off
//#exec Texture Import File=Main_5.bmp Mips=Off

//#exec Texture Import File=Gen1_up.bmp	Mips=Off	Flags=2
//#exec Texture Import File=Gen2_up.bmp	Mips=Off	Flags=2
//#exec Texture Import File=Gen3_up.bmp	Mips=Off	Flags=2
//#exec Texture Import File=Gen4_up.bmp	Mips=Off	Flags=2

//#exec Texture Import File=Main_Back_up.bmp		Mips=Off
//#exec Texture Import File=Main_Back_ov.bmp		Mips=Off
//#exec Texture Import File=Main_Back_dn.bmp		Mips=Off

//#exec Texture Import File=Main_Disconnect_up.bmp		Mips=Off
//#exec Texture Import File=Main_Disconnect_ov.bmp		Mips=Off
//#exec Texture Import File=Main_Disconnect_dn.bmp		Mips=Off

//#exec Texture Import File=Main_Reconnect_up.bmp		Mips=Off
//#exec Texture Import File=Main_Reconnect_ov.bmp		Mips=Off
//#exec Texture Import File=Main_Reconnect_dn.bmp		Mips=Off

//#exec Texture Import File=renewal_up.bmp		Mips=Off
//#exec Texture Import File=renewal_ov.bmp		Mips=Off
//#exec Texture Import File=renewal_dn.bmp		Mips=Off

//#exec Texture Import File=Main_audio_up.bmp		Mips=Off
//#exec Texture Import File=Main_audio_ov.bmp		Mips=Off
//#exec Texture Import File=Main_audio_dn.bmp		Mips=Off

//#exec Texture Import File=Main_Controls_up.bmp		Mips=Off
//#exec Texture Import File=Main_Controls_ov.bmp		Mips=Off
//#exec Texture Import File=Main_Controls_dn.bmp		Mips=Off

//#exec Texture Import File=Main_quit_up.bmp			Mips=Off
//#exec Texture Import File=Main_quit_ov.bmp			Mips=Off
//#exec Texture Import File=Main_quit_dn.bmp			Mips=Off

//#exec Texture Import File=Main_credits_dn.bmp		Mips=Off
//#exec Texture Import File=Main_credits_ov.bmp		Mips=Off
//#exec Texture Import File=Main_credits_up.bmp		Mips=Off

//#exec Texture Import File=Main_sload_up.bmp			Mips=Off
//#exec Texture Import File=Main_sload_ov.bmp			Mips=Off
//#exec Texture Import File=Main_sload_dn.bmp			Mips=Off

//#exec Texture Import File=Main_new_up.bmp		Mips=Off
//#exec Texture Import File=Main_new_ov.bmp		Mips=Off
//#exec Texture Import File=Main_new_dn.bmp		Mips=Off

//#exec Texture Import File=Main_video_up.bmp			Mips=Off
//#exec Texture Import File=Main_video_ov.bmp			Mips=Off
//#exec Texture Import File=Main_video_dn.bmp			Mips=Off

//#exec Texture Import File=Main_Multiplayer_up.bmp		Mips=Off
//#exec Texture Import File=Main_Multiplayer_ov.bmp		Mips=Off
//#exec Texture Import File=Main_Multiplayer_dn.bmp		Mips=Off

//#exec Texture Import Name=Light File=Light.pcx Mips=Off Flags=4

var ShellButton Buttons[8];
var ShellButton BackToGame;
var ShellButton Disconnect;
var ShellButton Reconnect;
var ShellButton RenewalButton;

var UWindowWindow Single;
var UWindowWindow Audio;
var UWindowWindow Controls;
var UWindowWindow Credits;
var UWindowWindow Quit; //fix messagebox ?
var UWindowWindow Website;
var UWindowWindow LoadSave;
var UWindowWindow Multiplayer;
var UWindowWindow Renewal;
var UWindowWindow Video;
var UWindowWindow Console;

var UWindowWindow Confirm;
//var ShellWindow Dialog;
//var UWindowMessageBox ConfirmJoin;
//var() sound NewScreenSound;
//var sound ExitSound;
var int		SmokingWindows[12];
var float	SmokingTimers[12];

var int AmbientSoundID;

var bool Initialized;

var int XCenter, YCenter;
/*
var MeshActor Model;

var float locx, locy;
var float velx, vely;
*/

var int RelaunchedFrom;

//----------------------------------------------------------------------------

function Created()
{
	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;

	Super.Created();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	for( i=0; i<8; i++ )
	{
		SmokingWindows[i] = -1;

		Buttons[i] = ShellButton(CreateWindow(class'ShellButton', 0, 0, 160, 64));

		Buttons[i].TexCoords = NewRegion(0, 0, 160, 64);

		Buttons[i].Manager = Self;
		Buttons[i].Style = 5; // Alpha Blend

		Buttons[i].bBurnable = true;
		Buttons[i].OverSound=sound'Shell_HUD.Shell_Blacken01';	
	}

	Buttons[0].UpTexture =   texture'ShellTextures.Main_New_up';
	Buttons[0].DownTexture = texture'ShellTextures.Main_New_dn';
	Buttons[0].OverTexture = texture'ShellTextures.Main_New_ov';

	Buttons[1].UpTexture =   texture'ShellTextures.Main_audio_up';
	Buttons[1].DownTexture = texture'ShellTextures.Main_audio_dn';
	Buttons[1].OverTexture = texture'ShellTextures.Main_audio_ov';

	Buttons[2].UpTexture =   texture'ShellTextures.Main_Controls_up';		
	Buttons[2].DownTexture = texture'ShellTextures.Main_Controls_dn';		
	Buttons[2].OverTexture = texture'ShellTextures.Main_Controls_ov';		
	
	Buttons[3].UpTexture =   texture'ShellTextures.Main_credits_up';		
	Buttons[3].DownTexture = texture'ShellTextures.Main_credits_dn';
	Buttons[3].OverTexture = texture'ShellTextures.Main_credits_ov';		
	
	Buttons[4].UpTexture =   texture'ShellTextures.Main_quit_up';	
	Buttons[4].DownTexture = texture'ShellTextures.Main_quit_dn';	
	Buttons[4].OverTexture = texture'ShellTextures.Main_quit_ov';	
	
	Buttons[5].UpTexture =   texture'ShellTextures.Main_Multiplayer_up';
	Buttons[5].DownTexture = texture'ShellTextures.Main_Multiplayer_dn';	
	Buttons[5].OverTexture = texture'ShellTextures.Main_Multiplayer_ov';		
	Buttons[5].Style = 5;		
	
	Buttons[6].UpTexture =   texture'ShellTextures.Main_sload_up';	
	Buttons[6].DownTexture = texture'ShellTextures.Main_sload_dn';
	Buttons[6].OverTexture = texture'ShellTextures.Main_sload_ov';

	Buttons[7].UpTexture   = texture'ShellTextures.Main_video_up';		
	Buttons[7].DownTexture = texture'ShellTextures.Main_video_dn';		
	Buttons[7].OverTexture = texture'ShellTextures.Main_video_ov';		

//positions and sizes at 800x600.. other resolutions can use these to move and resize
	Buttons[0].Template = NewRegion( 188,50,160,64);
	Buttons[1].Template = NewRegion( 378,132,160,64);
	Buttons[2].Template = NewRegion( 396,222,160,64);
	Buttons[3].Template = NewRegion( 368,321,160,64);
	Buttons[4].Template = NewRegion( 214,392,160,64);
	Buttons[5].Template = NewRegion( 78,312,160,64);
	Buttons[6].Template = NewRegion( 52,230,160,64);
	Buttons[7].Template = NewRegion( 78,116,160,64);


// backtogame button
	BackToGame = ShellButton(CreateWindow(class'ShellButton', 616*RootScaleX, 500*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	BackToGame.TexCoords = NewRegion(0,0,160,64);

	BackToGame.Template = NewRegion( 616, 500, 160, 64);

	BackToGame.Manager = Self;
	BackToGame.Style=5;

	BackToGame.UpTexture   = texture'ShellTextures.Main_Back_Up';
	BackToGame.DownTexture = texture'ShellTextures.Main_Back_Dn';
	BackToGame.OverTexture = texture'ShellTextures.Main_Back_Ov';

	BackToGame.bBurnable = true;
	BackToGame.OverSound=sound'Aeons.Shell_Blacken01';
	
// disconnect button
	Disconnect = ShellButton(CreateWindow(class'ShellButton', 620*RootScaleX, 430*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	Disconnect.TexCoords = NewRegion(0,0,160,64);

	Disconnect.Template = NewRegion( 620, 430, 160, 64);

	Disconnect.Manager = Self;
	Disconnect.Style=5;

	Disconnect.UpTexture   = texture'ShellTextures.Main_Disconnect_Up';
	Disconnect.DownTexture = texture'ShellTextures.Main_Disconnect_Dn';
	Disconnect.OverTexture = texture'ShellTextures.Main_Disconnect_Ov';

	Disconnect.bBurnable = true;
	Disconnect.OverSound=sound'Aeons.Shell_Blacken01';

// reconnect button
	Reconnect = ShellButton(CreateWindow(class'ShellButton', 610*RootScaleX, 350*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	Reconnect.TexCoords = NewRegion(0,0,160,64);

	Reconnect.Template = NewRegion( 610, 350, 160, 64);

	Reconnect.Manager = Self;
	Reconnect.Style=5;

	Reconnect.UpTexture   = texture'ShellTextures.Main_Reconnect_Up';
	Reconnect.DownTexture = texture'ShellTextures.Main_Reconnect_Dn';
	Reconnect.OverTexture = texture'ShellTextures.Main_Reconnect_Ov';

	Reconnect.bBurnable = true;
	Reconnect.OverSound=sound'Aeons.Shell_Blacken01';
	
// renewal button
	RenewalButton = ShellButton(CreateWindow(class'ShellButton', 600*RootScaleX, 30*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	RenewalButton.TexCoords = NewRegion(0,0,160,64);

	RenewalButton.Template = NewRegion( 600, 30, 160, 64);

	RenewalButton.Manager = Self;
	RenewalButton.Style=5;

	RenewalButton.UpTexture   = texture'ShellTextures.renewal_up';
	RenewalButton.DownTexture = texture'ShellTextures.renewal_dn';
	RenewalButton.OverTexture = texture'ShellTextures.renewal_ov';

	RenewalButton.bBurnable = true;
	RenewalButton.OverSound=sound'Aeons.Shell_Blacken01';

	RenewalButton.bDrawShadow = true;

//	ExitSound = Sound(DynamicLoadObject("Aeons.Shell_Select01", class'Sound'));

	/*
	velx = 0.12; 
	vely = 0.23;
	Model = GetPlayerOwner().Spawn(class'MeshActor', GetEntryLevel());
	Model.Mesh = SkelMesh'Aeons.Darkbat_m';//GetPlayerOwner().Mesh;
	Model.Skin = GetPlayerOwner().Skin;
	Model.NotifyClient = Self;
	SetMesh(Model.Mesh);
	*/

	Initialized = True;
	Root.Console.bBlackout = True;
}

function AfterCreate()
{
	local string SaveString;
	
	Super.AfterCreate();

	RelaunchedFrom = AeonsRootWindow(Root).RelaunchedFrom;
	if (RelaunchedFrom != 0)
	{
		// reset config variable
		AeonsRootWindow(Root).RelaunchedFrom = 0;
		AeonsRootWindow(Root).SaveConfig();
	}

	// Check for a temporary save file, used when the player changes Video Drivers in the middle of the game.
	SaveString = GetPlayerOwner().GetSaveGameList();
	if ((InStr (SaveString, "98,")) >= 0)
	{
		if (RelaunchedFrom == 0)
			RelaunchedFrom = -1;
	}

	if (RelaunchedFrom != 0)
	{
		// shell ambient sound will stop after loading a game
		// this can't be fixed by calling StopShellAmbient() here because LoadGame happens the next tick
		switch (RelaunchedFrom)
		{
			case -1:
				// allow main menu to close
				GetPlayerOwner().Level.bLoadBootShellPSX2 = false;	
				
				Close();

				// load autosave after a crash from slot 98
				GetPlayerOwner().ConsoleCommand("LoadGame 98");
				GetPlayerOwner().ConsoleCommand("DeleteGame 98");
				break;
			case 1:
				// added default 32 bits by renewal
				//GetPlayerOwner().ConsoleCommand("SetRes "$ GetPlayerOwner().ConsoleCommand("GetCurrentRes") $ "x" $ 32);
				VideoPressed();
				GetPlayerOwner().ConsoleCommand("LoadGame 99");
				GetPlayerOwner().ConsoleCommand("DeleteGame 99");
				break;
			case 2:
				AudioPressed();
				GetPlayerOwner().ConsoleCommand("LoadGame 99");
				GetPlayerOwner().ConsoleCommand("DeleteGame 99");
				break;
		}

		RelaunchedFrom = 0;
	}
}


//----------------------------------------------------------------------------
/*
function SetMesh(mesh NewMesh)
{
	Model.bMeshEnviroMap = False;
	Model.DrawScale = Model.Default.DrawScale;
	Model.Mesh = NewMesh;
	if(Model.Mesh != None)
		Model.LoopAnim( 'hunt', 3 );
		// Model.PlayAnim('Walk');//, 0.5);
}
*/
//----------------------------------------------------------------------------

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case Buttons[0]:
					SinglePressed();
					break;
				case Buttons[4]:
					QuitPressed();
					//Root.QuitGame();
					break;	
				case Buttons[1]:
					AudioPressed();
					break;	
				case Buttons[7]:
					VideoPressed();
					break;
				case Buttons[2]:
					ControlsPressed();
					break;
				case Buttons[6]:
					LoadSavePressed();
					break;
				case Buttons[5]:
					MultiplayerPressed();
					break;
				case Buttons[3]:
					CreditsPressed();
					break;
				case BackToGame:
					BackPressed();
					break;
				case Disconnect:
					DisconnectPressed();
					break;
				case Reconnect:
					ReconnectPressed();
					break;
				case RenewalButton:
					RenewalButtonPressed();
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
		case Buttons[0]:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case Buttons[1]:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;

		case Buttons[2]:
			SmokingWindows[2] = 1;
			SmokingTimers[2] = 90;
			break;

		case Buttons[3]:
			SmokingWindows[3] = 1;
			SmokingTimers[3] = 90;
			break;

		case Buttons[4]:
			SmokingWindows[4] = 1;
			SmokingTimers[4] = 90;
			break;

		case Buttons[5]:
			SmokingWindows[5] = 1;
			SmokingTimers[5] = 90;
			break;

		case Buttons[6]:
			SmokingWindows[6] = 1;
			SmokingTimers[6] = 90;
			break;

		case Buttons[7]:
			SmokingWindows[7] = 1;
			SmokingTimers[7] = 90;
			break;

		case BackToGame:
			SmokingWindows[8] = 1;
			SmokingTimers[8] = 90;
			break;

		case Disconnect:
			SmokingWindows[9] = 1;
			SmokingTimers[9] = 90;
			break;	

		case Reconnect:
			SmokingWindows[10] = 1;
			SmokingTimers[10] = 90;
			break;	

		case RenewalButton:
			SmokingWindows[11] = 1;
			SmokingTimers[11] = 90;
			break;
	}
}
//----------------------------------------------------------------------------

/*
function PlayNewScreenSound()
{
	if ( NewScreenSound != None )
		GetPlayerOwner().PlaySound( NewScreenSound );
}
*/

//----------------------------------------------------------------------------
/*
function PlayExitSound()
{
	if ( ExitSound != None )
		GetPlayerOwner().PlaySound( ExitSound );
}
*/
//----------------------------------------------------------------------------

function LoadSavePressed()
{
	if (GetPlayerOwner().Level.NetMode != NM_Standalone && !GetPlayerOwner().PlayerReplicationInfo.bAdmin)
	{
		GetPlayerOwner().PlaySound( Sound(DynamicLoadObject("Shell_HUD.HUD.HUD_Negative01",class'Sound')), [Flags]482 );
		return;
	}

	PlayNewScreenSound();

	if (LoadSave == None ) 
		LoadSave = ManagerWindow(Root.CreateWindow(class'LoadSaveWindow', 100, 100, 200, 200, Root, True));
	else
		LoadSave.ShowWindow();		
}

//----------------------------------------------------------------------------

function WebsitePressed()
{
	PlayNewScreenSound();
//	GetPlayerOwner().ConsoleCommand("start http://www.dreamworksgames.com");
	GetPlayerOwner().ConsoleCommand("start http://undying.ea.com");
//	Close();
}

//----------------------------------------------------------------------------

function VideoPressed()
{
	if (RelaunchedFrom != 1)
		PlayNewScreenSound(); //PlayExitSound();

	if (Video == None ) 
		Video = ManagerWindow(Root.CreateWindow(class'VideoWindow', 100, 100, 200, 200, Root, True));
	else
		Video.ShowWindow();		
}

//----------------------------------------------------------------------------

function ControlsPressed()
{
	PlayNewScreenSound(); //PlayExitSound();

	if ( Controls== None )
		Controls = ManagerWindow(Root.CreateWindow(class'ControlsWindow', 100, 100, 200, 200, Root, True));
	else
		Controls.ShowWindow();
		
}

//----------------------------------------------------------------------------

function AudioPressed()
{
	if ( RelaunchedFrom != 2 )
		PlayNewScreenSound(); //PlayExitSound();

	if ( Audio == None )
		Audio = ManagerWindow(Root.CreateWindow(class'AudioWindow', 100, 100, 200, 200, Root, True));
	else
		Audio.ShowWindow();
}

//----------------------------------------------------------------------------

function QuitPressed()
{
	PlayNewScreenSound(); //PlayExitSound();

	if ( Quit == None )
		Quit = ManagerWindow(Root.CreateWindow(class'QuitWindow', 100, 100, 200, 200, Root, True));
		
	else
		Quit.ShowWindow();

}

//----------------------------------------------------------------------------

function SinglePressed()
{
	PlayNewScreenSound(); //PlayExitSound();

	if ( Single == None )
		//Single = ManagerWindow(Root.CreateWindow(class'NewGameWindow', 100, 100, 200, 200, Root, True));
		Single = ManagerWindow(Root.CreateWindow(class'DifficultyWindow', 100, 100, 200, 200, Root, True));
		
	else
		Single.ShowWindow();

}

//----------------------------------------------------------------------------

function CreditsPressed()
{

//	MessageBox("Title", "Text", MB_YesNo, MR_No);
//	return;

	// MessageBox , UWindowFramedWindow
/*
	Dialog = ShellWindow(Root.CreateWindow(class'DialogWindow', 100,100,200,200, Root, True));
	if ( Dialog != None ) 
		ShowModal(Dialog);
	else
		Log("MainMenuWindow: Dialog is None!");

	return;
*/

	PlayNewScreenSound(); //PlayExitSound();
	
	if ( Credits == None )
		Credits = ManagerWindow(Root.CreateWindow(class'CreditsWindow', 100, 100, 200, 200, Root, True));
	else
		Credits.ShowWindow();

	//ShowConfirm(Credits);
}

function ShowConfirm(UwindowWindow W)
{
	if (Confirm == None ) 
		Confirm = ManagerWindow(Root.CreateWindow(class'ConfirmWindow', 0, 0, 200, 200, Root, True));

	Confirm.ShowWindow();		
	ConfirmWindow(Confirm).Owner = self;
	ConfirmWindow(Confirm).QuestionWindow = W;
}

function QuestionAnswered( UWindowWindow W, int Answer )
{
	if(W != Credits)
		return;
		
	// answered yes
	if ( Answer == 1 ) 
	{
		//GetPlayerOwner().Level.bLoadBootShellPSX2 = false;	
		BackPressed();
	}
	// answered no
	else
	{
		BackPressed();
	}
}
//----------------------------------------------------------------------------
function MultiplayerPressed()
{
	PlayNewScreenSound(); //PlayExitSound();

	if ( Multiplayer == None )
		Multiplayer = ManagerWindow(Root.CreateWindow(class'MultiplayerWindow', 100, 100, 200, 200, Root, True));
	else
		Multiplayer.ShowWindow();
}
//----------------------------------------------------------------------------

function BackPressed()
{
	PlayNewScreenSound(); //PlayExitSound();
	Close(); 
}

function DisconnectPressed()
{
	SmokingTimers[9] = 0;
	GetPlayerOwner().ConsoleCommand("DISCONNECT");
	PlayNewScreenSound(); //PlayExitSound();
	//Close(); 
}

function ReconnectPressed()
{
	SmokingTimers[10] = 0;
	GetPlayerOwner().ConsoleCommand("RECONNECT");
	PlayNewScreenSound();
}

function RenewalButtonPressed()
{
	SmokingTimers[11] = 0;
	//GetPlayerOwner().ConsoleCommand("start http://undying.ea.com");
	
	if ( Renewal == None )
		Renewal = Root.CreateWindow(class'RenewalWindow', Root.WinWidth - 450, 100, 350, 220);
	else
		Renewal.ShowWindow();
	
	PlayNewScreenSound(); //PlayExitSound();
	//Close(); 
}

//----------------------------------------------------------------------------

function StopShellAmbient()
{
	GetPlayerOwner().StopSound(AmbientSoundID);
	AmbientSoundID = 0;
}

//----------------------------------------------------------------------------

function Close(optional bool bByParent)
{
	//if the level has bLoadBootShellPSX2 set, we want the shell to stay up
	if ( GetPlayerOwner().Level.bLoadBootShellPSX2 ) 
		return;

	StopShellAmbient();

	Root.Console.bLocked = False;
	Root.Console.CloseUWindow();
}

//----------------------------------------------------------------------------

function HideWindow()
{
	Root.Console.bBlackOut = False;

	Super.HideWindow();
}

//----------------------------------------------------------------------------

function Paint(Canvas C, float X, float Y)
{
	local int i;
	//local texture Smoke;
	local int Brightness;
	local float Distance;
	//local vector cursorloc, windowloc, direction;
	local int OldFOV;
	local UWindowWindow Book;

	//log("mainmenuwindow: paint");

	// main menu always receives Paint messages, even if another window is open
	// a workaround is to check NextSiblingWindow, to see if another window is open
	// leave the current behavior for now
	//if (NextSiblingWindow != None)
	//	return;
	
	Super.Paint(C, X, Y);

	if ( GetPlayerOwner().Level.bLoadBootShellPSX2 && GetLevel().NetMode == NM_Standalone )
		BackToGame.HideWindow();
	else
		BackToGame.ShowWindow();

	if ( GetLevel().NetMode == NM_Client )
	{
		Disconnect.ShowWindow();
		Reconnect.WinTop = 350*Root.ScaleY;
	}
	else
	{
		Disconnect.HideWindow();
		Reconnect.WinTop = 420*Root.ScaleY;
	}

	if ( GetLevel().NetMode == NM_Client || GetLevel() == GetEntryLevel() )
		Reconnect.ShowWindow();
	else
		Reconnect.HideWindow();

	Root.Console.bLocked =  True;

	Book = AeonsRootWindow(Root).Book;

	if (AmbientSoundID == 0) 
	{
		if ( ((Book != none) && (BookWindow(Book).AmbientSoundID == 0)) || (Book == None) )
			AmbientSoundID = GetPlayerOwner().PlaySound(Sound(DynamicLoadObject("Shell_HUD.Shell_Ambience", class'Sound')), SLOT_None, 0.5, true, 1600.0, 1.0, 491);	
	}
	else if ( (Book != none) && (BookWindow(Book).AmbientSoundID != 0) )
	{
		GetPlayerOwner().StopSound(AmbientSoundID);
		AmbientSoundID = 0;
	}

	Super.PaintSmoke(C, BackToGame, SmokingWindows[8], SmokingTimers[8]);
	Super.PaintSmoke(C, Disconnect, SmokingWindows[9], SmokingTimers[9]);
	Super.PaintSmoke(C, Reconnect, SmokingWindows[10], SmokingTimers[10]);
	Super.PaintSmoke(C, RenewalButton, SmokingWindows[11], SmokingTimers[11]);
	for ( i=0; i<8; i++ )
		Super.PaintSmoke(C, Buttons[i], SmokingWindows[i], SmokingTimers[i]);

	/*
	if (Model != None)
	{
		OldFov = GetPlayerOwner().FOVAngle;
		GetPlayerOwner().SetFOVAngle(90);

		locx+= velx;
		locy+= vely;

		if ( (locx > 40) || (locx < 0) )
		{
			velx *= -1;
			locx+=velx;
		}

		if ( (locy > 40) || (locy < 0) )
		{
			vely *= -1;
			locy+=vely;
		}

		log(" x="$ locx $ " y="$ locy);
		Model.ViewOffset.y = locx;
		Model.ViewOffset.z = locy;
		Model.ViewOffset.x = 40;

		//DrawClippedActor( C, WinWidth/5, WinHeight/5, Model, False, GetPlayerOwner().Rotation, Model.ViewOffset);//vect(0, 0, 0) );
		DrawClippedActor( C, WinWidth/5, WinHeight/5, Model, False, GetPlayerOwner().Rotation, Model.ViewOffset);//vect(0, 0, 0) );
		GetPlayerOwner().SetFOVAngle(OldFov);
	}
	*/
}

//----------------------------------------------------------------------------

function ShowWindow()
{
	log("MainMenuWindow: ShowWindow");
	Super.ShowWindow();
/*
	if ( GetPlayerOwner().Level.bLoadBootShellPSX2 )
	{
		BackToGame.HideWindow();
	}
	else 
		BackToGame.ShowWindow();
*/
}

//----------------------------------------------------------------------------

function Resized()
{
	local int W, H, XMod, YMod, i;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	// MainMenuWindow is parent of Single and other windows.
	//fix might be better to have AeonsRootWindow or UWindowRootWindow know the active window
	// I think there is already a variable for that, i'll look later
	if ( Single != None )
		Single.Resized();
	
	if ( Multiplayer != None )
		Multiplayer.Resized();

	if ( Renewal != None )
		Renewal.Resized();

	if ( LoadSave != None )
		LoadSave.Resized();

	if ( Audio != None ) 
		Audio.Resized();

	if ( Video != None ) 
		Video.Resized();

	if ( Controls != None )
		Controls.Resized();

	if ( Credits != None )
		Credits.Resized();

	if ( Quit != None ) 
		Quit.Resized();

	if ( BackToGame != None )
		BackToGame.ManagerResized(RootScaleX, RootScaleY);

	if ( Disconnect != None )
		Disconnect.ManagerResized(RootScaleX, RootScaleY);	

	if ( Reconnect != None )
		Reconnect.ManagerResized(RootScaleX, RootScaleY);	

	if ( RenewalButton != None )
		RenewalButton.ManagerResized(RootScaleX, RootScaleY);

	for ( i=0; i<8; i++ )
	{
		Buttons[i].ManagerResized(RootScaleX, RootScaleY);
	}
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     BackNames(0)="ShellTextures.Main_0"
     BackNames(1)="ShellTextures.Main_1"
     BackNames(2)="ShellTextures.Main_2"
     BackNames(3)="ShellTextures.Main_3"
     BackNames(4)="ShellTextures.Main_4"
     BackNames(5)="ShellTextures.Main_5"
     bAllowControllerCursor=True
}
