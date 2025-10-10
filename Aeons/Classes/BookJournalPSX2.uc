//=============================================================================
// BookJournalPSX2.
//=============================================================================
class BookJournalPSX2 expands BookJournalBase;

#exec OBJ LOAD FILE=..\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var() bool bCapsOnly;

function PreLoad()
{
	local texture foo;
	local JournalEntry bar;

	// This is here purely to force the icons to load
	// I've encountered too much trouble with them not showing up
	foo = texture'Aeons.bk_book';
	foo = texture'Aeons.bk_conv';
	foo = texture'Aeons.bk_paper';
	foo = texture'Aeons.bk_scrye';
	foo = texture'Aeons.bk_scroll';

	// Let's also force load the various JournalEntry classes
	bar = Spawn(class'Book_Entry');
	bar = Spawn(class'Scroll_Entry');
	bar = Spawn(class'Scrye_Entry');
	bar = Spawn(class'Pap_Entry');
	bar = Spawn(class'Con_Entry');
}

function PostBeginPlay()
{
	local JournalEntry TempEntry;

	Super.PostBeginPlay();
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
				TempEntry = Spawn(JournalEntryClass, Owner);
				
				if ( TempEntry != None ) 
					Journals[i] = TempEntry;
			}
		}
	}

}


function PreBeginPlay()
{
	local int i;
	local JournalEntry TempEntry;

	Super.PreBeginPlay();
}

function RefreshPages()
{
	local int i;
	local JournalEntry Entry;
	
	Entry = Journals[CurrentJournalIndex];

	if ( Entry == None ) 
		return;

	if (!Entry.bRead)
	{
		NumUnreadJournals--;
		Log("BookJournal: RefreshPages: NumUnreadJournals = " $ NumUnreadJournals);
		Entry.bRead = True;

		// If this journal entry was the newest unread entry, assign a different entry as the latest.
		for (i = 0; i < NumJournals; i++)
		{
			if (!Journals[i].bRead)
				NewestUnread = Journals[i];
		}
	}
}

function string GetJournalLIne( int Entry, int Line )
{
	if ( Journals[CurrentJournalIndex] != None )
	{
		return Journals[CurrentJournalIndex].Lines[Line];
	}
	else
	{
		return " ";
	}
}

defaultproperties
{
     ItemType=ITEM_Inventory
     InventoryGroup=125
     ItemName="BookJournal"
}
