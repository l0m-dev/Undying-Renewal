//=============================================================================
// DispelModifier.
//=============================================================================
class DispelModifier expands PlayerModifier;

var float dispelLen;
var bool debug;

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	dispelLen = 2.0;
	debug = true;
}

auto state Idle
{
	Begin:
		AeonsPlayer(Owner).bDispelActive = false;
		if ( debug )
			log("In Idle State");
}

state Dispelled
{
	function Timer()
	{
		gotoState('Idle');
	}

	Begin:
		AeonsPlayer(Owner).bDispelActive = true;
		setTimer(dispelLen,false);
}

function int Dispel(optional bool bCheck)
{
	if ( !bCheck )
		GotoState('Dispelled');
	else
		return 0;
}

defaultproperties
{
     RemoteRole=ROLE_None
}
