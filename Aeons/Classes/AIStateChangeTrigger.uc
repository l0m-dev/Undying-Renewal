//=============================================================================
// AIStateChangeTrigger.
//=============================================================================
class AIStateChangeTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigAIState FILE=TrigAIState.pcx GROUP=System Mips=Off Flags=2

var() name NewState;

function PassThru(Actor Other)
{
	local Actor A;
	
	if ( !bPassThru || !bInitiallyActive)
		return;

	if ( !CheckConditionalEvent(Condition) )
		return;

	if ( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
		{
			if ( A.IsA('ScriptedPawn') )
			{
				if (NewState != 'none')
					ScriptedPawn(A).TriggerState = NewState;
			}
		}

	if( Message != "" )
		Other.Instigator.ClientMessage( Message );

	if( bTriggerOnceOnly )
		SetCollision(False);
}

//
// Called when something touches the trigger.
//
function Touch( actor Other )
{
	local Actor A;
	
	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		if ( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
			{
				if ( A.IsA('Trigger') )
				{
					// handle Pass Thru message
					if ( Trigger(A).bPassThru )
					{
						Trigger(A).PassThru(Other);
					}
				}

				if ( A.IsA('ScriptedPawn') )
				{
					if (NewState != 'none')
						if ( ScriptedPawn(A).Health > 0 )
							ScriptedPawn(A).TriggerState = NewState;
				}
				A.Trigger( Other, Other.Instigator );
			}

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if( Message != "" )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

defaultproperties
{
     Texture=Texture'Aeons.System.TrigAIState'
     DrawScale=0.5
}
