//=============================================================================
//
//	StatManager
//
//=============================================================================
class StatManager extends Info
	native;

//const MAX_STATS=16;

enum EStatDisplayMode
{
	ESM_Off, 
	ESM_FrameRate,
	ESM_NoFrameRate,
	ESM_Always
};

enum EStatDataType
{
	SDT_Percent, 
	SDT_Absolute  
};	

struct StatInfo
{
	var()	bool	bEnabled; 
	var()	texture	Icon;
	var()	color	Color;	

	var		string	TechInfo[7];
	var()	editconst 	string  Title;

	var		float	Shame;
	var		float	PeakShame;
	
	var		float	DisplayTime;

	var()	float	Max;
	var()	float	DisplayMax;

	var() EStatDataType DataType; 

	var StatData Data;

	// what about CalculateShame ? GetMax ? GetDisplayMax  ?
};

var() StatInfo	Entries[16]; 

var		EStatDisplayMode DisplayMode;
var()	bool	bUseFrameRate;
var()	byte	MinFrameRate;
var		float	MaxFrameTime;

//- - - - - - - - - - - - - - - - - - - - -

//- - - - - - - - - - - - - - - - - - - - -

function DrawIconsofShame(Canvas Canvas)
{
	local int i, line;
	local int ScreenX, ScreenY, Size;
	local float XL, YL;
	local texture IconTexture;
	local Color black, white;
	local float Shame;

	// stat manager is off
	if ( DisplayMode == ESM_Off ) 
		return;
	//
	// small font is 6x8
	//
	Size = 64;
	//ScreenX = Canvas.ClipX - 128;
	//ScreenY = 10;
		
	IconTexture = Texture(DynamicLoadObject("UWindow.WhiteTexture", class'Texture'));
	black.r = 0;	black.g = 0;	black.b = 0;
	white.r = 255;	white.g = 255;	white.b = 255;

	for ( i=0; i<16; i++ )	
	{
		if ( Entries[i].bEnabled )
		{
			if ( (Entries[i].PeakShame > 1.0) || (DisplayMode == ESM_Always) ) 
			{
				// locate top, left corner depending on what cell this is
				Shame = (Entries[i].PeakShame - 1.0) / 4.0;
				if (Shame < 0.0)
					Shame = 0.0;
				else if (Shame > 1.0)
					Shame = 1.0;
				ScreenX = Canvas.ClipX - Size - i/7*Size;
				ScreenY = (i%7)* Size ;
				Canvas.SetPos( ScreenX, ScreenY+8 );
/*
				// color / alpha is proportional to shamefulness
				Canvas.DrawColor.r = Entries[i].Color.r * Shame; 
				Canvas.DrawColor.g = Entries[i].Color.g * Shame; 
				Canvas.DrawColor.b = Entries[i].Color.b * Shame; 
*/
				Canvas.DrawColor = black;
				Canvas.DrawColor.r = 196 * Shame; 
			
				// background icon
				//Canvas.Style = ERenderStyle.STY_Translucent;
				Canvas.Style = ERenderStyle.STY_Normal;

				Entries[i].Icon = IconTexture;
				Canvas.DrawTileClipped( Entries[i].Icon, Size, Size-8, 0, 0, Entries[i].Icon.USize, Entries[i].Icon.VSize);
				
				//Title rendering
				Canvas.Style = ERenderStyle.STY_Normal;
				Canvas.SetPos(ScreenX, ScreenY);
				Canvas.Font = Canvas.DebugFont;

				//bright white text for Title
				Canvas.DrawColor = white;

				Canvas.DrawText( Entries[i].Title, false );

				//white text for TechInfo
				
				for ( line=0; line<7; line++ )
				{
					if ( Entries[i].TechInfo[line] != "" )
					{
						Canvas.StrLen( Entries[i].TechInfo[line], XL, YL );

						// right aligned, smallfont is 6x8
						Canvas.SetPos(ScreenX+64-XL, ScreenY+(line+1)*8);
						Canvas.DrawText( Entries[i].TechInfo[line], false );
					}
				}
			}
		}
	}

	Canvas.DrawColor = Canvas.Default.DrawColor;
	Canvas.Style = ERenderStyle.STY_Normal;
}

defaultproperties
{
     Entries(0)=(bEnabled=True,Title="BSP",Max=0.2,DisplayMax=0.5)
     Entries(1)=(bEnabled=True,Title="Mesh",Max=0.1,DisplayMax=0.3)
     Entries(2)=(bEnabled=True,Title="Shadow",Max=0.1,DisplayMax=0.3)
     Entries(3)=(bEnabled=True,Title="Particle",Max=0.1,DisplayMax=0.3)
     Entries(4)=(bEnabled=True,Title="Render",Max=0.2,DisplayMax=0.5)
     Entries(5)=(bEnabled=True,Title="Animation",Max=0.1,DisplayMax=0.3)
     Entries(6)=(bEnabled=True,Title="Physics",Max=0.05,DisplayMax=0.25)
     Entries(7)=(bEnabled=True,Title="Script",Max=0.15,DisplayMax=0.45)
     bUseFrameRate=True
     MinFrameRate=30
     RemoteRole=ROLE_None
}
