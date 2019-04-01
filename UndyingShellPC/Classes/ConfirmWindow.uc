//=============================================================================
// ConfirmWindow.
//=============================================================================
class ConfirmWindow expands ShellWindow;

#exec Texture Import File=Confirm_L.bmp Mips=Off
#exec Texture Import File=Confirm_R.bmp Mips=Off

#exec Texture Import File=Confirm_yes_up.bmp Mips=Off
#exec Texture Import File=Confirm_yes_ov.bmp Mips=Off
#exec Texture Import File=Confirm_yes_dn.bmp Mips=Off

#exec Texture Import File=Confirm_no_up.bmp Mips=Off
#exec Texture Import File=Confirm_no_ov.bmp Mips=Off
#exec Texture Import File=Confirm_no_dn.bmp Mips=Off

//----------------------------------------------------------------------------

var ShellWindow Owner;
var UWindowWindow QuestionWindow;

var ShellButton Yes;
var ShellButton No;

var int		SmokingWindows[2];
var float	SmokingTimers[2];

//----------------------------------------------------------------------------

function Created()
{
	local int i;
	local color TextColor;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Created();
	
	AeonsRoot = AeonsRootWindow(Root);

	SmokingWindows[0] = -1;
	SmokingWindows[1] = -1;

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}

	RootScaleX = AeonsRoot.ScaleX;
	RootScaleY = AeonsRoot.ScaleY;
//--	

	Yes = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	Yes.Template = NewRegion(225,300,160,64);

	Yes.TexCoords = NewRegion(0, 0, 160, 64);

	Yes.Manager = Self;
	Yes.Style = 5;
	
	Yes.bBurnable = true;
	Yes.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Yes.UpTexture =   texture'Video_ok_up';
	Yes.DownTexture = texture'Video_ok_dn';
	Yes.OverTexture = texture'Video_ok_ov';



	No = ShellButton(CreateWindow(class'ShellButton', 1,1,1,1));

	No.Template = NewRegion(425,300,160,64);

	No.TexCoords = NewRegion(0, 0, 160, 64);

	No.Manager = Self;
	No.Style = 5;

	No.bBurnable = true;
	No.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	No.UpTexture =   texture'Video_cancel_up';
	No.DownTexture = texture'Video_cancel_dn';
	No.OverTexture = texture'Video_cancel_ov';


//--
	Root.Console.bBlackout = True;
	Resized();
}

//----------------------------------------------------------------------------

function YesPressed()
{
	log("YesPressed: Owner=" $ Owner);

	if ( Owner != None ) 
	{
		Owner.QuestionAnswered(QuestionWindow, 1);
		QuestionWindow = None;
		Owner = None;
		Close();
	}
}

//----------------------------------------------------------------------------

function NoPressed()
{
	if ( Owner != None ) 
	{
		Owner.QuestionAnswered(QuestionWindow, 2);
		QuestionWindow = None;
		Owner = None;
		Close();
	}

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
				case Yes:
					YesPressed();
					break;

				case No:
					NoPressed();
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
	switch (B) 
	{
		case Yes:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case No:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;
	}
}

//----------------------------------------------------------------------------

function Paint(Canvas C, float X, float Y)
{
	local int XOffset, YOffset, W, H;
	local float TileWidth, TileHeight;
	local int i;

	for ( i=0; i<2; i++ )
	{
		if (Back[i] == None ) 
			Back[i]=texture(DynamicLoadObject(BackNames[i], class'texture'));

		// probably unnecessary, but if any texture is missing, just return ( this frame )
		if (Back[i] == None )
			return;
	}
	
	TileWidth = WinWidth / 3;
	TileHeight = WinHeight / 2;

	C.DrawColor = BackColor;
	
	C.bNoSmooth = false;

	DrawStretchedTextureSegment( C, TileWidth/2, TileHeight/2, TileWidth, TileHeight, 1, 1, 254, 254, Back[0] );
	DrawStretchedTextureSegment( C, TileWidth/2+TileWidth, TileHeight/2, TileWidth, TileHeight, 1, 1, 254, 254, Back[1] );

	C.DrawColor = C.Default.DrawColor;

	Super.PaintSmoke(C, Yes, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, No, SmokingWindows[1], SmokingTimers[1]);
}

//----------------------------------------------------------------------------

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
	else
	{
		RootScaleX = 1.0;
		RootScaleY = 1.0;
	}

	Yes.ManagerResized(RootScaleX, RootScaleY);
	No.ManagerResized(RootScaleX, RootScaleY);
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
     BackNames(0)="UndyingShellPC.Confirm_L"
     BackNames(1)="UndyingShellPC.Confirm_R"
}
