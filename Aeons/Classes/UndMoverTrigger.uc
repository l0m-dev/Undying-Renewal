//=============================================================================
// UndMoverTrigger.
//=============================================================================
class UndMoverTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigUndMover FILE=TrigUndMover.pcx GROUP=System Mips=Off Flags=2

var int SeqNum;
var() int SequenceNum;			// SequenceNumber to fire.
var() int SequenceNumRev;		// SequenceNumber to fire in reverse direction.
var() int SequenceExit;			// SequenceNumber to fire in reverse direction.
var() bool bCheckDirection;		// Check the direction of the instigator
var() bool bUseSequenceExit;	// Use the Exit Sequence?

function PostBeginPlay()
{
	Super.PostBeginPlay();
	EnableLog('Misc');
	//log("UndMoverTrigger "$self.name$" PreBeginPlay() - bInitiallyActive = "$bInitiallyActive);
}
// Trigger is always active.
state() NormalTrigger
{
}

// Other trigger toggles this trigger's activity.
state() OtherTriggerToggles
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		//log(""$self.name$" is being toggled from "$bInitiallyActive$" to "$!bInitiallyActive$" by "$Other.Name$", "$EventInstigator.name, 'Misc');
		bSavable = true;
		bInitiallyActive = !bInitiallyActive;
		if ( bInitiallyActive )
			CheckTouchList();
	}
}

// Other trigger turns this on.
state() OtherTriggerTurnsOn
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		local bool bWasActive;

		bSavable = true;
		bWasActive = bInitiallyActive;
		bInitiallyActive = true;
		if ( !bWasActive )
			CheckTouchList();
	}
}

// Other trigger turns this off.
state() OtherTriggerTurnsOff
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		bSavable = true;
		bInitiallyActive = false;
	}
}

function bool CheckDir(Actor Other, out int i)
{
	local vector MyView, YourView;
	
	if ( bCheckDirection )
	{
		MyView = Vector(Rotation);
		YourView = Vector(Other.Rotation);
		
		if ((MyView dot YourView) > 0)
			i = SequenceNum;
		else
			i = SequenceNumRev;
	} else {
		// we're not checking direction, the test passes
		i = SequenceNum;
	}
}

function Touch( actor Other )
{
	local actor A;

	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if ( !bInitiallyActive )
	{
		//log("UndMoverTrigger "$self.name$" Touch() in state "$GetStateName()$" by "$Other.name$" -- not continuing because I am NOT active!", 'Misc');
		return;
	} else {
		//log("UndMoverTrigger "$self.name$" Touch() in state "$GetStateName()$" by "$Other.name$" -- continuing because I AM active!", 'Misc');
	}

	if ( bPassThru )
		return;

	if ( IsRelevant( Other ) )
	{
		CheckDir(Other, SeqNum);
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

				if ( A.IsA('UndMover') )
				{
					//log("UndMoverTrigger "$self.name$" Triggering UndMover "$A.name$" sequence "$SeqNum, 'Misc');
					UndMover(A).SetPendingSequence(SeqNum);
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

	//log ("UndMoverTrigger recieved Pass Thru event from "$Other, 'Misc');
	if( Message != "" && Level.bDebugMessaging)
		Other.Instigator.ClientMessage( Message );

	if ( bTriggerOnceOnly )
		SetCollision(False);

	CheckDir(Other, SeqNum);

	if ( Event != '' )
	{
		foreach AllActors( class 'Actor', A, Event )
		{
			if ( A.IsA('UndMover') )
			{
				//log ("UndMoverTrigger firing UndMover with sequence -- "$SeqNum, 'Misc');
				UndMover(A).SetPendingSequence(SeqNum);
			}
			A.Trigger( Other, Other.Instigator );
		}
	}
}

function UnTouch( actor Other )
{
	local actor A;

	if( IsRelevant( Other ) )
	{

		if ( bUseSequenceExit )
		{
			// Untrigger all matching actors.
			if( Event != '' )
				foreach AllActors( class 'Actor', A, Event )
				{
					if ( A.IsA('UndMover') && bDirectional )
					{
						UndMover(A).SetPendingSequence(SequenceExit);
						A.Trigger( Other, Other.Instigator );
						//A.UnTrigger( Other, Other.Instigator );
					}
				}
		}
	}
}

defaultproperties
{
     bUseSequenceExit=True
     bDirectional=True
     Texture=Texture'Aeons.System.TrigUndMover'
     DrawScale=0.5
}
