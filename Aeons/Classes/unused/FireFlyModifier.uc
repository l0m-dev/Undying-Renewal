//=============================================================================
// FireFlyModifier.
//=============================================================================
class FireFlyModifier expands PlayerModifier;

var pawn p;
var float tLen;
var AeonsPlayer Player;

function PreBeginPlay()
{
	p = Pawn(Owner);
	if (Owner.IsA('AeonsPlayer'))
		Player = AeonsPlayer(Owner);
	super.PreBeginPlay();
}

function LightOn(Pawn p)
{
	p.LightType = LT_Steady;
	p.LightRadius = 16;
	p.LightBrightness = 255;
	p.LightSaturation = 255;
}

function LightOff(Pawn p)
{
	p.LightType = LT_None;
	p.LightRadius = 0;
	p.LightBrightness = 0;
	p.LightSaturation = 0;
}

state Activated
{
	function Timer()
	{
		gotoState('Deactivated');
	}

	Begin:
		if ( castingLevel == 0 ) {
			LightOn(p);						// Light effect ON
			setTimer(10, false);				// 5 sec Timer
		} else if ( castingLevel == 1) {
			LightOn(p);						// Light effect ON
			setTimer(10, false);				// 5 sec Timer
		} else if ( castingLevel == 2) {
			LightOn(p);						// Light effect ON
			setTimer(10, false);				// 5 sec Timer
		} else if ( castingLevel == 3) {
			LightOn(p);						// Light effect ON
			setTimer(10, false);				// 5 sec Timer
		} else if ( castingLevel == 4) {
			LightOn(p);						// Light effect ON
			setTimer(20, false);			// 5 sec Timer
		} else if ( castingLevel == 5) {
			LightOn(p);						// Light effect ON
			setTimer(30, false);			// 5 sec Timer
		}

		if (Player != none)
			Player.bFireFlyActive = true;
		bActive = true;
		p.bIsLit = true;
		p.LitAmplitude = castingLevel;

}

state Deactivated
{
	Begin:
		if (Player != none)
			Player.bFireFlyActive = false;

		bActive = false;
			
		p.bIsLit = false;
		p.LitAmplitude = 0;
		LightOff(p);
}

defaultproperties
{
     RemoteRole=ROLE_None
}
