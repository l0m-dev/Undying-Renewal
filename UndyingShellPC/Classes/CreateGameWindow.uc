//=============================================================================
// CreateGameWindow.
//=============================================================================
class CreateGameWindow expands ShellWindow;


#exec OBJ LOAD FILE=\aeons\sounds\Shell_HUD.uax PACKAGE=Shell_HUD

#exec Texture Import File=Video_0.bmp Mips=Off
#exec Texture Import File=CreateGame_1.bmp Mips=Off
#exec Texture Import File=CreateGame_2.bmp Mips=Off
#exec Texture Import File=Video_3.bmp Mips=Off
#exec Texture Import File=Video_4.bmp Mips=Off
#exec Texture Import File=CreateGame_5.bmp Mips=Off

#exec Texture Import File=video_advan_up.bmp Mips=Off
#exec Texture Import File=video_advan_dn.bmp Mips=Off
#exec Texture Import File=video_advan_ov.bmp Mips=Off

/* 
#exec Texture Import File=video_adv_up.bmp Flags=2 Mips=Off
#exec Texture Import File=video_adv_dn.bmp Flags=2 Mips=Off
#exec Texture Import File=video_adv_ov.bmp Flags=2 Mips=Off
*/

#exec Texture Import File=video_ok_up.bmp Mips=Off
#exec Texture Import File=video_ok_dn.bmp Mips=Off
#exec Texture Import File=video_ok_ov.bmp Mips=Off

#exec Texture Import File=video_Cancel_up.bmp Mips=Off
#exec Texture Import File=video_Cancel_dn.bmp Mips=Off
#exec Texture Import File=video_Cancel_ov.bmp Mips=Off

#exec Texture Import File=Video_resol_up.bmp  Mips=Off
#exec Texture Import File=Video_resol_dn.bmp  Mips=Off
#exec Texture Import File=Video_resol_ov.bmp  Mips=Off

/*
#exec Texture Import File=Video_res_up.bmp Flags=2 Mips=Off
#exec Texture Import File=Video_res_dn.bmp Flags=2 Mips=Off
#exec Texture Import File=Video_res_ov.bmp Flags=2 Mips=Off
*/
//----------------------------------------------------------------------------

var UWindowWindow AdvCreateGame;

var ShellButton Advanced;
var ShellButton Maps[5]; // Maps currently displayed in the scrollable list
var string MapList[112]; // complete list of available Maps
var int CurrentRow; // current row in scrollable resolution list
var ShellButton OK;
var ShellButton Cancel;
var ShellButton Down;
var ShellButton Up;
var ShellButton SinglePlayer, Multiplayer;
var ShellButton ChangeDedicated;

var ShellLabel LocalIPLabel;
var ShellLabel IpLabel;

var ShellSlider MaxPlayersSlider;

var int MaxPlayers;

var string map;
var string URL;

var localized string DedicatedText, ListenText;

var sound ChangeSound;
var bool bInitialized;
var bool bSinglePlayer;
var bool bDedicated;

var int		SmokingWindows[3];
var float	SmokingTimers[3];

var string ScreenShotName;
var ShellBitmap ScreenShot;

//----------------------------------------------------------------------------

function Created()
{

	local int i;
	local color TextColor;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;
	
	if(!bInitialized) {
		bSinglePlayer = true;
		bDedicated = false;
	}

	Super.Created();
	
	AeonsRoot = AeonsRootWindow(Root);

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}

	RootScaleX = AeonsRoot.ScaleX;
	RootScaleY = AeonsRoot.ScaleY;

	for ( i = 0; i < 3; i++ )
		SmokingWindows[i] = -1;

	Advanced = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	Advanced.Template = NewRegion(35,108,160,64);

	Advanced.TexCoords.X = 0;
	Advanced.TexCoords.Y = 0;
	Advanced.TexCoords.W = 160;
	Advanced.TexCoords.H = 64;

	Advanced.Manager = Self;
	Advanced.Style = 5;

	Advanced.bBurnable = true;
	Advanced.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Advanced.UpTexture =   texture'video_advan_up';
	Advanced.DownTexture = texture'video_advan_dn';
	Advanced.OverTexture = texture'video_advan_ov';
	Advanced.DisabledTexture = None;

	// Max Players Slider
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

MapList[ 0] = "SmokeTest";	
MapList[ 1] = "Playground";
MapList[ 2] = "Catacombs_Cisterns";
MapList[ 3] = "Catacombs_Cliffs";
MapList[ 4] = "Catacombs_Entrance";
MapList[ 5] = "Catacombs_Exit";
MapList[ 6] = "Catacombs_Exit_After";
MapList[ 7] = "Catacombs_LairOfLizbeth";
MapList[ 8] = "Catacombs_LairOfLizbethPostCU";
MapList[ 9] = "Catacombs_LowerLevel";
MapList[10] = "Catacombs_SaintsHall";
MapList[11] = "Catacombs_Tunnels";
MapList[12] = "Catacombs_WellRoom";
MapList[13] = "Catacombs_WindChamber";
MapList[14] = "EternalAutumn_FinalFight_Arch";
MapList[15] = "EternalAutumn_FinalFight_Arena";
MapList[16] = "EternalAutumn_FinalFight_ArenaBattle";
MapList[17] = "EternalAutumn_FinalFight_Ruins";
MapList[18] = "EternalAutumn_Ravines_Airie_Interior";
MapList[19] = "EternalAutumn_Ravines_Bridge";
MapList[20] = "EternalAutumn_Ravines_Chase";
MapList[21] = "EternalAutumn_Ravines_Chieftain";
MapList[22] = "EternalAutumn_Ravines_Forest";
MapList[23] = "EternalAutumn_Transition";
MapList[24] = "EternalAutumn_Waterfall_Dwellings_Lower";
MapList[25] = "EternalAutumn_Waterfall_Dwellings_Upper";
MapList[26] = "EternalAutumn_Waterfall_Gauntlet";
MapList[27] = "Grounds_Cottage";
MapList[28] = "grounds_dock_night";
MapList[29] = "Grounds_Lighthouse";
MapList[30] = "Grounds_Mausoleum_Approach";
MapList[31] = "Grounds_Mausoleum_Entrance";
MapList[32] = "Grounds_Mausoleum_Tunnels";
MapList[33] = "Grounds_OldCemetery";
MapList[34] = "Manor_CentralLower";
MapList[35] = "Manor_CentralLower_After";
MapList[36] = "Manor_CentralLower_night";
MapList[37] = "Manor_CentralLower_storm";
MapList[38] = "Manor_CentralUpper";
MapList[39] = "Manor_CentralUpper_After";
MapList[40] = "Manor_CentralUpper_PostOneiros";
MapList[41] = "Manor_CentralUpper_storm";
MapList[42] = "Manor_Chapel";
MapList[43] = "Manor_Chapel_night";
MapList[44] = "Manor_Crypt";
MapList[45] = "Manor_EastWingLower";
MapList[46] = "Manor_EastWingLower_After";
MapList[47] = "Manor_EastWingLower_night";
MapList[48] = "Manor_EastWingUpper";
MapList[49] = "Manor_EastWingUpper_After";
MapList[50] = "Manor_EastWingUpper_night";
MapList[51] = "Manor_EntranceHall";
MapList[52] = "Manor_EntranceHall_FromKitch";
MapList[53] = "Manor_EntranceHall_Intro";
MapList[54] = "Manor_EntranceHall_Night";
MapList[55] = "Manor_EntranceHall_night_ReturnfromCove";
MapList[56] = "Manor_EntranceHall_Storm";
MapList[57] = "Manor_EntranceHall_ToKitch";
MapList[58] = "Manor_FrontGate";
MapList[59] = "Manor_FrontGate_night";
MapList[60] = "Manor_FrontGate_Night_Return";
MapList[61] = "Manor_Gardens";
MapList[62] = "Manor_Gardens_night";
MapList[63] = "Manor_Gardens_storm";
MapList[64] = "Manor_GreatHall_night";
MapList[65] = "Manor_GreatHall_Storm";
MapList[66] = "Manor_InnerCourtyard";
MapList[67] = "Manor_InnerCourtyard_Storm";
MapList[68] = "Manor_NorthWingLower";
MapList[69] = "Manor_NorthWingLower_After";
MapList[70] = "Manor_NorthWingLower_night";
MapList[71] = "Manor_NorthWingLower_storm";
MapList[72] = "Manor_NorthWingUpper";
MapList[73] = "Manor_NorthWingUpper_night";
MapList[74] = "Manor_NorthWingUpper_PostOneiros";
MapList[75] = "Manor_NorthWingUpper_storm";
MapList[76] = "Manor_PatricksRoom";
MapList[77] = "Manor_TowerRun_night";
MapList[78] = "Manor_TowerRun_storm";
MapList[79] = "Manor_WestWing";
MapList[80] = "Manor_WestWing_Hall1";
MapList[81] = "Manor_WestWing_Night";
MapList[82] = "Manor_WidowsWatch_storm";
MapList[83] = "Monastery_Past_Church";
MapList[84] = "Monastery_Past_Exterior";
MapList[85] = "Monastery_Past_Interior";
MapList[86] = "Monastery_Past_LivingQuarters";
MapList[87] = "Monastery_Present_Church";
MapList[88] = "Monastery_Present_Cove";
MapList[89] = "Monastery_Present_Entrance";
MapList[90] = "Monastery_Present_InnerSanctum";
MapList[91] = "Monastery_Present_Tunnels";
MapList[92] = "Oneiros_Amphitheater";
MapList[93] = "Oneiros_City1";
MapList[94] = "Oneiros_City2";
MapList[95] = "Oneiros_HowlingWell";
MapList[96] = "Oneiros_Intro";
MapList[97] = "Oneiros_Oracle";
MapList[98] = "Oneiros_RetreatBath";
MapList[99] = "Oneiros_RetreatExterior";
MapList[100] = "Oneiros_RetreatSecondFloor";
MapList[101] = "Oneiros_RetreatStudio";
MapList[102] = "Oneiros_ZigguratInterior";
MapList[103] = "Oneiros_ZigguratLower";
MapList[104] = "Oneiros_ZigguratUpper";
MapList[105] = "PiratesCove_Barracks";
MapList[106] = "PiratesCove_Exterior";
MapList[107] = "PiratesCove_Pier";
MapList[108] = "PiratesCove_Pool";
MapList[109] = "PiratesCove_TreasureRoom";
MapList[110] = "StandingStones_FirstVisit";
MapList[111] = "StandingStones_KingFight";
	
	map = "SmokeTest";
	URL = "SmokeTest";

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


// SinglePlayer Button
	SinglePlayer = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	//SinglePlayer.TexCoords.X = NewRegion(0,0,82,36);
	
	// position and size in designed resolution of 800x600
	SinglePlayer.Template = NewRegion(550,311,82,36);

	SinglePlayer.Manager = Self;
	SinglePlayer.Style = 5;
	SinglePlayer.Text = "Singleplayer";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	SinglePlayer.SetTextColor(TextColor);
	SinglePlayer.Align = TA_Center;
	SinglePlayer.Font = 4;


	SinglePlayer.TexCoords = NewRegion(0,0,204,54);
	SinglePlayer.UpTexture =   None;//texture'Video_SinglePlayer_up';
	SinglePlayer.DownTexture = None;//texture'Video_SinglePlayer_dn';
	SinglePlayer.OverTexture = None;//texture'Video_SinglePlayer_ov';
	SinglePlayer.DisabledTexture = None;


	
// Multiplayer button	
	Multiplayer = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	//Multiplayer.TexCoords.X = NewRegion(0,0,82,36);
	
	// position and size in designed resolution of 800x600
	Multiplayer.Template = NewRegion(644,309,82,36);

	Multiplayer.Manager = Self;
	Multiplayer.Style = 5;
	Multiplayer.Text = "Deathmatch";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	Multiplayer.SetTextColor(TextColor);
	Multiplayer.TextStyle=1;
	Multiplayer.Align = TA_Center;
	Multiplayer.Font = 4;

	Multiplayer.TexCoords = NewRegion(0,0,204,54);
	Multiplayer.UpTexture =			None;
	Multiplayer.DownTexture =		None;
	Multiplayer.OverTexture =		None;
	Multiplayer.DisabledTexture =	None;


// Change Dedicated button	
	ChangeDedicated = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));
	
	ChangeDedicated.TexCoords = NewRegion(0,0,204,54);
	ChangeDedicated.Template = NewRegion(556,260,180,48);
	
	ChangeDedicated.Manager = Self;
	ChangeDedicated.Style = 5;
	ChangeDedicated.Text = ListenText;

	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	ChangeDedicated.SetTextColor(TextColor);
	ChangeDedicated.TextStyle=1;
	ChangeDedicated.Align = TA_Center;
	ChangeDedicated.Font = 4;

	ChangeDedicated.UpTexture =		texture'Video_resol_up';
	ChangeDedicated.DownTexture =		texture'Video_resol_up';
	ChangeDedicated.OverTexture =		texture'Video_resol_ov';
	ChangeDedicated.DisabledTexture =	None;

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

	OK.UpTexture =   texture'Video_ok_up';
	OK.DownTexture = texture'Video_ok_dn';
	OK.OverTexture = texture'Video_ok_ov';
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

	Cancel.UpTexture =   texture'Video_cancel_up';
	Cancel.DownTexture = texture'Video_cancel_dn';
	Cancel.OverTexture = texture'Video_cancel_ov';
	Cancel.DisabledTexture = None;

// Local IP label
	LocalIPLabel = ShellLabel(CreateWindow(class'ShellLabel', 1,1,1,1));

	LocalIPLabel.Template=NewRegion(566, 183, 158, 38);
	LocalIPLabel.Manager = Self;
	LocalIPLabel.Text = "Local IP";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	LocalIPLabel.SetTextColor(TextColor);
	LocalIPLabel.Align = TA_Center;
	LocalIPLabel.Font = 4;

//Ip label
	IpLabel = ShellLabel(CreateWindow(class'ShellLabel', 1,1,1,1));

	IpLabel.Template=NewRegion(566, 218, 158, 38);
	IpLabel.Manager = Self;
	IpLabel.Text = "127.0.0.1";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	IpLabel.SetTextColor(TextColor);
	IpLabel.Align = TA_Center;
	IpLabel.Font = 4;
	
//Map screenshot
	ScreenShot = ShellBitmap(CreateWindow(class'ShellBitmap', 10,10,10,10));
	ScreenShot.T = Texture(DynamicLoadObject("Screens.Generic", class'texture'));//Dynamic texture'Black';//Screenshot3';
	ScreenShot.R = NewRegion(0,0,116,88);//Dynamic 256,256);
	ScreenShot.Template = NewRegion(40,280,116,88);
	ScreenShot.bStretch = true;
	ScreenShot.Style = 5;
	ScreenShot.Manager = Self;
	
	// initialize resolution list and scroll buttons
	CurrentRow = 0;
	Up.bDisabled = true;
	Down.bDisabled = false;

	Root.Console.bBlackout = True;

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
					URL = map $ "?Listen?nosave?-nointro?Difficulty=2" $ "?MaxPlayers=" $ MaxPlayers;
					
					if (bSinglePlayer)
						URL = URL $ "?Game=Aeons.SinglePlayer";
					else
						URL = URL $ "?Game=Aeons.DeathMatchGame";
					
					if(bDedicated)
						GetPlayerOwner().ConsoleCommand("RELAUNCH " $ URL $ "-server");
					else {
						//GetPlayerOwner().ConsoleCommand("start " $ URL);  
						//GetPlayerOwner().ConsoleCommand("addall"); // needs a delay...
	
						GetPlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);

						GetPlayerOwner().Level.bLoadBootShellPSX2 = true;
					}

					PlayNewScreenSound();
					Close();
					ParentWindow.Close();
					
					MainMenuWindow(AeonsRootWindow(Root).MainMenu).Close();
					//AeonsRootWindow(Root).MainMenu.Close();
					//MainMenuWindow(AeonsRootWindow(Root).MainMenu).Multiplayer
					//MainMenuWindow(AeonsRootWindow(Root).MainMenu).Single.Close();
					//MainMenuWindow(AeonsRootWindow(Root).MainMenu).StopShellAmbient();
					
					//Root.Console.bLocked = False;
					//Root.Console.CloseUWindow();
					
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
					ResolutionClicked(B);	
					break;

				case Up:
					ScrolledUp();
					break;

				case Down:
					ScrolledDown();
					break;

				case SinglePlayer:
					SetSingleplayer(true);
					break;

				case Multiplayer:
					SetSingleplayer(false);
					break;
					
				case ChangeDedicated:
					ChangeDedicatedPressed();
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

function SetSingleplayer( bool SP )
{
		bSinglePlayer = SP;

		if ( bSinglePlayer )
		{
			SinglePlayer.UpTexture = texture'Video_resol_dn';
			SinglePlayer.OverTexture = texture'Video_resol_dn';
			SinglePlayer.DownTexture = texture'Video_resol_dn';

			Multiplayer.UpTexture = texture'Video_resol_up';
			Multiplayer.OverTexture = texture'Video_resol_ov';
			Multiplayer.DownTexture = texture'Video_resol_up';
		}
		else
		{
			Multiplayer.UpTexture = texture'Video_resol_dn';
			Multiplayer.OverTexture = texture'Video_resol_dn';
			Multiplayer.DownTexture = texture'Video_resol_dn';

			SinglePlayer.UpTexture = texture'Video_resol_up';
			SinglePlayer.OverTexture = texture'Video_resol_ov';
			SinglePlayer.DownTexture = texture'Video_resol_up';
		}
}

function ChangeDedicatedPressed()
{
	bDedicated = !bDedicated;
	
	if (bDedicated)
		ChangeDedicated.Text = DedicatedText;
	else
		ChangeDedicated.Text = ListenText;
}

function ResolutionClicked(UWindowWindow B)
{
	map = ShellButton(b).Text;
	MapNametoScreenShot( map );
}

function ScrolledUp()
{
	local int i;

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
		Maps[i].Text = MapList[CurrentRow + i];
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
	if ( bSinglePlayer )
	{
		SinglePlayer.UpTexture = texture'Video_resol_dn';
		SinglePlayer.OverTexture = texture'Video_resol_dn';
		SinglePlayer.DownTexture = texture'Video_resol_dn';

		Multiplayer.UpTexture = texture'Video_resol_up';
		Multiplayer.OverTexture = texture'Video_resol_ov';
		Multiplayer.DownTexture = texture'Video_resol_up';
	}
	else
	{
		Multiplayer.UpTexture = texture'Video_resol_dn';
		Multiplayer.OverTexture = texture'Video_resol_dn';
		Multiplayer.DownTexture = texture'Video_resol_dn';

		SinglePlayer.UpTexture = texture'Video_resol_up';
		SinglePlayer.OverTexture = texture'Video_resol_ov';
		SinglePlayer.DownTexture = texture'Video_resol_up';
	}
}

function AdvCreateGamePressed()
{
	PlayNewScreenSound();

	if (AdvCreateGame == None ) 
		AdvCreateGame = ManagerWindow(Root.CreateWindow(class'AdvCreateGameWindow', 100, 100, 200, 200, Root, True));
	else
		AdvCreateGame.ShowWindow();		
}

function Resized()
{
	local int i;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}

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

	SinglePlayer.ManagerResized(RootScaleX, RootScaleY);
	Multiplayer.ManagerResized(RootScaleX, RootScaleY);
	LocalIPLabel.ManagerResized(RootScaleX, RootScaleY);
	IpLabel.ManagerResized(RootScaleX, RootScaleY);
	ChangeDedicated.ManagerResized(RootScaleX, RootScaleY);
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


	for ( i=0; i<ArrayCount(Maps); i++ )
	{
		if ( map ~= Maps[i].Text )
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


function Close(optional bool bByParent)
{
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
     ChangeSound=Sound'Shell_HUD.Shell.SHELL_SliderClick'
     BackNames(0)="UndyingShellPC.Video_0"
     BackNames(1)="UndyingShellPC.CreateGame_1"
     BackNames(2)="UndyingShellPC.CreateGame_2"
     BackNames(3)="UndyingShellPC.Video_3"
     BackNames(4)="UndyingShellPC.Video_4"
     BackNames(5)="UndyingShellPC.CreateGame_5"
	 DedicatedText="Dedicated Server"
     ListenText="Listen Server"
}
