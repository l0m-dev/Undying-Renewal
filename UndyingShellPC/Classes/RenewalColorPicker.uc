class RenewalColorPicker extends UWindowDialogControl;

#exec TEXTURE IMPORT NAME=ColorPickerH FILE=Textures\ColorPickerH.bmp GROUP="Icons" MIPS=OFF

var Color PickedColor;

var TexRegion HueRegion;
var float HueStripDrawX;
var	float HueStripWidth;
var float HueMarkerX;

var float Padding;

function Created()
{
	Super.Created();

	SetSize(256, 32);
	HueRegion = NewTexRegion(0, 0, 256, 32, texture'ColorPickerH');

	HueStripWidth = WinWidth / 2;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float TW, TH;

	Super.BeforePaint(C, X, Y);
		
	TextSize(C, Text, TW, TH);
	
	WinHeight = 16 * Root.ScaleY;
	
	switch(Align)
	{
	case TA_Left:
		HueStripDrawX = WinWidth - HueStripWidth*Root.ScaleY;
		TextX = 0;
		break;
	case TA_Right:
		HueStripDrawX = 0;	
		TextX = WinWidth - TW;
		break;
	case TA_Center:
		HueStripDrawX = (WinWidth - HueStripWidth*Root.ScaleY) / 2;
		TextX = (WinWidth - TW) / 2;
		break;
	}

	TextY = (WinHeight - TH) / 2;
	Padding = 2*Root.ScaleY;
}

function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C, X, Y);

	DrawMiscBevel(C, HueStripDrawX, 0, HueStripWidth*Root.ScaleY, WinHeight, LookAndFeel.Misc, 2);

	DrawStretchedTextureSegment(C, HueStripDrawX+Padding, Padding, HueStripWidth*Root.ScaleY-Padding*2, WinHeight-Padding*2, HueRegion.X, HueRegion.Y, HueRegion.W, HueRegion.H, HueRegion.T);

	if(Text != "")
	{
		C.DrawColor = TextColor;
		C.Font = Root.Fonts[Font];
		ClipText(C, TextX, TextY, Text);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}

	DrawUpBevel(C, HueStripDrawX+(HueMarkerX-1)*Root.ScaleY+Padding, Padding, 2*Root.ScaleY, WinHeight-Padding*2, GetLookAndFeelTexture());
}

function SetColor(Color NewColor)
{
	PickedColor = NewColor;
	HueMarkerX = GetXFromColor(NewColor, HueStripWidth - Padding*2);
}

static final function Color HsvToRgb(float H, float S, float v)
{
	local float C, X, M, R, G, B, H_deg;
	local Color OutColor;

	C = V * S;
	
	H_deg = H * 360.0;
	
	X = C * (1.0 - Abs(((H_deg / 60.0) % 2.0) - 1.0));
	M = V - C;
	
	if		(H_deg >= 0.0  && H_deg < 60.0)		{ R = C; G = X; B = 0.0; }
	else if (H_deg >= 60.0 && H_deg < 120.0)	{ R = X; G = C; B = 0.0; }
	else if (H_deg >= 120.0 && H_deg < 180.0)	{ R = 0.0; G = C; B = X; }
	else if (H_deg >= 180.0 && H_deg < 240.0)	{ R = 0.0; G = X; B = C; }
	else if (H_deg >= 240.0 && H_deg < 300.0)	{ R = X; G = 0.0; B = C; }
	else if (H_deg >= 300.0 && H_deg <= 360.0)	{ R = C; G = 0.0; B = X; }
	
	OutColor.R = byte((R + M) * 255.0);
	OutColor.G = byte((G + M) * 255.0);
	OutColor.B = byte((B + M) * 255.0);
	
	return OutColor;
}

static final function Color GetColorFromClick(float MouseX, float MouseY, float PickerX, float PickerY, float PickerWidth, float PickerHeight)
{
	local float LocalX, LocalY, NormX, NormY;
	local float Hue, Saturation, Value;

	LocalX = MouseX - PickerX;
	LocalY = MouseY - PickerY;

	NormX = FClamp(LocalX / PickerWidth, 0.0, 1.0);
	NormY = FClamp(LocalY / PickerHeight, 0.0, 1.0);

	Hue = NormX;
	
	Saturation = 1.0;
	Value = 1.0;

	return HsvToRgb(Hue, Saturation, Value);
}

static final function float GetXFromColor(Color TargetColor, float PickerWidth)
{
	local float R, G, B;
	local float MaxVal, MinVal, Delta;
	local float Hue, NormX;

	R = float(TargetColor.R) / 255.0;
	G = float(TargetColor.G) / 255.0;
	B = float(TargetColor.B) / 255.0;

	MaxVal = FMax(R, FMax(G, B));
	MinVal = FMin(R, FMin(G, B));
	Delta = MaxVal - MinVal;

	if (Delta == 0.0)
	{
		Hue = 0.0;
	}
	else if (MaxVal == R)
	{
		Hue = (G - B) / Delta;
		if (Hue < 0.0) Hue += 6.0;
	}
	else if (MaxVal == G)
	{
		Hue = ((B - R) / Delta) + 2.0;
	}
	else
	{
		Hue = ((R - G) / Delta) + 4.0;
	}

	NormX = Hue / 6.0;

	return (NormX * PickerWidth);
}

function Click(float X, float Y)
{
	local Object TargetObject;
	
	Super.Click(X, Y);

	if (X > HueStripDrawX + Padding && X < (HueStripDrawX + HueStripWidth*Root.ScaleY - Padding))
	{
		PickedColor = GetColorFromClick(X, Y, HueStripDrawX+Padding, Padding, HueStripWidth*Root.ScaleY-Padding*2, WinHeight-Padding*2);
		HueMarkerX = (X - HueStripDrawX - Padding) / Root.ScaleY;
		
		//log("Selected Color output - R:" $ PickedColor.R $ " G:" $ PickedColor.G $ " B:" $ PickedColor.B);
		Notify(DE_Change);

		GetPlayerOwner().PlaySound(Sound'Shell_HUD.Shell.SHELL_SliderClick', SLOT_Interface, [Flags]482);
	}
}
