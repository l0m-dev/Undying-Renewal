//=============================================================================
// LockPlayerTrigger.
//=============================================================================
class LockPlayerTrigger expands Trigger;

var() float LockTimer;
var() bool bLetterBox;
var bool HideWeapons;
var bool bLocked;

var PlayerPawn P;
var name InState;

function PreBeginPlay()
{
	super.PreBeginPlay();
	SetTimer(0, false);
}

function PassThru(Actor Other)
{
	local Actor A;
	
	if ( !bPassThru || !bInitiallyActive)
		return;

	if ( !CheckConditionalEvent(Condition) )
		return;
	
	if ( Other.IsA('PlayerPawn') )
	{
		P = PlayerPawn(Other);
		GotoState('Holding');
	}
}

simulated function Touch( actor Other )
{
	local Actor A;

	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if ( IsRelevant( Other ) )
	{
		if ( Other.IsA('PlayerPawn') )
		{
			P = PlayerPawn(Other);
			InState = P.GetStateName();
			P.GotoState('DialogScene');
			if (bLetterBox)
			{
				P.LetterBox(true);
			}
			SetTimer(LockTimer, false);
			bLocked = true;

			if ( Other.IsA('AeonsPlayer') )
			{
				AeonsPlayer(Other).ScryeMod.GotoState( 'Deactivated' );
				AeonsPlayer(Other).ClientSetScryeModActive(false);
				if ( HideWeapons )
					AeonsPlayer(Other).bRenderWeapon = false;
			}
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
				A.Trigger( self, Other.Instigator );
			}

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if( Message != "" && Level.bDebugMessaging)
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);

		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}

	}
}

function Timer()
{
	ReleasePlayer();
}

function ReleasePlayer()
{
	// return the player to the state they were in when triggered.
	AeonsPlayer(P).bRenderWeapon = true;
	P.GotoState(InState);
	if (P.RemoteRole == ROLE_AutonomousProxy)
	{
		P.GotoState(InState);//ClientGotoState
	}
	if ( bLetterBox )
	{
		P.LetterBox(false);
	}
	SetTimer( 0.0, false );
	bLocked = false;
}

state Holding
{
	Begin:
		Sleep(0.25);
		Touch(P);
}

defaultproperties
{
     bLetterbox=True
     HideWeapons=True
     ReTriggerDelay=1
}
