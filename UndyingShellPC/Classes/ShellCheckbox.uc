//=============================================================================
// ShellCheckbox - a checkbox
//=============================================================================
class ShellCheckbox extends ShellButton;

var bool bChecked;

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
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
		// for checkboxes, just use the Down state as the Checked state
		if(bChecked)
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
					DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, OverTexture );
				}
			}
			else if ( UpTexture != None )
			{
				DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, TexCoords.X, TexCoords.Y, TexCoords.W, TexCoords.H, UpTexture );
			}
		}
	}

	if(Text != "")
	{
		C.DrawColor = TextColor;
		ClipText(C, TextX, TextY, Text, True);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}

}


function LMouseDown(float X, float Y)
{
	if(!bDisabled)
	{	
		bChecked = !bChecked;
		SendMessage(DE_Change);
	}

	Super.LMouseDown(X, Y);
}

defaultproperties
{
}
