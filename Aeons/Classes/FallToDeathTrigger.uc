//=============================================================================
// FallToDeathTrigger.
//=============================================================================
class FallToDeathTrigger expands Trigger;

//#exec TEXTURE IMPORT FILE=TrigFallToDeath.pcx GROUP=System Mips=Off Flags=2

#exec OBJ LOAD FILE=..\Sounds\Voiceover.uax PACKAGE=Voiceover

var bool bActive;
var PlayerPawn Player;
var() float FallTime;
var() sound FallSound;

state() FallToDeath
{
	function Touch(Actor Other)
	{
		// check the conditional event name - this checks the supplied event in the player
		if ( !CheckConditionalEvent(Condition) )
			return;
		
		if ( bActive )
		{
			if ( Other.IsA('PlayerPawn') )
			{
				Player = PlayerPawn(Other);
				
				// aviod falling to death multiple times via multiple trigger touches.
				if (Player.GetStateName() != 'FallingDeath')
				{
					log("FallingDeath - sound being played "$self.name, 'Misc');
					if ( FallSound != none )
						Player.PlaySound(FallSound,,2, [Flags]480);
					else
						Player.PlaySound(sound'Voiceover.Patrick.Pa_Falling',,2, [Flags]480);

					Player.PlayerDied('FallingDeath');
				}
				
				if (FallTime > 0)
				{
					Disable('UnTouch');
					SetTimer(FallTime, false);
				}
			}
			else if ( Other.IsA('ScriptedPawn') )
			{
				ScriptedPawn(Other).FallToDeathTrigger( self );
			}
		}
	}

	function Trigger(Actor Other, Pawn Instigator)
	{
		if (bActive)
			bActive = false;
		else
			bActive = true;
	}
	
	function Timer()
	{
		if (Player != none)
		{
			//if (FallSound != none)
			//	Player.PlaySound(FallSound);
			Player.GotoState('FallingDeath', 'FadeAway');
		}
	}

	function UnTouch(Actor Other)
	{
		if ( (Other == Player) && FallTime == 0)
		{
			Player = PlayerPawn(Other);
			//if (FallSound != none)
			//	Player.PlaySound(FallSound);
			Player.GotoState('FallingDeath', 'FadeAway');
		}
	}

	Begin:

}

defaultproperties
{
     bActive=True
     FallSound=Sound'Voiceover.Patrick.Pa_Falling'
     InitialState=FallToDeath
     Texture=Texture'Aeons.System.TrigFallToDeath'
}
