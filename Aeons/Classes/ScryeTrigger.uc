//=============================================================================
// ScryeTrigger.
//=============================================================================
class ScryeTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigScrye FILE=TrigScrye.pcx GROUP=System Mips=Off Flags=2

/*

what if there is no event ?  will they use this for other things?


*/

var bool bScryeDetected;
var bool bIsTouching;
var AeonsPlayer Player;
var() name ScryeEndEvent;

simulated function bool IsClientPlayer(PlayerPawn Other)
{
	local bool bIsClient;

	if ( Level.NetMode != NM_Standalone )
		return true;
	 
	if ( Viewport(Other.Player) != None ) 
		return true;
	else
		return false;
	
}

simulated function Timer()
{
	local Actor A;

	CheckTouchListAccurate();
	if( (Player != None) )
	{
		if ( Player.ScryeTimer > 0.0f )
		{
			if ( bIsTouching && !bScryeDetected )
			{
				bScryeDetected = True;
				
				if ( Player.bShowScryeHint )
					Player.DisableScryeHint();
				
				if( Message != "" && Level.bDebugMessaging)
					// Send a string message to the toucher.
					Player.Instigator.ClientMessage( Message );
	
				// Broadcast the Trigger message to all matching actors.
				if ( Event != '' )
					foreach AllActors( class 'Actor', A, Event )
					{
						if ( A.IsA('Trigger') )
						{
							// handle Pass Thru message
							if ( Trigger(A).bPassThru )
							{
								Trigger(A).PassThru(Player);
							}
						}
						A.Trigger( Player, Player.Instigator );
						if ( Player.ScryeMod != none )
							ScryeModifier(Player.ScryeMod).EndEvent = ScryeEndEvent;
					}
			}
			
		}
		else // not scrying
		{
			if ( bScryeDetected )
			{
				if ( Event != '' )
				{
					foreach AllActors( class 'Actor', A, Event )
					{	
						A.UnTrigger( Player, Player.Instigator );
					}
				}

				if( bTriggerOnceOnly )
				{
					// no need to waste timer updates anymore
					SetTimer(0.0, false);
					
					// no more collisions
					SetCollision(False);
				}
				
				bScryeDetected = False;
				//Player = None;
										
			}
		}	
	}
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	SetTimer(0.2, true);
}

//
// Called when something touches the trigger.
//
simulated function Touch( actor Other ) 
{

	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if( IsRelevant( Other ) )
	{
		Player = AeonsPlayer(Other);
				
		if ( IsClientPlayer(Player) ) 
		{
			bIsTouching = True;
		}
	}
}

//
// When something untouches the trigger.
//
simulated function UnTouch( actor Other )
{
	//bScryeDetected = False;
	//Player = None;
	bIsTouching = False;
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     Texture=Texture'Aeons.System.TrigScrye'
     DrawScale=0.5
}
