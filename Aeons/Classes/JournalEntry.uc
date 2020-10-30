//=============================================================================
// JournalEntry.
//=============================================================================
class JournalEntry expands Info
	abstract;

var() enum EntryType
{
	Book,
	Paper, 
	Scroll, 
	ScryeEvent, 
	Conversation
}Type;

var() Texture Icon;
var() Texture HUDIcon;

var const int MAX_LINES;

var string Text;

var bool	bRead;		// has player read this entry 
var() localized string Title;
var() localized string Objectives;
var() localized string Lines[150];

// Offset of Text currently displayed in Quadrant 0
var int CharOffset;		
// these two variables treat every 2 pages as one viewed page
var int CurrentPage;
var int NumPages;

var string TextSections[4];

var int CharOffsets[30];

var int PrevCharOffset;
var int CurrCharOffset;
var int NextCharOffset;

var color FontColor;

//var const string CODE_NewLine;
//var const string CODE_Image;

/*
// String functions.
native(125) static final function int    Len    ( coerce string S );
native(126) static final function int    InStr  ( coerce string S, coerce string t );
native(127) static final function string Mid    ( coerce string S, int i, optional int j );
native(128) static final function string Left   ( coerce string S, int i );
native(234) static final function string Right  ( coerce string S, int i );
native(235) static final function string Caps   ( coerce string S );
native(236) static final function string Chr    ( int i );
native(237) static final function int    Asc    ( string S );

// ScriptedTexture functions
native(473) final function DrawTile( float X, float Y, float XL, float YL, float U, float V, float UL, float VL, Texture Tex, bool bMasked );
native(472) final function DrawText( float X, float Y, string Text, Font Font );
native(474) final function DrawColoredText( float X, float Y, string Text, Font Font, color FontColor );
native(475) final function ReplaceTexture( Texture Tex );
native(476) final function TextSize( string Text, out float XL, out float YL, Font Font );
*/

function PostBeginPlay()
{
	local int i;

	Log("JournalEntry: PostBeginPlay" $ Self);
	Super.PostBeginPlay();

	Text = "";
	
	for ( i=0; i<MAX_LINES; i++ )
	{
		if ( Lines[i] == "" )
			return;
		
		Text = Text $ Lines[i];	
		Lines[i] = "";
	}
}

static function string GetWord(string SearchString)
{
	if ( InStr(SearchString, " ") >= 0 )
	{
		//found space
	}
}

static function DrawPages()
{

}

function Repaginate( string Source, byte TopMargin, byte LeftMargin, int Width, int Height, ScriptedTexture Tex, Font SourceFont )
{
	local string CurrentText;
	local string SourceOffset;

	if ( Tex == None )
	{
		Log("Repaginate: Tex is None");
		return;
	}

	if ( SourceFont == None )
	{
		Log("Repaginate: SourceFont is None");
		return;
	}	
		
	if ( Len(Source) == 0 )
	{
		Log("Repaginate: Length of passed in text is 0");
		return;
	}
		
	SourceOffset = Mid(Source, CharOffsets[CurrentPage], Len(Source)-CharOffsets[CurrentPage]);

	TextSections[0] = FillQuad( SourceOffset, 0, 5, 245, 256, Tex, SourceFont, true );
	CurrentText = TextSections[0];

	TextSections[1] = FillQuad( Right(SourceOffset, Len(SourceOffset)-Len(CurrentText)), 0, 5, 245, 256, Tex, SourceFont, true );
	CurrentText = CurrentText $ TextSections[1];

	TextSections[2] = FillQuad( Right(SourceOffset, Len(SourceOffset)-Len(CurrentText)), 0, 5, 245, 256, Tex, SourceFont, true );
	CurrentText = CurrentText $ TextSections[2];

	TextSections[3] = FillQuad( Right(SourceOffset, Len(SourceOffset)-Len(CurrentText)), 0, 5, 245, 256, Tex, SourceFont, true );
	CurrentText = CurrentText $ TextSections[3];

	//Log("repaginate: charoffsets[currentpage]=" $ charoffsets[currentpage]);

	CharOffsets[CurrentPage+1] = CharOffsets[CurrentPage] + Len(CurrentText);

	//Log("repaginate: charoffsets[currentpage+1]=" $ charoffsets[currentpage+1]);
}

function string FillQuad( string Source, byte TopMargin, byte LeftMargin, int Width, int Height, ScriptedTexture Tex, Font SourceFont, bool FormatOnly, optional bool english )
{
	local int y;
	local float sizex, sizey;
	local string Line;
	local string QuadString;
	local int token;
	local float drawx, drawy;
	local texture image;
	local string temp;
	local string texturename;
	local int offset;

	y = TopMargin;
	Width -= LeftMargin*2;
	drawx = LeftMargin;
	drawy = TopMargin;

	while ( y <= Height )
	{
		QuadString = QuadString $ Line;

		if ((Len(Line) > 0)&&(!FormatOnly)) 
		{
			class'JournalEntry'.static.EatLeadingWhitespace(Line);

			token = InStr(Line, "&");
			
			Tex.bNoSmooth = false;
			
			if ( token >= 0 )
			{
				if (english)
					Tex.DrawText( LeftMargin, y-sizey, Left(Line, token-1), SourceFont );
				else
					Tex.DrawColoredText( LeftMargin, y-sizey, Left(Line, token-1), SourceFont, FontColor );
			}
			else
			{
				if (english)
					Tex.DrawText( LeftMargin, y-sizey, Line, SourceFont );
				else
					Tex.DrawColoredText( LeftMargin, y-sizey, Line, SourceFont, FontColor );
			}
		}

		Line = GetLine( Right(Source, Len(Source)-Len(QuadString)), Width, Tex, SourceFont );

		//log("FillQuad: GetLine returned " $ Line);

		// we have come to the end of our text so remember how many pages we have.
		if ( Line == "" )
		{
			NumPages=CurrentPage + 1;
			break;
		}

		Tex.TextSize( Line, sizex, sizey, SourceFont );	
		y += sizey;

		if ( Left(Line, 2) == "&i" )
		{
			temp = Right(Line, Len(Line)-2);

			offset = InStr(temp, "&i");

			if ( offset >= 0 ) 
			{
				// Decrease 'y' by sizey added above since the text was just a tag
				y -= sizey;
				texturename = Left(temp, offset);
				
				EatLeadingWhitespace(texturename);
				EatEndingWhitespace(texturename);

				image = Texture(DynamicLoadObject(texturename, class'Texture'));

				if ((image != none)&&(image.vsize > 0))
				{
					if ((!FormatOnly)&&((y+image.vsize) <= Height))

					{
						// automatically center horizontally
						Tex.DrawTile( Width/2 - image.usize/2, y, image.usize, image.vsize, 0, 0, image.usize, image.vsize, image, true); 
					}
					y += image.vsize;
				}
			}
			else
			{
				//log("JournalEntry: FillQuad: Couldn't find ending image tag in string " $ temp );
			}
			
		}
	}

	return QuadString;
}

static function string GetLine( string Source, int MaxPixels, ScriptedTexture Tex, Font SourceFont )
{
	local int i;
	local int Length;
	local float Width, Height;
	local bool FoundWord;
	local int LastGoodEnd;
	local byte c;
	local string Line;
	local string TempString;
	local int count;

	// Length of string passed in
	Length = Len(Source);

	// loop through source text, looking for special tokens and keeping text from crossing edge
	while ((Mid(Source, i, 1) != "&") && (Width <= MaxPixels))
	{
		// not a token, see if it's not a space
		if ( Mid(Source, i, 1) != " " )
		{
			// mark the fact that we are now on a word
			FoundWord = true;
		}
		else 
		{	
			// found a space, so see if we were traversing a word
			if ( FoundWord )
			{
				// remember where the last word ended in case we go too far while looking for next word
				LastGoodEnd = i;
				FoundWord = false;
			}	
		}

		// Calculate size of current string
		Tex.TextSize( Left(Source, i), Width, Height, SourceFont);
		
		// move to next character in source
		if ( i < Length )
			i++;
		else
		{
			// we reached end of source string, so end it here
			LastGoodEnd = i;
			break;
		}
	}

	// if we stopped at a "&"
	if ( Mid(Source, i, 1) == "&")
	{
		//log("GetLine: Found start of command: Command = " $ Mid(Source, i+1, 1));
		//log("GetLine: Found start of command: Source = " $ Right(Source, Len(Source)-i));
		// find out which command is there
		switch(Mid(Source, i+1, 1))
		{
			case "n":
				//newline
				Line = Left(Source, i+2);
				//Log("GetLine: Found NewLine, returning " $ Line);
				return Line;
				break;

			case "i":
				// image
				if ( i > 0 )
					return Left(Source, i);

				TempString = Right(Source, Len(Source)-2);
				count = InStr(TempString, "&i");

				if ( count >= 0 ) 
				{
					Line = Mid(Source, i, count+4);
					//log("GetLine: Found image: returning " $ Line);									
				}
				else
					Line = Left(Source, i);

				return Line;
				break;

			case "c":
				// center 
				Line = Left(Source, i+2);
				return Line;
				break;

			case "s":
				// play sound ? 
				Line = Left(Source, i+2);
				return Line;
				break;

			default:
				// I probably should assert here
				Line = Left(Source, i+1);
				return Line;
				break;
		}

	}
	else
	{
		//MaxPixels exceeded ?
		Line = Left(Source, LastGoodEnd);
		//Log("GetLine: AutoWrapped, LastGoodEnd was " $ LastGoodEnd $ " returning " $ Line );
		return Line;			
	}

}


static function EatEndingWhitespace( out string Text )
{
	local int i;

	i = InStr(Text, " ");

	if ( i > 0 ) 
	{
		Text = Left(Text, i);
	}
}



static function EatLeadingWhitespace( out string Text )
{
	local int i;
	local int Length;

	Length = Len(Text);

	while ( Mid(Text, i, 1 ) == " " )
	{
		i++;
	}
	
	Text = Right(Text, Len(Text)-i);
}

defaultproperties
{
	 FontColor=(R=84,G=41,B=11)
     Icon=Texture'Aeons.bk_book'
     MAX_LINES=150
     NumPages=1
}
