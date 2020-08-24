//=============================================================================
// PhaseEffect.
//=============================================================================
class PhaseEffect expands PlayerEffects;

function PreBeginPlay()
{
	// LightRadius = 0;
	LightBrightness = 0;
	super.PreBeginPlay();
}

auto state ExpandLight
{
	function Timer()
	{
		// LightRadius += 1;
		LightBrightness += 16;
		if ( LightBrightness > 180 )
			gotoState('Hold');
	}

	Begin:
		setTimer(0.01,true);
		LightBrightness = 0;
		// PlaySound();
}

state Hold
{
	
	Begin:
		sleep(0);
		gotoState('RetractLight');

}

state RetractLight
{
	function Timer()
	{
		// LightRadius -= 1;
		if ( LightBrightness >= 16 )
			LightBrightness -= 16;
	}

	Begin:
		// PlaySound();
		setTimer(0.002,true);
		sleep(1);
		Destroy();
}

defaultproperties
{
     LightType=LT_Steady
     LightSaturation=255
     LightRadius=24
     bDarkLight=True
}
