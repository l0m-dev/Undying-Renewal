//=============================================================================
// DestroyTrigger.
//=============================================================================
class DestroyTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigDestroy FILE=TrigDestroy.pcx GROUP=System Mips=Off Flags=2

var() name Events[8];

function PassThru(Actor Other)
{
	local actor A;
	local int i;
	
	if ( !CheckConditionalEvent(Condition) )
		return;

	// Broadcast the Trigger message to all matching actors.
	
	for (i=0; i<8; i++)
	{
		if (Events[i] != 'None')
			foreach AllActors( class 'Actor', A, Events[i] )
				A.Destroy();
	}

	if ( Message != "" && Level.bDebugMessaging )
		Other.Instigator.ClientMessage( Message );

	Destroy();
}

function Touch( actor Other )
{
	local actor A;
	local int i;
	
	if( IsRelevant( Other ) )
	{
		// Broadcast the Trigger message to all matching actors.
		
		for (i=0; i<8; i++)
		{
			if (Events[i] != 'None')
				foreach AllActors( class 'Actor', A, Events[i] )
					A.Destroy();
		}

		Destroy();
	}
}

defaultproperties
{
}
