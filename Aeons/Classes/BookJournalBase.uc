//=============================================================================
// BookJournalBase.
//=============================================================================
class BookJournalBase expands Inventory;

var travel int NumUnreadJournals;
var travel JournalEntry NewestUnread;

var travel int NumJournals;
var travel int CurrentJournalIndex;
var travel int FirstJournalId;

var travel int		JournalRead[150];
var travel string JournalNames[150];
var travel JournalEntry Journals[150]; //fix travel  ?


// someone wants us to display a specific JournalEntry class in the book.
var Class<JournalEntry> RequestedEntryClass;

function AddEntry( JournalEntry NewEntry, bool bMakeCurrent )
{
	local JournalEntry temp;
	local int i;
	
	if ( NewEntry == None )
	{
		//log("AddEntry: NewEntry is NONE, returning early");
		return;
	}

	for ( i=0; i<ArrayCount(Journals); i++ )
	{
		if ( (Journals[i] != None) && (Journals[i].Class == NewEntry.Class) ) 
		{
			log("AddEntry: duplicate found: " $ NewEntry);
			return;
		}
	}

	// Refresh status of unread journals.
	NumUnreadJournals = 0;
	for (i = 0; i < NumJournals; i++)
	{
		if (!Journals[i].bRead)
			NumUnreadJournals++;
	}

	NewEntry.bRead=false;
	NumUnreadJournals++;
	NumJournals++;
	CurrentJournalIndex= NumJournals-1;
	
	JournalNames[CurrentJournalIndex] = String(NewEntry.Class);
	Journals[CurrentJournalIndex] = NewEntry;
	
	NewestUnread=NewEntry;

	if ( NewEntry.Objectives != "" )
		AeonsPlayer(Owner).ProcessObjectives( NewEntry.Objectives );

//	RefreshPages();
}

function FindRequestedEntryClass()
{
	local int i;
	local JournalEntry NewEntry;

	//log("FindRequestedEntryClass: Begin");

	for ( i=0; i<NumJournals; i++ )
	{
		if ( (Journals[i] != None) && ( Journals[i].Class == RequestedEntryClass) ) 
		{
			CurrentJournalIndex = i;
			FirstJournalId = i;
			RequestedEntryClass = None;
			//log("FindRequestedEntryClass: found class: returning");
			return;
		}	
	}

	// if we got this far, we didn't find it.  We should probably create it.
	NewEntry = Spawn(RequestedEntryClass);
	AddEntry(NewEntry, true);

	RequestedEntryClass = None;
	//log("FindRequestedEntryClass: added requested class");
}


function RefreshUnread()
{
	local int i;

	for (i = 0; i < NumJournals; i++)
	{
		NumUnreadJournals = 0;
		if (!Journals[i].bRead)
		{
			NumUnreadJournals++;
			NewestUnread = Journals[i];
		}
	}	
}


function JournalEntry GetJournalEntry( int Index ) 
{
	if ( Journals[Index] != None ) 
		return Journals[Index];
	else
		return None;
}

defaultproperties
{
}
