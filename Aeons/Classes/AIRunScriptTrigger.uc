//=============================================================================
// AIRunScriptTrigger.
//=============================================================================
class AIRunScriptTrigger expands Trigger;

var() name		NewScript;

function PassThru( actor Other )
{
	local ScriptedPawn	SP;
	
	if ( !bPassThru || !bInitiallyActive)
		return;

	if ( !CheckConditionalEvent(Condition) )
		return;

	if ( Event != '' )
		foreach AllActors( class'ScriptedPawn', SP, Event )
		{
			if ( ( NewScript != '' ) && ( SP.Health > 0 ) )
			{
				SP.Script = none;
				SP.ScriptTag = NewScript;
				if ( SP.GetStateName() == 'AIRunScript' )
					SP.BeginState();
				SP.GotoState( 'AIRunScript', 'BEGIN' );
			}
		}

	if ( Message != "" )
		Other.Instigator.ClientMessage( Message );

	if( bTriggerOnceOnly )
		SetCollision( false );
}

//
// Called when something touches the trigger.
//
function Touch( actor Other )
{
	local actor		A;
	
	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if ( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		if ( Event != '' )
			foreach AllActors( class'actor', A, Event )
			{
				if ( A.IsA('Trigger') )
				{
					// handle Pass Thru message
					if ( Trigger(A).bPassThru )
					{
						Trigger(A).PassThru( Other );
					}
				}

				if ( A.IsA('ScriptedPawn') )
				{
					if ( ( NewScript != '' ) && ( ScriptedPawn(A).Health > 0 ) )
					{
						ScriptedPawn(A).Script = none;
						ScriptedPawn(A).ScriptTag = NewScript;
						if ( A.GetStateName() == 'AIRunScript' )
							A.BeginState();
						ScriptedPawn(A).GotoState( 'AIRunScript', 'BEGIN' );
					}
				}
				else
					A.Trigger( Other, Other.Instigator );
			}

		if ( Other.IsA('pawn') && ( pawn(Other).SpecialGoal == self ) )
			pawn(Other).SpecialGoal = none;

		if ( Message != "" )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if ( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision( false );
		else if ( RepeatTriggerTime > 0 )
			SetTimer( RepeatTriggerTime, false );
	}
}

defaultproperties
{
}
