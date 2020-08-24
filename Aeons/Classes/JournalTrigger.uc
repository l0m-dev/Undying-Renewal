//=============================================================================
// JournalTrigger.
//=============================================================================
class JournalTrigger expands Info;

var() class<JournalEntry> JournalClass;

function Trigger( actor Other, pawn EventInstigator )
{
	local AeonsPlayer AP;

	log("JournalTrigger: Trigger");

	forEach AllActors( class 'AeonsPlayer', AP )
	{
		break;
	}

	if (( AP != None )&&( AP.Book != None )&&( JournalClass != None ))
	{
		AP.Book.RequestedEntryClass = JournalClass;
		AP.ShowBook();
	}
	else
	{
		Log("JournalTrigger: couldn't process JournalClass.  AP=" $ AP $ " AP.Book=" $ AP.Book $ " JournalClass=" $ JournalClass); 
	}

}

defaultproperties
{
}
