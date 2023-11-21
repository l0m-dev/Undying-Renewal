//=============================================================================
// MainMenuWindow.
//=============================================================================
class MainMenuWindow expands ShellWindow;

//#exec OBJ LOAD FILE=\aeons\sounds\Shell_HUD.uax PACKAGE=Shell_HUD

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

#exec Texture Import File=Main_Disconnect_up.bmp		Mips=Off
#exec Texture Import File=Main_Disconnect_ov.bmp		Mips=Off
#exec Texture Import File=Main_Disconnect_dn.bmp		Mips=Off

#exec Texture Import File=renewal_up.bmp		Mips=Off
#exec Texture Import File=renewal_ov.bmp		Mips=Off
#exec Texture Import File=renewal_dn.bmp		Mips=Off

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

#exec Texture Import File=Main_Multiplayer_up.bmp		Mips=Off
#exec Texture Import File=Main_Multiplayer_ov.bmp		Mips=Off
#exec Texture Import File=Main_Multiplayer_dn.bmp		Mips=Off

//#exec Texture Import Name=Light File=Light.pcx Mips=Off Flags=4

var ShellButton Buttons[8];
var ShellButton BackToGame;
var ShellButton Disconnect;
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
var int		SmokingWindows[11];
var float	SmokingTimers[11];

var int AmbientSoundID;

var bool Initialized;
var bool FromReLaunch;
var bool LoadingAutosave;

var int XCenter, YCenter;
/*
var MeshActor Model;

var float locx, locy;
var float velx, vely;
*/

//----------------------------------------------------------------------------

function Created()
{
	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;
	local string SaveString;

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

	SmokingWindows[i] = -1;

	Buttons[0].UpTexture =   texture'Main_New_up';
	Buttons[0].DownTexture = texture'Main_New_dn';
	Buttons[0].OverTexture = texture'Main_New_ov';

	Buttons[1].UpTexture =   texture'Main_audio_up';
	Buttons[1].DownTexture = texture'Main_audio_dn';
	Buttons[1].OverTexture = texture'Main_audio_ov';

	Buttons[2].UpTexture =   texture'Main_Controls_up';		
	Buttons[2].DownTexture = texture'Main_Controls_dn';		
	Buttons[2].OverTexture = texture'Main_Controls_ov';		
	
	Buttons[3].UpTexture =   texture'Main_credits_up';		
	Buttons[3].DownTexture = texture'Main_credits_dn';
	Buttons[3].OverTexture = texture'Main_credits_ov';		
	
	Buttons[4].UpTexture =   texture'Main_quit_up';	
	Buttons[4].DownTexture = texture'Main_quit_dn';	
	Buttons[4].OverTexture = texture'Main_quit_ov';	
	
	Buttons[5].UpTexture =   texture'Main_Multiplayer_up';
	Buttons[5].DownTexture = texture'Main_Multiplayer_dn';	
	Buttons[5].OverTexture = texture'Main_Multiplayer_ov';		
	Buttons[5].Style = 5;		
	
	Buttons[6].UpTexture =   texture'Main_sload_up';	
	Buttons[6].DownTexture = texture'Main_sload_dn';
	Buttons[6].OverTexture = texture'Main_sload_ov';

	Buttons[7].UpTexture   = texture'Main_video_up';		
	Buttons[7].DownTexture = texture'Main_video_dn';		
	Buttons[7].OverTexture = texture'Main_video_ov';		

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

	BackToGame.UpTexture   = texture'Main_Back_Up';
	BackToGame.DownTexture = texture'Main_Back_Dn';
	BackToGame.OverTexture = texture'Main_Back_Ov';

	BackToGame.bBurnable = true;
	BackToGame.OverSound=sound'Aeons.Shell_Blacken01';
	
// disconnect button
	Disconnect = ShellButton(CreateWindow(class'ShellButton', 620*RootScaleX, 430*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	Disconnect.TexCoords = NewRegion(0,0,160,64);

	Disconnect.Template = NewRegion( 620, 430, 160, 64);

	Disconnect.Manager = Self;
	Disconnect.Style=5;

	Disconnect.UpTexture   = texture'Main_Disconnect_Up';
	Disconnect.DownTexture = texture'Main_Disconnect_Dn';
	Disconnect.OverTexture = texture'Main_Disconnect_Ov';

	Disconnect.bBurnable = true;
	Disconnect.OverSound=sound'Aeons.Shell_Blacken01';
	
// renewal button
	RenewalButton = ShellButton(CreateWindow(class'ShellButton', 600*RootScaleX, 30*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	RenewalButton.TexCoords = NewRegion(0,0,160,64);

	RenewalButton.Template = NewRegion( 600, 30, 160, 64);

	RenewalButton.Manager = Self;
	RenewalButton.Style=5;

	RenewalButton.UpTexture   = texture'renewal_up';
	RenewalButton.DownTexture = texture'renewal_dn';
	RenewalButton.OverTexture = texture'renewal_ov';

	RenewalButton.bBurnable = true;
	RenewalButton.OverSound=sound'Aeons.Shell_Blacken01';

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

	// Check for a temporary save file, used when the player changes Video Drivers in the middle of the game.
	SaveString = GetPlayerOwner().GetSaveGameList();
	if ((InStr (SaveString, "99,")) >= 0)
	{
		// added default 32 bits by renewal
		GetPlayerOwner().ConsoleCommand("SetRes "$ GetPlayerOwner().ConsoleCommand("GetCurrentRes") $ "x" $ 32);
		FromRelaunch = True;

		LoadingAutosave = ((InStr (SaveString, "99,Autosave")) >= 0);
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

		case RenewalButton:
			SmokingWindows[10] = 1;
			SmokingTimers[10] = 90;
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
	if (!FromRelaunch)
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
	GetPlayerOwner().ClientTravel("start?nosave", TRAVEL_Absolute, false);
	PlayNewScreenSound(); //PlayExitSound();
	//Close(); 
}

function RenewalButtonPressed()
{
	SmokingTimers[10] = 0;
	//GetPlayerOwner().ConsoleCommand("start http://undying.ea.com");
	
	if ( Renewal == None )
		Renewal = Root.CreateWindow(class'RenewalWindow', Root.WinWidth - 400, 100, 300, 200);
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
	//if BackToGame isn't visible we want the shell to stay up
	if ( !BackToGame.bWindowVisible ) 
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
	
	if (FromRelaunch)
	{
		if (!LoadingAutosave)
			VideoPressed();
		GetPlayerOwner().ConsoleCommand("LoadGame 99");
		GetPlayerOwner().ConsoleCommand("DeleteGame 99");
		FromRelaunch=False;
		LoadingAutosave=False;
		return;
	}
	
	Super.Paint(C, X, Y);

	if ( GetPlayerOwner().Level.bLoadBootShellPSX2 )
	{
		BackToGame.HideWindow();
		Disconnect.HideWindow();
	}
	else
	{
		BackToGame.ShowWindow();
		Disconnect.ShowWindow();
	}

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
	Super.PaintSmoke(C, RenewalButton, SmokingWindows[10], SmokingTimers[10]);
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
     BackNames(0)="UndyingShellPC.Main_0"
     BackNames(1)="UndyingShellPC.Main_1"
     BackNames(2)="UndyingShellPC.Main_2"
     BackNames(3)="UndyingShellPC.Main_3"
     BackNames(4)="UndyingShellPC.Main_4"
     BackNames(5)="UndyingShellPC.Main_5"
}
