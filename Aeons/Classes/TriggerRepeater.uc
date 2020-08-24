//=============================================================================
// TriggerRepeater.
//=============================================================================
class TriggerRepeater expands Triggers;

var() float RepeatTimer;
var() float RepeatRandom;
var() bool bInitiallyOn;

simulated function SetInitialState()
{
	if ( bInitiallyOn )
	{
		GotoState('Repeating');
	} else {
		GotoState('Idle');
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;
	
	ForEach AllActors(class 'Actor', A, 'Event')
	{
		A.Trigger(self, none);
	}
}

state Idle
{
	function Timer();
	
	function BeginState()
	{	
		SetTimer(0, false);
	}

	function Trigger(Actor Other, Pawn Instigator)
	{
		GotoState('Repeating');
	}
	
	Begin:

}

state Repeating
{
	function Trigger(Actor Other, Pawn Instigator)
	{
		GotoState('Idle');
	}
	
	function Timer()
	{
		local Actor A;

		ForEach AllActors (class 'Actor', A, Event)
		{
			A.Trigger(self, none);
		}
		SetTimer(RepeatTimer + (FRand() * RepeatRandom) , true);
	}

	function BeginState()
	{
		SetTimer(RepeatTimer + (FRand() * RepeatRandom), true );
	}
	
	Begin:

}

defaultproperties
{
}
