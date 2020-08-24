//=============================================================================
// IUndMoverTrigger.
//=============================================================================
class IUndMoverTrigger expands IntermediateTriggers;

//#exec TEXTURE IMPORT NAME=TrigIUndMover FILE=TrigIUndMover.pcx GROUP=System Mips=On Flags=2

var() int SequenceNum;			// SequenceNumber to fire.

function Trigger( Actor Other, Pawn EventInstigator )
{
	local Actor A;
	
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
		{
			if ( A.IsA('UndMover') )
				UndMover(A).SetPendingSequence(SequenceNum);
			A.Trigger( Other, Other.Instigator );
		}
}

defaultproperties
{
}
