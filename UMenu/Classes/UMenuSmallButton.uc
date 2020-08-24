class UMenuSmallButton extends UWindowButton;

//#exec TEXTURE IMPORT NAME=SmallButtonDisabled FILE=Textures\SmallButtonDisabled.pcx GROUP="Icons" MIPS=OFF
//#exec TEXTURE IMPORT NAME=SmallButtonDown FILE=Textures\SmallButtonDown.pcx GROUP="Icons" MIPS=OFF
//#exec TEXTURE IMPORT NAME=SmallButtonUp FILE=Textures\SmallButtonUp.pcx GROUP="Icons" MIPS=OFF

function Created()
{
	bNoKeyboard = True;

	Super.Created();

	UpTexture=Texture'SmallButtonUp'; 
	DownTexture=Texture'SmallButtonDown';
	DisabledTexture=Texture'SmallButtonDisabled';
	OverTexture=Texture'SmallButtonUp';
	ToolTipString = "";
	SetText("Close");
	//SetFont(Font(DynamicLoadObject("UWindowFonts.UTFont14B", Class'Font')));
	SetFont(F_Normal);

	WinWidth = 48;
	WinHeight = 16;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float W, H;
	C.Font = Root.Fonts[Font];
	
	TextSize(C, Text, W, H);

	TextX = (WinWidth-W)/2;
	TextY = (WinHeight-H)/2;

	if(bMouseDown)
	{
		TextX += 1;
		TextY += 1;
	}		
}

defaultproperties
{
}
