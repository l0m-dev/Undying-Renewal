//=============================================================================
// ShellLabelAutoWrap
//=============================================================================
class ShellLabelAutoWrap extends ShellLabel;


function Paint(Canvas C, float X, float Y)
{
	local float W, H;
	local bool bFoundEnd;
	local string TempString;
	local string CurrentLine;
	local string LastString;
	local string NewWord;
	local int CurrentWidth;
	local string Remainder;
	local int SpacePos;
		
	//Super.Paint(C, X, Y);
	
	C.Font = Root.Fonts[Font];

	TextSize(C, Text, W, H);
	
	if ( W <= WinWidth )
	{
		TextY = 0;//(WinHeight - H) / 2;

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
/*
			C.DrawColor.R = 0;
			C.DrawColor.G = 0;

			DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, 0, 0, 8, 8, Texture'UWindow.WhiteTexture' );
*/

			C.DrawColor = TextColor;
			C.Font = Root.Fonts[Font];
			C.Style = TextStyle;
			C.bNoSmooth = false;
			ClipText(C, TextX, TextY, Text);
			C.DrawColor.R = 255;
			C.DrawColor.G = 255;
			C.DrawColor.B = 255;
		}
	}
	else
	{

/*
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;

		DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, 0, 0, 8, 8, Texture'UWindow.WhiteTexture' );
		
		// final function int WrapClipText(Canvas C, float X, float Y, coerce string S, optional bool bCheckHotkey, optional int Length, optional int PaddingLength, optional bool bNoDraw)
		WrapClipText(C, 0, 0, Text);
		return;
*/
	

		TextY = 0;
		CurrentLine="";
		Remainder = Text;
/*
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;

		DrawStretchedTextureSegment( C, 0, 0, WinWidth, WinHeight, 0, 0, 8, 8, Texture'UWindow.WhiteTexture' );
*/		
		while ( Remainder != "" )
		{
			//Token = InStr(Remainder, " ");

			W=0;
			bFoundEnd=False;
			NewWord="";
			CurrentLine="";

			while ( (W < WinWidth) && (!bFoundEnd) )
			{
				CurrentLine = CurrentLine $ NewWord;
				
				Remainder = Right( Remainder, Len(Remainder)-Len(NewWord) );

				//Log("WidthLoop Top: CurrentLine=" $ CurrentLine $ " Remainder=" $ Remainder);
				SpacePos = InStr(Remainder, " ");
				
				if ( SpacePos >= 0 ) 
				{
					NewWord = Left(Remainder, SpacePos+1);
				}
				else
				{
					bFoundEnd = True;
					//NewWord = Remainder;
					//log("WidthLoop: Hit End of String, Remainder=" $ Remainder);
					TextSize(C, CurrentLine $ Remainder, W, H);

					if ( W <= WinWidth )
					//	Remainder = NewWord;
					//else
					{
						CurrentLine = CurrentLine $ Remainder;
						Remainder = "";
					}
					// handle special case of only word left not fitting 
					else if ( CurrentLine == "" ) 
					{
						CurrentLine = Remainder;
						Remainder = "";
					}
				}

				//log("WidthLoop Bottom: CurrentLine=" $ CurrentLine $ " NewWord=" $ NewWord);
				TextSize(C, CurrentLine $ NewWord, W, H);
			
			}

			//Remainder = Right( Remainder, Len(Remainder)-Len(CurrentLine) );
			TextSize(C, CurrentLine, W, H);
			TextX = (WinWidth - W)/2;

			//Log("AfterWidthLoop: CurrentLine=" $ CurrentLine $ " Remainder=" $ Remainder );

			if(CurrentLine != "")
			{
				C.DrawColor = TextColor;
				C.Font = Root.Fonts[Font];
				C.Style = TextStyle;
				C.bNoSmooth = false;
				ClipText(C, TextX, TextY, CurrentLine);
				C.DrawColor.R = 255;
				C.DrawColor.G = 255;
				C.DrawColor.B = 255;

				TextY += H;
			}

		}
	
	}

	//log("");
	C.Style = 1;
}

defaultproperties
{
}
