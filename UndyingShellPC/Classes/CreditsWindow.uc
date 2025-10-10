//=============================================================================
// CreditsWindow.
//=============================================================================
class CreditsWindow expands ShellWindow;

//#exec Texture Import File=Credits_0.bmp Mips=Off
//#exec Texture Import File=Credits_1.bmp Mips=Off
//#exec Texture Import File=Credits_2.bmp Mips=Off
//#exec Texture Import File=Credits_3.bmp Mips=Off
//#exec Texture Import File=Credits_4.bmp Mips=Off
//#exec Texture Import File=Credits_5.bmp Mips=Off

//----------------------------------------------------------------------------

var ShellButton PSX2CreditsButton;
var ShellButton Back;

var ShellButton BradyCheat;
var ShellButton KeebCheat;
var ShellButton DannyCheat;
var ShellButton GalvanCheat;
var ShellButton GoodyCheat;

var UWindowWindow PSX2Credits;

var int		SmokingWindows[2];
var float	SmokingTimers[2];

//----------------------------------------------------------------------------

function Created()
{

	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;

	Super.Created();
	
	SmokingWindows[0] = -1;
	SmokingWindows[1] = -1;

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;
//--	

	PSX2CreditsButton = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	PSX2CreditsButton.Template = NewRegion(650,520,88,51);

	PSX2CreditsButton.TexCoords = NewRegion(0,8,88,51);

	PSX2CreditsButton.Manager = Self;
	PSX2CreditsButton.Style = 5;

	PSX2CreditsButton.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	PSX2CreditsButton.UpTexture =   texture'Book_Right_up';
	PSX2CreditsButton.DownTexture = texture'Book_Right_dn';
	PSX2CreditsButton.OverTexture = texture'Book_Right_ov';
	PSX2CreditsButton.DisabledTexture = None;




	Back = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	Back.Template = NewRegion(465,520,88,51);

	Back.TexCoords = NewRegion(0,0,88,51);

	Back.Manager = Self;
	Back.Style = 5;

	Back.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Back.UpTexture =   texture'Book_Left_up';
	Back.DownTexture = texture'Book_Left_dn';
	Back.OverTexture = texture'Book_Left_ov';
	Back.DisabledTexture = None;

// play "brady's been drinkin' "
	BradyCheat = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	BradyCheat.Template = NewRegion( 328, 363, 16, 18);
	//BradyCheat.UpTexture = texture'defaulttexture';
	BradyCheat.Manager = Self;

	KeebCheat = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	KeebCheat.Template = NewRegion( 378, 84, 16, 18);
	//KeebCheat.UpTexture = texture'defaulttexture';
	KeebCheat.Manager = Self;

	DannyCheat = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	DannyCheat.Template = NewRegion( 62, 120, 16, 18);
	//DannyCheat.UpTexture = texture'defaulttexture';
	DannyCheat.Manager = Self;

	GalvanCheat = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	GalvanCheat.Template = NewRegion( 358, 383, 16, 18);
	//GalvanCheat.UpTexture = texture'defaulttexture';
	GalvanCheat.Manager = Self;

	GoodyCheat = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	GoodyCheat.Template = NewRegion( 310, 106, 16, 18);
	//GoodyCheat.UpTexture = texture'defaulttexture';
	GoodyCheat.Manager = Self;

//--
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
				case PSX2CreditsButton:
					ShowPSX2Credits();
					break;

				case Back:
					PlayNewScreenSound();
					Close();
					break;
			}
			break;

		case DE_RClick:
			switch(B)
			{
				case BradyCheat:
					GetPlayerOwner().PlaySound( Sound(DynamicLoadObject("Voiceover.Maids.SMAI_007", class'Sound')), SLOT_None, 1.0, [Flags]499 );
					break;

				case KeebCheat:
					GetPlayerOwner().PlaySound( Sound(DynamicLoadObject("Voiceover.Misc.Keeb", class'Sound')), SLOT_None, 1.0, [Flags]499 );
					break;

				case DannyCheat:
					GetPlayerOwner().PlaySound( Sound(DynamicLoadObject("Voiceover.Sedgewick.Sed_016", class'Sound')), SLOT_None, 1.0, [Flags]499 );
					break;
				
				case GalvanCheat:
					GetPlayerOwner().PlaySound( Sound(DynamicLoadObject("CreatureSFX.Donkey.C_DonkeyV04", class'Sound')), SLOT_None, 1.0, [Flags]499 );
					break;

				case GoodyCheat:
					GetPlayerOwner().PlaySound( Sound(DynamicLoadObject("Voiceover.Lith.Lith1_002", class'Sound')), SLOT_None, 1.0, [Flags]499 );
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

//----------------------------------------------------------------------------

function OverEffect(ShellButton B)
{
	// we changed to arrows which don't burn
	return;

	switch (B) 
	{
		case Back:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case PSX2CreditsButton:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;
	}
}

//----------------------------------------------------------------------------

function ShowPSX2Credits()
{
	PlayNewScreenSound();

	if ( PSX2Credits== None )
		PSX2Credits = ManagerWindow(Root.CreateWindow(class'PSX2CreditsWindow', 100, 100, 200, 200, Root, True));
	else
		PSX2Credits.ShowWindow();

}

//----------------------------------------------------------------------------

function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C,X,Y);

	// we changed to arrows which don't burn
	return;

	Super.PaintSmoke(C, Back, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, PSX2CreditsButton, SmokingWindows[1], SmokingTimers[1]);

//	Log("CreditsWindow: Paint");
}

//----------------------------------------------------------------------------

function Resized()
{
	local int W, H, XMod, YMod, i;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	if ( PSX2Credits != None )
		PSX2Credits.Resized();

	PSX2CreditsButton.ManagerResized(RootScaleX, RootScaleY);
	Back.ManagerResized(RootScaleX, RootScaleY);

	BradyCheat.ManagerResized(RootScaleX, RootScaleY);
	KeebCheat.ManagerResized(RootScaleX, RootScaleY);
	DannyCheat.ManagerResized(RootScaleX, RootScaleY);
	GalvanCheat.ManagerResized(RootScaleX, RootScaleY);
	GoodyCheat.ManagerResized(RootScaleX, RootScaleY);
}

//----------------------------------------------------------------------------

function Close(optional bool bByParent)
{
	HideWindow();
}

//----------------------------------------------------------------------------

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
     BackNames(0)="ShellTextures.Credits_0"
     BackNames(1)="ShellTextures.Credits_1"
     BackNames(2)="ShellTextures.Credits_2"
     BackNames(3)="ShellTextures.Credits_3"
     BackNames(4)="ShellTextures.Credits_4"
     BackNames(5)="ShellTextures.Credits_5"
}
