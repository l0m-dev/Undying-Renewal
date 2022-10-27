class ShellSlider extends ShellButton;

//fix right now it's horiz only
var	float	MinValue;
var	float	MaxValue;
var	float	Value;
var	float	Step;		// 0 = continuous


var Region  Slider;
var Region	SliderTemplate;

var	float	SliderWidth;
var	float	SliderDrawX, SliderDrawY;
var float	TrackStart;
var float	TrackWidth;
var bool	bSliding;
var bool	bNoSlidingNotify;

var float SlideOffset;

function Created()
{
	Super.Created();
}

function SetRange(float Min, float Max, float NewStep)
{
	MinValue = Min;
	MaxValue = Max;
	Step = NewStep;
	Value = CheckValue(Value);
}

function float GetValue()
{
	return Value;
}

function SetValue(float NewValue, optional bool bNoNotify)
{
	local float OldValue;

	OldValue = Value;

	Value = CheckValue(NewValue);

	if(Value != OldValue && !bNoNotify)
	{
		Message(DE_Change);
	}	

}

function SetSlider(float X, float Y, float W, float H)
{
	Slider = NewRegion(X,Y,W,H);
	SliderTemplate = NewRegion(X,Y,W,H);
}

function float CheckValue(float Test)
{
	local float TempF;
	local float NewValue;
	
	NewValue = Test;
	
	if(Step >= 0.01)
	{
		TempF = NewValue / Step;
		NewValue = Int(TempF + 0.5) * Step;
	}

	if(NewValue < MinValue) NewValue = MinValue;
	if(NewValue > MaxValue) NewValue = MaxValue;

	return NewValue;
}

function Paint(Canvas C, float X, float Y)
{
	local texture test;

	C.Font = Root.Fonts[Font];

	Slider.X = (WinWidth - Slider.W) * ((Value - MinValue)/(MaxValue - MinValue));

	if(bDisabled)
	{
		if(DisabledTexture != None)
		{
			DrawStretchedTextureSegment( C, Slider.X, Slider.Y, Slider.W, Slider.H, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, DisabledTexture );
		}
	}
	else 
	{
		if(bMouseDown)
		{
			if(DownTexture != None)
			{
				DrawStretchedTextureSegment( C, Slider.X, Slider.Y, Slider.W, Slider.H, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, DownTexture );
			}
		} 
		else 
		{
			if(MouseIsOver())
			{
				if(OverTexture != None)
				{
					//UpTexture = OverTexture;
					DrawStretchedTextureSegment( C, Slider.X, Slider.Y, Slider.W, Slider.H, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, OverTexture );
				}
			}
			else if ( UpTexture != None )
			{
				DrawStretchedTextureSegment( C, Slider.X, Slider.Y, Slider.W, Slider.H, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, UpTexture );
			}
		}
	}

	if(Text != "")
	{
		C.DrawColor = TextColor;
		C.Style = 3; // translucent
		ClipText(C, TextX, TextY, Text, True);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}

}

function LMouseUp(float X, float Y)
{
	Super.LMouseUp(X, Y);

	if(bNoSlidingNotify && bSliding)
		Message(DE_Change);
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);

	if((X >= Slider.X) && (X <= Slider.X + Slider.W)) 
	{
		bSliding = True;
		SlideOffset = X - Slider.X;
		Root.CaptureMouse();
	}

	if(X < Slider.X && X > 0)
	{
		if(Step >= 0.01)
			SetValue(Value - Step);
		else
			SetValue(Value - 0.01);
	}
	
	if(X > Slider.X + Slider.W && X < WinWidth)
	{
		if(Step >= 0.01)
			SetValue(Value + Step);
		else
			SetValue(Value + 0.01);
	}
	
}


function MouseMove(float X, float Y)
{
	Super.MouseMove(X, Y);

	if(bSliding && bMouseDown)
	{
		SetValue( ((X - SlideOffset) / (WinWidth - Slider.W)) * (MaxValue - MinValue) + MinValue, bNoSlidingNotify);
	}
	else
		bSliding = False;
}


function KeyDown(int Key, float X, float Y)
{
	local PlayerPawn P;

	P = GetPlayerOwner();

	switch (Key)
	{
	case P.EInputKey.IK_Left:
		if(Step >= 0.01)
			SetValue(Value - Step);
		else
			SetValue(Value - 0.01);

		break;
	case P.EInputKey.IK_Right:
		if(Step >= 0.01)
			SetValue(Value + Step);
		else
			SetValue(Value + 0.01);

		break;
	case P.EInputKey.IK_Home:
		SetValue(MinValue);
		break;
	case P.EInputKey.IK_End:
		SetValue(MaxValue);
		break;
	default:
		Super.KeyDown(Key, X, Y);
		break;
	}
}

function Message(byte E)
{
	Super.SendMessage(E);	
}

function ManagerResized(float ScaleX, float ScaleY)
{
	Super.ManagerResized(ScaleX, ScaleY);

	Slider.x = SliderTemplate.x * ScaleX;
	Slider.y = SliderTemplate.y * ScaleY;
	Slider.w = SliderTemplate.w * ScaleX;
	Slider.h = SliderTemplate.h * ScaleY;
}

defaultproperties
{
}
