//=============================================================================
// SphereOfColdModifier.
//=============================================================================
class SphereOfColdModifier expands PlayerModifier;

var ColdScriptedFX cp;
var float OriginalGroundSpeed;
var float OriginalAirSpeed;
var float EffectLen;
//fix implement bActive functionality

function attachSmoke(actor Other)
{
	cp = spawn(class 'ColdScriptedFX',Other,,Other.Location);
	cp.setBase(Other);
	cp.LifeSpan = EffectLen;
}

function detachSmoke()
{
	cp.ShutDownFX();
}

// ===================================================================================
// Activated state
// ===================================================================================
state Activated
{
	function BeginState()
	{
		if (Owner.IsA('ScriptedPawn'))
			gotoState('SPActivated');
	}

	function Tick(float deltaTime)
	{
	
	}

	function Timer()
	{
		gotoState('Deactivated');
	}

	Begin:
		attachSmoke(Pawn(Owner));
		bActive = true;
		playSound(EffectSound);
		AeonsPlayer(Owner).Haste(0.1);
		setTimer(EffectLen, false);
}

// ===================================================================================
// Deactivated state
// ===================================================================================
state Deactivated
{
	Begin:
		detachSmoke();
		bActive = false;
		AeonsPlayer(Owner).Haste(1.0);
}

// ===================================================================================
// ScriptedPawn Deactivated state
// ===================================================================================
state SPDeactivated
{

	Begin:
		detachSmoke();
		bActive = false;
		Pawn(Owner).groundSpeed = OriginalGroundSpeed;
		Pawn(Owner).AirSpeed = OriginalAirSpeed;
}

// ===================================================================================
// ScriptedPawn Activated state
// ===================================================================================
state SPActivated
{
	function Timer()
	{
		gotoState('SPDeactivated');
	}
	
	function Tick(float deltaTime)
	{
		if (ScriptedPawn(Owner).health <= 0)
			detachSmoke();
	
	}

	Begin:
		attachSmoke(Pawn(Owner));
		bActive = true;
		OriginalGroundSpeed = Pawn(Owner).groundSpeed;
		OriginalAirSpeed = Pawn(Owner).AirSpeed;
		Pawn(Owner).groundspeed = Pawn(Owner).groundSpeed * 0.5;
		Pawn(Owner).AirSpeed = Pawn(Owner).AirSpeed * 0.5;
		setTimer(EffectLen, false);
}

// ===================================================================================
// Idle state
// ===================================================================================
auto state Idle
{

	Begin:

}

defaultproperties
{
     bTimedTick=True
     MinTickTime=0.25
}
