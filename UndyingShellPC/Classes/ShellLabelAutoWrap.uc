//=============================================================================
// ShellLabelAutoWrap
//=============================================================================
class ShellLabelAutoWrap extends ShellLabel;

// originally only used for book titles

function Paint(Canvas C, float X, float Y)
{
	local float W, H;
	local string CurrentLine;
	local string NewWord;
	local string Remainder;
	local int SpacePos;
	
	C.Font = Root.Fonts[Font];
	C.DrawColor = TextColor;
	C.Style = TextStyle;
	C.bNoSmooth = false;

	TextX = 0;
	TextY = 0;

	Remainder = Text;
	while ( Remainder != "" )
	{
		W = 0;
		CurrentLine = "";
		
		while ( true )
		{
			// Get next word
			SpacePos = InStr(Remainder, " ");
			if ( SpacePos >= 0 )
			{
				NewWord = Left(Remainder, SpacePos + 1);
				Remainder = Mid(Remainder, SpacePos + 1);
			}
			else
			{
				NewWord = Remainder;
				Remainder = "";
			}

			// Check if the word fits in the current line
			TextSize(C, CurrentLine $ NewWord, W, H);

			if ( W <= WinWidth )
			{
				CurrentLine = CurrentLine $ NewWord;

				if ( Remainder == "" )
					break;
			}
			else
			{
				if ( CurrentLine == "" )
					CurrentLine = NewWord;
				else
					Remainder = NewWord $ Remainder;

				Remainder = LTrim(Remainder);
				break;
			}
		}

		// Draw the current line
		CurrentLine = Trim(CurrentLine);
		TextSize(C, CurrentLine, W, H);
		
		switch ( Align )
		{
			case TA_Center:
				TextX = (WinWidth - W)/2;
				break;
			case TA_Right:
				TextX = WinWidth - W;
				break;
		}

		ClipText(C, TextX, TextY, CurrentLine);
		TextY += H;
	}

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	C.Style = 1;
}

defaultproperties
{
}
