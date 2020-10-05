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

function Created()
{
	Super.Created();
}

function Paint(Canvas C, float X, float Y)
{
	local texture test;
	local int SaveStyle;
	local float OrgX, OrgY, ClipX, ClipY;
	local float W,H;

	C.Font = Root.Fonts[Font];

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


	if(Text != "")
	{
		//Log("ShellButton: Paint: Text=" $ Text $ " TextX=" $ TextX $ " TextY=" $ TextY $ " Align=" $ Align);
		C.DrawColor = TextColor;
		C.Style = TextStyle;
		C.bNoSmooth = false;
		
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
		
		ClipText(C, TextX - 1, TextY, Text, True);
		ClipText(C, TextX + 1, TextY, Text, True);
		ClipText(C, TextX, TextY - 1, Text, True);
		ClipText(C, TextX, TextY + 1, Text, True);
		
		C.DrawColor = TextColor;
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
		GetPlayerOwner().PlaySound(OverSound, SLOT_Interface, [Flags]482 );
}

simulated function Click(float X, float Y) 
{
	if ( !bIgnoreNextClick )
	{
		SendMessage(DE_Click);
		
		if (!bDisabled && (DownSound != None))
			GetPlayerOwner().PlaySound(DownSound, SLOT_Interact, [Flags]482 );
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
}
