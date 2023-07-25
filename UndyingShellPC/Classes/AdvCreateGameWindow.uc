//=============================================================================
// AdvCreateGameWindow.
//=============================================================================
class AdvCreateGameWindow expands ShellWindow;

//#exec OBJ LOAD FILE=\aeons\sounds\Shell_HUD.uax PACKAGE=Shell_HUD

#exec Texture Import File=AdvCreateGame_0.bmp Mips=Off
#exec Texture Import File=AdvCreateGame_1.bmp Mips=Off
//#exec Texture Import File=AdvVideo_2.bmp Mips=Off
#exec Texture Import File=AdvCreateGame_3.bmp Mips=Off
#exec Texture Import File=AdvCreateGame_4.bmp Mips=Off
//#exec Texture Import File=AdvVideo_5.bmp Mips=Off

var ShellButton OK;
var ShellButton Cancel;
var ShellCheckbox	CheckBoxes[8];
var ShellTextBox TextBox;

var() sound CheckboxSound;

var bool bInitialized;
var bool bSaveChanges;

var int		SmokingWindows[2];
var float	SmokingTimers[2];

function Created()
{

	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;

	Super.Created();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;

	SmokingWindows[0] = -1;
	SmokingWindows[1] = -1;

	// CheckBoxes for Shadows and Decals
	for ( i = 0; i < 8; i++ )
	{
		CheckBoxes[i] = ShellCheckbox(CreateWindow(class'ShellCheckBox', 1,1,1,1));
		
		CheckBoxes[i].TexCoords = NewRegion(0,0,39,37);
		CheckBoxes[i].Manager = Self;

		CheckBoxes[i].UpTexture =   None;
		CheckBoxes[i].DownTexture = texture'audio_x';
		CheckBoxes[i].OverTexture = None;
		CheckBoxes[i].DisabledTexture = None;
	}

	CheckBoxes[0].Template = NewRegion(240,182,39,37);
	CheckBoxes[1].Template = NewRegion(240,242,39,37);
	CheckBoxes[2].Template = NewRegion(240,302,39,37);
	CheckBoxes[3].Template = NewRegion(240,362,39,37);
	CheckBoxes[4].Template = NewRegion(440,182,39,37);
	CheckBoxes[5].Template = NewRegion(440,242,39,37);
	CheckBoxes[6].Template = NewRegion(686,192,39,37);
	CheckBoxes[7].Template = NewRegion(686,285,39,37);

// OK Button
	OK = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	OK.TexCoords.X = 0;
	OK.TexCoords.Y = 0;
	OK.TexCoords.W = 160;
	OK.TexCoords.H = 60;

	// position and size in designed resolution of 800x600
	OK.Template = NewRegion(30,475,160,60);

	OK.Manager = Self;
	Ok.Style = 5;

	OK.bBurnable = true;
	OK.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	OK.UpTexture =   texture'Cntrl_ok_up';
	OK.DownTexture = texture'Cntrl_ok_dn';
	OK.OverTexture = texture'Cntrl_ok_ov';
	OK.DisabledTexture = None;

// Cancel Button
	Cancel = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	Cancel.TexCoords = NewRegion(0,0,160,60);

	// position and size in designed resolution of 800x600
	Cancel.Template = NewRegion(30,535,160,60);

	Cancel.Manager = Self;
	Cancel.Style = 5;

	Cancel.bBurnable = true;
	Cancel.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Cancel.UpTexture =   texture'Cntrl_cancl_up';
	Cancel.DownTexture = texture'Cntrl_cancl_dn';
	Cancel.OverTexture = texture'Cntrl_cancl_ov';
	Cancel.DisabledTexture = None;
	
	TextBox = ShellTextBox(CreateWindow(class'ShellTextBox', 48*RootScaleX, 130*RootScaleY, 500*RootScaleX, 128*RootScaleY));

	//TextBox.TexCoords = NewRegion(0,0,500,128);
	TextBox.Template = NewRegion(48,130,500,128);
	TextBox.Font = 2;
	TextBox.Value = GetPlayerOwner().PlayerReplicationInfo.PlayerName;
	TextBox.CaretOffset = Len(TextBox.Value);

	TextBox.Manager = Self;

	Root.Console.bBlackout = True;
	Resized();

	GetCurrentSettings();
	bInitialized=True;
}

function GetCurrentSettings()
{
	local int i;

	CheckBoxes[0].bChecked = GetPlayerOwner().Level.Game.bCoopWeaponMode;
	CheckBoxes[1].bChecked = DeathMatchGame(GetPlayerOwner().Level.Game).bMegaSpeed;
	CheckBoxes[2].bChecked = GetPlayerOwner().Level.Game.bNoCheating;
	CheckBoxes[3].bChecked = DeathMatchGame(GetPlayerOwner().Level.Game).bHardCoreMode;
	CheckBoxes[4].bChecked = GetPlayerOwner().Level.Game.bNoMonsters;
	CheckBoxes[5].bChecked = DeathMatchGame(GetPlayerOwner().Level.Game).bChangeLevels;
	CheckBoxes[6].bChecked = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager ActorShadows"));
	CheckBoxes[7].bChecked = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager Decals"));
	TextBox.Value = GetPlayerOwner().Level.Game.GameReplicationInfo.ServerName;

	// default will be to save changes--only discard changes if cancel is clicked
	bSaveChanges = True;
}

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case OK:
					bSaveChanges = true;
					PlayNewScreenSound();
					Close();
					break;

				case Cancel:
					bSaveChanges = false;
					PlayNewScreenSound();
					Close();
					break;
			}
			break;

		case DE_Change:
			Changed();
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
		case OK:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case Cancel:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;
	}
}

function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C, X, Y);

	Super.PaintSmoke(C, OK, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, Cancel, SmokingWindows[1], SmokingTimers[1]);
}

function Changed()
{
	if ( (CheckboxSound != none) && bInitialized )
		GetPlayerOwner().PlaySound( CheckboxSound,, 0.25, [Flags]482 );
}

function SaveChanges()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager ActorShadows " $ Checkboxes[6].bChecked );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Decals " $ Checkboxes[7].bChecked );
	
	GetPlayerOwner().Level.Game.bCoopWeaponMode = CheckBoxes[0].bChecked;
	DeathMatchGame(GetPlayerOwner().Level.Game).bMegaSpeed = CheckBoxes[1].bChecked;
	GetPlayerOwner().Level.Game.bNoCheating = CheckBoxes[2].bChecked;
	DeathMatchGame(GetPlayerOwner().Level.Game).bHardCoreMode = CheckBoxes[3].bChecked;
	GetPlayerOwner().Level.Game.bNoMonsters = CheckBoxes[4].bChecked;
	DeathMatchGame(GetPlayerOwner().Level.Game).bChangeLevels = CheckBoxes[5].bChecked;
	GetPlayerOwner().Level.Game.GameReplicationInfo.ServerName = TextBox.Value;
	
	GetPlayerOwner().Level.Game.SaveConfig(); 
	DeathMatchGame(GetPlayerOwner().Level.Game).SaveConfig();
	GetPlayerOwner().Level.Game.GameReplicationInfo.SaveConfig();
}

function Resized()
{
	local int i;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	for ( i = 0; i < 8; i++ )
		if ( Checkboxes[i] != None )
			Checkboxes[i].ManagerResized(RootScaleX, RootScaleY);

	if ( OK != None ) 
		OK.ManagerResized(RootScaleX, RootScaleY);

	if ( Cancel != None ) 
		Cancel.ManagerResized(RootScaleX, RootScaleY);
		
	if ( TextBox != None )
		TextBox.ManagerResized(RootScaleX, RootScaleY);
}


function Close(optional bool bByParent)
{
	if ( bSaveChanges ) 
		SaveChanges();

	bSaveChanges = false;

	HideWindow();
}


function HideWindow()
{
	Root.Console.bBlackOut = False;
	Super.HideWindow();
}

function ShowWindow()
{
	Super.ShowWindow();

	GetCurrentSettings();
}

defaultproperties
{
     CheckboxSound=Sound'Shell_HUD.Shell.SHELL_CheckBox'
     BackNames(0)="UndyingShellPC.AdvCreateGame_0"
     BackNames(1)="UndyingShellPC.AdvCreateGame_1"
     BackNames(2)="UndyingShellPC.AdvVideo_2"
     BackNames(3)="UndyingShellPC.AdvCreateGame_3"
     BackNames(4)="UndyingShellPC.AdvCreateGame_4"
     BackNames(5)="UndyingShellPC.AdvVideo_5"
}
