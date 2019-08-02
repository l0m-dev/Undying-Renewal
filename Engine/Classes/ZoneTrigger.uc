//=============================================================================
// ZoneTrigger.
//=============================================================================
class ZoneTrigger extends Trigger;

//
// Called when something touches the trigger.
//
function Touch( actor Other )
{
	local ZoneInfo Z;

	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if( IsRelevant( Other ) )
	{
		// Broadcast the Trigger message to all matching actors.
		if( Event != '' )
			foreach AllActors( class 'ZoneInfo', Z )
				if ( Z.ZoneTag == Event )
					Z.Trigger( Other, Other.Instigator );

		if( Message != "" )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
	}
}

function PassThru( actor Other )
{
	local ZoneInfo Z;

	if ( !bPassThru || !bInitiallyActive)
		return;

	if ( !CheckConditionalEvent(Condition) )
		return;

	// Broadcast the Trigger message to all matching actors.
	if( Event != '' )
		foreach AllActors( class 'ZoneInfo', Z )
			if ( Z.ZoneTag == Event )
				Z.Trigger( Other, Other.Instigator );

	if( Message != "" )
		Other.Instigator.ClientMessage( Message );

	if( bTriggerOnceOnly )
		SetCollision(False);
}

//
// When something untouches the trigger.
//
function UnTouch( actor Other )
{
	local ZoneInfo Z;
	if( IsRelevant( Other ) )
	{
		// Untrigger all matching actors.
		if( Event != '' )
			foreach AllActors( class 'ZoneInfo', Z )
				if ( Z.ZoneTag == Event )
					Z.UnTrigger( Other, Other.Instigator );
	}
}

defaultproperties
{
}
