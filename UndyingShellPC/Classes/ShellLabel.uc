//=============================================================================
// ShellLabel - A label 
//=============================================================================
class ShellLabel extends ShellComponent;

function Created()
{
	TextX = 0;
	TextY = 0;
}


function Paint(Canvas C, float X, float Y)
{
	local float W, H;
	
	Super.Paint(C, X, Y);
	
	C.Font = Root.Fonts[Font];

	TextSize(C, Text, W, H);
	
	TextY = (WinHeight - H) / 2;
	switch (Align)
	{
		case TA_Left:
			break;
		case TA_Center:
			TextX = (WinWidth - W)/2;
			break;
		case TA_Right:
			TextX = WinWidth - W;
			break;
	}	

	if(Text != "")
	{
		C.DrawColor = TextColor;
		C.Font = Root.Fonts[Font];
		C.Style = TextStyle;
		C.bNoSmooth = false;
		ClipText(C, TextX, TextY, Text);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}

	C.Style = 1;
}

defaultproperties
{
}
