//=============================================================================
// DirectionalTrigger.
//=============================================================================
class DirectionalTrigger expands Trigger;

var()  name InEvent;
var()  name OutEvent;

var()  name InExitEvent;
var()  name OutExitEvent;

var() bool bUsePlayerVelocity;


function name GetEvent(Actor Other)
{
	local vector MyView, YourView;
	
	MyView = Vector(Rotation);

	if ( bUsePlayerVelocity )
		YourView = Normal(Other.Velocity);
	else if ( Other.IsA('PlayerPawn') ) {
		YourView = Vector(Pawn(Other).ViewRotation);
	} else {
		YourView = Vector(Other.Rotation);
	}
	
	
	if ((MyView dot YourView) > 0)
		return InEvent;
	else
		return OutEvent;
}

function name GetExitEvent(Actor Other)
{
	local vector MyView, YourView;
	
	MyView = Vector(Rotation);

	if ( bUsePlayerVelocity )
		YourView = Normal(Other.Velocity);
	else if ( Other.IsA('PlayerPawn') ) {
		YourView = Vector(Pawn(Other).ViewRotation);
	} else {
		YourView = Vector(Other.Rotation);
	}
	
	
	if ((MyView dot YourView) > 0)
		return InExitEvent;
	else
		return OutExitEvent;
}

function bool CheckDir(Actor Other)
{
	local vector MyView, YourView;
	
	MyView = Vector(Rotation);

	if ( bUsePlayerVelocity )
		YourView = Normal(Other.Velocity);
	else if ( Other.IsA('PlayerPawn') ) {
		YourView = Vector(Pawn(Other).ViewRotation);
	} else {
		YourView = Vector(Other.Rotation);
	}
	
	if ((MyView dot YourView) > 0)
		return true;
	else
		return false;
}

function Touch( actor Other )
{
	local actor A;
	local name TempEvent;
	
	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	TempEvent = GetEvent(Other);
	if( IsRelevant( Other ) && (TempEvent != 'none') )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		foreach AllActors( class 'Actor', A, TempEvent )
		{
			if ( A.IsA('Trigger') )
			{
				// handle Pass Thru message
				if ( Trigger(A).bPassThru )
				{
					Trigger(A).PassThru(Other);
				}
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

function UnTouch( actor Other )
{
	local actor A;
	local name TempEvent;
	
	TempEvent = GetExitEvent(Other);
	if( IsRelevant( Other ) && (TempEvent != 'none') )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		foreach AllActors( class 'Actor', A, TempEvent )
			A.Trigger( Other, Other.Instigator );

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
     bDirectional=True
}
