//=============================================================================
// FireEmber.
//=============================================================================
class FireEmber expands AnimSpriteEffect;

var() float destroyAtDrawScale;
var() float updateTimeStep;
var() float scaleOffset;
var float trailMultiplier;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}

auto state Flying
{
	function BeginState()
	{	
		SetTimer(updateTimeStep,True);
		Super.BeginState();
	}
}

function Timer ()
{
	
	DrawScale = (DrawScale * (trailMultiplier));
	if (DrawScale < destroyAtDrawScale)
		destroy();
}

defaultproperties
{
}
