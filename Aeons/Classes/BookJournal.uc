//=============================================================================
// BookJournal.
//=============================================================================
class BookJournal expands BookJournalBase;

//#exec OBJ LOAD FILE=\Aeons\Textures\Pages.utx PACKAGE=Pages
//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//#exec MESH IMPORT MESH=BookJournal_m SKELFILE=BookJournal.ngf SMOOTHING=88
//#exec MESHMAP SCALE 0.35 0.01 0.01

//#exec MESHMAP SETTEXTURE MESHMAP=BookJournal_m NUM=1 TEXTURE=Pages.Page0
//#exec MESHMAP SETTEXTURE MESHMAP=BookJournal_m NUM=2 TEXTURE=Pages.Page2
//#exec MESHMAP SETTEXTURE MESHMAP=BookJournal_m NUM=3 TEXTURE=Pages.Page1
//#exec MESHMAP SETTEXTURE MESHMAP=BookJournal_m NUM=4 TEXTURE=Pages.Page3

//#exec Texture Import File=bk_scrye.bmp Mips=Off
//#exec Texture Import File=bk_scroll.bmp Mips=Off
//#exec Texture Import File=bk_paper.bmp Mips=Off
//#exec Texture Import File=bk_conv.bmp Mips=Off
//#exec Texture Import File=bk_book.bmp Mips=Off

//#exec Audio Import File=I_BookOpen01.WAV
//#exec Audio Import File=I_BookOpen02.WAV
//#exec Audio Import File=I_BookClose01.WAV
//#exec Audio Import File=I_BookClose02.WAV
//#exec Audio Import File=I_BookPageTurn01.WAV
//#exec Audio Import File=I_BookPageTurn02.WAV
//#exec Audio Import File=I_BookScroll01.WAV
//#exec Audio Import File=I_BookSelect01.WAV

//#exec Font Import File=DauphinFont.bmp Mips=Off
//#exec Font Import File=Dauphin_Grey.bmp Mips=Off

//#exec Font Import File=Dauphin16_Pad.bmp Mips=Off
//#exec Font Import File=Dauphin16_Skinny.bmp Mips=Off

//----------------------------------------------------------------------------

//var() texture Pages[4];
var() color FontColor;

var() int MarginLeft;
var() int MarginTop;
var() int VertSpacing;
var() int LinesPerPage;
var() bool bCapsOnly;

var() bool bDisplay3D;

var() Font TextFont;
var() Font TextFontEnglish;

var() float		BookFOV;
var() vector	BookOffset;
var() rotator	BookRotation; 

var JournalEntry ObjectivesEntry;

var ScriptedTexture Textures[4];
var int TextureStatus[4];

//----------------------------------------------------------------------------

function ForceLoad()
{
	local texture foo;

	// This is here purely to force the icons to load
	// I've encountered too much trouble with them not showing up
	foo = texture'Aeons.bk_book';
	foo = texture'Aeons.bk_conv';
	foo = texture'Aeons.bk_paper';
	foo = texture'Aeons.bk_scrye';
	foo = texture'Aeons.bk_scroll';


}

//----------------------------------------------------------------------------

function UpdateObjectives()
{
	local int i;
	local AeonsPlayer AP;
	local string TempString;
	local int Token;

	AP = AeonsPlayer(Owner);

	if ( AP == None ) 
	{
		log("UpdateObjectives: AeonsPlayerOwner was None, Owner = " $ Owner);
		return;
	}

	ObjectivesEntry.Text = "";

	for ( i=0; i<ArrayCount(AP.Objectives); i++ )
	{
		// once we hit a 0 or a disabled objective we have reached the end of the valid objectives
		// currently a BYTE in UnrealScript is Unsigned and so we can't have negative numbers
		// so the current implementation just adds 100 to the objective number to make it disabled. 
		if ( (AP.Objectives[i] == 0) || (AP.Objectives[i] >= 100) )
		{
			return;
		}
		else if ( AP.Objectives[i] < ArrayCount(AP.Objectives) )
		{
			if (AP.ObjectivesText[ AP.Objectives[i] ] != "")
			{
				TempString = AP.ObjectivesText[ AP.Objectives[i] ];
				Token = InStr(TempString, ",");

				if (Token >= 0)
				{
					TempString = Right(TempString, Len(TempString)-Token-1);	
				}

				ObjectivesEntry.Text = ObjectivesEntry.Text $ TempString $ " &n &n ";	
			}
		}
		
	}
}

function PostBeginPlay()
{
	local JournalEntry TempEntry;

	Super.PostBeginPlay();

	if ( ObjectivesEntry == None )
	{
		ObjectivesEntry = Spawn(class'ObjectivesJournal');
	}

	//fix why is this happening ?  After postbeginplay, but before GiveTo() Mesh gets assigned PlayerViewMesh and Scale gets PlayerViewScale ?????
	//	PlayerViewMesh = Mesh;
	//	PlayerViewScale = DrawScale;
}


function TravelPostAccept()
{
	local JournalEntry TempEntry;
	local int i;
	local Class<JournalEntry> JournalEntryClass;

	Super.TravelPostAccept();

	for ( i=0; i<NumJournals; i++ )
	{
		if (( JournalNames[i] != "")&&( Journals[i] == None )) 
		{
			JournalEntryClass = Class<JournalEntry>(DynamicLoadObject(JournalNames[i], class'Class'));

			if ( JournalEntryClass != None )
			{
				TempEntry = Spawn(JournalEntryClass);
				
				if ( TempEntry != None )
				{ 
					Journals[i] = TempEntry;
					Journals[i].bRead = bool(JournalRead[i]);
				}
			}
		}
	}

}


function PreBeginPlay()
{
	local int i;
	local JournalEntry TempEntry;

	Super.PreBeginPlay();

	//TextFont = Font(DynamicLoadObject("Aeons.DauphinFont", class'Font'));
	//TextFont = Font(DynamicLoadObject("Aeons.Dauphin_Book_pad", class'Font'));
	//TextFont = Font(DynamicLoadObject("Aeons.Dauphin16_pad", class'Font'));
	TextFont = Font(DynamicLoadObject("dauphin.dauphin16", class'Font'));
	TextFontEnglish = Font(DynamicLoadObject("Aeons.Dauphin16_Skinny", class'Font'));
	
	Textures[0].NotifyActor = Self;
	Textures[1].NotifyActor = Self;
	Textures[2].NotifyActor = Self;
	Textures[3].NotifyActor = Self;
}


simulated function Destroyed()
{
	Textures[0].NotifyActor = None;
	Textures[1].NotifyActor = None;
	Textures[2].NotifyActor = None;
	Textures[3].NotifyActor = None;
}


simulated event RenderTexture(ScriptedTexture Tex)
{
	local int LineCount;
	local int x,y;
	local int i;
	local int Section;
	local int StartLine;
	local float fchance;
	local string Text;
	local JournalEntry CurrentEntry;
	local string Source;
	local string CurrentText;
	local string SourceOffset;
	local float tx, ty;
	local bool english;
	local font CurrentFont;

	Tex.TextSize("This is the english version of the game", tx, ty, TextFont);
	english = (tx == 224 && ty == 20);

	CurrentFont = TextFontEnglish;

	if (!english)
		CurrentFont = TextFont;
	
	if ( CurrentJournalIndex == -1 )
		CurrentEntry = ObjectivesEntry;
	else
		CurrentEntry = Journals[CurrentJournalIndex];
	
	if ( CurrentEntry == None ) 
		return;
	
	Section = Int( Right( Tex.Name, 1 ) );

    assert(Section >= 0);

	TextureStatus[Section] = 1;

	switch(Section)
	{
		case 0:
			Text = CurrentEntry.TextSections[0];
			y=MarginTop;
			break;

		case 1:
			Text = CurrentEntry.TextSections[2];
			y=MarginTop;
			break;

		case 2:
			Text = CurrentEntry.TextSections[1];
			y=0;
			break;

		case 3:
			Text = CurrentEntry.TextSections[3];
			y=0;
			break;
	}		

	x = MarginLeft;

	//class'JournalEntry'.static.FillQuad( Text, y, x, 245, 256, Tex, CurrentFont, false );
//	CurrentEntry.FillQuad( Text, y, x, 245, 256, Tex, CurrentFont, false, english );

	// the texture doesn't need to be updated again until we change the contents
	Tex.bRedraw=false;

	// if all textures have had their SourceTexture blitted into them and are ready for me 
	// to draw into them, then by all means blit the text.
	if ( (TextureStatus[0] > 0) &&
		 (TextureStatus[1] > 0) &&
		 (TextureStatus[2] > 0) &&
		 (TextureStatus[3] > 0) )
	{
		Source = CurrentEntry.Text;

		SourceOffset = Mid(Source, CurrentEntry.CharOffsets[CurrentEntry.CurrentPage], Len(Source)-CurrentEntry.CharOffsets[CurrentEntry.CurrentPage]);

		CurrentText = CUrrentEntry.FillQuad( SourceOffset, MarginTop, MarginLeft, 245, 256, Textures[0], CurrentFont, false, english );
		// CurrentText = TextSections[0];

		CurrentText = CurrentText $ CUrrentEntry.FillQuad( Right(SourceOffset, Len(SourceOffset)-Len(CurrentText)), 5, MarginLeft, 245, 256, Textures[1], CurrentFont, false, english );
		// CurrentText = CurrentText $ TextSections[1];

		CurrentText = CurrentText $ CUrrentEntry.FillQuad( Right(SourceOffset, Len(SourceOffset)-Len(CurrentText)), MarginTop, MarginLeft, 245, 256, Textures[2], CurrentFont, false, english );
		// CurrentText = CurrentText $ TextSections[2];

		CurrentText = CurrentText $ CUrrentEntry.FillQuad( Right(SourceOffset, Len(SourceOffset)-Len(CurrentText)), 5, MarginLeft, 245, 256, Textures[3], CurrentFont, false, english );
		// CurrentText = CurrentText $ TextSections[3];

		//Log("rendertexture: charoffsets[currentpage]=" $ CurrentEntry.charoffsets[CurrentEntry.currentpage]);

		CurrentEntry.CharOffsets[CurrentEntry.CurrentPage+1] = CurrentEntry.CharOffsets[CurrentEntry.CurrentPage] + Len(CurrentText);

		//Log("rendertexture: charoffsets[currentpage+1]=" $ CurrentEntry.charoffsets[CurrentEntry.currentpage+1]);

		//Log("Len(CurrentEntry.Text)=" $ Len(CurrentEntry.Text));
		if ( CurrentEntry.charoffsets[CurrentEntry.currentpage+1] < Len(CurrentEntry.Text) )
		{
			if ( CurrentEntry.CUrrentPage == CurrentEntry.NumPages-1 )
			{
				CurrentEntry.NumPages++;
				log("Increased NumPages to " $ CurrentEntry.NumPages );
			}
		}
		
		// reset all the textures 
		TextureStatus[0] = 0;		
		TextureStatus[1] = 0;
		TextureStatus[2] = 0;
		TextureStatus[3] = 0;
	}
}

function RefreshPages()
{
	local JournalEntry Entry;
	local int i;
	
	if (RequestedEntryClass != None)
	{
		FindRequestedEntryClass();
	}
	
	if ( CurrentJournalIndex == -1 )
		Entry = ObjectivesEntry;
	else
		Entry = Journals[CurrentJournalIndex];

	if ( Entry == None ) 
	{
		return;
	}

	if (!Entry.bRead)
	{
		NumUnreadJournals--;
		//Log("BookJournal: RefreshPages: NumUnreadJournals = " $ NumUnreadJournals);
		Entry.bRead = True;
		// journals don't travel with player so we need to store an extra array of bools of what entries have been read or not
		if ( CurrentJournalIndex >= 0 ) 
			JournalRead[CurrentJournalIndex] = 1;

		// If this journal entry was the newest unread entry, assign a different entry as the latest.
		NewestUnread = None;
		for (i = 0; i < NumJournals; i++)
		{
			if (!Journals[i].bRead)
				NewestUnread = Journals[i];
		}

	}
		
	//new Journals[CurrentJournalIndex].Repaginate( Entry.Text, 5, 5, 256, 256, Texture'Pages.Page0', TextFont);

	Textures[0].bRedraw = true;
	Textures[1].bRedraw = true;
	Textures[2].bRedraw = true;
	Textures[3].bRedraw = true;

	Textures[0].NotifyActor = self;
	Textures[1].NotifyActor = self;
	Textures[2].NotifyActor = self;
	Textures[3].NotifyActor = self;
}

function JournalEntry GetJournalEntry( int Index ) 
{
	if ( Index == -1 ) 
		return ObjectivesEntry;
	else if ( Journals[Index] != None ) 
		return Journals[Index];
	else
		return None;
}


//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     MarginLeft=5
     MarginTop=12
     VertSpacing=23
     LinesPerPage=10
     bDisplay3D=True
     TextFont=Font'Aeons.Dauphin16_Skinny'
     BookFOV=90
     BookOffset=(X=41,Y=6,Z=2.8)
     BookRotation=(Pitch=32768,Yaw=16384,Roll=16384)
     Textures(0)=ScriptedTexture'Pages.Page0'
     Textures(1)=ScriptedTexture'Pages.Page1'
     Textures(2)=ScriptedTexture'Pages.Page2'
     Textures(3)=ScriptedTexture'Pages.Page3'
     ItemType=ITEM_Inventory
     InventoryGroup=125
     ItemName="BookJournal"
     PlayerViewMesh=SkelMesh'Aeons.Meshes.BookJournal_m'
     PlayerViewScale=0.75
     bClientAnim=True
     bUnlit=True
}
