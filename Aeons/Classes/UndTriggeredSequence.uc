//=============================================================================
// UndTriggeredSequence.
//=============================================================================
class UndTriggeredSequence expands Info;

//#exec TEXTURE IMPORT FILE=UndTrigSeq.pcx GROUP=System Mips=Off Flags=2

var() int TriggerSeqNum;			// SequenceNumber to fire.
var() bool bDisableMover;

function Trigger(Actor Other, Pawn Instigator)
{
	local UndMover U;

	log("UndTriggeredSequence "$self.name$" Triggered ... "$TriggerSeqNum$" ... "$Level.TimeSeconds, 'Misc');
	foreach AllActors( class 'UndMover', U, Event )
	{
		U.TriggerSequence = TriggerSeqNum;
		U.Trigger( self, Instigator );
		if (bDisableMover)
			U.bDisabled = true;
	}
}

defaultproperties
{
     Texture=Texture'Aeons.System.UndTrigSeq'
}
