//=============================================================================
// StealthTrigger.
//=============================================================================
class StealthTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigStealth FILE=TrigStealth.pcx GROUP=System Mips=Off Flags=2

var() bool 	bCheckVisible;
var() bool 	bCheckAudible;
var() bool 	bCheckMovement;
var() bool 	bCheckTotal;
var() float StealthThreshold;
var() bool 	bOverThresh;
var() bool	bContinuousCheck;

var float fStealth;
var AeonsPlayer Player ;
var bool bFirstTouch;

function PreBeginPlay()
{
	super.PreBeginPlay();
	bFirstTouch = true;
}

function Tick(float DeltaTime)
{
	if (Player != none) {
		if (VSize(Player.Location - Location) < CollisionRadius)
			Touch(Player);
	}
}

function GetStealth(out float value)
{
	local float Div;
		
	if (bCheckTotal)
		value = StealthModifier(Player.StealthMod).TotalStealth;
	else {
		value = 0;
		Div = 0;
		
		if (bCheckVisible)
		{
			value += StealthModifier(Player.StealthMod).VisibleStealth;
			Div += 1;
		}
	
		if (bCheckAudible)
		{
			value += StealthModifier(Player.StealthMod).AudibleStealth;
			Div += 1;
		}

		if (bCheckMovement)
		{
			value += StealthModifier(Player.StealthMod).MovementStealth;
			Div += 1;
		}
		
		value /= Div;
	}

}

function Touch( actor Other )
{
	
	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if (Other.IsA('AeonsPlayer'))
	{
		Player = AeonsPlayer(Other);
		
		if ( bFirstTouch )
			bFirstTouch = false;
		
		if ( bContinuousCheck )
			Enable('Tick');

		// Is the trigger set to check for anything?
		if (bCheckVisible || bCheckAudible || bCheckMovement || bCheckTotal)
		{
			getStealth(fStealth);
		
			if ( bOverThresh )
			{
				if (fStealth > StealthThreshold)
					super.Touch(Other);
			} else {
				if (fStealth < StealthThreshold)
					super.Touch(Other);
			}
		}
	
	} else {
		super.Touch(Other);
	}
}

function UnTouch(Actor Other)
{
	super.UnTouch(Other);
	Player = none;
	bFirstTouch = true;

}

defaultproperties
{
     Texture=Texture'Aeons.System.TrigStealth'
     DrawScale=0.5
}
