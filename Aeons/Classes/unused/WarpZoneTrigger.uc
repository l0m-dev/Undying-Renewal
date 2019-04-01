//=============================================================================
// WarpZoneTrigger.
//=============================================================================
class WarpZoneTrigger expands Trigger;

#exec TEXTURE IMPORT FILE=TrigWarpZone.pcx GROUP=System Mips=Off Flags=2

var() string NewTag;

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
		if( Event != '' )
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
				if (A.IsA('WarpZoneInfo'))
				{
					WarpzoneInfo(A).OtherSideURL = NewTag;
					WarpzoneInfo(A).ForceGenerate();
				}
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

function PassThru( actor Other )
{
	local WarpZoneInfo W;

	if ( !bPassThru || !bInitiallyActive)
		return;

	if ( !CheckConditionalEvent(Condition) )
		return;

	if( Message != "" && Level.bDebugMessaging)
		Other.Instigator.ClientMessage( Message );

	if( bTriggerOnceOnly )
		SetCollision(False);

	if( Event != '' )
		foreach AllActors( class 'WarpZoneInfo', W, Event )
		{
			// log("WarpZoneTrigger "$W,'Misc');
			W.OtherSideURL = NewTag;
			W.ForceGenerate();
		}
}

defaultproperties
{
     Texture=Texture'Aeons.System.TrigWarpZone'
}
