//=============================================================================
// ShellButton - A button
//=============================================================================
class ShellButton extends ShellComponent;

var bool		bDisabled;

var int 		Style;

var texture		UpTexture;
var texture		DownTexture;
var texture		DisabledTexture;
var texture		OverTexture;

var Region		TexCoords;

var string		ToolTipString;
var sound		OverSound, DownSound;

var bool bBurnable;

var bool bRepeat;
var float time_count;
var float key_delay;
var float key_interval;
var bool bSentClick;
var bool bIgnoreNextClick;

var bool bScrollingText;
var float ScrollingOffsetX, MaxScrollX, ScrollDir, ScrollDelay;

var bool bDrawShadow;
var float ShadowOffset;

const SCROLL_SPEED = 40.0f;
const SCROLL_DELAY = 2.0f;

function Created()
{
	Super.Created();

	ResetScroll();
}

function ResetScroll()
{
	ScrollingOffsetX = 0;
	ScrollDir = 1.0;
	ScrollDelay = SCROLL_DELAY;
}

function SetText(string NewText)
{
	Super.SetText(NewText);

	ResetScroll();
}

function ManagerResized(float ScaleX, float ScaleY)
{
	Super.ManagerResized(ScaleX, ScaleY);
	
	ResetScroll();
}

function Paint(Canvas C, float X, float Y)
{
	local texture test;
	local int SaveStyle;
	local float OrgX, OrgY, ClipX, ClipY;
	local float W,H;
	local float ScaledShadowOffset;

	C.Font = Root.Fonts[Font];

	SaveStyle = C.Style;

	// shadow
	if ( false && bDrawShadow && Style == 5 && UpTexture != None )
	{
		ScaledShadowOffset = ShadowOffset*Root.ScaleY;

		C.Style = 5;
		C.DrawColor.r = 0;
		C.DrawColor.g = 0;
		C.DrawColor.b = 0;
		C.DrawColor.a = 100;
		//C.bNoSmooth = false;

		C.OrgX += ScaledShadowOffset;
		C.OrgY += ScaledShadowOffset;
		DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, UpTexture );
		C.OrgX -= ScaledShadowOffset;
		C.OrgY -= ScaledShadowOffset;

		C.Style = SaveStyle;
		C.DrawColor.r = 255;
		C.DrawColor.g = 255;
		C.DrawColor.b = 255;
	}

	if ( Style == 5 ) 
	{
		C.Style = 5;
		C.DrawColor.a = 255;
	}

	if(bDisabled)
	{
		if(DisabledTexture != None)
		{
			DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, DisabledTexture );
		}
	}
	else 
	{
		if(bMouseDown)
		{
			if(DownTexture != None)
			{
				DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, DownTexture );
			}
		} 
		else 
		{
			if(MouseIsOver())
			{
				if(OverTexture != None)
				{
					if ( bBurnable )
					{
						UpTexture = OverTexture;
						//overSound = None;
					}
					DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, OverTexture );
				}
			}
			else if ( UpTexture != None )
			{
				DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, UpTexture );
			}

		}
	}

	TextSize(C, Text, W, H);

	bScrollingText = (W >= WinWidth);

	TextY = (WinHeight - H) / 2;
	switch (Align)
	{
		case TA_Left:
			TextX = 0;
			break;
		case TA_Center:
			TextX = (WinWidth - W)/2;
			break;
		case TA_Right:
			TextX = WinWidth - W;
			break;
	}	

	if (bScrollingText)
	{
		MaxScrollX = W - WinWidth;
		TextX = -ScrollingOffsetX;
	}
	
	if(Text != "")
	{
		//Log("ShellButton: Paint: Text=" $ Text $ " TextX=" $ TextX $ " TextY=" $ TextY $ " Align=" $ Align);
		C.DrawColor = TextColor;
		C.Style = TextStyle;
		C.bNoSmooth = false;
		
		ClipText(C, TextX, TextY, Text, True);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}

	C.Style = 1;

}

function Tick(float Delta) 
{
	if ( bMouseDown && bRepeat )
	{
		time_count += Delta;
		if (time_count > key_delay+key_interval)
		{
			time_count -= key_interval;
			Click(0,0);
			bSentClick = True;
		}
	}
	if ( bScrollingText )
	{
		if ( ScrollDelay > 0 )
		{
			ScrollDelay -= Delta;
		}
		else
		{
			ScrollingOffsetX = ScrollingOffsetX + SCROLL_SPEED*Root.ScaleY*Delta*ScrollDir;
			if ( ScrollingOffsetX > MaxScrollX )
			{
				ScrollingOffsetX = MaxScrollX;
				ScrollDir = -1;
				ScrollDelay = SCROLL_DELAY;
			}
			else if ( ScrollingOffsetX < 0 )
			{
				ScrollingOffsetX = 0;
				ScrollDir = 1;
				ScrollDelay = SCROLL_DELAY;
			}
		}
	}
}

function MouseLeave()
{
	Super.MouseLeave();
	
	if(ToolTipString != "") 
		ToolTip("");
}

simulated function MouseEnter()
{
	Super.MouseEnter();
	
	if(ToolTipString != "") 
		ToolTip(ToolTipString);

	if (!bDisabled && (OverSound != None))
		GetPlayerOwner().PlaySound(OverSound, SLOT_Interface, [Pitch]FRand()*0.1 + 0.95, [Flags]482 );
}

simulated function Click(float X, float Y) 
{
	if ( !bIgnoreNextClick )
	{
		SendMessage(DE_Click);
		
		if (!bDisabled && (DownSound != None))
			GetPlayerOwner().PlaySound(DownSound, SLOT_Interact, [Pitch]FRand()*0.1 + 0.95, [Flags]482 );
	}
	else
		bIgnoreNextClick = False;
}

function DoubleClick(float X, float Y) 
{
	SendMessage(DE_DoubleClick);
}

function RClick(float X, float Y) 
{
	SendMessage(DE_RClick);
}

function MClick(float X, float Y) 
{
	SendMessage(DE_MClick);
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X,Y);
	time_count = 0;
}

function LMouseUp(float X, float Y)
{
	if (bSentClick)
	{
		bSentClick = false;
		bIgnoreNextClick = True;
	}

	Super.LMouseUp(X,Y);
}

function KeyDown(int Key, float X, float Y)
{
	local PlayerPawn P;

	P = Root.GetPlayerOwner();

	switch (Key)
	{
		case P.EInputKey.IK_Space:
			LMouseDown(X, Y);
			LMouseUp(X, Y);
			break;

		default:
			Super.KeyDown(Key, X, Y);
			break;
	}
}

defaultproperties
{
     key_delay=0.3
     key_interval=0.15
     bIgnoreLDoubleClick=True
     bIgnoreMDoubleClick=True
     bIgnoreRDoubleClick=True
     ShadowOffset=5
}
