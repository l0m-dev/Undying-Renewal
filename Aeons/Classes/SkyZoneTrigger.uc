//=============================================================================
// SkyZoneTrigger.
//=============================================================================
class SkyZoneTrigger expands Trigger;


//#exec TEXTURE IMPORT NAME=TrigSkyBox FILE=TrigSkyBox.pcx GROUP=System Mips=Off Flags=2

var() name NewSkyZoneTag;

function PassThru(Actor Other)
{
	local ZoneInfo Z;
	local Actor A;

	if ( !bPassThru || !bInitiallyActive)
		return;

	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;


	if ( Message != "" && Level.bDebugMessaging)
		Other.Instigator.ClientMessage( Message );

	if ( (Event != '') && (NewSkyZoneTag != 'none') )
	{
		if ( bTriggerOnceOnly )
			SetCollision(False);

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
			if (A.IsA('ZoneInfo'))
			{
				Z = ZoneInfo(A);
				Z.SkyZoneTag = NewSkyZoneTag;
				Z.LinkToSkybox();
			}
		}
	}
}

function Touch( actor Other )
{
	local ZoneInfo Z;
	local Actor A;

	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}

		// Broadcast the Trigger message to all matching actors.
		if( (Event != '') && (NewSkyZoneTag != 'none') )
		{
			if( bTriggerOnceOnly )
				// Ignore future touches.
				SetCollision(False);

			
			foreach AllActors( class 'Actor', A, Event )
			{
				if (A.IsA('ZoneInfo'))
				{
					Z = ZoneInfo(A);
					Z.SkyZoneTag = NewSkyZoneTag;
					Z.LinkToSkybox();
				}
				
				A.Trigger(Other, Other.Instigator);
			}
		}

		if( Message != "" && Level.bDebugMessaging)
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

defaultproperties
{
     Texture=Texture'Aeons.System.TrigSkyBox'
     DrawScale=0.5
}
