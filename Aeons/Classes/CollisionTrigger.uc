//=============================================================================
// CollisionTrigger.
//=============================================================================
class CollisionTrigger expands Trigger;

var() bool NewBlockActors;
var() bool NewColActors;
var() bool NewBlockPlayers;
var() float NewRadius;
var() float NewHeight;

var() bool bUpdateCollisionSize;
var() bool bUpdateCollisionFlags;

// function SetCollision( optional bool NewColActors, optional bool NewBlockActors, optional bool NewBlockPlayers );
// function bool SetCollisionSize( float NewRadius, float NewHeight );

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
			if (bUpdateCollisionFlags)
				A.SetCollision( NewColActors, NewBlockActors, NewBlockPlayers );
			if (bUpdateCollisionSize)
				A.SetCollisionSize( NewRadius, NewHeight );
		}

	if( Message != "" && Level.bDebugMessaging)
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

				if (bUpdateCollisionFlags)
					A.SetCollision( NewColActors, NewBlockActors, NewBlockPlayers );
				if (bUpdateCollisionSize)
					A.SetCollisionSize( NewRadius, NewHeight );
				A.Trigger( Other, Other.Instigator );
			}

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if( Message != "" && Level.bDebugMessaging)
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
}
