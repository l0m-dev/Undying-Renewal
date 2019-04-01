//=============================================================================
// TemporalLightTrigger.
//=============================================================================
class TemporalLightTrigger expands Trigger;

var()	byte NextHue;
var()	byte NextSaturation;
var()	byte NextBrightness;
var()	float ChangeTime;

function Touch( actor Other )
{
	local actor A;

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
				if (A.IsA('TemporalLight'))
				{
					TemporalLight(A).NextHue = NextHue;
					TemporalLight(A).NextSaturation = NextSaturation;
					TemporalLight(A).NextBrightness = NextBrightness;
					TemporalLight(A).ChangeTime = ChangeTime;
					TemporalLight(A).ColorInit();
				}
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

function PassThru( actor Other )
{
	local actor A;

	if ( !bPassThru || !bInitiallyActive)
		return;

	if ( !CheckConditionalEvent(Condition) )
		return;

	if( bTriggerOnceOnly )
		SetCollision(False);

	if( Message != "" && Level.bDebugMessaging)
		Other.Instigator.ClientMessage( Message );

	// Broadcast the Trigger message to all matching actors.
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
		{
			if ( A.IsA('TemporalLight') )
			{
				TemporalLight(A).NextHue = NextHue;
				TemporalLight(A).NextSaturation = NextSaturation;
				TemporalLight(A).NextBrightness = NextBrightness;
				TemporalLight(A).ChangeTime = ChangeTime;
				TemporalLight(A).ColorInit();
				A.Trigger( Other, Other.Instigator );
			}
		}
}

defaultproperties
{
}
