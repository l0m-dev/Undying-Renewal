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
var travel class<JournalEntry> JournalsClassesRep[150];

replication
{
	reliable if (Role == ROLE_Authority && bNetOwner && bNetInitial)
		NumJournals, JournalsClassesRep, JournalRead;
}

// someone wants us to display a specific JournalEntry class in the book.
var Class<JournalEntry> RequestedEntryClass;

simulated function bool HasEntry(JournalEntry NewEntry)
{
	local int i;
	for ( i=0; i<ArrayCount(Journals); i++ )
	{
		if ( (Journals[i] != None) && (Journals[i].Class == NewEntry.Class) ) 
		{
			//log("AddEntry: duplicate found: " $ NewEntry);
			return true;
		}
	}
	return false;
}

simulated function bool AddEntry( JournalEntry NewEntry, bool bMakeCurrent )
{
	local JournalEntry temp;
	local int i;
	local name tempname;

	
	if ( NewEntry == None )
	{
		//log("AddEntry: NewEntry is NONE, returning early");
		return false;
	}
	
	if (HasEntry(NewEntry))
		return false;
	
	/*
	for ( i=0; i<ArrayCount(Journals); i++ )
	{
		if ( (Journals[i] != None) && (Journals[i].Class == NewEntry.Class) ) 
		{
			log("AddEntry: duplicate found: " $ NewEntry);
			return;
		}
	}
	*/
	
	// Refresh status of unread journals.
	NumUnreadJournals = 0;
	for (i = 0; i < NumJournals; i++)
	{
		if (Journals[i] != None && !Journals[i].bRead) // check for none since NumJournals is replicated and not number of spawned journals for the client
			NumUnreadJournals++;
	}

	NewEntry.bRead=false;
	NumUnreadJournals++;
	NumJournals++;
	CurrentJournalIndex= NumJournals-1;
	
	JournalNames[CurrentJournalIndex] = String(NewEntry.Class);
	Journals[CurrentJournalIndex] = NewEntry;
	JournalsClassesRep[CurrentJournalIndex] = NewEntry.Class;
	
	NewestUnread=NewEntry;

	if ( NewEntry.Objectives != "" )
		AeonsPlayer(Owner).ProcessObjectives( NewEntry.Objectives );

//	RefreshPages();
	return true;
}

simulated function FindRequestedEntryClass()
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


simulated function RefreshUnread()
{
	local int i;

	NumUnreadJournals = 0;
	for (i = 0; i < NumJournals; i++)
	{
		if (Journals[i] != None && !Journals[i].bRead)
		{
			NumUnreadJournals++;
			NewestUnread = Journals[i];
		}
	}	
}


simulated function JournalEntry GetJournalEntry( int Index ) 
{
	if ( Journals[Index] != None ) 
		return Journals[Index];
	else
		return None;
}

defaultproperties
{
	 RemoteRole=Role_SimulatedProxy
}
