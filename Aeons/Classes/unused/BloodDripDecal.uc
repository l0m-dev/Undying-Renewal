//=============================================================================
// BloodDripDecal.
//=============================================================================
class BloodDripDecal expands AeonsDecal;

var() float ScaleMin;
var() float ScaleMax;
var float TargetScale;

var() float RateMin;
var() float RateMax;
var float rate;
 
function PreBeginPlay()
{
	Super.PreBeginPlay();
	rate = RandRange(RateMin, RateMax);
	TargetScale = RandRange(ScaleMin, ScaleMax);
}

function Tick(float DeltaTime)
{
	if (DrawScale < TargetScale)
		SetDrawScale(DrawScale + (DeltaTime / rate));
}

defaultproperties
{
     ScaleMin=1
     ScaleMax=3
     RateMin=1
     RateMax=2
     DecalTextures(0)=Texture'BloodAndGuts.BloodDecal0'
     NumDecals=1
     Style=STY_AlphaBlend
     DrawScale=0.75
}
