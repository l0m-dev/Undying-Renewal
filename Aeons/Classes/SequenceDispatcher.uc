//=============================================================================
// SequenceDispatcher.
//=============================================================================
class SequenceDispatcher expands Triggers;

//#exec Texture Import File=SequenceDispatcher.pcx Name=SequenceDispatcher Mips=On Flags=2 GROUP=System

//-----------------------------------------------------------------------------

var() bool	bLoopList;		// loop back to the start of the seq.
var() name  Events[16];		// Events to generate.
var() int	NumEvents;		// total number of events
var int i;					// Internal counter.
var Actor Other;

function PreBeginPlay()
{
	super.PreBeginPlay();
	bSavable = true;
}

function Trigger( actor Other, pawn EventInstigator )
{
	Instigator = EventInstigator;

	if( Events[i] != '' )
	{
		forEach AllActors( class 'Actor', Target, Events[i] )
		{
			if ( Target.IsA('Trigger') )
			{
				// handle Pass Thru message
				if ( Trigger(Target).bPassThru )
				{
					Trigger(Target).PassThru(Other);
				}
			}
			Target.Trigger( Self, Instigator );
		}
		i ++;
		if ( (i==NumEvents) && bLoopList)
		{
			i = 0;
		} else {
			Disable('Trigger');
		}
	}
	gotostate('Dispatch');
}

defaultproperties
{
     Texture=Texture'Aeons.System.SequenceDispatcher'
     DrawScale=0.5
}
