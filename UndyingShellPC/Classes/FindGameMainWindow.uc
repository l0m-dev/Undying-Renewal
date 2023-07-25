//=============================================================================
// PlayerSetupWindow.
//=============================================================================
class FindGameMainWindow expands ShellWindow;

//#exec Texture Import File=PSetup_0.bmp Mips=Off
//#exec Texture Import File=PSetup_1.bmp Mips=Off
//#exec Texture Import File=PSetup_2.bmp Mips=Off
//#exec Texture Import File=PSetup_3.bmp Mips=Off
//#exec Texture Import File=PSetup_4.bmp Mips=Off
//#exec Texture Import File=PSetup_5.bmp Mips=Off

//#exec Texture Import File=psetup_ok_ov.BMP	Mips=Off Flags=2
//#exec Texture Import File=psetup_ok_up.BMP	Mips=Off Flags=2
//#exec Texture Import File=psetup_ok_dn.BMP	Mips=Off Flags=2

function Created()
{
	local int i;
	
	Super.Created();
	bAlwaysOnTop = True;
	
	SetAcceptsFocus();
	FocusWindow();
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
	local int i;

	Root.Console.bBlackOut = False;
	Super.HideWindow();

	for ( i=0; i<6; i++ )
	{
		if ( Back[i] != None )
			GetPlayerOwner().UnloadTexture( Back[i] );
	}

}



function Paint(Canvas C, float X, float Y) 
{
	local float OldFov;

	C.Style = GetPlayerOwner().ERenderStyle.STY_Modulated;
	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
	Super.Paint(C, X, Y);
}



//----------------------------------------------------------------------------

function ShowWindow()
{
	Super.ShowWindow();
	BringToFront();
}