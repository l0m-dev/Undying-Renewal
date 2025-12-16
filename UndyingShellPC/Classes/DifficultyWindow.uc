//=============================================================================
// DifficultyWindow.
//=============================================================================
class DifficultyWindow expands ShellWindow;

//#exec Texture Import File=Difficulty_0.bmp Mips=Off
//#exec Texture Import File=Difficulty_1.bmp Mips=Off
//#exec Texture Import File=Difficulty_2.bmp Mips=Off
//#exec Texture Import File=Difficulty_3.bmp Mips=Off
//#exec Texture Import File=Difficulty_4.bmp Mips=Off
//#exec Texture Import File=Difficulty_5.bmp Mips=Off

//#exec Texture Import File=dfclt_mediu_up.bmp	Mips=Off
//#exec Texture Import File=dfclt_mediu_ov.bmp	Mips=Off
//#exec Texture Import File=dfclt_mediu_dn.bmp	Mips=Off

//#exec Texture Import File=dfclt_cancl_up.bmp	Mips=Off
//#exec Texture Import File=dfclt_cancl_ov.bmp	Mips=Off
//#exec Texture Import File=dfclt_cancl_dn.bmp	Mips=Off

//#exec Texture Import File=dfclt_easy_up.bmp		Mips=Off
//#exec Texture Import File=dfclt_easy_ov.bmp		Mips=Off
//#exec Texture Import File=dfclt_easy_dn.bmp		Mips=Off

//#exec Texture Import File=dfclt_nightm_up.bmp	Mips=Off
//#exec Texture Import File=dfclt_nightm_ov.bmp	Mips=Off
//#exec Texture Import File=dfclt_nightm_dn.bmp	Mips=Off

#exec Texture Import File=Textures\dfclt_ultra_nightm_ov.bmp	Mips=Off

var string StartMap;

var() ShellButton Buttons[4];
var int		SmokingWindows[5];
var float	SmokingTimers[5];

var ShellButton Advanced;
var bool bShowMutators;

struct MutatorInfo
{
	var string MutatorName;
	var string MutatorClass;
	var bool   bEnabled;
};

var config string Mutators;

var string MutatorBaseClass;

var ShellLabelAutoWrap MutatorsLabel;
var ShellLabelAutoWrap MutatorsHintLabel;
var ShellButton InfoButton;
var ShellButton MutatorsButtons[5]; // mutators currently displayed in the scrollable list
var MutatorInfo MutatorList[250]; // complete list of available mutators
var int CurrentRow; // current row in scrollable resolution list
var ShellButton Down;
var ShellButton Up;
var int NumberOfMutators;

var bool bDedicated;

var localized string SelectMutatorsText;
var localized string AboutText;

var ShellButton UltraNightmareButton;
var float UltraNightmareTimer;
var ParticleFX BloodFX;
var UWindowWindow Confirm;

var bool bCanMouseActivateUltraNightmare;
var bool bControllerViewPressed;

function Created()
{

	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;

	Super.Created();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;
//--
	
	Buttons[0] = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	Buttons[1] = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	Buttons[2] = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	Buttons[3] = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));

	Buttons[0].Template = NewRegion(229,46,142,64);
	Buttons[1].Template = NewRegion(392,214,164,64);
	Buttons[2].Template = NewRegion(214,385,162,85);
	Buttons[3].Template = NewRegion(57,208,154,74);

	for ( i=0; i<ArrayCount(Buttons); i++ )
	{
		Buttons[i].bBurnable = true;
		Buttons[i].OverSound=sound'Shell_HUD.Shell_Blacken01';	

		Buttons[i].Manager = Self;
		Buttons[i].Style = 5;
	}

	for ( i=0; i<ArrayCount(SmokingWindows); i++ )
	{
		SmokingWindows[i] = -1;
	}

	Buttons[0].TexCoords = NewRegion(0,0,142,64);

	Buttons[0].UpTexture =   texture'ShellTextures.dfclt_easy_up';
	Buttons[0].DownTexture = texture'ShellTextures.dfclt_easy_dn';
	Buttons[0].OverTexture = texture'ShellTextures.dfclt_easy_ov';


	Buttons[1].TexCoords = NewRegion(0,0,164,64);

	Buttons[1].UpTexture =   texture'ShellTextures.dfclt_nightm_up';		
	Buttons[1].DownTexture = texture'ShellTextures.dfclt_nightm_dn';		
	Buttons[1].OverTexture = texture'ShellTextures.dfclt_nightm_ov';		


	Buttons[2].TexCoords = NewRegion(0,0,162,85);

	Buttons[2].UpTexture =   texture'ShellTextures.dfclt_cancl_up';		
	Buttons[2].DownTexture = texture'ShellTextures.dfclt_cancl_dn';
	Buttons[2].OverTexture = texture'ShellTextures.dfclt_cancl_ov';		


	Buttons[3].TexCoords = NewRegion(0,0,154,74);

	Buttons[3].UpTexture =   texture'ShellTextures.dfclt_mediu_up';
	Buttons[3].DownTexture = texture'ShellTextures.dfclt_mediu_dn';
	Buttons[3].OverTexture = texture'ShellTextures.dfclt_mediu_ov';
	
	// Advanced button
	Advanced = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	Advanced.Template = NewRegion(620,30,160,64);

	Advanced.TexCoords = NewRegion(0,0,160,64);

	Advanced.Manager = Self;
	Advanced.Style = 5;

	Advanced.bBurnable = true;
	Advanced.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Advanced.UpTexture =   texture'ShellTextures.video_advan_up';
	Advanced.DownTexture = texture'ShellTextures.video_advan_dn';
	Advanced.OverTexture = texture'ShellTextures.video_advan_ov';
	Advanced.DisabledTexture = None;

	Advanced.bDrawShadow = true;
	
	// Mutator buttons
	for( i=0; i<ArrayCount(MutatorsButtons); i++ )
	{
		MutatorsButtons[i] = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

		MutatorsButtons[i].Template = NewRegion(584, 156+(54+5)*i, 204, 54);

		MutatorsButtons[i].Manager = Self;
		MutatorsButtons[i].Style = 5;
		MutatorsButtons[i].TextX = 0;
		MutatorsButtons[i].TextY = 0;
		MutatorsButtons[i].bDisabled = True;
		
		MutatorsButtons[i].Align = TA_Center;

		MutatorsButtons[i].TexCoords = NewRegion(0,0,204,54);

		MutatorsButtons[i].UpTexture =   texture'Video_resol_up';
		MutatorsButtons[i].DownTexture = texture'Video_resol_dn';
		MutatorsButtons[i].OverTexture = texture'Video_resol_ov';


		TextColor.R = 255;
		TextColor.G = 255;
		TextColor.B = 255;
		MutatorsButtons[i].SetTextColor(TextColor);
		MutatorsButtons[i].Font = 4;
	}

// Mutator scroll buttons
	Up =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	Down =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	Up.Style = 5;
	Down.Style = 5;

	Up.Template =	NewRegion(538,130,64,128);
	Down.Template = NewRegion(538,388,64,128);

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
	
	MutatorsLabel = ShellLabelAutoWrap(CreateWindow(class'ShellLabelAutoWrap', 1,1,1,1));

	MutatorsLabel.Template=NewRegion(564, 100, 244, 54);
	MutatorsLabel.Manager = Self;
	MutatorsLabel.Text = SelectMutatorsText;
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	MutatorsLabel.SetTextColor(TextColor);
	MutatorsLabel.Align = TA_Center;
	MutatorsLabel.Font = 4;
	
	MutatorsHintLabel = ShellLabelAutoWrap(CreateWindow(class'ShellLabelAutoWrap', 1,1,1,1));

	MutatorsHintLabel.Template=NewRegion(564, 116, 244, 54);
	MutatorsHintLabel.Manager = Self;
	MutatorsHintLabel.Text = "";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	MutatorsHintLabel.SetTextColor(TextColor);
	MutatorsHintLabel.Align = TA_Center;
	MutatorsHintLabel.Font = 4;

// Ultra-Nightmare button
	UltraNightmareButton = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	UltraNightmareButton.Template = NewRegion(253,213,84,84);
	UltraNightmareButton.TexCoords = NewRegion(22,22,84,84);
	UltraNightmareButton.OverSound= sound'Shell_HUD.HUD.SHELL_Scroll';
	UltraNightmareButton.Manager = Self;
	UltraNightmareButton.Style = 5;
	UltraNightmareButton.UpTexture =   None;
	UltraNightmareButton.DownTexture = texture'dfclt_ultra_nightm_ov';
	UltraNightmareButton.OverTexture = texture'dfclt_ultra_nightm_ov';
	UltraNightmareButton.bDisabled = true;

// Info button	
	InfoButton = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));
	InfoButton.Template = NewRegion(620,120,130,36);

	InfoButton.Manager = Self;
	InfoButton.Style = 5;
	InfoButton.Text = AboutText;
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	InfoButton.SetTextColor(TextColor);
	InfoButton.TextStyle=1;
	InfoButton.Align = TA_Center;
	InfoButton.Font = 4;
	InfoButton.TexCoords = NewRegion(0,0,204,54);
	InfoButton.UpTexture = texture'Video_resol_up';
	InfoButton.OverTexture = texture'Video_resol_ov';
	InfoButton.DownTexture = texture'Video_resol_dn';
	InfoButton.DisabledTexture =	None;

	// set which button is activated by pressing space, without reordering code above
	Buttons[3].ActivateWindow(0, false);
	
	SetMutatorsVisible(false);
	LoadMutators();
	RefreshButtons();
	
	//--
	Root.Console.bBlackout = True;

	Resized();
}

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_Click:
		case DE_DoubleClick:
			switch (B)
			{
				case Buttons[0]:
					StartGame(0); //easy
					break;

				case Buttons[1]:
					StartGame(2); //nightmare
					break;	

				case Buttons[2]:
					PlayNewScreenSound();
					Close();
					break;

				case Buttons[3]:
					StartGame(1);	//medium
					break;

				case UltraNightmareButton:
					if (!UltraNightmareButton.bDisabled)
						ShowConfirm(UltraNightmareButton);	//ultra-nightmare
					break;

				case Advanced:
					AdvancedPressed();
					break;

				case InfoButton:
					InfoPressed();
					break;

				// mutator stuff
				case MutatorsButtons[0]:
				case MutatorsButtons[1]:
				case MutatorsButtons[2]:
				case MutatorsButtons[3]:
				case MutatorsButtons[4]:
					MutatorClicked(B);	
					break;

				case Up:
					if (!Up.bDisabled)
						ScrolledUp();
					break;

				case Down:
					if (!Down.bDisabled)
						ScrolledDown();
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
		case DE_MouseMove:
			bCanMouseActivateUltraNightmare = true;
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
		if (Key == Root.Console.EInputKey.IK_Joy16)
			bControllerViewPressed = true;
		break;
	case WM_KeyUp:
		if (Key == Root.Console.EInputKey.IK_Joy16)
			bControllerViewPressed = false;
		break;
	}

	Super.WindowEvent(Msg, C, X, Y, Key);
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

		case Advanced:
			SmokingWindows[4] = 1;
			SmokingTimers[4] = 90;
			break;
	}
}

function Paint(Canvas C, float X, float Y)
{
	local int i, j;
	local string mName;
	local vector ParticleLoc;
	local RenewalConfig RenewalConfig;
	
	Super.Paint(C, X, Y);

	for ( i = 0; i < ArrayCount(Buttons); i++ )
		Super.PaintSmoke(C, Buttons[i], SmokingWindows[i], SmokingTimers[i]);
	
	Super.PaintSmoke(C, Advanced, SmokingWindows[4], SmokingTimers[4]);

	// mutator stuff
	for ( i=0; i < NumberOfMutators; i++ )
	{
		for (j = 0; j < ArrayCount(MutatorList); j++)
		{
			if (MutatorList[j].MutatorName == MutatorList[CurrentRow + i].MutatorName)
			{
				if ( MutatorList[j].bEnabled )
				{
					//DrawStretchedTexture(C, MutatorsButtons[i].WinLeft, MutatorsButtons[i].WinTop, MutatorsButtons[i].WinWidth, MutatorsButtons[i].WinHeight, texture'Aeons.Particles.SOft_pfx');		
					MutatorsButtons[i].UpTexture = texture'Video_resol_dn';
					MutatorsButtons[i].DownTexture = texture'Video_resol_up';
					MutatorsButtons[i].OverTexture = texture'Video_resol_dn';
				} else {
					MutatorsButtons[i].UpTexture =   texture'Video_resol_up';
					MutatorsButtons[i].DownTexture = texture'Video_resol_dn';
					MutatorsButtons[i].OverTexture = texture'Video_resol_ov';
				}
				break;
			}
		}
	}

	if ( UltraNightmareTimer > 0 )
	{
		if ( (UltraNightmareButton.MouseIsOver() && bCanMouseActivateUltraNightmare) || bControllerViewPressed )
		{
			UltraNightmareTimer -= LastDelta;

			if ( UltraNightmareTimer < 1.0 )
			{
				C.Style = 5;
				C.DrawColor.R = 255;
				C.DrawColor.G = 255;
				C.DrawColor.B = 255;
				C.DrawColor.A = byte((1.0 - UltraNightmareTimer) * 255);
				DrawStretchedTextureSegment( C, UltraNightmareButton.WinLeft, UltraNightmareButton.WinTop, UltraNightmareButton.WinWidth, UltraNightmareButton.WinHeight, UltraNightmareButton.TexCoords.X, UltraNightmareButton.TexCoords.Y, UltraNightmareButton.TexCoords.W, UltraNightmareButton.TexCoords.H, UltraNightmareButton.OverTexture );
			}

			if ( UltraNightmareTimer <= 0 )
			{
				UltraNightmareButton.bDisabled = false;
				GetPlayerOwner().PlaySound( Sound(DynamicLoadObject("CreatureSFX.Kiesinger.C_Kies_Laugh1", class'Sound')), SLOT_Interface, [Pitch]1.0, [Flags]482 );

				if ( BloodFX == None )
				{
					BloodFX = GetPlayerOwner().Spawn(class'Aeons.BloodyMandorlaParticleFX');
					BloodFX.bShellOnly = true;
					BloodFX.bSteadyState = true;
					BloodFX.LifeTime.Base = 5;
					BloodFX.ParticlesAlive = 50;
					BloodFX.SizeWidth.Base = 64;
					BloodFX.SizeLength.Base = 64;
				}

				RenewalConfig = GetPlayerOwner().GetRenewalConfig();
				RenewalConfig.bUnlockedUltraNightmare = true;
				RenewalConfig.SaveConfig();
			}
		}
		else
		{
			UltraNightmareTimer = default.UltraNightmareTimer;
		}
	}
	else if ( BloodFX != None )
	{
		if ( UltraNightmareButton.MouseIsOver() || bControllerViewPressed )
		{
			BloodFX.ParticlesPerSec.Base = 4;
			BloodFX.ParticlesPerSec.Rand = 4;
		}
		else
		{
			BloodFX.ParticlesPerSec.Base = 0;
			BloodFX.ParticlesPerSec.Rand = 0;
		}
	}

	if ( BloodFX != None )
	{
		BloodFX.SizeWidth.Base = 64 * Root.ScaleY;
		BloodFX.SizeLength.Base = 64 * Root.ScaleY;
		
		ParticleLoc.X = InnerLeft + 293 * Root.ScaleY;
		ParticleLoc.Y = InnerTop + 253 * Root.ScaleY;
		ParticleLoc.Z = 10.0; 
		
		BloodFX.SetRotation( rot(16400,0,0));
		BloodFX.SetLocation( ParticleLoc );

		C.DrawClippedActorFixedFov(BloodFX, 90, false, C.SizeX/Root.GUIScale, C.SizeY/Root.GUIScale, 0, 0, true);
	}
}

function StartGame( int Difficulty )
{
	local string URL;
	local string mutatorClassString;
	local bool setFirstMutator;
	local int i;
	
	for (i = 0; i < ArrayCount(MutatorList); i++)
	{
		if (MutatorList[i].bEnabled)
		{
			if (!setFirstMutator)
			{
				setFirstMutator = true;
				mutatorClassString = MutatorList[i].MutatorClass;
			}
			else
			{
				mutatorClassString = mutatorClassString $ "," $ MutatorList[i].MutatorClass;
			}
		}
	}
	
	PlayNewScreenSound();

	URL = StartMap $ "?nosave?Difficulty=" $ Difficulty;

	if (mutatorClassString != "")
		URL = URL $ "?mutator=" $ mutatorClassString;

	// allow main menu to close
	GetPlayerOwner().Level.bLoadBootShellPSX2 = false;

	Close();
	ParentWindow.Close();
	MainMenuWindow(AeonsRootWindow(Root).MainMenu).StopShellAmbient();//Close();

	//AeonsRootWindow(Root).MainMenu.ShowWindow();
	Root.Console.bLocked = False;

	Root.Console.CloseUWindow();

	if (OwnerWindow != Root)
		OwnerWindow.NotifyBeforeLevelChange();
	
	if (bDedicated)
	{
		GetPlayerOwner().ConsoleCommand("RELAUNCH" @ URL @ "-server -nointro");
	}
	else
	{
		GetPlayerOwner().ConsoleCommand("deletesavelevels");
		GetPlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);
	}
}


function Resized()
{
	local int W, H, XMod, YMod, i;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;
	
	for ( i=0; i<ArrayCount(Buttons); i++ )
	{
		Buttons[i].ManagerResized(RootScaleX, RootScaleY);
	}

	Advanced.ManagerResized(RootScaleX, RootScaleY);
	
	// mutator stuff

	if ( Up != None ) 
		Up.ManagerResized(RootScaleX, RootScaleY);

	if ( Down != None ) 
		Down.ManagerResized(RootScaleX, RootScaleY);
	
	for ( i=0; i<ArrayCount(MutatorsButtons); i++ )
	{
		MutatorsButtons[i].ManagerResized(RootScaleX, RootScaleY);
	}
	
	MutatorsLabel.ManagerResized(RootScaleX, RootScaleY);
	MutatorsHintLabel.ManagerResized(RootScaleX, RootScaleY);
	InfoButton.ManagerResized(RootScaleX, RootScaleY);

	UltraNightmareButton.ManagerResized(RootScaleX, RootScaleY);

	if ( Confirm != None ) 
		Confirm.Resized();
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

// mutator stuff

function LoadMutators()
{
	local int NumMutatorClasses;
	local string NextMutator, NextDesc, MutatorName, HelpText;
	//local UMenuMutatorList I;
	//local string MutatorList;
	local int j;
	local int k;
	
	//DynamicLoadObject(MutatorBaseClass, class'Class');
	//DynamicLoadObject("QuakeMovement.MovementMutator", class'Class');
		
	GetPlayerOwner().GetNextIntDesc(MutatorBaseClass, 0, NextMutator, NextDesc);
	while( NextMutator != "" && (NumMutatorClasses < 200) )
	{		
		MutatorList[NumMutatorClasses].MutatorClass = NextMutator;

		k = InStr(NextDesc, ",");
		if(k == -1)
		{
			MutatorName = NextDesc;
			HelpText = "";
		}
		else
		{
			MutatorName = Left(NextDesc, k);
			HelpText = Mid(NextDesc, k+1);
		}
		
		MutatorList[NumMutatorClasses].MutatorName = MutatorName;
		
		NumMutatorClasses++;
		GetPlayerOwner().GetNextIntDesc(MutatorBaseClass, NumMutatorClasses, NextMutator, NextDesc);
	}
	NumberOfMutators = NumMutatorClasses + 1;
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

	if ( CurrentRow < ArrayCount(MutatorList) - NumberOfMutators )
	{
		Down.bDisabled = false;
	}

	RefreshButtons();
}

function ScrolledDown()
{
	local int i;

	CurrentRow++;
	if ( CurrentRow + NumberOfMutators >= ArrayCount(MutatorList) ) 
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
	local string mName;
	
	for( i=0; i<ArrayCount(MutatorsButtons); i++ )
	{
		mName = MutatorList[CurrentRow + i].MutatorName;
		if (mName != "")
		{
			MutatorsButtons[i].Text = mName;
			MutatorsButtons[i].bDisabled = MutatorList[CurrentRow + i].bEnabled;
		}
	}
	
	if ( NumberOfMutators < 2 )
	{
		MutatorsButtons[0].Text = "";
		MutatorsButtons[0].bDisabled = True;
		
		MutatorsLabel.Text = "";
		MutatorsHintLabel.Text = "";
	}
	
	if ( ArrayCount(MutatorsButtons) >= NumberOfMutators )
	{
		Up.bDisabled = True;
		Down.bDisabled = True;
		
		Up.DisabledTexture = None;
		Down.DisabledTexture = None;
	}
}

function SetMutatorsVisible(bool bShow)
{
	local int i;

	if ( bShowMutators == bShow )
		return;

	bShowMutators = bShow;

	if ( bShowMutators )
	{
		MutatorsLabel.ShowWindow();
		MutatorsHintLabel.ShowWindow();
		InfoButton.ShowWindow();
		Up.ShowWindow();
		Down.ShowWindow();

		for( i=0; i<ArrayCount(MutatorsButtons); i++ )
		{
			MutatorsButtons[i].ShowWindow();
		}
	}
	else
	{
		MutatorsLabel.HideWindow();
		MutatorsHintLabel.HideWindow();
		InfoButton.HideWindow();
		Up.HideWindow();
		Down.HideWindow();

		for( i=0; i<ArrayCount(MutatorsButtons); i++ )
		{
			MutatorsButtons[i].HideWindow();
		}
	}
}

function AdvancedPressed()
{
	PlayNewScreenSound();
	SetMutatorsVisible(!bShowMutators);
}

function InfoPressed()
{
	// open a file relative to System
	class'StatLog'.static.BrowseRelativeLocalURL("../What are mutators.pdf");
}

function MutatorClicked(UWindowWindow B)
{
	local string mName;
	local string mClass;
	local int i;
	
	mName = ShellButton(b).Text;
	
	for (i = 0; i < ArrayCount(MutatorList); i++)
	{
		if (MutatorList[i].MutatorName == mName)
		{
			MutatorList[i].bEnabled = !MutatorList[i].bEnabled;
			break;
		}
	}
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
	switch( W ) 
	{
		case UltraNightmareButton:
			// answered yes
			if ( Answer == 1 ) 
			{
				StartGame(3);
			}
			break;
	}
}

defaultproperties
{
     StartMap="CU_01"
     BackNames(0)="ShellTextures.Difficulty_0"
     BackNames(1)="ShellTextures.Difficulty_1"
     BackNames(2)="ShellTextures.Difficulty_2"
     BackNames(3)="ShellTextures.Difficulty_3"
     BackNames(4)="ShellTextures.Difficulty_4"
     BackNames(5)="ShellTextures.Difficulty_5"
     MutatorBaseClass="Engine.Mutator"
     SelectMutatorsText="SELECT MUTATORS"
     AboutText="About"
     bShowMutators=True
     UltraNightmareTimer=3.0
     bAllowControllerCursor=True
}
