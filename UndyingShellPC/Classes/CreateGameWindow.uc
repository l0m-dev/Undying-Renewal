//=============================================================================
// CreateGameWindow.
//=============================================================================
class CreateGameWindow expands ShellWindow;


#exec OBJ LOAD FILE=..\sounds\Shell_HUD.uax PACKAGE=Shell_HUD
#exec OBJ LOAD FILE=..\textures\ShellTextures.utx PACKAGE=ShellTextures

//#exec Texture Import File=CreateGame_0.bmp Mips=Off
//#exec Texture Import File=CreateGame_1.bmp Mips=Off
//#exec Texture Import File=CreateGame_2.bmp Mips=Off
//#exec Texture Import File=CreateGame_3.bmp Mips=Off
//#exec Texture Import File=CreateGame_4.bmp Mips=Off
//#exec Texture Import File=CreateGame_5.bmp Mips=Off

//#exec Texture Import File=video_advan_up.bmp Mips=Off
//#exec Texture Import File=video_advan_dn.bmp Mips=Off
//#exec Texture Import File=video_advan_ov.bmp Mips=Off

/* 
//#exec Texture Import File=video_adv_up.bmp Flags=2 Mips=Off
//#exec Texture Import File=video_adv_dn.bmp Flags=2 Mips=Off
//#exec Texture Import File=video_adv_ov.bmp Flags=2 Mips=Off
*/

//#exec Texture Import File=video_ok_up.bmp Mips=Off
//#exec Texture Import File=video_ok_dn.bmp Mips=Off
//#exec Texture Import File=video_ok_ov.bmp Mips=Off

//#exec Texture Import File=video_Cancel_up.bmp Mips=Off
//#exec Texture Import File=video_Cancel_dn.bmp Mips=Off
//#exec Texture Import File=video_Cancel_ov.bmp Mips=Off

//#exec Texture Import File=Video_resol_up.bmp  Mips=Off
//#exec Texture Import File=Video_resol_dn.bmp  Mips=Off
//#exec Texture Import File=Video_resol_ov.bmp  Mips=Off

/*
//#exec Texture Import File=Video_res_up.bmp Flags=2 Mips=Off
//#exec Texture Import File=Video_res_dn.bmp Flags=2 Mips=Off
//#exec Texture Import File=Video_res_ov.bmp Flags=2 Mips=Off
*/
//----------------------------------------------------------------------------

var UWindowWindow AdvCreateGame;

var ShellButton Advanced;
var ShellButton Maps[5]; // Maps currently displayed in the scrollable list
var string MapList[24]; // complete list of available Maps
var int CurrentRow; // current row in scrollable resolution list
var ShellButton OK;
var ShellButton Cancel;
var ShellButton Down;
var ShellButton Up;
var ShellButton Listen, Dedicated;
var ShellButton GameTypeLabel;

var ShellLabel ServerNameLabel;
var ShellLabelAutoWrap MapNameLabel;

var ShellLabel DriverLabel;
var ShellLabel ResLabel;

var ShellSlider MaxPlayersSlider;

var int MaxPlayers;

var string Map;
var string MapName;
var string GameType;
var string GameTypeName;

var localized string DedicatedText, ListenText;

var sound ChangeSound;
var bool bInitialized;
var bool bDedicated;

var int		SmokingWindows[3];
var float	SmokingTimers[3];

var string ScreenShotName;
var ShellBitmap ScreenShot;

var DifficultyWindow DifficultyWindow;

var bool bAdvancedSettingsUpdated;
var AdvCreateGameGeneralPage AdvGameplayPage;

//----------------------------------------------------------------------------

function Created()
{

	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;

	Super.Created();
	
	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	for ( i = 0; i < 3; i++ )
		SmokingWindows[i] = -1;

	Advanced = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	Advanced.Template = NewRegion(566,405,160,64);

	Advanced.TexCoords.X = 0;
	Advanced.TexCoords.Y = 0;
	Advanced.TexCoords.W = 160;
	Advanced.TexCoords.H = 64;

	Advanced.Manager = Self;
	Advanced.Style = 5;

	Advanced.bBurnable = true;
	Advanced.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Advanced.UpTexture =   texture'ShellTextures.video_advan_up';
	Advanced.DownTexture = texture'ShellTextures.video_advan_dn';
	Advanced.OverTexture = texture'ShellTextures.video_advan_ov';
	Advanced.DisabledTexture = None;

	// Max Players Slider
	/*
	MaxPlayersSlider = ShellSlider(CreateWindow(class'ShellSlider', 515*RootScaleX, 386*RootScaleY, 228*RootScaleX, 26*RootScaleY));

	MaxPlayersSlider.TexCoords = NewRegion(0,0,32,32);
	MaxPlayersSlider.Template = NewRegion(515,386,228,26);
	MaxPlayersSlider.SetSlider(0,0,32,32);

	MaxPlayersSlider.SetRange(1.0, 32.0, 1.0);
	MaxPlayersSlider.SetValue(8);

	MaxPlayersSlider.Manager = Self;
	MaxPlayersSlider.Style = 5;

	//UT used this 
	MaxPlayersSlider.bNoSlidingNotify = True;

	MaxPlayersSlider.UpTexture =   texture'aeons.cntrl_slidr';
	MaxPlayersSlider.DownTexture = texture'aeons.cntrl_slidr';
	MaxPlayersSlider.OverTexture = texture'aeons.cntrl_slidr';
	MaxPlayersSlider.DisabledTexture = None;
	*/

// Map buttons
	for( i=0; i<5; i++ )
	{
		Maps[i] = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

		Maps[i].Template = NewRegion(254, 156+(54+5)*i, 204, 54);

		Maps[i].Manager = Self;
		Maps[i].Style = 5;
		Maps[i].TextX = 0;
		Maps[i].TextY = 0;

		Maps[i].Align = TA_Center;

		Maps[i].TexCoords = NewRegion(0,0,204,54);

		Maps[i].UpTexture =   texture'Video_resol_up';
		Maps[i].DownTexture = texture'Video_resol_dn';
		Maps[i].OverTexture = texture'Video_resol_ov';


		TextColor.R = 255;
		TextColor.G = 255;
		TextColor.B = 255;
		Maps[i].SetTextColor(TextColor);
		Maps[i].Font = 4;
	}

	//MapList[] = "MAX BUTTON LENGTH";
	MapList[ 0] = "Manor_FrontGate";	
	MapList[ 1] = "Playground";
	MapList[ 2] = "Catacombs_Cisterns";
	MapList[ 3] = "Catacombs_Entrance";
	MapList[ 4] = "Catacombs_LairOfLizbeth";
	MapList[ 5] = "EternalAutumn_FinalFight_Arch";
	MapList[ 6] = "EternalAutumn_Waterfall_Gauntlet";
	MapList[ 7] = "Grounds_Dock_Night";
	MapList[ 8] = "Grounds_Lighthouse";
	MapList[ 9] = "Grounds_Mausoleum_Approach";
	MapList[10] = "Manor_CentralLower_night";
	MapList[11] = "Manor_Chapel_night";
	MapList[12] = "Manor_FrontGate_Night_Return";
	MapList[13] = "Manor_Gardens_storm";
	MapList[14] = "Manor_WidowsWatch_storm";
	MapList[15] = "Monastery_Past_Church";
	MapList[16] = "Monastery_Present_Church";
	MapList[17] = "Monastery_Present_Entrance";
	MapList[18] = "Oneiros_Amphitheater";
	MapList[19] = "Oneiros_ZigguratInterior";
	MapList[20] = "PiratesCove_Barracks";
	MapList[21] = "PiratesCove_TreasureRoom";
	MapList[22] = "StandingStones_FirstVisit";
	MapList[23] = "StandingStones_KingFight";

// Map scroll buttons
	Up =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	Down =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	Up.Style = 5;
	Down.Style = 5;

	Up.Template =	NewRegion(466,130,64,128);
	Down.Template = NewRegion(466,388,64,128);

	Up.TexCoords = NewRegion(0,0,64,128);
	Down.TexCoords = NewRegion(0,0,64,128);

	Up.bRepeat = True;
	Down.bRepeat = True;

	Up.key_interval = 0.08;
	Down.key_interval = 0.08;

	Up.Manager = Self;
	Down.Manager = Self;

	Up.UpTexture =   texture'Cntrl_upbut_up';
	Up.DownTexture = texture'Cntrl_upbut_dn';
	Up.OverTexture = texture'Cntrl_upbut_ov';
	Up.DisabledTexture = texture'Cntrl_upbut_ds';

	Down.UpTexture =   texture'Cntrl_dnbut_up';
	Down.DownTexture = texture'Cntrl_dnbut_dn';
	Down.OverTexture = texture'Cntrl_dnbut_ov';
	Down.DisabledTexture = texture'Cntrl_dnbut_ds';


// Listen Button
/*
	Listen = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	//Listen.TexCoords.X = NewRegion(0,0,82,36);
	
	// position and size in designed resolution of 800x600
	Listen.Template = NewRegion(550,311,72,36);

	Listen.Manager = Self;
	Listen.Style = 5;
	Listen.Text = ListenText;
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	Listen.SetTextColor(TextColor);
	Listen.Align = TA_Center;
	Listen.Font = 4;


	Listen.TexCoords = NewRegion(0,0,204,54);
	Listen.UpTexture =   None;//texture'Video_Coop_up';
	Listen.DownTexture = None;//texture'Video_Coop_dn';
	Listen.OverTexture = None;//texture'Video_Coop_ov';
	Listen.DisabledTexture = None;


	
// Dedicated button	
	Dedicated = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	//Dedicated.TexCoords.X = NewRegion(0,0,82,36);
	
	// position and size in designed resolution of 800x600
	Dedicated.Template = NewRegion(626,309,105,36);

	Dedicated.Manager = Self;
	Dedicated.Style = 5;
	Dedicated.Text = DedicatedText;
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	Dedicated.SetTextColor(TextColor);
	Dedicated.TextStyle=1;
	Dedicated.Align = TA_Center;
	Dedicated.Font = 4;

	Dedicated.TexCoords = NewRegion(0,0,204,54);
	Dedicated.UpTexture =			None;
	Dedicated.DownTexture =		None;
	Dedicated.OverTexture =		None;
	Dedicated.DisabledTexture =	None;
*/


// Change Dedicated button	
	GameTypeLabel = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));
	
	GameTypeLabel.TexCoords = NewRegion(0,0,204,54);
	GameTypeLabel.Template = NewRegion(556,275,180,48);
	
	GameTypeLabel.Manager = Self;
	GameTypeLabel.Style = 5;
	GameTypeLabel.Text = default.GameTypeName;

	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	GameTypeLabel.SetTextColor(TextColor);
	GameTypeLabel.TextStyle=1;
	GameTypeLabel.Align = TA_Center;
	GameTypeLabel.Font = 4;

	GameTypeLabel.UpTexture =		texture'Video_resol_up';
	GameTypeLabel.DownTexture =		texture'Video_resol_up';
	GameTypeLabel.OverTexture =		texture'Video_resol_ov';
	GameTypeLabel.DisabledTexture =	None;

// OK Button
	OK = ShellButton(CreateWindow(class'ShellButton', 30*RootScaleX, 108*RootScaleY, 138*RootScaleX, 60*RootScaleY));

	OK.TexCoords.X = 0;
	OK.TexCoords.Y = 0;
	OK.TexCoords.W = 138;
	OK.TexCoords.H = 60;

	// position and size in designed resolution of 800x600
	OK.Template = NewRegion(30,394,138,60);

	OK.Manager = Self;
	Ok.Style = 5;

	OK.bBurnable = true;
	OK.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	OK.UpTexture =   texture'ShellTextures.Video_ok_up';
	OK.DownTexture = texture'ShellTextures.Video_ok_dn';
	OK.OverTexture = texture'ShellTextures.Video_ok_ov';
	OK.DisabledTexture = None;

// Cancel Button
	Cancel = ShellButton(CreateWindow(class'ShellButton', 30*RootScaleX, 200*RootScaleY, 138*RootScaleX, 60*RootScaleY));

	Cancel.TexCoords.X = 0;
	Cancel.TexCoords.Y = 0;
	Cancel.TexCoords.W = 138;
	Cancel.TexCoords.H = 60;

	// position and size in designed resolution of 800x600
	Cancel.Template = NewRegion(30,494,138,60);

	Cancel.Manager = Self;
	Cancel.Style = 5;

	Cancel.bBurnable = true;
	Cancel.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Cancel.UpTexture =   texture'ShellTextures.Video_cancel_up';
	Cancel.DownTexture = texture'ShellTextures.Video_cancel_dn';
	Cancel.OverTexture = texture'ShellTextures.Video_cancel_ov';
	Cancel.DisabledTexture = None;

// Server name label
	ServerNameLabel = ShellLabel(CreateWindow(class'ShellLabel', 1,1,1,1));

	ServerNameLabel.Template=NewRegion(566, 200, 158, 38);
	ServerNameLabel.Manager = Self;
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	ServerNameLabel.SetTextColor(TextColor);
	ServerNameLabel.Align = TA_Center;
	ServerNameLabel.Font = F_Normal;

// Map name Label
	MapNameLabel = ShellLabelAutoWrap(CreateWindow(class'ShellLabelAutoWrap', 1,1,1,1));

	MapNameLabel.Template=NewRegion(560, 250, 164, 38);
	MapNameLabel.Manager = Self;
	TextColor.R = 255;
	TextColor.G = 215;
	TextColor.B = 0;
	MapNameLabel.SetTextColor(TextColor);
	MapNameLabel.Align = TA_Center;
	MapNameLabel.Font = F_Normal;
	
//Map screenshot
	ScreenShot = ShellBitmap(CreateWindow(class'ShellBitmap', 10,10,10,10));
	ScreenShot.T = Texture(DynamicLoadObject("Screens.Generic", class'texture'));//Dynamic texture'Black';//Screenshot3';
	ScreenShot.R = NewRegion(0,0,116,88);//Dynamic 256,256);
	ScreenShot.Template = NewRegion(34,184,116,88);
	ScreenShot.bStretch = true;
	ScreenShot.Style = 5;
	ScreenShot.Manager = Self;
	MapNametoScreenShot( default.Map );

	if (AdvCreateGame == None )
	{
		AdvCreateGame = Root.CreateWindow(class'AdvCreateGameWindow', Root.WinWidth - 450, 100, 350, 220);
		AdvCreateGame.HideWindow();

		AdvGameplayPage = AdvCreateGameWindow(AdvCreateGame).GameplayPage;
	}
	
	// initialize resolution list and scroll buttons
	CurrentRow = 0;
	Up.bDisabled = true;
	Down.bDisabled = false;

	Root.Console.bBlackout = True;

	i = AdvGameplayPage.MapCombo.FindItemIndex("Manor_FrontGate", true);
	if (i != -1)
		AdvGameplayPage.MapCombo.SetSelectedIndex(i);

	GetCurrentSettings();
	RefreshButtons();
	Resized();

	bInitialized=True;
}

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			if ( ShellButton(B).bDisabled ) 
				return;
			switch (B)
			{
				case Advanced:
					AdvCreateGamePressed();
					break;

				case OK:
					CreateGamePressed();
					break;

				case Cancel:
					PlayNewScreenSound();
					Close();
					break;

				case Maps[0]:
				case Maps[1]:
				case Maps[2]:
				case Maps[3]:
				case Maps[4]:
					MapClicked(B);	
					break;

				case Up:
					ScrolledUp();
					break;

				case Down:
					ScrolledDown();
					break;

				case GameTypeLabel:
					GameTypePressed();
					break;

				case Listen:
					SetServerMode(false);
					break;

				case Dedicated:
					SetServerMode(true);
					break;
			}
			break;

		case DE_Change:
			switch (B)
			{
				case MaxPlayersSlider:
					MaxPlayersChanged();
					break;
			}
			break;

		case DE_MouseEnter:
			OverEffect(ShellButton(B));
			break;
	}
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{
	switch(Msg)
	{
	case WM_KeyDown:
		if (Key == Root.Console.EInputKey.IK_MWheelUp && !Up.bDisabled)
			ScrolledUp();
		if (Key == Root.Console.EInputKey.IK_MWheelDown && !Down.bDisabled)
			ScrolledDown();
		break;
	}

	Super.WindowEvent(Msg, C, X, Y, Key);
}

function MapNametoScreenShot(string MapName)
{
	if ( InStr(MapName, "Catacombs") >= 0 )
	{
		ScreenShotName = "Screens.Catacomb"; 
	}
	else if ( InStr(MapName, "Cemetery") >= 0 )
	{
		ScreenShotName = "Screens.Cemetery"; 
	}
	else if ( InStr(MapName, "Cottage") >= 0 )
	{
		ScreenShotName = "Screens.Cottage"; 
	}
	else if ( InStr(MapName, "Dock") >= 0 )
	{
		ScreenShotName = "Screens.Dock"; 
	}
	else if ( InStr(MapName, "Eternal") >= 0 )
	{
		ScreenShotName = "Screens.Eternal"; 
	}
	else if ( InStr(MapName, "Lighthouse") >= 0 )
	{
		ScreenShotName = "Screens.Lighthouse";
	}
	else if ( InStr(MapName, "Manor") >= 0 )
	{
		ScreenShotName = "Screens.Manor";
	}
	else if ( InStr(MapName, "Mausoleum") >= 0 )
	{
		ScreenShotName = "Screens.Mausoleum";
	}
	else if ( InStr(MapName, "Oneiros") >= 0 )
	{
		ScreenShotName = "Screens.Oneiros"; 
	}
	else if ( InStr(MapName, "Past") >= 0 )
	{
		ScreenShotName = "Screens.Past"; 
	}
	else if ( (InStr(MapName, "Pirate") >= 0) || (InStr(MapName, "Coastal") >= 0) )
	{
		ScreenShotName = "Screens.Pirate"; 
	}
	else if ( InStr(MapName, "Present") >= 0 )
	{
		ScreenShotName = "Screens.Present"; 
	}
	else if ( InStr(MapName, "Stone") >= 0 )
	{
		ScreenShotName = "Screens.Stone"; 
	}
	else
		ScreenShotName = "Screens.Generic"; 

	ScreenShot.T = Texture(DynamicLoadObject(ScreenShotName, class'texture'));
}

function OverEffect(ShellButton B)
{
	switch (B) 
	{
		case OK:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case Advanced:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;

		case Cancel:
			SmokingWindows[2] = 1;
			SmokingTimers[2] = 90;
			break;
	}
}

function GameTypePressed()
{
	local int GameIndex;
	
	GameIndex = AdvGameplayPage.GameCombo.GetSelectedIndex() + 1;

	if (GameIndex >= AdvGameplayPage.MaxGames)
		GameIndex = 0;

	AdvGameplayPage.GameCombo.SetSelectedIndex(GameIndex);
}

function SetServerMode( bool bMode )
{
	default.bDedicated = bMode;

	if ( default.bDedicated )
	{
		Dedicated.UpTexture = texture'Video_resol_dn';
		Dedicated.OverTexture = texture'Video_resol_dn';
		Dedicated.DownTexture = texture'Video_resol_dn';

		Listen.UpTexture = texture'Video_resol_up';
		Listen.OverTexture = texture'Video_resol_ov';
		Listen.DownTexture = texture'Video_resol_up';
	}
	else
	{
		Dedicated.UpTexture = texture'Video_resol_up';
		Dedicated.OverTexture = texture'Video_resol_ov';
		Dedicated.DownTexture = texture'Video_resol_up';

		Listen.UpTexture = texture'Video_resol_dn';
		Listen.OverTexture = texture'Video_resol_dn';
		Listen.DownTexture = texture'Video_resol_dn';
	}
}

function MapClicked(UWindowWindow B)
{
	default.Map = ShellButton(b).Text;
	default.MapName = FormatString(default.Map, "_", " ");
	MapNametoScreenShot( default.Map );
}

function ScrolledUp()
{
	local int i;
	
	if ( (ChangeSound != none) && bInitialized ) 
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );
	
	CurrentRow--;
	if ( CurrentRow <= 0 ) 
	{
		CurrentRow = 0;
		Up.bDisabled = true;
	}

	if ( CurrentRow < ArrayCount(MapList) - ArrayCount(Maps) )
	{
		Down.bDisabled = false;
	}

	RefreshButtons();

}

function ScrolledDown()
{
	local int i;
	
	if ( (ChangeSound != none) && bInitialized ) 
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );
	
	CurrentRow++;
	if ( CurrentRow + ArrayCount(Maps) >= ArrayCount(MapList) ) 
	{
		Down.bDisabled = true;
	}

	if ( CurrentRow > 0 ) 
	{
		Up.bDisabled = false;
	}

	RefreshButtons();
}

function RefreshButtons()
{
	local int i;

	for( i=0; i<ArrayCount(Maps); i++ )
	{
		Maps[i].SetText(MapList[CurrentRow + i]);
	}

}

function MaxPlayersChanged()
{
	local sound changedsound;

//	changedsound = Sound(DynamicLoadObject("LevelMechanics.Catacombs.A14_WoodCrk02", class'Sound'));

	if ( (ChangeSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( ChangeSound,, 0.25, [Flags]482 );

	MaxPlayers = int(MaxPlayersSlider.Value);
}

function GetCurrentSettings()
{
	//SetServerMode(default.bDedicated);
}

function CreateGamePressed()
{
	local string URL, Checksum;

	URL = default.Map $ "?nosave" $ "?MaxPlayers=" $ MaxPlayers $ "?Game=" $ default.GameType;
	
	class'StatLog'.Static.GetPlayerChecksum(GetPlayerOwner(), Checksum);
	
	if (Checksum == "")
		URL = URL $ "?Checksum=NoChecksum";
	else
		URL = URL $ "?Checksum="$Checksum;

	PlayNewScreenSound();
	
	if (!default.bDedicated)
	{
		URL = URL $ "?Listen";

		GetPlayerOwner().ConsoleCommand("deletesavelevels");
	}

	if (DifficultyWindow == None)
		DifficultyWindow = DifficultyWindow(Root.CreateWindow(class'DifficultyWindow', 100, 100, 200, 200, Self, True));
	else
		DifficultyWindow.ShowWindow();
		
	DifficultyWindow.StartMap = URL;
	DifficultyWindow.bDedicated = default.bDedicated;

	//Close();
	//ParentWindow.Close();
	//MainMenuWindow(AeonsRootWindow(Root).MainMenu).Close();
	
	//Root.Console.bLocked = False;
	//Root.Console.CloseUWindow();
}

function AdvCreateGamePressed()
{
	PlayNewScreenSound();

	if (AdvCreateGame == None ) 
		AdvCreateGame = Root.CreateWindow(class'AdvCreateGameWindow', Root.WinWidth - 450, 100, 350, 220);
	else
		AdvCreateGame.ShowWindow();		
}

function Resized()
{
	local int i;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	//fix might be better to have AeonsRootWindow or UWindowRootWindow know the active window
	// I think there is already a variable for that, i'll look later

	if ( AdvCreateGame != None )
		AdvCreateGame.Resized();

	Advanced.ManagerResized(RootScaleX, RootScaleY);

	if ( OK != None ) 
		OK.ManagerResized(RootScaleX, RootScaleY);

	if ( Cancel != None ) 
		Cancel.ManagerResized(RootScaleX, RootScaleY);

	if ( Up != None ) 
		Up.ManagerResized(RootScaleX, RootScaleY);

	if ( Down != None ) 
		Down.ManagerResized(RootScaleX, RootScaleY);

	//Listen.ManagerResized(RootScaleX, RootScaleY);
	//Dedicated.ManagerResized(RootScaleX, RootScaleY);
	ServerNameLabel.ManagerResized(RootScaleX, RootScaleY);
	MapNameLabel.ManagerResized(RootScaleX, RootScaleY);
	GameTypeLabel.ManagerResized(RootScaleX, RootScaleY);
	ScreenShot.ManagerResized(RootScaleX, RootScaleY);
	
	for ( i=0; i<ArrayCount(Maps); i++ )
	{
		Maps[i].ManagerResized(RootScaleX, RootScaleY);
	}

	if ( MaxPlayersSlider != None ) 
		MaxPlayersSlider.ManagerResized(RootScaleX, RootScaleY);
}


function Paint(Canvas C, float X, float Y)
{
	local int i;
	local color textcolor;

	Super.Paint(C, X, Y);

	Super.PaintSmoke(C, OK, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, Advanced, SmokingWindows[1], SmokingTimers[1]);
	Super.PaintSmoke(C, Cancel, SmokingWindows[2], SmokingTimers[2]);

	MapNameLabel.Text = default.MapName;
	ServerNameLabel.Text = class'Engine.GameReplicationInfo'.default.ServerName;
	GameTypeLabel.Text = default.GameTypeName;

	if ( default.bAdvancedSettingsUpdated )
	{
		default.bAdvancedSettingsUpdated = false;

		default.MapName = FormatString(default.Map, "_", " ");
		MapNametoScreenShot( default.Map );
	}

	for ( i=0; i<ArrayCount(Maps); i++ )
	{
		if ( default.Map ~= Maps[i].Text )
		{
			//DrawStretchedTexture(C, Maps[i].WinLeft, Maps[i].WinTop, Maps[i].WinWidth, Maps[i].WinHeight, texture'Aeons.Particles.SOft_pfx');		
			Maps[i].UpTexture = texture'Video_resol_dn';
			Maps[i].DownTexture = texture'Video_resol_up';
			Maps[i].OverTexture = texture'Video_resol_dn';
		} else {
			Maps[i].UpTexture =   texture'Video_resol_up';
			Maps[i].DownTexture = texture'Video_resol_dn';
			Maps[i].OverTexture = texture'Video_resol_ov';
		}
	}
	
	//DrawStretchedTexture(C, 20, 20, 116, 88, Texture(DynamicLoadObject(ScreenShotName, class'texture')));	

	C.DrawColor = C.Default.DrawColor;
	C.Style = 1;

}

/*
function NotifyBeforeLevelChange()
{
	Super.NotifyBeforeLevelChange();	

	Close();
	ParentWindow.Close();
	MainMenuWindow(AeonsRootWindow(Root).MainMenu).Close();
}
*/


function Close(optional bool bByParent)
{
	if (AdvCreateGame != None)
		AdvCreateGame.HideWindow();
	
	HideWindow();
}


function ShowWindow()
{
	Super.ShowWindow();

	GetCurrentSettings();
	RefreshButtons();
}


function HideWindow()
{
	Root.Console.bBlackOut = False;
	Super.HideWindow();
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     DedicatedText="Dedicated"
     ListenText="Listen"
     ChangeSound=Sound'Shell_HUD.Shell.SHELL_SliderClick'
     BackNames(0)="ShellTextures.CreateGame_0"
     BackNames(1)="ShellTextures.CreateGame_1"
     BackNames(2)="ShellTextures.CreateGame_2"
     BackNames(3)="ShellTextures.CreateGame_3"
     BackNames(4)="ShellTextures.CreateGame_4"
     BackNames(5)="ShellTextures.CreateGame_5"
}
