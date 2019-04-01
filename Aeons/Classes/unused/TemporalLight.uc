//=============================================================================
// TemporalLight.
//=============================================================================
class TemporalLight expands Light;

struct HSBColor {
	var float H;
	var float S;
	var float B;
};

struct RGBColor {
	var float R;
	var float G;
	var float B;
};

struct LightProps
{
	var() byte Brightness;
	var() byte Hue;
	var() byte Saturation;
};

//-----------------------------------------------------------------------------
// Variables.

var() 	float ChangeTime;        // Time light takes to change from on to off.
var() 	bool  bInitiallyOn;      // Whether it's initially on.
var() 	bool  bDelayFullOn;      // Delay then go full-on.
var() 	float RemainOnTime;      // How long the TriggerPound effect lasts

var	byte NextHue;
var	byte NextSaturation;
var	byte NextBrightness;

var		float Alpha, Direction;

var		float dH;
var		float dS;
var		float dB;

var		HSBColor InitialColor; // Initial Color
var		HSBColor NextHSBColor;	// my next HSB Color - when triggered.

// convert a rgb color to an hsb color
function HSBtoRGB(HSBColor HSB, out RGBColor RGB)
{
	local int i; 
	local float f, p, q, t;
	
	HSB.H *= 360.0;

	if (HSB.H == 360)
		HSB.H = 0;

	HSB.H /= 60.0;

	i = HSB.H;
	f = HSB.H - i;
	p = HSB.B * (1 - HSB.S);
	q = HSB.B * (1 - (HSB.S * f));
	t = HSB.B * (1 - (HSB.S * (1-f)));
	
	switch (i)
	{
		case 0:
			RGB.R = HSB.B;
			RGB.G = t;
			RGB.B = p;
			break;

		case 1:
			RGB.R = q;
			RGB.G = HSB.B;
			RGB.B = p;
			break;

		case 2:
			RGB.R = p;
			RGB.G = HSB.B;
			RGB.B = t;
			break;

		case 3:
			RGB.R = p;
			RGB.G = q;
			RGB.B = HSB.B;
			break;

		case 4:
			RGB.R = t;
			RGB.G = p;
			RGB.B = HSB.B;
			break;

		case 5:
			RGB.R = HSB.B;
			RGB.G = p;
			RGB.B = q;
			break;
	};
}

// convert a hsb color to a rgb color
function RGBtoHSB(RGBColor RGB, out HSBColor HSB)
{
	local float mx, mn, delta;
	
	// max
	mx = FMax(RGB.R, RGB.G);
	mx = FMax(mx, RGB.B);

	// min
	mn = FMin(RGB.R, RGB.G);
	mn = FMin(mn, RGB.B);
	
	HSB.B = mx;
	
	if (mx != 0)
		HSB.S = (mx-mn)/mx;
	else
		HSB.S = 0;
	
	delta = mx-mn;
	
	if (RGB.R == mx)
		HSB.H = (RGB.G - RGB.B) / delta;
	else if (RGB.G == mx)
		HSB.H = 2 + (RGB.B - RGB.R) / delta;
	else if (RGB.B == mx)
		HSB.H = 4 + (RGB.R - RGB.G) / delta;
	
	HSB.H *= 60;
	if (HSB.H < 0)
		HSB.H += 360;
	
	HSB.H /= 360;
}

simulated function ColorInit()
{
	InitialColor.H = LightHue / 255.0;
	InitialColor.S = LightSaturation / 255.0;
	InitialColor.B = LightBrightness / 255.0;

	NextHSBColor.H = NextHue / 255.0;
	NextHSBColor.S = NextSaturation / 255.0;
	NextHSBColor.B = NextBrightness / 255.0;

	dH = NextHSBColor.H - InitialColor.H;
	dS = NextHSBColor.S - InitialColor.S;
	dB = NextHSBColor.B - InitialColor.B;


	// Instigator.ClientMessage("dH: "$dH$" dS: "$dS$" dB: "$dB);
}

simulated function BeginPlay()
{
	Disable( 'Tick' );
	Alpha     = 0.0;
	Direction = -1.0;
	ColorInit();
}

// Called whenever time passes.
function Tick( float DeltaTime )
{

	Alpha += Direction * DeltaTime / ChangeTime;
	
	if( Alpha > 1.0 )
	{
		Alpha = 1.0;
		Disable( 'Tick' );
	} else if( Alpha < 0.0 ) {
		Alpha = 0.0;
		Disable( 'Tick' );
	}

	if ( !bDelayFullOn ) {
		LightHue 		= byte((InitialColor.H + Alpha * dH) * 255);
		LightSaturation = byte((InitialColor.S + Alpha * dS) * 255);
		LightBrightness = byte((InitialColor.B + Alpha * dB) * 255);

//		Instigator.ClientMessage("H: "$LightHue$"S: "$LightSaturation$"B: "$LightBrightness);

	} else {
		LightHue = InitialColor.H * 255;
		LightSaturation = InitialColor.S * 255;
		LightBrightness = InitialColor.B * 255;
	}
}

function Trigger( actor Other, pawn EventInstigator )
{
	Alpha     = 0.0;
	Direction = 1.0;
	ColorInit();
	Enable( 'Tick' );
}

defaultproperties
{
     bStatic=False
     LightSource=LD_Ambient
}
