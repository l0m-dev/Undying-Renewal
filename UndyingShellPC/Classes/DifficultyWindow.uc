//=============================================================================
// DifficultyWindow.
//=============================================================================
class DifficultyWindow expands ShellWindow;

#exec Texture Import File=Difficulty_0.bmp Mips=Off
#exec Texture Import File=Difficulty_1.bmp Mips=Off
#exec Texture Import File=Difficulty_2.bmp Mips=Off
#exec Texture Import File=Difficulty_3.bmp Mips=Off
#exec Texture Import File=Difficulty_4.bmp Mips=Off
#exec Texture Import File=Difficulty_5.bmp Mips=Off

#exec Texture Import File=dfclt_mediu_up.bmp	Mips=Off
#exec Texture Import File=dfclt_mediu_ov.bmp	Mips=Off
#exec Texture Import File=dfclt_mediu_dn.bmp	Mips=Off

#exec Texture Import File=dfclt_cancl_up.bmp	Mips=Off
#exec Texture Import File=dfclt_cancl_ov.bmp	Mips=Off
#exec Texture Import File=dfclt_cancl_dn.bmp	Mips=Off

#exec Texture Import File=dfclt_easy_up.bmp		Mips=Off
#exec Texture Import File=dfclt_easy_ov.bmp		Mips=Off
#exec Texture Import File=dfclt_easy_dn.bmp		Mips=Off

#exec Texture Import File=dfclt_nightm_up.bmp	Mips=Off
#exec Texture Import File=dfclt_nightm_ov.bmp	Mips=Off
#exec Texture Import File=dfclt_nightm_dn.bmp	Mips=Off

var localized string StartMap;

var() ShellButton Buttons[4];
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
//--
	
	Buttons[0] = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	Buttons[1] = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	Buttons[2] = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	Buttons[3] = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));

	Buttons[0].Template = NewRegion(229,46,142,64);
	Buttons[1].Template = NewRegion(392,214,164,64);
	Buttons[2].Template = NewRegion(214,385,162,85);
	Buttons[3].Template = NewRegion(57,208,154,74);

	for ( i=0; i<4; i++ )
	{
		SmokingWindows[i] = -1;

		Buttons[i].bBurnable = true;
		Buttons[i].OverSound=sound'Shell_HUD.Shell_Blacken01';	

		Buttons[i].Manager = Self;
		Buttons[i].Style = 5;
	}

	Buttons[0].TexCoords = NewRegion(0,0,142,64);

	Buttons[0].UpTexture =   texture'dfclt_easy_up';
	Buttons[0].DownTexture = texture'dfclt_easy_dn';
	Buttons[0].OverTexture = texture'dfclt_easy_ov';


	Buttons[1].TexCoords = NewRegion(0,0,164,64);

	Buttons[1].UpTexture =   texture'dfclt_nightm_up';		
	Buttons[1].DownTexture = texture'dfclt_nightm_dn';		
	Buttons[1].OverTexture = texture'dfclt_nightm_ov';		


	Buttons[2].TexCoords = NewRegion(0,0,162,85);

	Buttons[2].UpTexture =   texture'dfclt_cancl_up';		
	Buttons[2].DownTexture = texture'dfclt_cancl_dn';
	Buttons[2].OverTexture = texture'dfclt_cancl_ov';		


	Buttons[3].TexCoords = NewRegion(0,0,154,74);

	Buttons[3].UpTexture =   texture'dfclt_mediu_up';
	Buttons[3].DownTexture = texture'dfclt_mediu_dn';
	Buttons[3].OverTexture = texture'dfclt_mediu_ov';
	
//--
	Root.Console.bBlackout = True;

	Resized();
}

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
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
	}
}

function Paint(Canvas C, float X, float Y)
{
	local int i;

	Super.Paint(C, X, Y);

	for ( i = 0; i < 4; i++ )
		Super.PaintSmoke(C, Buttons[i], SmokingWindows[i], SmokingTimers[i]);
}

function StartGame( int Difficulty )
{
	local string URL;
	
	PlayNewScreenSound();

	URL = StartMap $ "?nosave?Difficulty=" $ Difficulty;
	//ParentWindow.Close();

	Close();
	MainMenuWindow(AeonsRootWindow(Root).MainMenu).Single.Close();
	MainMenuWindow(AeonsRootWindow(Root).MainMenu).StopShellAmbient();//Close();

	//AeonsRootWindow(Root).MainMenu.ShowWindow();
	Root.Console.bLocked = False;

	Root.Console.CloseUWindow();
	
	//GetPlayerOwner().ConsoleCommand("deletesavelevels");
	GetPlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);

	GetPlayerOwner().Level.bLoadBootShellPSX2 = false;
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
	
	for ( i=0; i<4; i++ )
	{
		Buttons[i].ManagerResized(RootScaleX, RootScaleY);
	}

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
     StartMap="CU_01"
     BackNames(0)="UndyingShellPC.Difficulty_0"
     BackNames(1)="UndyingShellPC.Difficulty_1"
     BackNames(2)="UndyingShellPC.Difficulty_2"
     BackNames(3)="UndyingShellPC.Difficulty_3"
     BackNames(4)="UndyingShellPC.Difficulty_4"
     BackNames(5)="UndyingShellPC.Difficulty_5"
}
